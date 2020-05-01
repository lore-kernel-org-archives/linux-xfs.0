Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54C54C47256
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 06:39:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3291C208C3
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 06:39:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="ITMTdeWM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbgEAGjf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 02:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728286AbgEAGje (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 02:39:34 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F44C08E859
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 23:39:34 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id j1so10470825wrt.1
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 23:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=/mcb2FvhqEDcRhiT/KLUXGr3wPUe4NuYg1JLX3+jiqE=;
        b=ITMTdeWM0lw7Wru0eFXJAnEr1Q6q4HFk5v1XlpgZnZbtXLcf3eDkzjU1Bp+lmrZNXG
         r04sUX4E35L8ViJV/N47J1dNlqJhrdWkEypiTBASldElIUtzCm0wbRgGhdzPyB0sDBaH
         LmA1M3tEAM3xu0Mom5/2IrReXnIQPeu+YuGVpy0/n97ySJX978yvonOgogz2mjkcDwNY
         5EaAbXb8Nsdj/6RVMYfucaVhGriNK0nMa2gUmlE1QSnASYuha9TSSXSOUbZknhZuj49U
         aN348T48UXISwMCg/bL1x1wBWSVN0upisb1oHtFw26Z9CcsTPs4tveBe1nLlFMj8LOlX
         5Sag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=/mcb2FvhqEDcRhiT/KLUXGr3wPUe4NuYg1JLX3+jiqE=;
        b=b5YqoDm3gYd6KSHTZSc9vBDvUQRsHV9p6z0/5+PF+AkJ7KSybdYHNMG8vQordf4UbS
         pYGnuto9ac7FmLQVIkPZ/xs9l9MK+yNYnrqgj5aWXUUrOWOAa61F1C+Fv1ULQ73b9hlK
         ZnAFBsnUjBWQmoG/1b6HhrUrQDeBRLVBYTDG6PGhX7W4bZm9uDwFnPVzUWInvD+edN6n
         ntKIzcAo+NQwGnk7J8/8FTCXdEI8f9PAPTmUkMDoXHqo3meM7DRiwNIALU2h7fYHDuBs
         gSF3NMX0KpgDc32R9HtfEMs8ye4p3qyXZQ70oJik+4Ck1KGxl5HnWNL8HZSeH31ZXzu9
         DPGw==
X-Gm-Message-State: AGi0PuZieNar7pTuhRw6cwmsMDr95yxqorOkUfdPlDzRPe2h2jyC17p8
        Tald+2gftFs1NJj4RDiC4TJgHQ==
X-Google-Smtp-Source: APiQypKr/Cov9lBLfeX8odUPVKbRN1IPp5JWnyg7FEbdsE5fkPQXlhR/GgRBnVvt0v2I8N4upI/E9Q==
X-Received: by 2002:adf:f2c5:: with SMTP id d5mr2306494wrp.285.1588315172931;
        Thu, 30 Apr 2020 23:39:32 -0700 (PDT)
Received: from ?IPv6:2001:16b8:48db:9b00:e80e:f5df:f780:7d57? ([2001:16b8:48db:9b00:e80e:f5df:f780:7d57])
        by smtp.gmail.com with ESMTPSA id s9sm3225364wrg.27.2020.04.30.23.39.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 23:39:32 -0700 (PDT)
Subject: Re: [RFC PATCH V2 1/9] include/linux/pagemap.h: introduce
 attach/clear_page_private
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com,
        Andrew Morton <akpm@linux-foundation.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        William Kucharski <william.kucharski@oracle.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Yafang Shao <laoar.shao@gmail.com>, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        Anton Altaparmakov <anton@tuxera.com>,
        linux-ntfs-dev@lists.sourceforge.net,
        Mike Marshall <hubcap@omnibond.com>,
        Martin Brandenburg <martin@omnibond.com>,
        devel@lists.orangefs.org, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Roman Gushchin <guro@fb.com>,
        Andreas Dilger <adilger@dilger.ca>
References: <20200430214450.10662-1-guoqing.jiang@cloud.ionos.com>
 <20200430214450.10662-2-guoqing.jiang@cloud.ionos.com>
 <20200430221338.GY29705@bombadil.infradead.org>
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Message-ID: <4c177757-7e27-420e-621b-98353ec43ea1@cloud.ionos.com>
Date:   Fri, 1 May 2020 08:39:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200430221338.GY29705@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/1/20 12:13 AM, Matthew Wilcox wrote:
> On Thu, Apr 30, 2020 at 11:44:42PM +0200, Guoqing Jiang wrote:
>> +/**
>> + * attach_page_private - attach data to page's private field and set PG_private.
>> + * @page: page to be attached and set flag.
>> + * @data: data to attach to page's private field.
>> + *
>> + * Need to take reference as mm.h said "Setting PG_private should also increment
>> + * the refcount".
>> + */
> I don't think this will read well when added to the API documentation.
> Try this:
>
> /**
>   * attach_page_private - Attach private data to a page.
>   * @page: Page to attach data to.
>   * @data: Data to attach to page.
>   *
>   * Attaching private data to a page increments the page's reference count.
>   * The data must be detached before the page will be freed.
>   */
>
>> +/**
>> + * clear_page_private - clear page's private field and PG_private.
>> + * @page: page to be cleared.
>> + *
>> + * The counterpart function of attach_page_private.
>> + * Return: private data of page or NULL if page doesn't have private data.
>> + */
> Seems to me that the opposite of "attach" is "detach", not "clear".
>
> /**
>   * detach_page_private - Detach private data from a page.
>   * @page: Page to detach data from.
>   *
>   * Removes the data that was previously attached to the page and decrements
>   * the refcount on the page.
>   *
>   * Return: Data that was attached to the page.
>   */

Thanks you very much, Mattew! Will change them in next version.

Best Regards,
Guoqing
