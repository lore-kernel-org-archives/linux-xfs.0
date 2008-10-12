Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 12 Oct 2008 15:19:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9CMJ1sc025153
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 15:19:01 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C53D0A5565C
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 15:20:36 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id npOfC7he9uO95Ke4 for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 15:20:36 -0700 (PDT)
Date: Mon, 13 Oct 2008 00:20:32 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fix remount rw with unrecognized options
Message-ID: <20081012222032.GA19748@lst.de>
References: <20081012123044.GA30272@lst.de> <48F27807.1080702@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F27807.1080702@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Sun, Oct 12, 2008 at 05:19:51PM -0500, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> > When we skip unrecognized options in xfs_fs_remount we should just break
> > out of the switch and not return because otherwise we may skip clearing
> > the xfs-internal read-only flag.  This will only show up on some
> > operations like touch because most read-only checks are done by the VFS
> > which things this filesystem is r/w.  Eventually we should replace the
> > XFS read-only flag with a helper that always checks the VFS flag to make
> > sure they can never get out of sync.
> > 
> > Bug reported and fix verified by Marcel Beister on #xfs.
> 
> Seems reasonable.
> 
> I think this is 2.6.27.1 material?

Yes.
