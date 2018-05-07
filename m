Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51866 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750881AbeEGPJM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 11:09:12 -0400
Date: Mon, 7 May 2018 08:09:10 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] xfs: repair full xfs_dqblk during quotacheck
Message-ID: <20180507150910.GD22414@infradead.org>
References: <f5d059e3-28de-e365-acd4-d82aa9d17db7@redhat.com>
 <b4796b08-5a1b-c541-395e-3450aecae29b@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4796b08-5a1b-c541-395e-3450aecae29b@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

I think this commit is mislabeld, it onl passes the xfs_dqblk,
but doesn't actually change any functionality as far as I can tell.

>  		if (fa)
> -			xfs_dquot_repair(mp, ddq, id + j, type);
> +			xfs_dqblk_repair(mp, &dqb[j], id + j, type);

Also please pick one of the two possible array index / pointer
arithmetics notations and stick to them in a single statement at least.
