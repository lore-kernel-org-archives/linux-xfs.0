Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6SEL03T184672 for <xfs@oss.sgi.com>; Tue, 28 Jul 2009 09:21:01 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BFAFC149F51C
	for <xfs@oss.sgi.com>; Tue, 28 Jul 2009 07:30:31 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id UPg7I6CtmDqkGeah for
	<xfs@oss.sgi.com>; Tue, 28 Jul 2009 07:30:31 -0700 (PDT)
Message-ID: <4A6F0978.4070709@sandeen.net>
Date: Tue, 28 Jul 2009 09:21:44 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: BUG REPORT: XFS LOG FORWARD COMPATIBILITY PROBLEM
References: <362522677.1010811248671789619.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>	<1938435153.1010831248671852499.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
	<b094161c0907280550y58cde45fja97b2c413c92a8d4@mail.gmail.com>
In-Reply-To: <b094161c0907280550y58cde45fja97b2c413c92a8d4@mail.gmail.com>
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
To: Eddy Zhao <eddy.y.zhao@gmail.com>
Cc: Lachlan McIlroy <lmcilroy@redhat.com>, xfs@oss.sgi.com

Eddy Zhao wrote:
> Hello Lachlan:
> 
>>
>> We all start somewhere!
>>
> 
> Yes. I'll start from this problem :)
> 
>>
>> It should also be the same architecture too - is it possible you have a
>> 32 bit kernel on the 2.6.10 system and a 64 bit kernel on the 2.6.28
>> system?  If so then this fix might help
>>
> 
> The two systems are all 32bit.
> 
> Enlightened by your suggestion, I find problem lies in the two systems
> are different architecture. One is arm, on is x86. Use 2.6.10 on both
> system, XFS created on arm can't mount on x86, vice versa (dump stack at
> xlog_recover_process_data).

Well, the fact that you have 2 arches would have been highly relevant in
your first email.  ;)  Is this the old abi or the new?  Guessing old,
based on the alignment issues.

> Use xfs_logprint to inspect log, tool exit with assertion failed:
> "item->ri_buf[0].i_len == sizeof(xfs_inode_log_format_t)". Debug the
> assertion and find xfs_inode_log_format_t on arm is 56 byte, on x86 is
> 52 byte. Then find on 2.6.10 xfs_inode_log_format is not packed!! Fix
> this, fix the mount failed problem.
> 
> Grep the code and find a lot other log/metadata needs pack on 2.6.10. I
> find these
>  xfs_fid64
>  xfs_extent_32_t
>  xfs_efi_log_format_32_t
>  xfs_efd_log_format_32_t
>  xfs_inode_log_format_32_t
>  xfs_flock64_32
>  compat_xfs_fsop_geom_v1_t
>  compat_xfs_inogrp_t
>  xfs_dir2_sf_off_t
>  xfs_dir2_sf_hdr_t
>  xfs_dir2_sf_entry_t
> 
> Is there any other log/metadata needs pack on 2.6.10? Any other
> problem/caveat I need pay attention to while/besides fix pack bug?

Well, packing structures like mad is not a great solution[1] - it needs
to be done carefully & judiciously.  We don't want to pack structures
that are already aligned on most arches, because this will cause
performance issues.

But I see above you've found a few that were, for various reasons.  Note
that the dir2 types above use a funky "__arch_pack" to conditionally
pack only on arm old abi:

/* ARM old ABI has some weird alignment/padding */
#if defined(__arm__) && !defined(__ARM_EABI__)
#define __arch_pack __attribute__((packed))
#else
#define __arch_pack
#endif

When I looked around for structure size mismatches on arm old abi, I was
only looking at on-disk structures for which were big-endian.  Because
the log is native-endian, I did not think to check the log structures.

To be honest, I am not certain that this is "worth fixing" - we already
have the requirement that log replay can only be done on an architecture
of the same endianness, and a further requirement that it can only be
done on architectures with similar alignment rules doesn't seem so bad.
 The problem is, if you go off and "fix" this on arm now, you'll find
that logs created under older arm kernels can't be replayed on newer arm
kernels and vice versa...

-Eric

[1]
http://digitalvampire.org/blog/index.php/2006/07/31/why-you-shouldnt-use-__attribute__packed/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
