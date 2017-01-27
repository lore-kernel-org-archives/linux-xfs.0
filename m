Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:58842 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754945AbdA0PIY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Jan 2017 10:08:24 -0500
Date: Fri, 27 Jan 2017 15:59:30 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] xfs: use per-AG reservations for the finobt
Message-ID: <20170127145930.GA14983@lst.de>
References: <1485335667-22435-1-git-send-email-hch@lst.de> <1485335667-22435-3-git-send-email-hch@lst.de> <c4b1428d-6861-5290-d108-043ecbfeb1b1@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4b1428d-6861-5290-d108-043ecbfeb1b1@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@lst.de>, darrick.wong@oracle.com, bfoster@redhat.com, linux-xfs@vger.kernel.org

On Thu, Jan 26, 2017 at 11:08:00PM -0600, Eric Sandeen wrote:
> This seems to cause regressions for me, at least on generic/108, xfs/004

xfs/004 isn't really broken, it just needs a change every time we
tune some reservations.   I've been pondering to just drop that
sub-check.

I can't run generic/108 as it requires a modular scsi_debug, and
none of my test setups uses modular kernels, so I'm curious on how
that could get broken by this change.
