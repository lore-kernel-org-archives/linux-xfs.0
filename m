Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 78F017F54
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 10:07:46 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0B64DAC002
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 08:07:42 -0800 (PST)
Received: from internal-smtp3.wesleyan.edu (internal-smtp3.wesleyan.edu
	[129.133.6.182]) by cuda.sgi.com with ESMTP id 6ebFGHKvsQ67dDEJ
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 03 Feb 2014 08:07:39 -0800 (PST)
From: "C. Morgan Hamill" <chamill@wesleyan.edu>
In-reply-to: <52ED61C9.8060504@hardwarefreak.com>
Subject: Re: Question regarding XFS on LVM over hardware RAID.
References: <1391005406-sup-1881@al.wesleyan.edu>
	<52E91923.4070706@sandeen.net>
	<1391022066-sup-5863@al.wesleyan.edu>
	<52E99504.4030902@hardwarefreak.com>
	<1391090527-sup-4664@al.wesleyan.edu>
	<20140130202819.GO2212@dastard>
	<52EB3B96.7000103@hardwarefreak.com>
	<1391202273-sup-9265@al.wesleyan.edu>
	<52ED61C9.8060504@hardwarefreak.com>
Date: Mon, 03 Feb 2014 11:07:34 -0500
Message-Id: <1391442947-sup-8195@al.wesleyan.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan <stan@hardwarefreak.com>
Cc: xfs <xfs@oss.sgi.com>

Excerpts from Stan Hoeppner's message of 2014-02-01 16:06:17 -0500:
> Yes, that's one of the beauties of LVM.  However, there are other
> reasons you may not want to do this.  For example, if you have allocated
> space from two different JBOD or SAN units to a single LVM volume, and
> you lack multipath connections, if you have a cable, switch, HBA, or
> other failure disconnecting one LUN that will wreak havoc on your
> mounted XFS filesystem.  If you have multipath and the storage device
> disappears due to some other failure such as backplane,  UPS, etc, you
> have the same problem.

Very true; I gather this would only take out any volumes which at least
partially rest on the failed device, however?  As in, I don't lose the
whole volume group, correct?

> This isn't a deal breaker.  There are many large XFS filesystems in
> production that span multiple storage arrays.  You just need to be
> mindful of your architecture at all times, and it needs to be
> documented.  Scenario:  XFS unmounts due to an IO error.  You're not yet
> aware an entire chassis is offline.  You can't remount the filesystem so
> you start a destructive xfs_repair thinking that will fix the problem.
> Doing so will wreck your filesystem and you'll likely lose access to all
> the files on the offline chassis, with no ability to get it back short
> of some magic and a full restore from tape or D2D backup server.  We had
> a case similar to this reported a couple of years ago.

Oh God, that sounds terrible.  My sysadmininess is wondering why the
chassis wasn't monitored, but hindsight, etc. etc. ;-)

> If the logical sector size reported by your RAID controller is 512
> bytes, then "--dataalignment=9216s" should start your data section on a
> RAID60 stripe boundary after the metadata section.

I see that 9216s == 2608k/512b, but I'm missing something: is the
default metadata size guaranteed to be less than a single stripe, or is
there more to it?

Oh, wait, I think I just got it: '--dataalignment' will take care to
start on some multiple of 9216 sectors, regardless of the size of the
metadata section. Doy.

> The PhysicalExtentSize should probably also match the 4608KB stripe
> width, but this is apparently not possible.  PhysicalExtentSize must be
> a power of 2 value.  I don't know if or how this will affect XFS aligned
> write out.  You'll need to consult with someone more knowledgeable of LVM.

Makes sense.  If it would have an impact, then I'd probably just end up
going with RAID 0 on top of 2 or 4 RAID 6 groups, which looks like the
math would work out there.

> You bet.

Honestly, this is the most helpful and straightforward I've ever found
any project's mailing list, so kudos++.
--
Morgan Hamill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
