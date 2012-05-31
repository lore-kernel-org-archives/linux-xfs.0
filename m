Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4VHrLOo057093 for <xfs@oss.sgi.com>; Thu, 31 May 2012 12:53:21 -0500
Date: Thu, 31 May 2012 12:59:13 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/2] types.h: implement intptr_t and uintptr_t
Message-ID: <20120531175913.GH4721@sgi.com>
References: <20120525103758.GD1707@infradead.org>
	<1337961147-11668-1-git-send-email-jengelh@inai.de>
	<1337961147-11668-2-git-send-email-jengelh@inai.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1337961147-11668-2-git-send-email-jengelh@inai.de>
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
To: Jan Engelhardt <jengelh@inai.de>
Cc: hch@infradead.org, joe@perches.com, xfs@oss.sgi.com

Hey Jan,

On Fri, May 25, 2012 at 05:52:26PM +0200, Jan Engelhardt wrote:
> intptr_t and uintptr_t designate an (un)signed integer type capable of
> holding void* pointers.
> (http://pubs.opengroup.org/onlinepubs/000095399/basedefs/stdint.h.html )
> 
> Notes: In linux/types.h, there are a handful of guards like "#ifdef
> _PTRDIFF_T", but a git grep reveals that this is never ever defined
> anywhere, so I omitted a corresponding "#ifdef _INTPTR_T" guard.
> Same goes for "#define __kernel_ptrdiff_t" in
> arch/sh/include/asm/posix_types_64.h.

Would it be appropriate to CC linux-kernel on this one given the nature of the
change?

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
