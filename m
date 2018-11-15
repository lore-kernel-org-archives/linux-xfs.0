Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37946 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728862AbeKOT4j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Nov 2018 14:56:39 -0500
Date: Thu, 15 Nov 2018 01:49:32 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix shared extent data corruption due to missing
 cow reservation
Message-ID: <20181115094932.GA10264@infradead.org>
References: <20181113170819.15220-1-bfoster@redhat.com>
 <20181115055020.GS4235@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115055020.GS4235@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Wed, Nov 14, 2018 at 09:50:20PM -0800, Darrick J. Wong wrote:
> I ran this through my overnight tests and saw no adverse effects, though
> Dave was complaining yesterday about continuing generic/091 corruptions
> (which I didn't see with this patch applied...)

I've seen occasional 091 corruption failures in always_cow mode, but
not often enough to be easily reproducible.
