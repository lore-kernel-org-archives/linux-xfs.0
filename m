Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60094 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751825AbdIAKnK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Sep 2017 06:43:10 -0400
Date: Fri, 1 Sep 2017 12:43:09 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: fix incorrect log_flushed on fsync
Message-ID: <20170901104309.GA25726@lst.de>
References: <1504100302-3297-1-git-send-email-amir73il@gmail.com> <20170831134722.GA6912@lst.de> <CAOQ4uxgrdijqVpFm+rZ4JE_ZY0A_CZdSPHQEb8S1_R_dyJYzSg@mail.gmail.com> <20170831163954.GH21939@bfoster.bfoster> <CAOQ4uxisPbcoNp8N8Y4yGdWDBfZ=PR7CgkKGbLGS6cbU6bx2rw@mail.gmail.com> <20170901095222.GC24482@lst.de> <CAOQ4uxhgp82Oz-fTFNwRy3Yr-9xqVpwEFYQ82QqX7mze2sK0xQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhgp82Oz-fTFNwRy3Yr-9xqVpwEFYQ82QqX7mze2sK0xQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <jbacik@fb.com>, "stable [v4.9]" <stable@vger.kernel.org>

On Fri, Sep 01, 2017 at 01:37:28PM +0300, Amir Goldstein wrote:
> Well since the bug was demonstrated using crash simulator,
> I have no idea how often one would run into this with actual power
> failure, but does it really matter how often, if we *know* that it can
> happen?

No, the issue is real.  I wonder how much of an issue the additional
flushes are in practice.

> I am working on a variant of the flushseq you suggested using
> log->l_last_sync_lsn that may be simple enough and not as painful
> as turning off optimization for WANT_SYNC log buffer.

Ok, I'll take a look once you post it.
