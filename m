Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from foobar.grin.hu ([91.146.180.88]:53916 "EHLO foobar.grin.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725995AbfFQMww (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Jun 2019 08:52:52 -0400
Received: from 20014c4c115502000000000000000042.catv.pool.telekom.hu ([2001:4c4c:1155:200::42] helo=narya.grin.hu)
        by foobar.grin.hu with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <lxfs@drop.grin.hu>)
        (authenticated <grin@grin.hu>)
        id 1hcqRx-00Ff15-PN
        for linux-xfs@vger.kernel.org; Mon, 17 Jun 2019 14:09:29 +0200
Date: Mon, 17 Jun 2019 14:09:24 +0200
From: grin <lxfs@drop.grin.hu>
Subject: xfs_db sigsegv, xfs.org wiki and misc
Message-ID: <20190617140924.7db29e91@narya.grin.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hello,

I haven't checked XFS project lately, and that's a decade or so, it
means that when I have met a bug I went out and tried to see where and
how to report. Just mentioning the following, since you may not be
aware from the inside:

The xfs.org seems to be the "main" xfs website, search gives it first,
and has a huge amount of informations. Problem is: most links point to
nonexistant pages (SGI links hijacked by HP main page), including those
mentioning documentation, development or suggest bug reporting. Only
two valid pointers are the #xfs on FreeNode and this mailing list. Some
mentioned https://xfs.wiki.kernel.org/ which is bacially impossible to 
find unless looking for it specifically, and it doesn't contain much
info anyway. So I can't see who to mention this to, maybe you know.

Anyway. xfs_db SIGSEGV, v5.0, pretty reliably, on
> inode <n>
> type inode
> print 
 [...lots of output of the extents...]
 crash

I am not sure how it's handled: whether it's a very low level utility
and sigsegv is a way to show "you're doing something wrong", or rather
it is a bug and shall be fixed. If you would kindly tell me whether
I shall report it anywhere, send metadump, or anything, I would be much
happier (to know at least).

(At least one external tool tries to use it and it's bitten by the
crash.)

Thanks,
g
