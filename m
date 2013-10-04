Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 73E757F4E
	for <xfs@oss.sgi.com>; Fri,  4 Oct 2013 17:16:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 40B20304051
	for <xfs@oss.sgi.com>; Fri,  4 Oct 2013 15:16:11 -0700 (PDT)
Received: from mail-oa0-f47.google.com (mail-oa0-f47.google.com
	[209.85.219.47]) by cuda.sgi.com with ESMTP id hSEr4NRmLWXYtAvg
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Oct 2013 15:16:09 -0700 (PDT)
Received: by mail-oa0-f47.google.com with SMTP id i1so4656989oag.34
	for <xfs@oss.sgi.com>; Fri, 04 Oct 2013 15:16:09 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: RESEND: xattr issue with 3.11 kernel
From: David Zafman <david.zafman@inktank.com>
In-Reply-To: <20131004210411.GJ4446@dastard>
Date: Fri, 4 Oct 2013 15:16:05 -0700
Message-Id: <6ECC8063-935A-4DD6-A460-4B7D8AE24271@inktank.com>
References: <ED5C1C84-614E-4EBB-A966-BBCD9CE89373@inktank.com>
	<20131004210411.GJ4446@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: ceph-devel@vger.kernel.org, xfs@oss.sgi.com


Dave,

The 3.12-rc3 kernel passed my test.  Thanks for the quick response.

David Zafman
Senior Developer
http://www.inktank.com




On Oct 4, 2013, at 2:04 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Fri, Oct 04, 2013 at 01:48:17PM -0700, David Zafman wrote:
>> 
>> <<Plain Text>>
>> 
>> This was also seen on a customized 3.10 kernel, but didn't reproduce on the Ubuntu 13.04 packaged 3.8 kernel.
>> 
>> $ cat /etc/issue
>> Ubuntu 13.04 \n \l
>> $ uname -a
>> Linux ubuntu 3.11.0-031100-generic #201309021735 SMP Mon Sep 2 21:36:21 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
>> $ mount | grep /mnt
>> /dev/sdb on /mnt type xfs (rw)
>> $ ./xattr-test.sh /mnt/foo 10240
>> 8
>> 16
>> 32
>> 64
>> 128
>> 256
>> 512
>> 1024
>> 2048
>> setfattr: /mnt/foo: Structure needs cleaning
>> failure to remove user.test1557
>> 
>> ffff88003a005000: 46 c4 4f 2f 00 00 06 b5 46 c4 4f a6 00 00 06 b4  F.O/....F.O.....
>> ffff88003a005010: 46 c4 4f a7 00 00 06 b3 46 c4 4f a8 00 00 06 b2  F.O.....F.O.....
>> ffff88003a005020: 46 c4 4f a9 00 00 06 b1 46 c4 4f aa 00 00 06 b0  F.O.....F.O.....
>> ffff88003a005030: 46 c4 4f ab 00 00 06 af 46 c4 4f ac 00 00 06 ae  F.O.....F.O.....
>> XFS (sdb): Internal error xfs_da_do_buf(2) at line 2694 of file /home/apw/COD/linux/fs/xfs/xfs_da_btree.c.  Caller 0xffffffffa0304423
>> 
>> CPU: 0 PID: 35058 Comm: setfattr Not tainted 3.11.0-031100-generic #201309021735
>> Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
>> 0000000000000001 ffff8800354ab9f8 ffffffff81720fca 0000000000000007
>> ffff88003a27b800 ffff8800354aba18 ffffffffa02cd27f ffffffffa0304423
>> 0000000000000001 ffff8800354aba58 ffffffffa02cd2ee 0000000000000002
>> Call Trace:
>> [<ffffffff81720fca>] dump_stack+0x46/0x58
>> [<ffffffffa02cd27f>] xfs_error_report+0x3f/0x50 [xfs]
>> [<ffffffffa0304423>] ? xfs_da3_node_read+0x23/0xd0 [xfs]
>> [<ffffffffa02cd2ee>] xfs_corruption_error+0x5e/0x90 [xfs]
>> [<ffffffffa030438a>] xfs_da_read_buf+0x1ba/0x230 [xfs]
>> [<ffffffffa0304423>] ? xfs_da3_node_read+0x23/0xd0 [xfs]
>> [<ffffffffa0332127>] ? xfs_trans_log_buf+0x97/0x100 [xfs]
>> [<ffffffffa0304423>] xfs_da3_node_read+0x23/0xd0 [xfs]
>> [<ffffffffa030608c>] xfs_da3_blk_unlink.isra.13+0x16c/0x1e0 [xfs]
>> [<ffffffffa030633f>] xfs_da3_join+0x9f/0x240 [xfs]
>> [<ffffffffa02e6872>] xfs_attr_node_removename+0x192/0x300 [xfs]
> 
> You are probably hitting the problem fixed in commit 997def2 ("xfs:
> fix node forward in xfs_node_toosmall") which went into 3.12-rc3.
> Can you test that this fixes your problem, ad if so, we'll need to
> push it back to -stable kernels..
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
