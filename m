Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Dec 2007 12:31:11 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBEKV2nU000873
	for <xfs@oss.sgi.com>; Fri, 14 Dec 2007 12:31:05 -0800
Received: from pentafluge.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A3CD3484C49
	for <xfs@oss.sgi.com>; Fri, 14 Dec 2007 12:31:14 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40]) by cuda.sgi.com with ESMTP id ihk6y9VIWmsR6qXv for <xfs@oss.sgi.com>; Fri, 14 Dec 2007 12:31:14 -0800 (PST)
Date: Fri, 14 Dec 2007 20:30:41 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] prevent panic during log recovery due to bogus
	operation header length
Message-ID: <20071214203041.GB23564@infradead.org>
References: <475F88C3.709@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475F88C3.709@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Dec 12, 2007 at 06:07:47PM +1100, Lachlan McIlroy wrote:
> A problem was reported where a system panicked in log recovery due
> to a corrupt log record.  The cause of the corruption is not known
> but this change will at least prevent a crash for this specific
> scenario.  Log recovery definitely needs some more work in this area.
>
> Lachlan

> --- fs/xfs/xfs_log_recover.c_1.332	2007-12-12 17:14:57.000000000 +1100
> +++ fs/xfs/xfs_log_recover.c	2007-12-12 17:15:42.000000000 +1100
> @@ -2912,7 +2912,12 @@ xlog_recover_process_data(
>  				xlog_recover_new_tid(&rhash[hash], tid,
>  					be64_to_cpu(rhead->h_lsn));
>  		} else {
> -			ASSERT(dp + be32_to_cpu(ohead->oh_len) <= lp);
> +			if (dp + be32_to_cpu(ohead->oh_len) > lp) {
> +				xlog_warn(
> +			"XFS: xlog_recover_process_data: bad length");
> +				ASSERT(0);
> +				return (XFS_ERROR(EIO));
> +			}

this still gives a panic for debug builds..  Maybe this should become
a WARN_ON(1) instead?
