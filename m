Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45644 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750839AbcKFQgo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 6 Nov 2016 11:36:44 -0500
Date: Sun, 6 Nov 2016 17:36:42 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: discard improvements
Message-ID: <20161106163642.GB15675@lst.de>
References: <1476735753-5861-1-git-send-email-hch@lst.de> <64a1c5dc-4a36-1ef6-606e-b382d36161ef@scylladb.com> <20161031151412.GA14804@lst.de> <5a50a07c-369d-1a41-2111-f9ee91ac7425@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a50a07c-369d-1a41-2111-f9ee91ac7425@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, michaelcallahan@fb.com

On Sat, Nov 05, 2016 at 08:18:05PM +0200, Avi Kivity wrote:
> The big problem with "it depends" is that usually the information it 
> depends on is not available, so the application has to rely on a human to 
> guess correctly.  With the trend for machines to be managed by machines, 
> it's really hard to get optimal performance.  So exposure of any 
> information that can help to make a decision, including that the kernel can 
> make good use of TRIM, will be very helpful.

I agree with you, but until devices tell us that their discard
implementation sucks on their own there is not much I can help
you there.
