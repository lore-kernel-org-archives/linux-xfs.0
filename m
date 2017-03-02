Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44280 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753638AbdCBAf6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Mar 2017 19:35:58 -0500
Date: Wed, 1 Mar 2017 16:35:57 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_repair: detect invalid zero-sized symlink inodes
Message-ID: <20170302003557.GA24593@infradead.org>
References: <1488380403-5826-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1488380403-5826-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Mathias Troiden <mathias.troiden@gmail.com>

> +	if (be64_to_cpu(dino->di_size) == 0) {

You can drop the be64_to_cpu if you're only comparing with 0.

Otherwise this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
