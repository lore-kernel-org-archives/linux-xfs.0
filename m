Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B9DC0032E
	for <linux-xfs@archiver.kernel.org>; Sat, 28 Oct 2023 13:17:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbjJ1NRm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 28 Oct 2023 09:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjJ1NRl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 28 Oct 2023 09:17:41 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA17E5;
        Sat, 28 Oct 2023 06:17:39 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 88F9021B04;
        Sat, 28 Oct 2023 13:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1698499056; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+20vd/rKlX4uy1Gaswqqv3MQqqxu+yYRb72mpfDHSgM=;
        b=AyhLtEam+XcrxJHevGMr5EhfqNytQwFqzlPKkqaZHHI8uyexAzjVVMFG2HSCs/p8+n4KhL
        qoBHyAgQ8ppQ15MJ4i4EuS3KEKN3Io/GtJ1RpXaQ3ulDFR3WXpM32+k1OXXGpnvNs/VIfe
        d2sfgGlw2hQ3FjidqzfUaXfTXBAi7j4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1698499056;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+20vd/rKlX4uy1Gaswqqv3MQqqxu+yYRb72mpfDHSgM=;
        b=x7cTm6coHhFl7VzQQ5dcqSnsaLnXJbPIsoYrn+aQEO5jWKKcIDK1rH9mN/r8dvuQOO7K1b
        qiefJA4C1Kif6HAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B133113915;
        Sat, 28 Oct 2023 13:17:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yS9TKO8JPWVicQAAMHmgww
        (envelope-from <hare@suse.de>); Sat, 28 Oct 2023 13:17:35 +0000
Message-ID: <3ce86ed7-2514-4d60-99b0-5029bcfb2126@suse.de>
Date:   Sat, 28 Oct 2023 15:17:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iomap: fix iomap_dio_zero() for fs bs > system page size
Content-Language: en-US
To:     Pankaj Raghav <p.raghav@samsung.com>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Pankaj Raghav <kernel@pankajraghav.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        djwong@kernel.org, mcgrof@kernel.org, da.gomez@samsung.com,
        gost.dev@samsung.com, david@fromorbit.com
References: <20231026140832.1089824-1-kernel@pankajraghav.com>
 <CGME20231027051855eucas1p2e465ca6afc8d45dc0529f0798b8dd669@eucas1p2.samsung.com>
 <20231027051847.GA7885@lst.de>
 <1e7e9810-9b06-48c4-aec8-d4817cca9d17@samsung.com>
 <ZTuVVSD1FnQ7qPG5@casper.infradead.org>
 <3d65652f-04c7-4240-9969-ba2d3869dbbf@samsung.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <3d65652f-04c7-4240-9969-ba2d3869dbbf@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out1.suse.de;
        none
X-Spamd-Result: default: False [-7.09 / 50.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         XM_UA_NO_VERSION(0.01)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         BAYES_HAM(-3.00)[100.00%];
         MIME_GOOD(-0.10)[text/plain];
         NEURAL_HAM_LONG(-3.00)[-1.000];
         DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
         NEURAL_HAM_SHORT(-1.00)[-0.999];
         RCPT_COUNT_SEVEN(0.00)[11];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         RCVD_TLS_ALL(0.00)[];
         MID_RHS_MATCH_FROM(0.00)[]
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/27/23 17:41, Pankaj Raghav wrote:
> On 27/10/2023 12:47, Matthew Wilcox wrote:
>> On Fri, Oct 27, 2023 at 10:03:15AM +0200, Pankaj Raghav wrote:
>>> I also noticed this pattern in fscrypt_zeroout_range_inline_crypt().
>>> Probably there are more places which could use a ZERO_FOLIO directly
>>> instead of iterating with ZERO_PAGE.
>>>
>>> Chinner also had a similar comment. It would be nice if we can reserve
>>> a zero huge page that is the size of MAX_PAGECACHE_ORDER and add it as
>>> one folio to the bio.
>>
>> i'm on holiday atm.  start looking at mm_get_huge_zero_page()
> 
> Thanks for the pointer. I made a rough version of how it might
> look like if I use that API:
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index bcd3f8cf5ea4..6ae21bd16dbe 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -236,17 +236,43 @@ static void iomap_dio_zero(const struct iomap_iter *iter, struct iomap_dio *dio,
>                  loff_t pos, unsigned len)
>   {
>          struct inode *inode = file_inode(dio->iocb->ki_filp);
> -       struct page *page = ZERO_PAGE(0);
> +       struct page *page = NULL;
> +       bool huge_page = false;
> +       bool fallback = false;
>          struct bio *bio;
> 
> -       bio = iomap_dio_alloc_bio(iter, dio, 1, REQ_OP_WRITE | REQ_SYNC | REQ_IDLE);
> +       if (len > PAGE_SIZE) {
> +               page = mm_get_huge_zero_page(current->mm);
> +               if (likely(page))
> +                       huge_page = true;
> +       }
> +
> +       if (!huge_page)
> +               page = ZERO_PAGE(0);
> +
> +       fallback = ((len > PAGE_SIZE) && !huge_page);
> +
That is pointless.
Bios can handle pages larger than PAGE_SIZE.

> +       bio = iomap_dio_alloc_bio(iter, dio, BIO_MAX_VECS,
> +                                 REQ_OP_WRITE | REQ_SYNC | REQ_IDLE);
Similar here. Just allocate space for a single folio.

>          fscrypt_set_bio_crypt_ctx(bio, inode, pos >> inode->i_blkbits,
>                                    GFP_KERNEL);
> +
>          bio->bi_iter.bi_sector = iomap_sector(&iter->iomap, pos);
>          bio->bi_private = dio;
>          bio->bi_end_io = iomap_dio_bio_end_io;
> 
> -       __bio_add_page(bio, page, len, 0);
> +       if (!fallback) {
> +               bio_add_folio_nofail(bio, page_folio(page), len, 0);
> +       } else {
> +               while (len) {
> +                       unsigned int io_len =
> +                               min_t(unsigned int, len, PAGE_SIZE);
> +
> +                       __bio_add_page(bio, page, io_len, 0);
> +                       len -= io_len;
> +               }
> +       }
See above. Kill the 'fallback' case.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

