Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1OFI0k2057873 for <xfs@oss.sgi.com>; Fri, 24 Feb 2012 09:18:00 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id wHp6VFZudwUKpqHQ for <xfs@oss.sgi.com>;
	Fri, 24 Feb 2012 07:17:57 -0800 (PST)
Message-ID: <4F47AA24.8010209@sandeen.net>
Date: Fri, 24 Feb 2012 09:17:56 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: creating a new 80 TB XFS
References: <4F478818.4050803@cape-horn-eng.com>
In-Reply-To: <4F478818.4050803@cape-horn-eng.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Richard Ems <richard.ems@cape-horn-eng.com>
Cc: xfs@oss.sgi.com

On 2/24/12 6:52 AM, Richard Ems wrote:
> Hi list,
> 
> I am not a storage expert, so sorry in advance for probably some *naive*
> questions or proposals from me. 8)
> 
> *INTRO*
> We are getting new hardware soon and I wanted to check with you my plans
> for creating and mounting this XFS.
> 
> The storage system is from EUROstor,
> http://eurostor.com/en/products/raid-sas-host/es-6600-sassas-toploader.html
> .
> 
> We are getting now 32 x 3 TB Hitachi SATA HDDs.
> I plan to configure them in a single RAID 6 set with one or two
> hot-standby discs. The raw storage space will then be 28 x 3 TB = 84 TB.
> On this one RAID set I will create only one volume.
> Any thoughts on this?
> 
> This storage will be used as secondary storage for backups. We use
> dirvish (www.dirvish.org, which uses rsync) to run our daily backups.
> dirvish heavily uses hard links. It compares all files, one by one, and
> synchronizes all new or changed files with rsync to the current daily
> dir YYYY-MM-DD, and creates hard links for all not changed files from
> the last previous backup on YYYY-MM-(DD-1) to the current YYYY-MM-DD
> directory.
> 
> 
> *MKFS*
> We also heavily use ACLs for almost all of our files. Christoph Hellwig
> suggested in a previous mail to use "-i size=512" on XFS creation, so my
> mkfs.xfs would look something like:
> 
> mkfs.xfs -i size=512 -d su=stripe_size,sw=28 -L Backup_2 /dev/sdX1

Be sure the stripe geometry matches the way the raid controller is
set up.

You know the size of your acls, so you can probably do some testing
to find out how well 512-byte inodes keep ACLs in-line.

As others mentioned, if sdX1 means you've partitioned your 80T
device, that's probably unnecessary.

> *MOUNT*
> On mount I will use the options
> 
> mount -o noatime,nobarrier,nofail,logbufs=8,logbsize=256k,inode64
> /dev/sdX1 /mount_point

Understand what nobarrier means, and convince yourself that it's safe
before you turn them off.  Then convince yourself again.
You'll want to know if your raid controller has a write back
cache, whether it disables disk write back caches, whether any active
caches are battery-backed, etc.
 
http://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_Linux/6/html/Storage_Administration_Guide/writebarr.html

You are restating defaults for logbufs.  Your logbsize value is bigger than default.
"The trade off for this increase in metadata performance is that more operations may
be "missing" after recovery if the system crashes while actively making modifications. "

inode64 is a good idea.

also, why nofail?

> What about the largeio mount option? In which cases would it be useful?

probably none in your case.  It changes what stat reports in st_blksize,
so it depends on what (if anything) your userspace does with that.

> Do you have any other/better suggestions or comments?

http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E

-Eric

> 
> Many thanks,
> Richard
> 
> 
> 
> 
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
