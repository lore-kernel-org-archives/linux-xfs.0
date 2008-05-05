Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 04 May 2008 22:54:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m455s4s6020570
	for <xfs@oss.sgi.com>; Sun, 4 May 2008 22:54:05 -0700
Date: Mon, 5 May 2008 01:54:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: review: xfstests/016 change
Message-ID: <20080505055446.GB15609@infradead.org>
References: <481E7F17.5090601@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481E7F17.5090601@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, May 05, 2008 at 01:29:27PM +1000, Timothy Shimmin wrote:
> Hi there,
>
> xfstests/016 has been failing for a while in many cases.
> It was relying on the log traffic for create/rm to be unaltered
> in XFS over the life of XFS.
> Its initial purpose was to test out the writing of the log around
> wrapping and checking that as we wrapped we didn't corrupt any data
> after the end of the log.
>
> The patch is to modify xfstest, 016, to take a sampling of the log traffic
> to guestimate how many ops are needed to get to the end of the log,
> instead of hard-coding in how many ops are expected to get there.

I get four rejects out of four hunk when trying to apply this patch,
looks like whitespace-damage.
