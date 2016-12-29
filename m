Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60173 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752906AbcL2SJg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Dec 2016 13:09:36 -0500
Date: Thu, 29 Dec 2016 19:09:33 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: don't print warnings when xfs_log_force fails
Message-ID: <20161229180933.GA16118@lst.de>
References: <1482999799-11776-1-git-send-email-hch@lst.de> <1482999799-11776-2-git-send-email-hch@lst.de> <d7b252bb-c5f8-eb18-b87e-73e8cbb81883@ieee.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7b252bb-c5f8-eb18-b87e-73e8cbb81883@ieee.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alex Elder <elder@ieee.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Dec 29, 2016 at 08:42:08AM -0600, Alex Elder wrote:
> This sounds like a good idea, though I haven't really reviewed
> the code itself.  But I'd say a one line comment indicating why
> errors from _xfs_log_force() are being ignored might be good.

I don't really know the answer, but it probabls is: some callers
shouldn't ignore it and others can't handle it either.  Maybe I'll
need to some further work in this area, but it's not really
related to dropping the message.
