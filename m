Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 Nov 2007 07:20:19 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lALFJwge007767
	for <xfs@oss.sgi.com>; Wed, 21 Nov 2007 07:20:12 -0800
Date: Wed, 21 Nov 2007 15:20:06 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH,RFC] Factor some btree code....
Message-ID: <20071121152006.GD8454@infradead.org>
References: <20071106091836.GV995458@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071106091836.GV995458@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>


I like this.  But I think a single set of xfs_btree_ops would be a lot
more readable.  Also I'm not sure we actually need all these ops, e.g.
instead of .buf_to_block we could always just call XFS_BUF_PTR directly.
