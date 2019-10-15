Return-Path: <SRS0=TKSY=YI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAB1AECE58C
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 01:56:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0F97217F9
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 01:56:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TIHUzyDc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbfJOB4b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Oct 2019 21:56:31 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35915 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbfJOB4b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Oct 2019 21:56:31 -0400
Received: by mail-pl1-f196.google.com with SMTP id j11so8794337plk.3
        for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2019 18:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Kwwu5kbmkBQ1HH+8pWXVXW0xmQfdqCxeByRCN8KSXEY=;
        b=TIHUzyDc6SGbORZPiz2reZIw7vN60Ixo8blMx0SNx6RBtQI/zstwu3hsCiWqL9JZQ6
         IPThY2YzkQg8LrKB3cqxmkqsAs5VVvubIY28QgI45g0H0yaF5IzjbklpNV2+uzg7ULhD
         41VHOncIQSJhMRT2o32TECBBQ+NfE0tIi1QkvfROvb7aKd+NouZWdTt5bs63H5tk7Ji2
         lgJqac9vy5pPNqpqTuv8j8JQxXSpPEXx8cXPgJNtDNi+Fb3nWytmId8qoUaiqQJznwsD
         RzvUXAbBZYq4mAHTGUiGi8GCDb+XMcbtyT4TfXEdMoBGZjYFytyAH9oMmYLxg4F/HIz4
         PdUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Kwwu5kbmkBQ1HH+8pWXVXW0xmQfdqCxeByRCN8KSXEY=;
        b=PbeO2sQ1mRDwhGUVyrHGp/PgUxbRyPwrvAsIysTaRdh/S7dn1yz2xomAOAfk5MNc7z
         32z6OLBDpOxHuAr6fxQwtOlcCtv1Xhj7AICccxVfhK9XzteN9nj5Aqot3lOzzjQtHTXT
         +ULcqUvc8sC1j3vvoui8LlBzJjEJIUnoRKOUSUhgCbpLZ71XbJUESIRv1nqI+B/gJUdV
         X+ClYUaPh/jMusDZGS5Pupr/eFbyqUK30we/0awAN3zH882NrMaSI6FBrsf6YEaxgHLJ
         Tba2URCb1snNK61xUccDdXCmQF0qRudZJ/jLK1TPzC7kxkVeCQxTcLKdu78TgIM4FQ49
         oOTA==
X-Gm-Message-State: APjAAAUIzPUK4E3IZSfmQBYOXiUfZQ6pa3y72HxMK7GDpu3LSg++4QsD
        15UlhTjXZyBJObtrtY3NYA==
X-Google-Smtp-Source: APXvYqw8OLndhpbDZgTRsz4NpKzRxTwytzyi9coZcCx6lgDY9wvvn1k4hzSKoy8pOwXWtzGMS7S1MA==
X-Received: by 2002:a17:902:2e:: with SMTP id 43mr32776368pla.270.1571104590386;
        Mon, 14 Oct 2019 18:56:30 -0700 (PDT)
Received: from mypc ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b16sm24060901pfb.54.2019.10.14.18.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 18:56:29 -0700 (PDT)
Date:   Tue, 15 Oct 2019 09:56:20 +0800
From:   Pingfan Liu <kernelfans@gmail.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <esandeen@redhat.com>,
        Hari Bathini <hbathini@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] xfs: introduce "metasync" api to sync metadata to fsblock
Message-ID: <20191015015620.GA14327@mypc>
References: <1570977420-3944-1-git-send-email-kernelfans@gmail.com>
 <20191014084027.GA3593@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014084027.GA3593@infradead.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 14, 2019 at 01:40:27AM -0700, Christoph Hellwig wrote:
> On Sun, Oct 13, 2019 at 10:37:00PM +0800, Pingfan Liu wrote:
> > When using fadump (fireware assist dump) mode on powerpc, a mismatch
> > between grub xfs driver and kernel xfs driver has been obsevered.  Note:
> > fadump boots up in the following sequence: fireware -> grub reads kernel
> > and initramfs -> kernel boots.
> 
> This isn't something new.  To fundamentally fix this you need to
> implement (in-memory) log recovery in grub.  That is the only really safe
> long-term solutioin.  But the equivalent of your patch you can already
Agree. For the consistency of the whole fs, we need grub to be aware of
log. While this patch just assumes that files accessed by grub are
known, and the consistency is forced only on these files.
> get by freezing and unfreezing the file system using the FIFREEZE and
> FITHAW ioctls.  And if my memory is serving me correctly Dave has been
freeze will block any further modification to the fs. That is different
from my patch, which does not have such limitation.
> preaching that to the bootloader folks for a long time, but apparently
> without visible results.
Yes, it is a pity. And maybe it is uneasy to do.

Thanks and regards,
	Pingfan
