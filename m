Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Feb 2008 14:52:11 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m13Mq5SE025022
	for <xfs@oss.sgi.com>; Sun, 3 Feb 2008 14:52:07 -0800
Date: Mon, 4 Feb 2008 09:52:18 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Extent merging past MAXEXTLEN
Message-ID: <20080203225218.GY155407@sgi.com>
References: <479E4A52.6000804@agami.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479E4A52.6000804@agami.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Nishimoto <miken@agami.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Mon, Jan 28, 2008 at 01:34:10PM -0800, Michael Nishimoto wrote:
> Hi everyone,
> 
> Is there a reason to continue limiting extent merges past MAXEXTLEN
> on 64-bit systems?

I don't think 32/64bit issues enter into this - the max extent length is
determined by the filesystem block size (the on disk length is in filesystem
blocks) so by default we are already at byte lengths greater than what fits in
a 32bit variable (i.e. 2^21*2^12 = 2^33).

Basically, MAXEXTLEN defines the number of bits in the length field of the on-disk
extent record when it is packed and so without a on-disk format change, we can't
sanely increase the size of this field. Perhaps we should look at doing this,
but it's going to have to wait until the btree re-factoring code is completed
so we can implement the record format change sanely....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
