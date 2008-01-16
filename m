Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Jan 2008 22:33:05 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0G6WuMq016898
	for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 22:32:59 -0800
Received: from pentafluge.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B7468524A27
	for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 22:33:11 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40]) by cuda.sgi.com with ESMTP id c5MBFsBxIXx9a3tI for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 22:33:11 -0800 (PST)
Date: Wed, 16 Jan 2008 06:32:35 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [REVIEW] Refactor xfs_repair's process_dinode_int
Message-ID: <20080116063234.GA21317@infradead.org>
References: <4782B72D.8070208@agami.com> <47833C0F.6070206@agami.com> <op.t4m0r1an3jf8g2@pc-bnaujok.melbourne.sgi.com> <478D1899.9080201@agami.com> <op.t4zzbvbs3jf8g2@pc-bnaujok.melbourne.sgi.com> <478D75C2.5010004@sgi.com> <20080116045943.GU155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080116045943.GU155407@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Timothy Shimmin <tes@sgi.com>, Barry Naujok <bnaujok@sgi.com>, Chandan Talukdar <chandan@agami.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Jan 16, 2008 at 03:59:43PM +1100, David Chinner wrote:
> As a result the kernel does not have endian types for single
> byte variables (ie. there's __be16, __be32, __be64 but not __be8),
> nor are there cpu_to_be8 or be8_to_cpu conversion functions.
> Hence the lack of them in the XFS code ;)
> 
> > I guess you might consider that you are letting people know
> > that we need to endian convert this value in general and
> > that if we change the code in the future it might be needed...
> 
> Well, that should be obvious when changing the structure
> that has lots of __beX types in already....

Actually enabling sparse checking for endianess annotations is still on
my todo list.  I started this project a while ago but failed when the
cgcc wrapper had some problems interacting with libtool.  I'll see how
to get that resolved.
