Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 85E8C7CA0
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 18:18:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3D0938F8035
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 16:18:36 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	0pzdwyR40KL7mGqY for <xfs@oss.sgi.com>;
	Wed, 20 Jul 2016 16:18:33 -0700 (PDT)
Date: Thu, 21 Jul 2016 09:18:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [4.7-rc6 snapshot] xfstests::generic/081 unable to tear down
	snapshot VG
Message-ID: <20160720231805.GX12670@dastard>
References: <20160719002202.GE16044@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160719002202.GE16044@dastard>
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
To: dm-devel@redhat.com
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jul 19, 2016 at 10:22:02AM +1000, Dave Chinner wrote:
> Hi folks,
> 
> I'm currently running the latest set of XFS patches through QA, and
> I'm getting generic/081 failing and leaving a block device in an
> unrecoverable EBUSY state. I'm running xfstests on a pair of 8GB
> fake pmem devices:
> 
> $ sudo ./run_check.sh " -i sparse=1" "" " -s xfs generic/081"
....

More problems after this failure, while trying to sort out a
workaround I can use. Reboot the machine after triggering it, and on
next boot I've ended up with:

$ sudo lvs
  LV       VG     Attr       LSize   Pool Origin   Data%  Meta%  Move Log Cpy%Sync Convert
  base_081 vg_081 owi---s--- 256.00m                                                      
  snap_081 vg_081 swi---s---   4.00m      base_081  
$ sudo vgs
  VG     #PV #LV #SN Attr   VSize VFree
  vg_081   1   2   1 wz--n- 8.00g 7.74g
$ sudo pvs
  PV         VG     Fmt  Attr PSize PFree
  /dev/pmem1 vg_081 lvm2 a--  8.00g 7.74g
$ sudo lvremove -f vg_081/snap_081
  Incorrect metadata area header checksum on /dev/pmem1 at offset 4096
  WARNING: Failed to write an MDA of VG vg_081.
  Failed to write VG vg_081.
  Incorrect metadata area header checksum on /dev/pmem1 at offset 4096
$ sudo vgremove -f vg_081
  Incorrect metadata area header checksum on /dev/pmem1 at offset 4096
  WARNING: Failed to write an MDA of VG vg_081.
  Failed to write VG vg_081.
  Incorrect metadata area header checksum on /dev/pmem1 at offset 4096
$ sudo pvremove -f /dev/pmem1
  PV /dev/pmem1 belongs to Volume Group vg_081 so please use vgreduce first.
  (If you are certain you need pvremove, then confirm by using --force twice.)
$

So whatever is going wrong is also resulting in corrupted LVM
headers on disk.

Ok, so it appears that the only workaround I've found that is
reliable is to add a "sleep 5" between the unmount and the vgremove
command. Adding udev settle commands does nothing, and there's
nothing else i can think of that would affect the unmounted
filesystem or block device once the unmount has returned to
userspace.

I've only ever seen this occur on pmem devices, so maybe it's
something perculiar to them....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
