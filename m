Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 Nov 2007 15:00:38 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAPMxP1e031725
	for <xfs@oss.sgi.com>; Sun, 25 Nov 2007 14:59:27 -0800
Date: Mon, 26 Nov 2007 09:59:28 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH, RFC] Delayed logging of file sizes
Message-ID: <20071125225928.GE114266761@sgi.com>
References: <47467B87.2000000@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47467B87.2000000@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Nov 23, 2007 at 06:04:39PM +1100, Lachlan McIlroy wrote:
> The easy solution is to log everything so that log replay doesn't need
> to check if the on-disk version is newer - it can just replay the log.
> But logging everything would cause too much log traffic so this patch
> is a compromise and it logs a transaction before we flush an inode to
> disk only if it has changes that have not yet been logged.

The problem with this is that the inode will be marked dirty during the
transaction, so we'll never be able to clean an inode if we issue a
transaction during inode writeback.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
