Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44699 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932343AbcLIOYb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Dec 2016 09:24:31 -0500
Date: Fri, 9 Dec 2016 06:24:30 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: icreate transactions should be replayed first
Message-ID: <20161209142430.GA12400@infradead.org>
References: <20161209044222.618-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161209044222.618-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

This looks fine in general.  One thing that confused be a bit is
that list_move will reorder them in a lifo way, but given that
inode create transactions shouldn't depend on each other that's
fine in the end.

Looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
