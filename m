Return-Path: <SRS0=54lF=CQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD09DC2BB84
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 09:00:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0B342145D
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 09:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgIGJAA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Sep 2020 05:00:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:40594 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727989AbgIGI76 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Sep 2020 04:59:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A15FAABD2;
        Mon,  7 Sep 2020 08:59:57 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 742E41E12D1; Mon,  7 Sep 2020 10:59:56 +0200 (CEST)
Date:   Mon, 7 Sep 2020 10:59:56 +0200
From:   Jan Kara <jack@suse.cz>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Mikulas Patocka <mpatocka@redhat.com>, Jan Kara <jack@suse.cz>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Jann Horn <jannh@google.com>, Christoph Hellwig <hch@lst.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Kirill Shutemov <kirill@shutemov.name>,
        Theodore Ts'o <tytso@mit.edu>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: don't update mtime on COW faults
Message-ID: <20200907085956.GA16559@quack2.suse.cz>
References: <alpine.LRH.2.02.2009031328040.6929@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2009041200570.27312@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2009050805250.12419@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2009050812060.12419@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=wh=0V27kdRkBAOkCDXSeFYmB=VzC0hMQVbmaiFV_1ZaCA@mail.gmail.com>
 <CAHk-=wgNoq2kh_xYKtTX38GJdEC_iAvoeFU9gpj6kFVaiA0o=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgNoq2kh_xYKtTX38GJdEC_iAvoeFU9gpj6kFVaiA0o=A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat 05-09-20 10:03:20, Linus Torvalds wrote:
> On Sat, Sep 5, 2020 at 9:47 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > So your patch is obviously correct, [..]
> 
> Oh, and I had a xfs pull request in my inbox already, so rather than
> expect Darrick to do another one just for this and have Jan do one for
> ext2, I just applied these two directly as "ObviouslyCorrect(tm)".

OK, thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
