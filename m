Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 Nov 2007 15:17:39 -0800 (PST)
Received: from smtp110.mail.mud.yahoo.com (smtp110.mail.mud.yahoo.com [209.191.85.220])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAPNHWRI002808
	for <xfs@oss.sgi.com>; Sun, 25 Nov 2007 15:17:33 -0800
From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 1/9]: introduce radix_tree_gang_lookup_range
Date: Mon, 26 Nov 2007 10:17:24 +1100
References: <20071122003211.GG114266761@sgi.com>
In-Reply-To: <20071122003211.GG114266761@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711261017.24694.nickpiggin@yahoo.com.au>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>

On Thursday 22 November 2007 11:32, David Chinner wrote:
> Introduce radix_tree_gang_lookup_range()
>
> The inode clustering in XFS requires a gang lookup on the radix tree to
> find all the inodes in the cluster.  The gang lookup has to set the
> maximum items to that of a fully populated cluster so we get all the
> inodes in the cluster, but we only populate the radix tree sparsely (on
> demand).
>
> As a result, the gang lookup can search way, way past the index of end
> of the cluster because it is looking for a fixed number of entries to
> return.
>
> We know we want to terminate the search at either a specific index or a
> maximum number of items, so we need to add a "last_index" parameter to
> the lookup.

Yeah, this fixes one downside of the gang lookup API. For consistency
it would be nice to do this for the tag lookup API as well...


> Furthermore, the existing radix_tree_gang_lookup() can use this same
> function if we define a RADIX_TREE_MAX_INDEX value so the search is not
> limited by the last_index.

Nit: should just define it to be ULONG_MAX.

>
> Signed-off-by: Dave Chinner <dgc@sgi.com>

Otherwise, Acked-by: Nick Piggin <npiggin@suse.de>
