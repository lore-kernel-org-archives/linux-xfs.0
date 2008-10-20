Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 20 Oct 2008 02:22:17 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9K9M3mr009189
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 02:22:05 -0700
Date: Mon, 20 Oct 2008 05:23:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS_ERROR use - was Re: [PATCH] prevent NULL returns from
	d_obtain_alias
Message-ID: <20081020092346.GA14455@infradead.org>
References: <20081015192839.GA867@lst.de> <E1KqWzC-00087u-TG@pomaz-ex.szeredi.hu> <20081016180947.GA26285@lst.de> <48F7D814.2080705@sgi.com> <20081017171000.GC18582@lst.de> <48FBD5AB.6090306@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FBD5AB.6090306@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>, xfs-oss <xfs@oss.sgi.com>

On Mon, Oct 20, 2008 at 11:49:47AM +1100, Timothy Shimmin wrote:
> > I have to revamp that whole
> > function anyway as it's extremly buggy in many ways, especially when
> > used to open directories (can lead to multiple dentries for a single
> > directory - ouch) and then I'll kill the other uses.
> 
> Oh ok.
> 
> In userspace,
> we use it for opening directories on xfsdump via jdm_open in order to
> do bulkstat driven dirent dumping.
> We also use it in xfsrestore - though I am not convinced we should -
> it was initially done for "performance" reasons apparently.

I think the use of the API is fine, the problem is that the current
implemention is buggy.
