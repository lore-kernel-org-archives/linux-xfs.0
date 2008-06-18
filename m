Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jun 2008 05:04:52 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5IC4n83017683
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 05:04:49 -0700
Date: Wed, 18 Jun 2008 14:05:36 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] kill INDUCE_IO_ERROR
Message-ID: <20080618120535.GA32691@lst.de>
References: <20080523062323.GA32637@lst.de> <20080616101412.GA17939@lst.de> <485892D7.4080000@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <485892D7.4080000@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Donald Douwsma <donaldd@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Wed, Jun 18, 2008 at 02:45:11PM +1000, Donald Douwsma wrote:
> Christoph Hellwig wrote:
> >On Fri, May 23, 2008 at 08:23:23AM +0200, Christoph Hellwig wrote:
> >>All the error injection is already enabled through ifdef DEBUG, so kill
> >>the never set second cpp symbol to activate it without the rest of the
> >>debugging infrastructure.
> >
> >Can I get a review on this absolutely trivial patch?
> 
> I'd like to keep INDUCE_IO_ERROR around so we have a way to introduce
> ioerrors in release builds during testing.
> 
> We could add it to xfs.h with the commented out QUOTADEBUG so people
> know we still want to use it.

cpp symbols not exposed by Kconfig will never get tested.  If you thing
it's really useful for release builds (which don't quite agree with) we
should just enable it unconditionally.  It's just in a few places, and
any branch predictor worth it's name should take care of the additional
branches without visible cost.
