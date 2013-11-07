Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8D9547FDB
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 01:06:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 768318F806F
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 23:06:25 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id AbDAlWeptr6vbjba (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 06 Nov 2013 23:06:24 -0800 (PST)
Date: Wed, 6 Nov 2013 23:06:22 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsdump: don't assume getdents exists
Message-ID: <20131107070622.GA32437@infradead.org>
References: <20131106213635.GC24712@redacted.bos.redhat.com>
	<20131107065835.GA24345@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131107065835.GA24345@infradead.org>
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
To: Kyle McMartin <kyle@redhat.com>
Cc: sandeen@redhat.com, xfs@oss.sgi.com

On Wed, Nov 06, 2013 at 10:58:35PM -0800, Christoph Hellwig wrote:
> On Wed, Nov 06, 2013 at 04:36:35PM -0500, Kyle McMartin wrote:
> > New Linux ports are using a standard syscall list that does not include
> > deprecated syscalls where 64-bit clean alternatives exist. As a result,
> > on arm64, __NR_getdents is undefined, resulting in xfsdump failing to
> > build.
> > 
> > To avoid that, in the case where __NR_getdents is unset in unistd.h,
> > avoid building the fallback path entirely, since
> > __ASSUME_GETDENTS64_SYSCALL will be true, the SYS_getdents64 case will
> > be the primary (and only) path used.
> 
> Seems like we could drop this mess of a file entirely and just rely
> on getdents64 from glibc.  The raison d'etre of that file appears to
> support 64 bit getdents before glibc really supported it, and I don't
> think we'll have to support such old configurations anymore.  I'll give
> it a quick spin and see how that works out.

Turns out there is no glibc wrapper for getdents, so unless we want
to use the buffered readdir code we'll have to stick to some variant of
this.  But I think we can just kill the fallback and use getdents64
unconditionally.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
