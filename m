Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Jul 2008 08:39:18 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6SFckQr025989
	for <xfs@oss.sgi.com>; Mon, 28 Jul 2008 08:38:48 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 205BA1940123
	for <xfs@oss.sgi.com>; Mon, 28 Jul 2008 08:39:58 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id bLkBFEZR80cmra3v for <xfs@oss.sgi.com>; Mon, 28 Jul 2008 08:39:58 -0700 (PDT)
Date: Mon, 28 Jul 2008 17:39:59 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 07/15] refactor xfs_btree_readahead
Message-ID: <20080728153959.GA29132@lst.de>
References: <20080723200859.GH7401@lst.de> <20080724233655.GH15438@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080724233655.GH15438@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Fri, Jul 25, 2008 at 09:36:55AM +1000, Dave Chinner wrote:
> I've been wondering if this is the best naming convention -
> appending a single s or l to indicate short or long btree ops.
> Perhaps this would be better as xfs_btree_readahead_short() and
> xfs_btree_readahead_long(), esp. as we dropped the 'core' from
> the caller to make it xfs_btree_readahead().

I've renamedthe helpers to xfs_btree_readahead_lblock /
xfs_btree_readahead_slblock to match the naming for the other short /
long block helpers.
