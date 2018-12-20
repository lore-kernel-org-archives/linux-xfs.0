Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54224 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbeLTHIn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Dec 2018 02:08:43 -0500
Date: Wed, 19 Dec 2018 23:08:42 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH] iomap: take responsibility for the filesystem iomap
 code
Message-ID: <20181220070842.GA5231@infradead.org>
References: <20181220053622.GD27176@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181220053622.GD27176@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>

On Wed, Dec 19, 2018 at 09:36:22PM -0800, Darrick J. Wong wrote:
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8119141a926f..a36a88a72423 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16518,6 +16518,16 @@ L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
>  S:	Supported
>  F:	sound/xen/*
>  
> +IOMAP FILESYSTEM LIBRARY
> +M:	linux-xfs@vger.kernel.org
> +M:	linux-fsdevel@vger.kernel.org
> +L:	linux-xfs@vger.kernel.org
> +L:	linux-fsdevel@vger.kernel.org

Listing not one but two mailing lists as the maintainer entry seems odd.
not sure if we need a M: entry at all, but if we do I'll volunteer
(in combination with Dave if he wants to)
