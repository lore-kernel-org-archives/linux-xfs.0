Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48101 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750858AbdIEOyn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Sep 2017 10:54:43 -0400
Date: Tue, 5 Sep 2017 16:54:42 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] xfs: fix incorrect log_flushed on fsync
Message-ID: <20170905145442.GA6869@lst.de>
References: <1504280365-25354-1-git-send-email-amir73il@gmail.com> <20170902131955.GB36492@bfoster.bfoster> <CAOQ4uxhLTtMV9FSr4um-dYefmpZ0NJseBiQzykxjy15kLqLsww@mail.gmail.com> <20170905144006.GA48515@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170905144006.GA48515@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Amir Goldstein <amir73il@gmail.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <jbacik@fb.com>, "stable [v4.9]" <stable@vger.kernel.org>

On Tue, Sep 05, 2017 at 10:40:07AM -0400, Brian Foster wrote:
> Thanks.. I agree that a rework of the optimization can come later now
> that the bug is fixed.

I agree in principle, but I don't think the patch in for-next is enough,
given that it doesn't take ic_refcnt into account.

> Christoph, are you planning to continue with your flushseq based patch?

I think it is fundamentally the right thing to do, but given how
much I've got on my plate I wouldn't mind someone else looking into it :)
