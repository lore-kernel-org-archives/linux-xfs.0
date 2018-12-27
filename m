Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34842 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728809AbeL0IHe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Dec 2018 03:07:34 -0500
Date: Thu, 27 Dec 2018 00:07:29 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: add a check for xfs_trans_commit
Message-ID: <20181227080728.GA12171@infradead.org>
References: <20181226060516.75103-1-kjlu@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181226060516.75103-1-kjlu@umn.edu>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kangjie Lu <kjlu@umn.edu>
Cc: pakki001@umn.edu, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Dec 26, 2018 at 12:05:16AM -0600, Kangjie Lu wrote:
> xfs_trans_commit could fails. The checks issues an error message upon
> its failure.
> 
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>

Please take a close look at what could fail in xfs_trans_commit, and how
those failures are logged inside the implementation.
