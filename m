Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 00:53:43 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6L7reX9031745
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 00:53:40 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A4292C31A7
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 00:54:49 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id GZKmbCy72I0wBnPH for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 00:54:49 -0700 (PDT)
Date: Mon, 21 Jul 2008 03:54:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] XFS: remove i_gen from incore inode
Message-ID: <20080721075449.GB6692@infradead.org>
References: <1216558002-838-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216558002-838-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sun, Jul 20, 2008 at 10:46:42PM +1000, Dave Chinner wrote:
> i_gen is incremented in directory operations when the
> directory is changed. It is never read or otherwise used
> so it should be removed to help reduce the size of the
> struct xfs_inode.

It also removes a xfs_trans_log_inode in xfs_remove, which looks
fine to me from a quick glance, but this should be verified and
documented.

Otherwise looks good.
