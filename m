Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 Mar 2007 18:11:39 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2Q1BZ6p018396
	for <xfs@oss.sgi.com>; Sun, 25 Mar 2007 18:11:36 -0700
From: Neil Brown <neilb@suse.de>
Date: Mon, 26 Mar 2007 11:11:11 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17927.7599.592215.21546@notabene.brown>
Subject: Re: XFS and write barriers.
In-Reply-To: message from Christoph Hellwig on Friday March 23
References: <17923.11463.459927.628762@notabene.brown>
	<20070323053043.GD32602149@melbourne.sgi.com>
	<20070323095055.GA13478@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Friday March 23, hch@infradead.org wrote:
> 
> That would be really bad.  XFS metadata buffers can have multiple bios
> and retrying a single one would be rather difficult.
> 

But would you have multiple bios for a write that had BIO_RW_BARRIER
set?  That would seem .... odd.

NeilBrown
