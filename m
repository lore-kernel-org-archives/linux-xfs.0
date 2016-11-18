Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38587 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751058AbcKRFiy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Nov 2016 00:38:54 -0500
Date: Thu, 17 Nov 2016 21:38:53 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 0/2] Btrfs: make a source length of 0 imply EOF for
 dedupe
Message-ID: <20161118053853.GC31780@infradead.org>
References: <cover.1479427384.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1479427384.git.osandov@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>, Christoph Hellwig <hch@infradead.org>, kernel-team@fb.com

On Thu, Nov 17, 2016 at 04:07:48PM -0800, Omar Sandoval wrote:
> So now we have 3 options:
> 
> a) Apply these patches as-is.
> b) Fix XFS to both return the actual bytes_deduped and cap the length
>    for the EOF case. Do the same for Btrfs.
> c) Make XFS consistent with the existing Btrfs behavior.
> 
> I'm starting to lean towards option c after writing this cover letter,
> but I might as well send these out and get a second opinion.

I agree - btrfs was there first, and there is no fatal flaw in the ABI,
so let's adjust XFS to it.
