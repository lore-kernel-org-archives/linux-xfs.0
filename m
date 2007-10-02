Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 02 Oct 2007 02:38:34 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l929cQmg029694
	for <xfs@oss.sgi.com>; Tue, 2 Oct 2007 02:38:31 -0700
Date: Tue, 2 Oct 2007 10:38:22 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Creation time in XFS
Message-ID: <20071002093822.GA24907@infradead.org>
References: <200709302124.38164.Martin@lichtvoll.de> <470042DC.2040009@sgi.com> <p73ve9r6v3a.fsf@bingen.suse.de> <20071002092509.GF995458@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071002092509.GF995458@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Timothy Shimmin <tes@sgi.com>, Martin Steigerwald <Martin@lichtvoll.de>, xfs@oss.sgi.com

On Tue, Oct 02, 2007 at 07:25:10PM +1000, David Chinner wrote:
> > I don't think it is at all currently:
> 
> So what is the point? Forensic analysis?

Windows wants it, so I guess they added when they had to bump the inode
version anyway in preparation of a user interface for samba.  We probably
should do the same for XFS when bumping the inode version for the crcs.
