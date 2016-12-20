Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36055 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752329AbcLTIbU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2016 03:31:20 -0500
Date: Tue, 20 Dec 2016 00:31:19 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] libxcmd: merge command() and iterate_command()
Message-ID: <20161220083119.GA12768@infradead.org>
References: <20161216044115.21287-1-david@fromorbit.com>
 <20161216044115.21287-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161216044115.21287-4-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 16, 2016 at 03:41:12PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Simplify the command loop further by merging the command loop
> iteration checks with the command execution function. This removes
> all visibility of command iteration from the main command execution
> loop, and enables us to factor and clean up the command loop
> processing neatly.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>

Looks fine, but some minor nitpicks below:

Signed-off-by: Christoph Hellwig <hch@lst.de>

> +static int
> +process_input(

return bool instead of int (and switch done in the caller to bool as
well)?

> +	char	*input,
> +	bool	iterate)
>  {
> -	int		c, i, j = 0, done = 0;
> -	char		*input;

Align the arguments to the same row as the variables below it?
