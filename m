Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ED9BD7F9E
	for <xfs@oss.sgi.com>; Fri, 21 Feb 2014 13:17:31 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 68FDEAC002
	for <xfs@oss.sgi.com>; Fri, 21 Feb 2014 11:17:28 -0800 (PST)
Received: from internal-smtp4.wesleyan.edu (internal-smtp4.wesleyan.edu
	[129.133.6.200]) by cuda.sgi.com with ESMTP id T1T77DvwzQeYiwVw
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 21 Feb 2014 11:17:26 -0800 (PST)
Message-ID: <9d279286de89334f66bef9eb832c2e45.squirrel@webmail.wesleyan.edu>
In-Reply-To: <5306C90B.1000904@hardwarefreak.com>
References: <52E91923.4070706@sandeen.net> <52EB3B96.7000103@hardwarefreak.com>
	<1391202273-sup-9265@al.wesleyan.edu>
	<52ED61C9.8060504@hardwarefreak.com> <20140202212152.GP2212@dastard>
	<1391443675-sup-1730@al.wesleyan.edu> <20140203214128.GR13997@dastard>
	<52F09E36.8050606@hardwarefreak.com>
	<1392748390-sup-1943@al.wesleyan.edu>
	<5303E7AC.50903@hardwarefreak.com>
	<20140220183125.29149.64880@al.wesleyan.edu>
	<5306C90B.1000904@hardwarefreak.com>
Date: Fri, 21 Feb 2014 14:17:21 -0500
Subject: Re: Question regarding XFS on LVM over hardware RAID.
From: "C. Morgan Hamill" <chamill@wesleyan.edu>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: xfs@oss.sgi.com


On Thu, February 20, 2014 10:33 pm, Stan Hoeppner wrote:
>  Forget all of this.  Forget RAID60.  I think you'd be best served by a
>  concatenation.
>
>  You have a RAID chassis with 15 drives and two 15 drive JBODs daisy
>  chained to it, all 4TB drives, correct?  Your original setup was 1 spare
>  and one 14 drive RAID6 array per chassis, 12 data spindles.  Correct?
>  Stick with that.

It's all in one chassis, but correct.

>  Export each RAID6 as a distinct LUN to the host.  Make an mdadm --linear
>  array of the 3 RAID6 LUNs, devices.  Then format the md linear device,
>  e.g. /dev/md0 using the geometry of a single RAID6 array.  We want to
>  make sure each allocation group is wholly contained within a RAID6
>  array.  You have 48TB per array and 3 arrays, 144TB total.  1TB=1000^4
>  and XFS deals with TebiBytes, or 1024^4.  Max agsize is 1TiB.  So to get
>  exactly 48 AGs per array, 144 total AGs, we'd format with
>
>  # mkfs.xfs -d su=128k,sw=12,agcount=144

I am intrigued...

>  The --linear array, or generically concatenation, stitches the RAID6
>  arrays together end-to-end.  Here the filesystem starts at LBA0 on the
>  first array and ends on the last LBA of the 3rd array, hence "linear".
>  XFS performs all operations at the AG level.  Since each AG sits atop
>  only one RAID6, the filesystem alignment geometry is that of a single
>  RAID6.  Any individual write will peak at ~1.2GB/s.  Since you're
>  limited by the network to 100MB/s throughput this shouldn't be an issue.
>
>  Using an md linear array you can easily expand in the future without all
>  the LVM headaches, by simply adding another identical RAID6 array to the
>  linear array (see mdadm grow) and then growing the filesystem with
>  xfs_growfs.

How does this differ from standard linear LVM? Is it simply that we avoid
the extent size issue?

>  In doing so, you will want to add the new chassis before
>  the filesystem reaches ~70% capacity.  If you let it grow past that
>  point, most of your new writes may go to only the new RAID6 where the
>  bulk of your large free space extents now exist.  This will create an IO
>  hotspot on the new chassis, while the original 3 will see fewer writes.

Good to know.

>  XFS has had filesystem quotas for exactly this purpose, for almost as
>  long as it has existed, well over 15 years.  There are 3 types of
>  quotas: user, group, and project.  You must enable quotas with a mount
>  option.  You manipulate quotas with the xfs_quota command.  See
>
>  man xfs_quota
>  man mount
>
>  Project quotas are set on a directory tree level.  Set a soft and hard
>  project quota on a directory and the available space reported to any
>  process writing into it or its subdirectories is that of the project
>  quota, not the actual filesystem free space.  The quota can be increased
>  or decreased at will using xfs_quota.  That solves your "sizing" problem
>  rather elegantly.

Oh, I was unaware of project quotas.

>  Now, when using a concatenation, md linear array, to reap the rewards of
>  parallelism the requirement is that the application creates lots of
>  directories with a fairly even spread of file IO.  In this case, to get
>  all 3 RAID6 arrays into play, that requires creation and use of at
>  minimum 97 directories.  Most backup applications make tons of
>  directories so you should be golden here.

Yes, quite a few directories are created.

>  You're welcome Morgan.  I hope this helps steer you towards what I think
>  is a much better architecture for your needs.
>
>  Dave and I both initially said RAID60 was an ok way to go, but the more
>  I think this through, considering ease of expansion, using a single
>  filesystem and project quotas, it's hard to beat the concat setup.

Seems like this will work quite well. Thanks so much for all your help.
-- 
Morgan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
