Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44275 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750829AbeC1HhB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Mar 2018 03:37:01 -0400
Date: Wed, 28 Mar 2018 09:36:57 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/3] xfs: move generic_write_sync calls inwards
Message-ID: <20180328073657.GB18726@lst.de>
References: <20180327070717.7107-1-david@fromorbit.com> <20180327070717.7107-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180327070717.7107-2-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de, rdorr@microsoft.com

> +	/*
> +	 * capture amount written on completion as we can't reliably account
> +	 * for it on submission

Captialize the first c, and a . at the end of the sentence please.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
