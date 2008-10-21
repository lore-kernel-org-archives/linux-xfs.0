Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 21 Oct 2008 05:07:50 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9LC7lRd017314
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 05:07:47 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 08F0F10C0A62
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 05:09:32 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id JDsCqzQyVL2gjvbE for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 05:09:32 -0700 (PDT)
Date: Tue, 21 Oct 2008 08:09:32 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 2/2] xfs: use scalable vmap API
Message-ID: <20081021120932.GB13348@infradead.org>
References: <20081021082542.GA6974@wotan.suse.de> <20081021082735.GB6974@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021082735.GB6974@wotan.suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nick Piggin <npiggin@suse.de>
Cc: xfs@oss.sgi.com

On Tue, Oct 21, 2008 at 10:27:35AM +0200, Nick Piggin wrote:
> +		bp->b_addr = vm_map_ram(bp->b_pages, bp->b_page_count,
> +					-1, PAGE_KERNEL);

What does the -1 stand for?
