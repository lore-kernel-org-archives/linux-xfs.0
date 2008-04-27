Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Apr 2008 16:57:43 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3RNvQIY006817
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 16:57:27 -0700
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 14D5110C4BA9
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 16:58:09 -0700 (PDT)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.159]) by cuda.sgi.com with ESMTP id Js0iz0fF2a6i2Uf3 for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 16:58:09 -0700 (PDT)
Received: by fg-out-1718.google.com with SMTP id e12so4054834fga.8
        for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 16:58:08 -0700 (PDT)
From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_bmap_btalloc()
Date: Mon, 28 Apr 2008 01:57:12 +0200
References: <200804261651.02078.vda.linux@googlemail.com> <20080427234056.GA108924158@sgi.com>
In-Reply-To: <20080427234056.GA108924158@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804280157.12736.vda.linux@googlemail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org

On Monday 28 April 2008 01:40, David Chinner wrote:
> On Sat, Apr 26, 2008 at 04:51:02PM +0200, Denys Vlasenko wrote:
> > Hi David,
> > 
> > This patch reduces xfs_bmap_btalloc() stack usage by 50 bytes
> > by moving part of its body into a helper function.
> 
> Can you please attach your patches inline, Denys (see
> Documentation/SubmittingPatches)?

I can, but Kmail is notorious for mangling them :(

Is it ok if I will paste them inline AND attach them too,
so that you get guaranteed-nonmangled one in attachment?

> I have a set of patches that introduces new functionality into the
> allocator (dynamic allocation policies) that reduces
> xfs_bmap_btalloc() function by 36 bytes (just by chance, I didn't
> design it for this purpose). It breaks it down on functional
> boundaries like Christoph's patch. I'm going to revist that patch
> w.r.t both these patches and see what falls out the bottom...

Nice to know that.

Can you point me to svn/CVS/git/whatever which holds latest xfs
devel tree?
--
vda
