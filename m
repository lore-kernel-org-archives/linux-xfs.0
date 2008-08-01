Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Aug 2008 12:45:37 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m71JjY4x026877
	for <xfs@oss.sgi.com>; Fri, 1 Aug 2008 12:45:34 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B011C19694BD
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2008 12:46:46 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id UqLSddrE3S7uYl8U for <xfs@oss.sgi.com>; Fri, 01 Aug 2008 12:46:46 -0700 (PDT)
Date: Fri, 1 Aug 2008 21:46:48 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/21] add get_maxrecs btree operation
Message-ID: <20080801194648.GH1263@lst.de>
References: <20080729193121.GO19104@lst.de> <20080730053455.GO13395@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730053455.GO13395@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Wed, Jul 30, 2008 at 03:34:55PM +1000, Dave Chinner wrote:
> On Tue, Jul 29, 2008 at 09:31:21PM +0200, Christoph Hellwig wrote:
> > Factor xfs_btree_maxrecs into a per-btree operation.
> > 
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> ->get_maxrecs was extracted out of my original patchset, right?
> 
> I didn't apply it to removing xfs_btree_maxrecs(), though. Good
> idea. Looks fine to me.

Yeah, should have added a comment that this has been taken from the
big patch.
