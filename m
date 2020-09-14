Return-Path: <SRS0=9PeN=CX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56C87C433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 17:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E3BC20715
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 17:23:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AYYeMzNY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgINRXY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 13:23:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49978 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726254AbgINM3b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 08:29:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600086568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fk8zzz6iG+LTm12PI7VouoO/Ytz2Ct1GiEhjBUFwErY=;
        b=AYYeMzNY5Bspq0LrGLneAO6ZMmdhtwSohYvLC711L0IHDj22DvEvdmDeGLFKh5i4CDm8o1
        NfBW/1DNeo3FazUgxSIfGjjh7kT+2yOILd8QsqH+uMz2wfgGm5ezLdBAC0JZb+sQ93KRzW
        e8To/wK3rpQBOCACv4lr53ZeCuQ9I4w=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-1QQIvnzSN2WsJ6zg07EW0A-1; Mon, 14 Sep 2020 08:29:27 -0400
X-MC-Unique: 1QQIvnzSN2WsJ6zg07EW0A-1
Received: by mail-wr1-f71.google.com with SMTP id k13so6879094wrl.4
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2020 05:29:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fk8zzz6iG+LTm12PI7VouoO/Ytz2Ct1GiEhjBUFwErY=;
        b=alsWXmgVXJX6npR5wmP5X5ClRFxuouZzrmnbGMSuLJMRiSTi90wuYq14CWU8SpyXwU
         I4pPInEaTge9LVXYYxNcbjUGNzUvohpJ6Oaq77DPPC3SyUmaa3N3I5boNnBn83TBH1w3
         bAMlnDRPZX8x0ORtZx2ebamQj9Kemwp63TF4Jgzc2XxQUyqRr58NtrtybEfFaNy0rBfl
         x7WRvIFco2CDndflTlyTBFeM22p5NeUHsEYVJsMID4oDghABRZ/a2izbSPsC+qt1Rvu+
         NrPXkhH5mA1OC+ZD24jd1OJ9vxgXXn5XsnQXRBY2Qabtf1qPgQQLVx9jJPbEhJ/jazUn
         CVhA==
X-Gm-Message-State: AOAM533swqInvDH4dh7nyGDYww1mSmZWy651sXEXy0y98+ZMuDPw5j+r
        pJ9tYrrG1CPW7nT7XP4oV/uLS35uGRiSwHUl1bwPX9UtKUXn3ev3fWEVqTAQPK9CVgS620FBf7+
        rwHUltqDFmYK6rdZdTlDKCB4fGcQqk2bA5hjk
X-Received: by 2002:adf:e391:: with SMTP id e17mr15196096wrm.289.1600086566095;
        Mon, 14 Sep 2020 05:29:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx+1/aFCLy9zZXQtB8mFgNA23Rd5h+C192n3Cb5/bsjdvKfJteU4hp00DAohSj/jPGHMiEVc2PHHrciAVdye6k=
X-Received: by 2002:adf:e391:: with SMTP id e17mr15196076wrm.289.1600086565833;
 Mon, 14 Sep 2020 05:29:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200623052059.1893966-1-david@fromorbit.com> <CAOQ4uxh0dnVXJ9g+5jb3q72RQYYqTLPW_uBqHPKn6AJZ2DNPOQ@mail.gmail.com>
 <20200914113516.GE4863@quack2.suse.cz>
In-Reply-To: <20200914113516.GE4863@quack2.suse.cz>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Mon, 14 Sep 2020 14:29:14 +0200
Message-ID: <CAHc6FU6jU3qJppLvs-FrKVt0SryWDs_q9bV_=Lr6rZTwMfv+Tg@mail.gmail.com>
Subject: Re: More filesystem need this fix (xfs: use MMAPLOCK around filemap_map_pages())
To:     Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>,
        Theodore Tso <tytso@mit.edu>,
        Martin Brandenburg <martin@omnibond.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Qiuyang Sun <sunqiuyang@huawei.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Could the xfs mmap lock documentation please be cleaned up? For
example, the xfs_ilock description says:

> * In addition to i_rwsem in the VFS inode, the xfs inode contains 2
> * multi-reader locks: i_mmap_lock and the i_lock.  This routine allows
> * various combinations of the locks to be obtained.

The field in struct xfs_inode is called i_mmaplock though, not
i_mmap_lock. In addition, struct inode has an i_mmap_rwsem field which
is also referred to as i_mmap_lock. If that isn't irritating enough.

Thanks,
Andreas

