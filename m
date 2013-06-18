Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E76537CBF
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 02:03:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E55D8304043
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 00:03:09 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id V87DpoFo0TqB2CmC
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 00:03:09 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 121D46C10A
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 02:03:09 -0500 (CDT)
Message-ID: <51C00631.9070809@hardwarefreak.com>
Date: Tue, 18 Jun 2013 02:03:13 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: linux software raid5 on lvm: sunit/swidth required?
References: <57FC0B2322184044812B39B9440D8AF662898079AA@MBX1.vi.corp>
In-Reply-To: <57FC0B2322184044812B39B9440D8AF662898079AA@MBX1.vi.corp>
Reply-To: stan@hardwarefreak.com
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
To: xfs@oss.sgi.com

On 6/17/2013 10:06 AM, Thomas Molszich wrote:
> Hello all,
> 
> At present, does one still need to calculate and pass the sunit/swidth to mkfs.xfs or does xfs calculate
> All this on its own?
> Xfsprogs 3.1.7, linked against libblkid, kernel 3.2.48 (Ubuntu 12.04 LTS), 6x3000GB Hitachi 4k sectors
> with 512b emulation, partitions and lvm 4k aligned already.

Your subject says Linux software RAID5, i.e. the md driver.  But you
don't mention md in your msg body, only "partitions and LVM 4K aligned
already".

If you layer LVM atop a striped md array then mkfs.xfs cannot see the
geometry of the md array.  LVM is not aware of it because LVM isn't
providing the striping function, and it does not perform "pass through"
of the md geometry.  So in this case you must manually align XFS,
assuming your workload will benefit from alignment.  It may not, in
which case using the default 4K alignment would be better.

mkfs.xfs will auto configure stripe geometry if directly targeting an md
striped array.  It will not with LVM atop the striped array.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
