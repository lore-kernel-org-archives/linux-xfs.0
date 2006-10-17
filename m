Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Oct 2006 14:58:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9HLw1aG002983
	for <xfs@oss.sgi.com>; Tue, 17 Oct 2006 14:58:03 -0700
Date: Wed, 18 Oct 2006 07:57:06 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/2] Make stuff static
Message-ID: <20061017215706.GI8394166@melbourne.sgi.com>
References: <20060929032856.8DA9C18001A5E@sandeen.net> <23F15D6AE8566A54B81188AC@timothy-shimmins-power-mac-g5.local> <45338DDE.8020903@sandeen.net> <4533FAEA.2080500@sandeen.net> <20061016232250.GM11034@melbourne.sgi.com> <1161042943.5723.117.camel@xenon.msp.redhat.com> <20061017005038.GN11034@melbourne.sgi.com> <AED98B89E193744D39BAC541@pmmelb207.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AED98B89E193744D39BAC541@pmmelb207.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Tim Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>, Russell Cattelan <cattelan@thebarn.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Tue, Oct 17, 2006 at 05:13:01PM +1000, Tim Shimmin wrote:
> --On 17 October 2006 10:50:38 AM +1000 David Chinner <dgc@sgi.com> wrote:
> >Fix them - inline functions in header files should always be "static
> >inline".  Inline functions in .c files should always be static as
> >well - if they need to be accessed from different source files then
> >they need to be in header files.  Hence "STATIC inline" is broken
> >code and should be fixed anyway. Luckily, there are very few of
> >these to fix and they are all in .c files:
> >
> >chook 137% grep -rIw "STATIC inline" fs/xfs | wc -l
> >21
> 
> So you are saying that "static inline"s should always be.

Yup.

> So for CONFIG_XFS_DEBUG where we define STATIC and so make static
> disappear for uses of STATIC, we will no longer touch these
> "static inline" functions.

Yup. The function will still get inlined, so changing it's scope on
debug builds doesn't provide any benefit IMO. FWIW, for debug
builds we probably want noinline....

> I thought that for debug, we could stop them from being inline
> for easier debugging. We could have a STATIC_INLINE :-)

We could, but I don't think it gains us anything.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
