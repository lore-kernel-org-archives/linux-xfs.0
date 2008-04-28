Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Apr 2008 09:13:00 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3SGCgaf003827
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 09:12:43 -0700
Received: from tetsuo.zabbo.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8F01AFBADD
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 09:13:24 -0700 (PDT)
Received: from tetsuo.zabbo.net (tetsuo.zabbo.net [207.173.201.20]) by cuda.sgi.com with ESMTP id 9ia29zUbqGAtFGG4 for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 09:13:24 -0700 (PDT)
Message-ID: <4815F7A2.7060605@oracle.com>
Date: Mon, 28 Apr 2008 09:13:22 -0700
From: Zach Brown <zach.brown@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] vfs: reduce stack usage by shrinking struct kiocb
References: <200804270617.36629.vda.linux@googlemail.com>
In-Reply-To: <200804270617.36629.vda.linux@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: David Chinner <dgc@sgi.com>, Benjamin LaHaise <bcrl@kvack.org>, xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org

Denys Vlasenko wrote:
> Hi Al, Benjamin, David,
> 
> struct kiocb is placed on stack by, for example, do_sync_write().
> Eventually it contributes to xfs writeout path's stack usage, among others.
> This is *the* path which causes 4k stack overflows on i386 with xfs.
> 
> This patch trivially reorders fields of this structure,
> and makes some of them smaller.

Great, thanks for doing this.  I see one fatal bug, though.  Can you fix
it up and resubmit?

-	unsigned long		ki_flags;
+	unsigned short		ki_flags; /* range: 0..2 */

Careful, ki_flags is used by the bitops routines which require an
unsigned long.  I'd just leave ki_flags as is.

> ki_nr_segs: ulong -> uint: nobody uses 4 billion element writev's
>                            (and it would not work anyway)

Indeed.  Maybe explicitly mention that it's safe 'cause we pass
ki_nbytes to rw_copy_check_uvector() for comparison against UIO_MAXIOV
before we store it in the kiocb.

+	/*unsigned short	ki_opcode; - moved up for denser packing */

Don't bother commenting out fields that are moved, just move 'em.

Otherwise it looks great, thanks.

- z
