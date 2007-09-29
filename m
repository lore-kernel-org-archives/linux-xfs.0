Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 29 Sep 2007 03:12:09 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8TAC06K005189
	for <xfs@oss.sgi.com>; Sat, 29 Sep 2007 03:12:04 -0700
Date: Sat, 29 Sep 2007 10:40:32 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PARTIAL TAKE 971050 - Remove linux-2.4 build support
Message-ID: <20070929094032.GA29241@infradead.org>
References: <20070926083416.C441A30A90AD@linuxbuild.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926083416.C441A30A90AD@linuxbuild.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: donaldd@sgi.com
Cc: xfs@oss.sgi.com

On Wed, Sep 26, 2007 at 06:34:16PM +1000, donaldd@sgi.com wrote:
> Remove Makefile wrappers in XFS
> 
> Makefile (and Kbuild) would include Makefile-linux-26
> I doubt XFS will really still compile on 2.4; so drop that. This
> moves Makefile-linux-26 into Makefile and drops Kbuild.
> Also having wrappers as both Kbuild and Makefile seemed redundant
> anyways.

After pulling this patch I can't build XFS anymore, because
in the CVS export there's a zero-size fs/xfs/Kbuild file left and the
kernel build thus doesn't actually look at fs/xfs/Makefile.

Can someone from SGI check if the file really isn't deleted in ptools
or whether is is a fuckup in the cvs export script?
