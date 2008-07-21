Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 04:51:23 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6LBpJoH023296
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 04:51:21 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 83B5C12E7E85
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 04:52:29 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id zNFJgnJXvLqGFbC4 for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 04:52:29 -0700 (PDT)
Date: Mon, 21 Jul 2008 07:52:28 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] XFS: remove i_gen from incore inode
Message-ID: <20080721115228.GA14077@infradead.org>
References: <1216558002-838-1-git-send-email-david@fromorbit.com> <20080721075449.GB6692@infradead.org> <20080721110814.GC6761@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721110814.GC6761@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Jul 21, 2008 at 09:08:14PM +1000, Dave Chinner wrote:
> On Mon, Jul 21, 2008 at 03:54:49AM -0400, Christoph Hellwig wrote:
> > On Sun, Jul 20, 2008 at 10:46:42PM +1000, Dave Chinner wrote:
> > > i_gen is incremented in directory operations when the
> > > directory is changed. It is never read or otherwise used
> > > so it should be removed to help reduce the size of the
> > > struct xfs_inode.
> > 
> > It also removes a xfs_trans_log_inode in xfs_remove, which looks
> > fine to me from a quick glance, but this should be verified and
> > documented.
> 
> If you note in the very next if/else statement the directory inode
> gets logged - either by dropping the link or directly. IOWs, we
> were logging the directory inode twice with the same value
> (XFS_ILOG_CORE). So I don't think there??s any problem here.

Indeed. The patch looks good but a little description like the one above
in the commit message would be nice.
