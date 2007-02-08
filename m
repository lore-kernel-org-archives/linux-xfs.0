Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 Feb 2007 11:53:55 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l18Jrhm7014101
	for <xfs@oss.sgi.com>; Thu, 8 Feb 2007 11:53:44 -0800
Date: Thu, 8 Feb 2007 19:27:12 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] don't special-case 32MB machines
Message-ID: <20070208192712.GA1461@infradead.org>
References: <45CA7D7B.3060307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45CA7D7B.3060307@redhat.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Feb 07, 2007 at 07:31:39PM -0600, Eric Sandeen wrote:
> This one may be a bit silly, but:
> 
> All the special cases for 32MB machines probably aren't so useful anymore...
> 
> Or maybe this points to the need to bump up the scaling points & sizes a 
> bit?
> 
> Also remove duplicate, unused XFS_MAX_RW_NBMAPS definitions in linux 
> subdirs.

Sounds good.  Any chance you could kill off xfs_physmem completely?
