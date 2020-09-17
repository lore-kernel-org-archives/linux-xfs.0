Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BD19C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 07:47:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07959221E3
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 07:47:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kmm0yesG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgIQHrf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 03:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgIQHrf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 03:47:35 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A2BC061756
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 00:47:28 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id m7so1477105oie.0
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 00:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=xuE7LaGJOi9kZU8SLjYfHhU0NXKHscTySoakr/Q5V18=;
        b=Kmm0yesG94IF9RUJc3KzwoLFkkmMbiP2V0JRQdz32bJsss5TJ1VsW8Ku2YtLStENzq
         sV8OWVJOiwzBpugNB/bIoDZGqQDfixpIVEu5kr+YJJiT52j3BGruFBwc8GzvLhs2Mok/
         rIRQKMp9IDiG9pcwohHPg3m+6oZGF6A5+sVZExpSn4+caMuFmkDeOfbn464Jspgx7dp2
         muNvmI3kWT4XFDVQPXFOdPjew8H0ZRbJn1CphOVfdBtuW8AV7Gj94ZK1fKkuAUXYR1R9
         7wjp1zAo/8haxWZHNBLW7a+uJTox2YNchnH9SP85CHnBt3M++Lcduhxw7S7XApi+2Vls
         LaJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=xuE7LaGJOi9kZU8SLjYfHhU0NXKHscTySoakr/Q5V18=;
        b=CFb1Mn+/GdfXZ1tECDNtXy/H4b8g2aeOtKw/FkT0HJRGWQLvb6gAEpAJCnJ0APBvEm
         H1zBHZ2EYQE7L/V0PL1Su1GtnCqAH+vJWwHZUuwa4i/7eULNg+tnRO80gkJ7WZbg/CVZ
         5GC5bNfS1IuoELVIqWMTjtXjWLT16g1TfmhS1n5QTkDRSNz9ShN2yXisJYoxE/N8nyTU
         O8Q2GP8ger5skt4HXvVhlfOnrwOlwiRUJm91Tc3jDob4qLq9x5w8eSe66aIsyoBos0D3
         okycvEr/zUUd2KtzkU2zJlofqiFd0xZDlIVZE9so7VE622JR0sqCn62Mur9WsdYmfC3b
         3EoA==
X-Gm-Message-State: AOAM5306oVWMj4kn+N3rxS4wROEPQaC4QHlihL91a4I5GzwatAf4y5j+
        rnUGxb/Xgdc7A39Wmx9Vm41MZw==
X-Google-Smtp-Source: ABdhPJyTkq2ud2gGkfCt3he+sXmBAD5xvV4TxEsvjI3/NSJz2fM5nyKi4a7W/xlBRROYMTE1qpNQrA==
X-Received: by 2002:aca:d0c:: with SMTP id 12mr5250119oin.178.1600328847618;
        Thu, 17 Sep 2020 00:47:27 -0700 (PDT)
Received: from eggly.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id w12sm12496765oow.22.2020.09.17.00.47.23
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Thu, 17 Sep 2020 00:47:24 -0700 (PDT)
Date:   Thu, 17 Sep 2020 00:47:10 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To:     Dave Chinner <david@fromorbit.com>
cc:     Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
        Amir Goldstein <amir73il@gmail.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Theodore Tso <tytso@mit.edu>,
        Martin Brandenburg <martin@omnibond.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Qiuyang Sun <sunqiuyang@huawei.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, nborisov@suse.de
Subject: Re: More filesystem need this fix (xfs: use MMAPLOCK around
 filemap_map_pages())
In-Reply-To: <20200917064532.GI12131@dread.disaster.area>
Message-ID: <alpine.LSU.2.11.2009170017590.8077@eggly.anvils>
References: <20200623052059.1893966-1-david@fromorbit.com> <CAOQ4uxh0dnVXJ9g+5jb3q72RQYYqTLPW_uBqHPKn6AJZ2DNPOQ@mail.gmail.com> <20200916155851.GA1572@quack2.suse.cz> <20200917014454.GZ12131@dread.disaster.area> <alpine.LSU.2.11.2009161853220.2087@eggly.anvils>
 <20200917064532.GI12131@dread.disaster.area>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 17 Sep 2020, Dave Chinner wrote:
> On Wed, Sep 16, 2020 at 07:04:46PM -0700, Hugh Dickins wrote:
> > On Thu, 17 Sep 2020, Dave Chinner wrote:
> > > 					<pte now points to a freed page>
> > 
> > No.  filemap_map_pages() checks page->mapping after trylock_page(),
> > before setting up the pte; and truncate_cleanup_page() does a one-page
> > unmap_mapping_range() if page_mapped(), while holding page lock.
> 
> Ok, fair, I missed that.
> 
> So why does truncate_pagecache() talk about fault races and require
> a second unmap range after the invalidation "for correctness" if
> this sort of race cannot happen?

I thought the comment
	 * unmap_mapping_range is called twice, first simply for
	 * efficiency so that truncate_inode_pages does fewer
	 * single-page unmaps.  However after this first call, and
	 * before truncate_inode_pages finishes, it is possible for
	 * private pages to be COWed, which remain after
	 * truncate_inode_pages finishes, hence the second
	 * unmap_mapping_range call must be made for correctness.
explains it fairly well. It's because POSIX demanded that when a file
is truncated, the user will get SIGBUS on trying to access even the
COWed pages beyond EOF in a MAP_PRIVATE mapping.  Page lock on the
cache page does not serialize the pages COWed from it very well.

But there's no such SIGBUS requirement in the case of hole-punching,
and trying to unmap those pages racily instantiated just after the
punching cursor passed, would probably do more harm than good.

> 
> Why is that different to truncate_pagecache_range() which -doesn't-i
> do that second removal? It's called for more than just hole_punch -
> from the filesystem's persepective holepunch should do exactly the
> same as truncate to the page cache, and for things like
> COLLAPSE_RANGE it is absolutely essential because the data in that
> range is -not zero- and will be stale if the mappings are not
> invalidated completely....

I can't speak to COLLAPSE_RANGE.

> 
> Also, if page->mapping == NULL is sufficient to detect an invalidated
> page in all cases, then why does page_cache_delete() explicitly
> leave page->index intact:
> 
> 	page->mapping = NULL;
> 	/* Leave page->index set: truncation lookup relies upon it */

Because there was, and I think still is (but might it now be xarrayed
away?), code (mainly in mm/truncate.c) which finds it convenient to
check page->index for end of range, without necessitating the overhead
of getting page lock.  I've no doubt it's an (minor) optimization that
could be discarded if there were ever a need to invalidate page->index
when deleting; but nobody has required that yet.

Hugh
