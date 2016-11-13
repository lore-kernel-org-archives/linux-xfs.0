Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52321 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933584AbcKMM37 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 13 Nov 2016 07:29:59 -0500
Date: Sun, 13 Nov 2016 04:29:57 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] build: resolve autoheader warning
Message-ID: <20161113122957.GB1839@infradead.org>
References: <20161105173806.20052-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161105173806.20052-1-jengelh@inai.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Engelhardt <jengelh@inai.de>
Cc: linux-xfs@vger.kernel.org

On Sat, Nov 05, 2016 at 06:38:05PM +0100, Jan Engelhardt wrote:
> $ autoreconf -fi
> [...]
> autoheader: warning: missing template: HAVE_UMODE_T
> autoheader: Use AC_DEFINE([HAVE_UMODE_T], [], [Description])
> autoreconf: /usr/bin/autoheader failed with exit status: 1

I really wish we could just stop using umode_t in xfs xfsprogs,
but until then:

Reviewed-by: Christoph Hellwig <hch@lst.de>
