Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:34893 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751763AbdFHPnN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Jun 2017 11:43:13 -0400
Date: Thu, 8 Jun 2017 08:43:11 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: fix spurious spin_is_locked() assert failures on
 non-smp kernels
Message-ID: <20170608154311.GA6956@infradead.org>
References: <1496840455-65279-1-git-send-email-bfoster@redhat.com>
 <20170608152607.GH4530@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170608152607.GH4530@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Thu, Jun 08, 2017 at 08:26:07AM -0700, Darrick J. Wong wrote:
> Hmm.... do you want me to put this into 4.12?  It's sort of a regression
> introduced in -rc4, but on the other hand this seems to have been broken
> for quite a while for SMP=n && XFS_DEBUG=y and nobody complained...

Please add it to 4.12.  It's harmless, and the thing that triggered it
only was merged in 4.12-rc.
