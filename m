Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38842 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755530AbeEaQFx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 May 2018 12:05:53 -0400
Date: Thu, 31 May 2018 18:12:22 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/18] xfs: make xfs_writepage_map extent map centric
Message-ID: <20180531161222.GC30465@lst.de>
References: <20180530100013.31358-1-hch@lst.de> <20180530100013.31358-7-hch@lst.de> <20180530173955.GF112411@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180530173955.GF112411@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Dave Chinner <dchinner@redhat.com>

On Wed, May 30, 2018 at 01:39:56PM -0400, Brian Foster wrote:
> What if the file is reflinked and the current page covers a non-shared
> block but has an overlapping cow mapping due to cowextsize? The current
> logic unconditionally uses the COW mapping for writeback. The updated
> logic doesn't appear to do that in all cases. Consider if the current
> imap was delalloc (and so not trimmed) or the cow mapping was introduced
> after the current imap was mapped. This logic appears to prioritize the
> current mapping so long as it is valid. Doesn't that break the
> cowextsize hint?

It does.  I've fixed it for the next version.
