Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Sep 2008 14:09:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8FL9lZI031134
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 14:09:49 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 018051273C4E
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 14:11:18 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 8Ii1jCdeFPhR2aXK for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 14:11:18 -0700 (PDT)
Date: Mon, 15 Sep 2008 17:11:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] XFS: Make use of the init-once slab optimisation.
Message-ID: <20080915211117.GA29743@infradead.org>
References: <1221314627-29065-1-git-send-email-david@fromorbit.com> <1221314627-29065-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221314627-29065-3-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sun, Sep 14, 2008 at 12:03:46AM +1000, Dave Chinner wrote:
> To avoid having to initialise some fields of the XFS inode
> on every allocation, we can use the slab init-once feature
> to initialise them. All we have to guarantee is that when
> we free the inode, all it's entries are in the initial state.
> Add asserts where possible to ensure debug kernels check this
> initial state before freeing and after allocation.

This looks like it's already in:
http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xaiki/xfs-linux-2.6-xfs-cvs/.git;a=commitdiff;h=12efb888674600ce73a64f8c6f4a20ea5e1ce4f1
