Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 16:37:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RNbSIR021900
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 16:37:30 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E37FE1492814
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 16:37:27 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id jDr2fFPF06agBK85 for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 16:37:27 -0700 (PDT)
Date: Tue, 28 Oct 2008 10:37:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] allow inode64 mount option on 32 bit systems
Message-ID: <20081027233721.GI4985@disturbed>
References: <20081027133015.GC30607@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027133015.GC30607@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Oct 27, 2008 at 09:30:15AM -0400, Christoph Hellwig wrote:
> Now that we've stopped using the Linux inode cache when can trivally
> support the inode64 mount option on 32bit architectures.  As far as the
> kernel and most userspace is concerned this works perfectly, but
> applications still using really old stat and readdir interfaces will get
> an EOVERFLOW error when hitting an inode number not fitting into 32
> bits (that problem of course also exists when using these applications
> on a 64bit kernel).
> 
> Note that because inode64 is simply a mount option we can currently
> mount a filesystem having > 32 bit inode numbers and cause a variety of
> problems, all this is solved but this patch which enables XFS_BIG_INUMS,
> even when inode64 is not used.
> 
> (First sent on October 18th)
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by; Dave Chinner <david@fromorbit.com>
-- 
Dave Chinner
david@fromorbit.com
