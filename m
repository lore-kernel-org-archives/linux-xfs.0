Return-Path: <SRS0=2geO=ZZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58A77C432C0
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 01:14:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CC7920684
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 01:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575335647;
	bh=pwx2zpy5m+hWbDJf2hRVzLvYGrk9YhD0g6iBdIxmiC8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=1QN6coDL7Sbni9XSDbW0jl2gyqjyNg0NTAcpGrZ42Sh3UftaCal4CfBo1z3lzJ0wt
	 eAIj2/C4AKbeppE1T7jiuauT/Y7Le4OKuei7vMpZGpoRp5R5qn4ARcY9Cx5x+393v6
	 d5HAYj8eMNsIy07vSy47gOepaCQazu4QMrCozNxE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfLCBOG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Dec 2019 20:14:06 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44681 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbfLCBOG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Dec 2019 20:14:06 -0500
Received: by mail-lf1-f65.google.com with SMTP id v201so1419050lfa.11
        for <linux-xfs@vger.kernel.org>; Mon, 02 Dec 2019 17:14:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f16wPMX3Hv5+5LpFCWWiK7eqWkk4a1TMh+b2JYuh2L4=;
        b=KquqAkqUVTyG83FELzXx6nZWqrQom0qPebBeM3l4nUnY0IjRxfw5jl9f4rhB4P0Ys1
         yMMjUqHh9Atftq9/aMH7vPLqvTYv5hjkMQeepjJof4arWmddxk+x0kYqi0oEsm1gm01r
         c0+/cFEMdOFDQe0735Al7ThhTziCMU1XmN/7g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f16wPMX3Hv5+5LpFCWWiK7eqWkk4a1TMh+b2JYuh2L4=;
        b=LOfYdmKLFo00Nd7gUYJuxOmK+QP2DTszxAldUf4ykC5Q41Ctkae0Lh6hijmRnz/5hL
         XGoheWEej1M6jtOKWB90AP/4WuYuyQCIXIEajjgt33h7wscW/abG+ROliU2f9cy/3eKw
         dkZcbdJhoaFRWBqIMe+C8UgLcFFaxsiC9Dbt9r8iC03xRzGwdaor4cDUR7M9dWsQnmqy
         cJC7LRuPwFEpdPy7as47WQ8d6XF98rdTYp3j8dvLru/F+uOW9PJb6iROkBDmNqYHy0M3
         r8AY8AZ49YYHg0cDSiTgPeyiXll0KS3IrMKH8o4r6VoUcFhMzf4VplzL7X8hyYjlIjW8
         IJXg==
X-Gm-Message-State: APjAAAVABQdNMDJj1VLSvtZcf+lFAJ2XwZApIjh5eBOOGUxpgomZMbgA
        xlt4AZs3qVV4HrpgvTvxAI/LzWJSboM=
X-Google-Smtp-Source: APXvYqzRL8NZ1WhlKD1XvvpngzqXg38iSK2S0FU9VwDhjIPfzzv0EAUd+CT/bzIMSKg+wryeIFFMqg==
X-Received: by 2002:a19:f514:: with SMTP id j20mr1009336lfb.31.1575335644405;
        Mon, 02 Dec 2019 17:14:04 -0800 (PST)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com. [209.85.208.176])
        by smtp.gmail.com with ESMTPSA id u3sm355663lfb.68.2019.12.02.17.14.04
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Dec 2019 17:14:04 -0800 (PST)
Received: by mail-lj1-f176.google.com with SMTP id m6so1787226ljc.1
        for <linux-xfs@vger.kernel.org>; Mon, 02 Dec 2019 17:14:04 -0800 (PST)
X-Received: by 2002:a2e:86c4:: with SMTP id n4mr889870ljj.97.1575335193641;
 Mon, 02 Dec 2019 17:06:33 -0800 (PST)
MIME-Version: 1.0
References: <20191129142045.7215-1-agruenba@redhat.com>
In-Reply-To: <20191129142045.7215-1-agruenba@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 2 Dec 2019 17:06:17 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj5caXKoukPyM7Zc6A0Q+E-pBGHSV64iZe8t98OerXR_w@mail.gmail.com>
Message-ID: <CAHk-=wj5caXKoukPyM7Zc6A0Q+E-pBGHSV64iZe8t98OerXR_w@mail.gmail.com>
Subject: Re: [PATCH v2] fs: Fix page_mkwrite off-by-one errors
To:     Andreas Gruenbacher <agruenba@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        ceph-devel@vger.kernel.org,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 29, 2019 at 6:21 AM Andreas Gruenbacher <agruenba@redhat.com> wrote:
>
> +/**
> + * page_mkwrite_check_truncate - check if page was truncated
> + * @page: the page to check
> + * @inode: the inode to check the page against
> + *
> + * Returns the number of bytes in the page up to EOF,
> + * or -EFAULT if the page was truncated.
> + */
> +static inline int page_mkwrite_check_truncate(struct page *page,
> +                                             struct inode *inode)
> +{
> +       loff_t size = i_size_read(inode);
> +       pgoff_t end_index = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;

This special end_index calculation seems to be redundant.

You later want "size >> PAGE_SHIFT" for another test, and that's
actually the important part.

The "+ PAGE_SIZE - 1" case is purely to handle the "AT the page
boundary is special" case, but since you have to calculate
"offset_in_page(size)" anyway, that's entirely redundant - the answer
is part of that.

So I think it would be better to write the logic as

        loff_t size = i_size_read(inode);
        pgoff_t index = size >> PAGE_SHIFT;
        int offset = offset_in_page(size);

        if (page->mapping != inode->i_mapping)
                return -EFAULT;

        /* Page is wholly past the EOF page */
        if (page->index > index)
                return -EFAULT;
        /* page is wholly inside EOF */
        if (page->index < index)
                return PAGE_SIZE;
        /* bytes in a page? If 0, it's past EOF */
        return offset ? offset : -PAGE_SIZE;

instead. That avoids the unnecessary "round up" part, and simply uses
the same EOF index for everything.

              Linus
