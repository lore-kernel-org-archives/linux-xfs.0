Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52671 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729686AbeLOKtP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 15 Dec 2018 05:49:15 -0500
Date: Sat, 15 Dec 2018 11:49:13 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3 V2] mm: don't search past page end in
 is_partially_uptodate
Message-ID: <20181215104913.GB1575@lst.de>
References: <1544739929-21651-1-git-send-email-sandeen@sandeen.net> <1544739929-21651-3-git-send-email-sandeen@sandeen.net> <5338b144-4501-25a7-2064-79103c7afb8e@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5338b144-4501-25a7-2064-79103c7afb8e@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de

> Fix this by limiting the range we ask for in the caller
> (generic_file_buffered_read()) so that offset+len doesn't extend past
> the page in question, and remove the clamping from the block variant.

Yes the current prototype is a bit odd..

> +	int (*is_partially_uptodate)(struct page *, unsigned, unsigned);

Can you also make it return a bool while you are at it?
