Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 20 Jul 2007 00:47:01 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6K7kwbm026469
	for <xfs@oss.sgi.com>; Fri, 20 Jul 2007 00:46:59 -0700
Date: Fri, 20 Jul 2007 08:28:47 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/7] - remove m_nreadaheads
Message-ID: <20070720072847.GA29295@infradead.org>
References: <46A03612.6030806@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A03612.6030806@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Jul 19, 2007 at 11:12:02PM -0500, Eric Sandeen wrote:
> Dave pointed this out...
> 
> m_nreadaheads in the mount struct is never used;
> remove it and the various macros assigned to it.
> 
> Also remove a couple other unused macros in the same areas.
> 
> Removes one user of xfs_physmem.

Looks good.
