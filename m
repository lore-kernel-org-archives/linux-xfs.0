Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30799EB64D9
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jun 2023 19:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjFOTeE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jun 2023 15:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjFOTeD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2023 15:34:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E7B26B6
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 12:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686857600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qJ9fh5TisbZKUaORbgtmA89u4YsXzvNQtjxXBV2tisQ=;
        b=GWfi8eyUjt0InukfFLbnpAsaGbvt4lE0sOOyeDovbYVQdN8kcnDqTX7A0mUweIVqatDmek
        t3edCAfZ+ajXF3TXQpuLFdCpul9YVAA5Ekcwzg1J8lJGpaH2Smu3XEQKrYnvR5Jlklgfmg
        yn9hEOQbzB6rnhZhPpMioGdETK0wcPs=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-wdbCe3ByOdiWZCPFXDTNAw-1; Thu, 15 Jun 2023 15:33:18 -0400
X-MC-Unique: wdbCe3ByOdiWZCPFXDTNAw-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-62dd9986b76so87176d6.1
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 12:33:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686857596; x=1689449596;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qJ9fh5TisbZKUaORbgtmA89u4YsXzvNQtjxXBV2tisQ=;
        b=FmDtT6azKJZ72ovZ0m1uGVr0NQDAlSxriLdHzZIMvH9l8klBiw3WfLn+DSHA30z9ml
         6CZcgt8tiasv7HgngKZJg1FYw/Vu9zBxKluWnqejtG2zfhl2kBsSLEEniXwWLAh3rwQe
         i1U79scC4kIN/vjvZtiX1HKK21HXsn1r4sqJlQVXibRg1Eoe5Wa3mv1DitZktnkeMf53
         upTXil4TIIk5B3gOYrJJK6mK9kenYmAFh02FwgSgL0jDXtCkVOO8P/6tCHvSZvQaG5BM
         krUgAhJH8RS87jwmb7j4RV1JUc5CjSBlDlish15FDnkLJj0U/PoYRO16FugZHiM7ncPX
         Li9g==
X-Gm-Message-State: AC+VfDxwU+1Gs9GoCIerQHbOus+R+Ea0njqgsuiMTWhlj81MSjDCdWrk
        We+cX/JJwRY/tOaU0d10B5i4rl7e0DDa5zQB0mxU1B80M1o9junlKoFHFDAhVLoSxF6VvWqJIEP
        MIupyvr8hTm8yFqT84O9LH9J3YRL8
X-Received: by 2002:ad4:5bca:0:b0:5ed:c96e:ca4a with SMTP id t10-20020ad45bca000000b005edc96eca4amr22503021qvt.1.1686857595806;
        Thu, 15 Jun 2023 12:33:15 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5M13ke+gvL3VoDObxmyNhDkjVrjDagXp/R2MhL92zTstn0T61v6zTXVFTefmODf0p29xAboA==
X-Received: by 2002:ad4:5bca:0:b0:5ed:c96e:ca4a with SMTP id t10-20020ad45bca000000b005edc96eca4amr22503000qvt.1.1686857595549;
        Thu, 15 Jun 2023 12:33:15 -0700 (PDT)
Received: from x1n (cpe5c7695f3aee0-cm5c7695f3aede.cpe.net.cable.rogers.com. [99.254.144.39])
        by smtp.gmail.com with ESMTPSA id c20-20020a0cca14000000b0062ff47845fcsm719203qvk.48.2023.06.15.12.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 12:33:14 -0700 (PDT)
Date:   Thu, 15 Jun 2023 15:33:12 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Alex Sierra <alex.sierra@amd.com>
Cc:     jgg@nvidia.com, david@redhat.com, Felix.Kuehling@amd.com,
        linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jglisse@redhat.com, apopple@nvidia.com,
        willy@infradead.org, akpm@linux-foundation.org
Subject: Re: [PATCH v9 02/14] mm: move page zone helpers from mm.h to mmzone.h
Message-ID: <ZItneGX+sqg7WApF@x1n>
References: <20220715150521.18165-1-alex.sierra@amd.com>
 <20220715150521.18165-3-alex.sierra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220715150521.18165-3-alex.sierra@amd.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello, all,

On Fri, Jul 15, 2022 at 10:05:09AM -0500, Alex Sierra wrote:
> +static inline enum zone_type page_zonenum(const struct page *page)
> +{
> +	ASSERT_EXCLUSIVE_BITS(page->flags, ZONES_MASK << ZONES_PGSHIFT);
> +	return (page->flags >> ZONES_PGSHIFT) & ZONES_MASK;
> +}

Sorry to hijack this patch - not directly relevant to the movement, but
relevant to this helper, so maybe I can leverage the cc list..

My question is whether page_zonenum() is ready for taking all kinds of tail
pages?

Zone device tail pages all look fine, per memmap_init_zone_device().  The
question was other kinds of usual compound pages, like either thp or
hugetlb.  IIUC page->flags can be uninitialized for those tail pages.

Asking because I noticed it seems possible that page_zonenum() can just
take any random tail page as input, e.g.:

try_grab_folio -> is_pci_p2pdma_page -> is_zone_device_page -> page_zonenum

I'm worried it'll just read fake things, but maybe I just missed something?

Thanks,

-- 
Peter Xu

