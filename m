Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57358 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755775AbcIKM6g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Sep 2016 08:58:36 -0400
Date: Sun, 11 Sep 2016 05:58:33 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/6] fs: add iomap_file_dirty
Message-ID: <20160911125833.GE1399@infradead.org>
References: <147216784041.525.7722906502172299465.stgit@birch.djwong.org>
 <147216786712.525.5901639662288553230.stgit@birch.djwong.org>
 <20160905145751.GC7662@infradead.org>
 <20160906173428.GG16696@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160906173428.GG16696@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>, david@fromorbit.com, viro@ZenIV.linux.org.uk, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-api@vger.kernel.org

On Tue, Sep 06, 2016 at 10:34:28AM -0700, Darrick J. Wong wrote:
> > > XXX: might want a bigger name, and possible a better implementation
> > > that doesn't require two lookups in the radix tree.
> > 
> > And these need to be looked into.  I can take a stab at it, but I need
> > to get a few other things off my plate first.
> 
> Yeah.  It works well enough for unsharing blocks, if inefficiently.
> 
> Not sure what "a bigger name" means, though.  I tried feeding the
> function prototype through figlet but gcc didn't like that. ;)

That should have been "better", sorry.
