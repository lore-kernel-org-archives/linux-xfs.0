Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0RNot6K053197 for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 17:50:55 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 526F7126ABE2
	for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 15:53:18 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id yHBBrIV2GHzWEm9X
	for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 15:53:18 -0800 (PST)
Message-ID: <4D42056E.2050505@hardwarefreak.com>
Date: Thu, 27 Jan 2011 17:53:18 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs: very slow after mount, very slow at umount
References: <4D40C8D1.8090202@teksavvy.com>
	<20110127033011.GH21311@dastard>	<4D40EB2F.2050809@teksavvy.com>
	<4D418B57.1000501@teksavvy.com>	<alpine.DEB.2.00.1101271040000.31246@p34.internal.lan>	<4D419765.4070805@teksavvy.com>	<4D41CA16.8070001@hardwarefreak.com>
	<alpine.DEB.2.00.1101271209370.17579@asgard.lang.hm>
In-Reply-To: <alpine.DEB.2.00.1101271209370.17579@asgard.lang.hm>
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
To: david@lang.hm
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, Alex Elder <aelder@sgi.com>, Mark Lord <kernel@teksavvy.com>

david@lang.hm put forth on 1/27/2011 2:11 PM:

> how do I understand how to setup things on multi-disk systems? the documentation
> I've found online is not that helpful, and in some ways contradictory.

Visit http://xfs.org  There you will find:

Users guide:
http://xfs.org/docs/xfsdocs-xml-dev/XFS_User_Guide//tmp/en-US/html/index.html

File system structure:
http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/html/index.html

Training labs:
http://xfs.org/docs/xfsdocs-xml-dev/XFS_Labs/tmp/en-US/html/index.html

> If there really are good rules for how to do this, it would be very helpful if
> you could just give mkfs.xfs the information about your system (this partition
> is on a 16 drive raid6 array) and have it do the right thing.

If your disk array is built upon Linux mdraid, recent versions of mkfs.xfs will
read the parameters and automatically make the filesystem accordingly, properly.

mxfs.fxs will not do this for PCIe/x hardware RAID arrays or external FC/iSCSI
based SAN arrays as there is no standard place to acquire the RAID configuration
information for such systems.  For these you will need to configure mkfs.xfs
manually.

At minimum you will want to specify stripe width (sw) which needs to match the
hardware stripe width.  For RAID0 sw=[#of_disks].  For RAID 10, sw=[#disks/2].
For RAID5 sw=[#disks-1].  For RAID6 sw=[#disks-2].

You'll want at minimum agcount=16 for striped hardware arrays.  Depending on the
number and spindle speed of the disks, the total size of the array, the
characteristics of the RAID controller (big or small cache), you may want to
increase agcount.  Experimentation may be required to find the optimum
parameters for a given hardware RAID array.  Typically all other parameters may
be left at defaults.

Picking the perfect mkfs.xfs parameters for a hardware RAID array can be
somewhat of a black art, mainly because no two vendor arrays act or perform
identically.

Systems of a caliber requiring XFS should be thoroughly tested before going into
production.  Testing _with your workload_ of multiple parameters should be
performed to identify those yielding best performance.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
