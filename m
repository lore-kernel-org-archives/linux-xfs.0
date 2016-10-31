Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47337 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S943942AbcJaPOO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 31 Oct 2016 11:14:14 -0400
Date: Mon, 31 Oct 2016 16:14:12 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: discard improvements
Message-ID: <20161031151412.GA14804@lst.de>
References: <1476735753-5861-1-git-send-email-hch@lst.de> <64a1c5dc-4a36-1ef6-606e-b382d36161ef@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64a1c5dc-4a36-1ef6-606e-b382d36161ef@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, michaelcallahan@fb.com

On Fri, Oct 28, 2016 at 01:11:55PM +0300, Avi Kivity wrote:
> With these patches, is it reasonable to run with discard enabled, or is 
> more work needed?

As usual the answer is: it depends.  With the high-end NVMe devices
I've been testing with you absolutely should enable discard.  With
SAS SSDs the same is probably true.  I haven't done much testing with
SATA SSDs but I'd be more cautious there, especially as very few seem
to support queued TRIM yet.
