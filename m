Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A510D7F37
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 11:01:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 229EEAC00A
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 09:01:50 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id FCP5ozdt2b9LDaLj for <xfs@oss.sgi.com>;
	Tue, 08 Dec 2015 09:01:45 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 11BFD63BEEB9
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 11:01:45 -0600 (CST)
Subject: Re: Metadata corruption detected at xfs_attr3_leaf_write_verify /
	Internal error xfs_attr3_leaf_write_verify
References: <5666F521.5060602@3qmedien.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56670CF8.9000208@sandeen.net>
Date: Tue, 8 Dec 2015 11:01:44 -0600
MIME-Version: 1.0
In-Reply-To: <5666F521.5060602@3qmedien.net>
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



On 12/8/15 9:20 AM, Dietmar Putz wrote:
> Hello all,

...

> [73715.250762] XFS (sdc1): Metadata corruption detected at xfs_attr3_leaf_write_verify+0xe5/0x100 [xfs], block 0x44482d730
> [73715.250803] XFS (sdc1): Unmount and run xfs_repair
> [73715.250816] XFS (sdc1): First 64 bytes of corrupted metadata buffer:
> [73715.250832] ffff8807f7b07000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00  ................
> [73715.250856] ffff8807f7b07010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........
> [73715.250876] ffff8807f7b07020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [73715.250907] ffff8807f7b07030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

...


> [175683.930045] ffff8807a8f59000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00  ................
                                    ^forward       ^back    ^magic^pad  ^count^usedbytes

> [175683.932979] ffff8807a8f59010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........
                                    ^firstused
> [175683.935812] ffff8807a8f59020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [175683.938644] ffff8807a8f59030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................



> [175683.940870] XFS (sdc1): Internal error xfs_attr3_leaf_write_verify at line 216 of file /build/linux-XHaR1x/linux-3.13.0/fs/xfs/xfs_attr_leaf.c.  Caller 0xffffffffa01936f0

Line 216 of xfs_attr_leaf.c: in 3.13 is:

	if (!xfs_attr3_leaf_verify(bp)) {
		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);

>From your xfs_info output, this is not a crc-enabled filesystem.

So xfs_attr3_leaf_verify() only checks these 2 things:

                if (ichdr.magic != XFS_ATTR_LEAF_MAGIC)
                        return false;

that magic is 0xfbee, so good there... and:

        if (ichdr.count == 0)
                return false;

so that's the problem, apparently.  If I'm reading it correctly, it's trying
to write an empty attribute block to disk; this shouldn't happen.

If you have traces, perhaps we can see which inode it's working on, and learn something
from examining it in xfs_db...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
