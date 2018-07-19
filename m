Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36688 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727508AbeGSUm1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jul 2018 16:42:27 -0400
Date: Thu, 19 Jul 2018 12:57:48 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/14] xfs: use internal dfops in cow blocks cancel
Message-ID: <20180719195748.GJ6558@infradead.org>
References: <20180719134919.29939-1-bfoster@redhat.com>
 <20180719134919.29939-10-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719134919.29939-10-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

> +			ASSERT((*tpp)->t_dfops &&
> +			       (*tpp)->t_firstblock == NULLFSBLOCK);

I'd make this two separate asserts so that we can see which one did
caused it if it triggers.
