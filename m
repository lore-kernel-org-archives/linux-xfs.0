Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 22 Sep 2008 00:50:27 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8M7oNgD001150
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 00:50:24 -0700
Date: Mon, 22 Sep 2008 03:51:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] Unlock inode before calling xfs_idestroy()
Message-ID: <20080922075155.GA14024@infradead.org>
References: <48D72864.2020604@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D72864.2020604@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Sep 22, 2008 at 03:08:52PM +1000, Lachlan McIlroy wrote:
> Lock debugging reported the ilock was being destroyed without being
> unlocked.  We don't need to lock the inode until we are going to
> insert it into the radix tree.

Looks good.
