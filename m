Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50200 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfAQOS0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jan 2019 09:18:26 -0500
Date: Thu, 17 Jan 2019 06:18:25 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/22] xfs: hoist extent size helpers to libxfs
Message-ID: <20190117141825.GA16270@infradead.org>
References: <154630914104.18437.15354380637179830566.stgit@magnolia>
 <154630914753.18437.17751711685826124435.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154630914753.18437.17751711685826124435.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Can we move thse to xfs_bmap.c, which includes a few users of these
little helpers?
