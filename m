Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Sep 2007 05:57:07 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8QCv0q5013139
	for <xfs@oss.sgi.com>; Wed, 26 Sep 2007 05:57:02 -0700
Date: Wed, 26 Sep 2007 13:28:54 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PARTIAL TAKE 971050 - Remove linux-2.4 build support
Message-ID: <20070926122854.GA17050@infradead.org>
References: <20070926082614.D92CE300F406@linuxbuild.melbourne.sgi.com> <46FA4FA5.5040405@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FA4FA5.5040405@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: donaldd@sgi.com, xfs@oss.sgi.com

On Wed, Sep 26, 2007 at 07:25:09AM -0500, Eric Sandeen wrote:
> So, what's to be done about xfs_refcache.c... right now it's 2.4-only,
> but i'm not convinced that there is similar generic nfs functionality in
> 2.6, anyone know for sure?

We keep the inodes around through nfsd, yes.  There's a slight problem
with ->release beeing called to early, but Greg is working on fixing
that using an open files cache in nfsd.
