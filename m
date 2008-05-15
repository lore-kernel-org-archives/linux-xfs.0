Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 May 2008 23:03:48 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4F63Tld016993
	for <xfs@oss.sgi.com>; Wed, 14 May 2008 23:03:30 -0700
Date: Thu, 15 May 2008 02:04:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] xfsqa 166 - fix filter pathname issue
Message-ID: <20080515060416.GA8780@infradead.org>
References: <20080515011735.GL155679365@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515011735.GL155679365@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, May 15, 2008 at 11:17:35AM +1000, David Chinner wrote:
> If the path to the file being bmap'd has a [0-9] in it,
> the output filter matches it and we get golden output
> failure. Be more specific on the match.

Looks good.
