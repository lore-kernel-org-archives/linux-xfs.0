Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:41446 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753025AbeDVC5d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Apr 2018 22:57:33 -0400
MIME-Version: 1.0
In-Reply-To: <20180418025755.GN24738@magnolia>
References: <20180417051918.GD5203@magnolia> <20180418025755.GN24738@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 22 Apr 2018 05:57:32 +0300
Message-ID: <CAOQ4uxguonNyKB=M7mhNouOhbhar3voLjneeSZDY3xooePPnjg@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: cap the length of deduplication requests
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Wed, Apr 18, 2018 at 5:57 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Since deduplication potentially has to read in all the pages in both
> files in order to compare the contents, cap the deduplication request
> length at MAX_RW_COUNT/2 (roughly 1GB) so that we have /some/ upper bound
> on the request length and can't just lock up the kernel forever.  Found
> by running generic/304 after commit 1ddae54555b62a ("common/rc: add
> missing 'local' keywords").
>

With this patch generic/304 doesn't soft lock the kernel, but it doesn't
seem 'quick' at all. I stopped waiting after 5 minutes. Is that expected?
If so, best get the test out of the quick group.

Can you shed some light on how the "missing 'local' keywords" change
exposed this behavior?

Thanks,
Amir.
