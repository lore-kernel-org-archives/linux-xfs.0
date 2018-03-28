Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44329 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752972AbeC1HoM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Mar 2018 03:44:12 -0400
Date: Wed, 28 Mar 2018 09:44:11 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] iomap: iomap_dio_rw() handles all sync writes
Message-ID: <20180328074411.GD18726@lst.de>
References: <20180327070717.7107-1-david@fromorbit.com> <20180327070717.7107-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180327070717.7107-3-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de, rdorr@microsoft.com

> +#define IOMAP_DIO_WRITE_SYNC	(1 << 29)

Actually based on the next patch can we rename this to something like:
IOMAP_DIO_NEED_SYNC?  That makes the usage a little more clear.
