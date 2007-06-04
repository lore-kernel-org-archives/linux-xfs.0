Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Jun 2007 07:53:03 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l54EqwWt024112
	for <xfs@oss.sgi.com>; Mon, 4 Jun 2007 07:52:59 -0700
Date: Mon, 4 Jun 2007 15:52:58 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] XFS metadump utility
Message-ID: <20070604145258.GB28033@infradead.org>
References: <op.ts0ukea43jf8g2@pc-bnaujok.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.ts0ukea43jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Mon, May 28, 2007 at 03:22:52PM +1000, Barry Naujok wrote:
> Back in February, I posted a patch to xfs_db to capture metadata from a  
> filesystem into a file  
> http://oss.sgi.com/archives/xfs/2007-02/msg00072.html .
> 
> I have now updated it with the following changes:
>  - obfuscates directory names and attribute names
>  - zeros attribute values
>  - better support of stdin/stdout for redirection.

Is this the dpprintf to fprintf changes?  These changes look like they
really want to be in a separate patch with at least a sentence of an
explanation.

The newly added files look good to me from a quick glance.
