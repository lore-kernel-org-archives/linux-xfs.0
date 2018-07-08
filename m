Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:59192 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751422AbeGHQAA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jul 2018 12:00:00 -0400
Date: Sun, 8 Jul 2018 09:00:00 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC 8/8] xfs: skip local format inode for reflinking
Message-ID: <20180708160000.GA8675@infradead.org>
References: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
 <1530846750-6686-9-git-send-email-shan.hai@oracle.com>
 <20180706032653.GL32415@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180706032653.GL32415@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Shan Hai <shan.hai@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Jul 05, 2018 at 08:26:53PM -0700, Darrick J. Wong wrote:
> What happens if someone tries to reflink and either src or dest are an
> inline file?

Very good question.  I'd also like to see how btrfs and gfs2
handle that case, as it would be good if all Linux file systems
behave the same way.
