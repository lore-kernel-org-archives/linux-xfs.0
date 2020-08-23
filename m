Return-Path: <SRS0=zZWs=CB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC286C433E3
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Aug 2020 06:57:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9549920768
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Aug 2020 06:57:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nvidia.com header.i=@nvidia.com header.b="BrUhEcP2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgHWG5a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Aug 2020 02:57:30 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:19974 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbgHWG53 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Aug 2020 02:57:29 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f42134a0003>; Sat, 22 Aug 2020 23:57:15 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Sat, 22 Aug 2020 23:57:29 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Sat, 22 Aug 2020 23:57:29 -0700
Received: from [10.2.94.162] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 23 Aug
 2020 06:57:28 +0000
Subject: Re: [PATCH 4/5] bio: introduce BIO_FOLL_PIN flag
To:     Christoph Hellwig <hch@infradead.org>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        <linux-xfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <ceph-devel@vger.kernel.org>,
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
References: <20200822042059.1805541-1-jhubbard@nvidia.com>
 <20200822042059.1805541-5-jhubbard@nvidia.com>
 <20200823062559.GA32480@infradead.org>
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <efa2519d-53b7-7b08-bf85-a5c2d725282c@nvidia.com>
Date:   Sat, 22 Aug 2020 23:57:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200823062559.GA32480@infradead.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598165835; bh=kB8FzCW7DtQaUtPovVv0+HKVzVDdBHBMlKCnKbkxrMg=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=BrUhEcP2N++kRHfl+zn7vDD/FlQ/3V2H/XgPoyKwbIdXc2SCUUSumiENqN7cJHfVK
         ZbkgfCj6OLx+CXHj8eM1/7+jc0ro3HzWRPLmxjKxc2RNOVXT5tORXdZinwrKaItaaq
         uygoVGHfGf5kDiATAsmUPuPK5q+iTOViZNwt7J27vitQCIVd1+qybDu8jYLh7sQfed
         X/Vpz7gURyRC6DpYj/2onKg32L5/uYmrGMAKvcltCs8K6bIwVtm+pGOn+qJmerTXrd
         RZ7OESoORKJrVEhKFDF1rhSrGhurBpHh+2Onm9Rn1gHlesoEDzJfJtRu7bsOBF08Po
         cACGMbyUwt2Ww==
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/22/20 11:25 PM, Christoph Hellwig wrote:
> On Fri, Aug 21, 2020 at 09:20:58PM -0700, John Hubbard wrote:
>> Add a new BIO_FOLL_PIN flag to struct bio, whose "short int" flags field
>> was full, thuse triggering an expansion of the field from 16, to 32
>> bits. This allows for a nice assertion in bio_release_pages(), that the
>> bio page release mechanism matches the page acquisition mechanism.
>>
>> Set BIO_FOLL_PIN whenever pin_user_pages_fast() is used, and check for
>> BIO_FOLL_PIN before using unpin_user_page().
> 
> When would the flag not be set when BIO_NO_PAGE_REF is not set?

Well, I don't *think* you can get there. However, I've only been studying
bio/block for a fairly short time, and the scattering of get_page() and
put_page() calls in some of the paths made me wonder if, for example,
someone was using get_page() to acquire ITER_BVEC or ITER_KVEC via
get_page(), and release them via bio_release_pages(). It's hard to tell.

It seems like that shouldn't be part of the design. I'm asserting that
it isn't, with this new flag. But if you're sure that this assertion is
unnecessary, then let's just drop this patch, of course.

> 
> Also I don't think we can't just expand the flags field, but I can send
> a series to kill off two flags.
> 

Good to know, just in case we do want this flag. Great!

thanks,
-- 
John Hubbard
NVIDIA
