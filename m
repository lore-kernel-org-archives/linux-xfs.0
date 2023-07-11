Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F050EB64DA
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jul 2023 00:47:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjGKAr1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Jul 2023 20:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjGKAr0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jul 2023 20:47:26 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CEDA0
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jul 2023 17:47:25 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1b8bbcfd89aso25427745ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jul 2023 17:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1689036445; x=1691628445;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QSJ4o+Lrgv9bVrzUJLTl/861qqJsTQQarDnBk/c55Fc=;
        b=f9L5Bi+TDfF8dSNl1Xp6x6Qt6+xr7LcVgpQDg9YPs215B0P65lnZAK4QVoG4EhvoPz
         CIBAuUvugM/YUgffDBa8SXNgKl3f3E4hYR5hKzO65Y0ff2lKnSEPpJwS+OHz9olqZiwe
         ZPs6j0C5n+mObYbwkUhR9u0O3cYzkglw8AILahrUxZyfbZu80oe47k03BeTxOBYx1Djg
         d3ZcfblJpWGSMzOdy+JKwO19Q2JGRKa9wjpizeb701yFjMFaakifdAyvEees+i+mmqLm
         WjXBZ9/xIk6fdT1XuZUm+Xchl1L2mAQfdu53ZJMs7vos25KUWg+Hn8vqikIgowEkKwTp
         W5aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689036445; x=1691628445;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QSJ4o+Lrgv9bVrzUJLTl/861qqJsTQQarDnBk/c55Fc=;
        b=ffVpchx+2DgoRnVNHgz1JzsHJAnjvmKUaUWLjGBKVVo5dIXMXAYKbpJdqzjMHAJaJ5
         RBtK1a2ms3xJ0zaQ8XIR96Ppp1IfNu0pVMlNpnfl1h3LnFosvCMLeahNZw7YDhnAjWYO
         w2FwGEwRhU0EedGzi5UhaRyCIcIhqCE6IAt13ft/RA6IZjTEMpiu2N8nn4OOMLi9+U4a
         olgs+T2qrkhKJvb49t3/F8dlg7nND/25mn5uG8u8kWCNl/R7B+H6xhI3M23OFdb3wEdM
         0cDDTx4BD3wcZ9foHiCunllXLRQR+LIcYg4qaI36Yc1+ulu/mhOWt9vLLdVBkeKneZdx
         tXeg==
X-Gm-Message-State: ABy/qLayy5h/MoG9nUt14NnVVEWtPy2L2ZtrxDHfpv6DmR/vK7wZH1x/
        jbDBMiIU7RaEaJQjWCzKt4ywvw==
X-Google-Smtp-Source: APBJJlHEWV+eZ+6RMc+5adTNnbPd7hwg9iC6ISXb8BEOQMES5BfGqajGT1gDl8TwSxVBsHb3cCOF/g==
X-Received: by 2002:a17:902:e80d:b0:1b8:b436:bef3 with SMTP id u13-20020a170902e80d00b001b8b436bef3mr12716814plg.24.1689036445024;
        Mon, 10 Jul 2023 17:47:25 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-246-40.pa.nsw.optusnet.com.au. [49.180.246.40])
        by smtp.gmail.com with ESMTPSA id d4-20020a170902854400b001aad714400asm475138plo.229.2023.07.10.17.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jul 2023 17:47:24 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qJ1XF-004avJ-2L;
        Tue, 11 Jul 2023 10:47:21 +1000
Date:   Tue, 11 Jul 2023 10:47:21 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Wang Yugui <wangyugui@e16-tech.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 7/9] filemap: Allow __filemap_get_folio to allocate
 large folios
Message-ID: <ZKymmc7viDIjd7Mm@dread.disaster.area>
References: <20230710130253.3484695-1-willy@infradead.org>
 <20230710130253.3484695-8-willy@infradead.org>
 <ZKybP22DRs1w4G3a@bombadil.infradead.org>
 <ZKydSZM70Fd2LW/q@casper.infradead.org>
 <ZKygcP5efM2AE/nr@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZKygcP5efM2AE/nr@bombadil.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 10, 2023 at 05:21:04PM -0700, Luis Chamberlain wrote:
> On Tue, Jul 11, 2023 at 01:07:37AM +0100, Matthew Wilcox wrote:
> > The caller hints at the
> > folio size it wants, and this code you're highlighting limits it to be
> > less than MAX_PAGECACHE_ORDER.
> 
> Yes sorry, if the write size is large we still max out at MAX_PAGECACHE_ORDER
> naturally. I don't doubt the rationale that that is a good idea.
> 
> What I'm curious about is why are we OK to jump straight to MAX_PAGECACHE_ORDER
> from the start and if there are situations where perhaps a a
> not-so-aggressive high order may be desriable. How do we know?

Decades of experience optimising IO and allocation on extent based
filesystems tell us this is the right thing to do. i.e. we should
always attempt to allocate the largest contiguous range possible for
the current operation being performed. This almost always results in
the minimum amount of metadata and overhead to index and manage the
data being stored.

There are relatively few situations where this is not the right
thing to do, but that is where per-inode behavioural control options
like extent size hints come into play....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
