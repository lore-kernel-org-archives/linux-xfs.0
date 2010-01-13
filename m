Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0DLfAHr191681 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 15:41:10 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7A9351C4CF03
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 13:42:07 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id FTHkfRHvmfLF8AUh for
	<xfs@oss.sgi.com>; Wed, 13 Jan 2010 13:42:07 -0800 (PST)
Date: Wed, 13 Jan 2010 16:42:06 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: fix build with latest glibc headers
Message-ID: <20100113214206.GA23091@infradead.org>
References: <4B4E365E.8000306@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B4E365E.8000306@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Jan 13, 2010 at 03:08:46PM -0600, Eric Sandeen wrote:
> glibc in rawhide has some changes...
> 
> * Tue Jan 12 2010 Andreas Schwab <schwab@redhat.com> - 2.11.90-8
> - Update from master.
>   - More POSIX conformance fixes.
> 
> * Mon Jan 11 2010 Andreas Schwab <schwab@redhat.com> - 2.11.90-6
> - Update from master.
>   - POSIX conformance fixes (BZ#11125).

Great, eh? :)

> @@ -102,7 +102,7 @@ GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
>  #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
>  
>  ifeq ($(PKG_PLATFORM),linux)
> -PCFLAGS = -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 $(GCCFLAGS)
> +PCFLAGS = -D_GNU_SOURCE -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 $(GCCFLAGS)

We might aswell got to -D_XOPEN_SOURCE=700 which is the newest revision and
should give us just about everything we might need.


But generally this looks okay to me,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
