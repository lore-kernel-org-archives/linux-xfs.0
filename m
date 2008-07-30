Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Jul 2008 00:34:14 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6U7YCmp023866
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2008 00:34:13 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9AB6D1947ED9
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2008 00:35:24 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id Ie2gVEk6EenhnzoI for <xfs@oss.sgi.com>; Wed, 30 Jul 2008 00:35:24 -0700 (PDT)
Date: Wed, 30 Jul 2008 17:35:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/15] refactor xfs_btree_readahead
Message-ID: <20080730073522.GW13395@disturbed>
References: <20080723200859.GH7401@lst.de> <20080724233655.GH15438@disturbed> <20080728153959.GA29132@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728153959.GA29132@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Mon, Jul 28, 2008 at 05:39:59PM +0200, Christoph Hellwig wrote:
> On Fri, Jul 25, 2008 at 09:36:55AM +1000, Dave Chinner wrote:
> > I've been wondering if this is the best naming convention -
> > appending a single s or l to indicate short or long btree ops.
> > Perhaps this would be better as xfs_btree_readahead_short() and
> > xfs_btree_readahead_long(), esp. as we dropped the 'core' from
> > the caller to make it xfs_btree_readahead().
> 
> I've renamedthe helpers to xfs_btree_readahead_lblock /
> xfs_btree_readahead_slblock to match the naming for the other short /
> long block helpers.

Ok, that sounds reasonable.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
