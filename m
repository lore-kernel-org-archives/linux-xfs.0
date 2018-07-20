Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56936 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731746AbeGTQzZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Jul 2018 12:55:25 -0400
Date: Fri, 20 Jul 2018 09:06:28 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/14] xfs: support embedded dfops in transaction
Message-ID: <20180720160628.GD12054@infradead.org>
References: <20180719134919.29939-1-bfoster@redhat.com>
 <20180719134919.29939-9-bfoster@redhat.com>
 <20180719195653.GI6558@infradead.org>
 <20180719203249.GG29404@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719203249.GG29404@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Thu, Jul 19, 2018 at 04:32:49PM -0400, Brian Foster wrote:
> Hm, I figured open-coding it would be faster than function calls since
> there are only 2 pointers, but tbh I'm not sure either way and don't
> have a strong preference.

We should not even generate a function call for a small memset thanks
to gcc builtins.
