Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:34890 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751053AbeDVNxY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Apr 2018 09:53:24 -0400
Date: Sun, 22 Apr 2018 06:53:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: cap the length of deduplication requests
Message-ID: <20180422135305.GB26268@magnolia>
References: <20180417051918.GD5203@magnolia>
 <20180418025755.GN24738@magnolia>
 <CAOQ4uxguonNyKB=M7mhNouOhbhar3voLjneeSZDY3xooePPnjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxguonNyKB=M7mhNouOhbhar3voLjneeSZDY3xooePPnjg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Sun, Apr 22, 2018 at 05:57:32AM +0300, Amir Goldstein wrote:
> On Wed, Apr 18, 2018 at 5:57 AM, Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > Since deduplication potentially has to read in all the pages in both
> > files in order to compare the contents, cap the deduplication request
> > length at MAX_RW_COUNT/2 (roughly 1GB) so that we have /some/ upper bound
> > on the request length and can't just lock up the kernel forever.  Found
> > by running generic/304 after commit 1ddae54555b62a ("common/rc: add
> > missing 'local' keywords").
> >
> 
> With this patch generic/304 doesn't soft lock the kernel, but it doesn't
> seem 'quick' at all. I stopped waiting after 5 minutes. Is that expected?
> If so, best get the test out of the quick group.

No, that is incorrect behavior; the test is buggy.

> Can you shed some light on how the "missing 'local' keywords" change
> exposed this behavior?

See the patch I sent to the fstests lists to fix generic/304.

--D

> Thanks,
> Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
