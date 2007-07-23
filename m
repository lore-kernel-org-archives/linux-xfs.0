Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jul 2007 01:45:52 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6N8jmbm021200
	for <xfs@oss.sgi.com>; Mon, 23 Jul 2007 01:45:49 -0700
Date: Mon, 23 Jul 2007 10:45:51 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] superblock endianess annotations
Message-ID: <20070723084551.GB1003@lst.de>
References: <20070720163303.GB6902@lst.de> <20070723002432.GL31489@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723002432.GL31489@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Mon, Jul 23, 2007 at 10:24:32AM +1000, David Chinner wrote:
> > +} xfs_dsb_t;
> 
> Should this be packed so we don't reintroduce have the problem we currently
> do with 32-vs-64-bit alignment of the last field(s) in the structure?

There's no packing for the xfs_sb_t, so there's none in xfs_dsb_t
aswell.  If you introduce packing for xfs_sb_t make sure to patch
xfs_dsb_t aswell.

Should we change names to xfs_sb_t for the ondisk one an xfs_icsb_t
here aswell?  That would be a quite large change as there are a lot
more incore instances of the superblock than ondisk.
