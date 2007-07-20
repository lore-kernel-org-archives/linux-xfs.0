Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 20 Jul 2007 00:47:01 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6K7kubm026455
	for <xfs@oss.sgi.com>; Fri, 20 Jul 2007 00:46:57 -0700
Date: Fri, 20 Jul 2007 08:29:39 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/7] - pick single default inode cluster
Message-ID: <20070720072939.GC29295@infradead.org>
References: <46A0361D.3090103@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A0361D.3090103@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Jul 19, 2007 at 11:12:13PM -0500, Eric Sandeen wrote:
> Remove scaling of inode "clusters" based on machine memory;
> small cluster cut-point was an unrealistic 32MB and was
> probably never tested.
> 
> Removes another user of xfs_physmem.

Looks good aswell.
