Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49026 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbeH3UgV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Aug 2018 16:36:21 -0400
Date: Thu, 30 Aug 2018 18:36:14 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC] xfs: re-enable FIBMAP on reflink; disable for swap
Message-ID: <20180830163614.GA27069@lst.de>
References: <2eb759e5-2faa-67fd-5c16-c1d8edc42d02@redhat.com> <20180830162545.GA26816@lst.de> <dbe27763-2e69-6e3a-f769-2528eda54940@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbe27763-2e69-6e3a-f769-2528eda54940@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Aug 30, 2018 at 11:31:40AM -0500, Eric Sandeen wrote:
> That's no reason to uniquely disallow it for reflinked files, though;
> the problem is universal.  It's true for fiemap as well.  So I'm not sure
> that's an argument against the patch?

fiemap at least tells you an extent is shared, bmap does not.
