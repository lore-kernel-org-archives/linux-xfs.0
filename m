Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49336 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751430AbdLUNdj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Dec 2017 08:33:39 -0500
Date: Thu, 21 Dec 2017 05:33:38 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ZOMG RFCRAP PATCH 0/2] xfs: horrifying eBPF hacks
Message-ID: <20171221133338.GD1567@infradead.org>
References: <20171213061825.GO19219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171213061825.GO19219@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Richard Wareing <rwareing@fb.com>, david@fromorbit.com, hch@infradead.org

Eek.  Whie eBPF is a really nice debug tool we should never use
it for actual required kernel I/O functionality.
