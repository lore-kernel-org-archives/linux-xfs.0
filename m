Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 26 Apr 2008 16:06:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3QN6CSI006927
	for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 16:06:15 -0700
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B50EF5BC7
	for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 16:06:54 -0700 (PDT)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.154]) by cuda.sgi.com with ESMTP id 5kMvxxN3sGb9QrB6 for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 16:06:54 -0700 (PDT)
Received: by fg-out-1718.google.com with SMTP id e12so3666309fga.8
        for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 16:06:53 -0700 (PDT)
From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_bmap_btalloc()
Date: Sun, 27 Apr 2008 01:05:17 +0200
References: <200804261651.02078.vda.linux@googlemail.com> <48137A7E.4000202@sandeen.net>
In-Reply-To: <48137A7E.4000202@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804270105.18096.vda.linux@googlemail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org

On Saturday 26 April 2008 20:54, Eric Sandeen wrote:
> > This patch reduces xfs_bmap_btalloc() stack usage by 50 bytes
> > by moving part of its body into a helper function.
> > 
> > This results in some variables not taking stack space in
> > xfs_bmap_btalloc() anymore.
> > 
> > The helper itself does not call anything stack-deep.
> > Stack-deep call to xfs_alloc_vextent() happen
> > in xfs_bmap_btalloc(), as before.
> > 
> > Compile tested only.
> > 
> > Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
> 
> Looks like a very good approach, it pushes a lot of large local vars off
> into the helper.
> 
> There is one build-time problem if DEBUG is turned on:
> 
>         if (args.fsbno != NULLFSBLOCK) {
>                 ap->firstblock = ap->rval = args.fsbno;
>                 ASSERT(nullfb || fb_agno == args.agno ||
>                        (ap->low && fb_agno < args.agno));
> 
> in xfs_bmap_btalloc, which no longer has an fb_agno variable which the
> ASSERT macro uses.

Do you want me to rework and resend the patch?
--
vda
