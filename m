Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Aug 2007 13:16:36 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7SKGV4p018191
	for <xfs@oss.sgi.com>; Tue, 28 Aug 2007 13:16:33 -0700
Date: Tue, 28 Aug 2007 20:52:21 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] refactor xfs_mountfs for clarity & stack savings
Message-ID: <20070828195221.GA7237@infradead.org>
References: <46D37A82.2080608@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D37A82.2080608@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>


Looks goo to me except for a tiny nitpick:

> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net
> +		if ((error = xfs_readsb(mp, mfsi_flags))) {
> +			return error;
> +		}

> +	if ((error = xfs_update_alignment(mp, mfsi_flags, &update_flags)))
> +		goto error1;

> +	if ((error = xfs_check_sizes(mp, mfsi_flags)))
> +		goto error1;

>  	if ((error = xfs_rtmount_init(mp))) {

Please make sure the assignment and conditional are on separate lines
for all of these once you're cleaning up this function.  In the first
case there's also some braces to remove.
