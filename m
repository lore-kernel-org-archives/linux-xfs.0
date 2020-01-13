Return-Path: <SRS0=9ni0=3C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44D8EC33CAD
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 14:02:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 155EA20678
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 14:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgAMOCY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jan 2020 09:02:24 -0500
Received: from foss.arm.com ([217.140.110.172]:39940 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726399AbgAMOCY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Jan 2020 09:02:24 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D6C3B1045;
        Mon, 13 Jan 2020 06:02:23 -0800 (PST)
Received: from [10.37.12.172] (unknown [10.37.12.172])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ACAD13F68E;
        Mon, 13 Jan 2020 06:02:22 -0800 (PST)
Subject: Re: [PATCH] xfs: Fix xfs_dir2_sf_entry_t size check
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
References: <20200109141459.21808-1-vincenzo.frascino@arm.com>
 <c43539f2-aa9b-4afa-985c-c438099732ff@sandeen.net>
 <1a540ee4-6597-c79e-1bce-6592cb2f3eae@arm.com>
 <20200109165048.GB8247@magnolia>
 <435bcb71-9126-b1f1-3803-4977754b36ff@arm.com>
 <CAK8P3a0eY6Vm5PNdzR8Min9MrwAqH8vnMZ3C+pxTQhiFVNPyWA@mail.gmail.com>
From:   Vincenzo Frascino <vincenzo.frascino@arm.com>
Message-ID: <ae266015-7521-e1fa-e72d-f3f97e623ad2@arm.com>
Date:   Mon, 13 Jan 2020 14:05:21 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a0eY6Vm5PNdzR8Min9MrwAqH8vnMZ3C+pxTQhiFVNPyWA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Arnd,

On 1/13/20 1:55 PM, Arnd Bergmann wrote:
> On Thu, Jan 9, 2020 at 10:01 PM Vincenzo Frascino
> <vincenzo.frascino@arm.com> wrote:
>>
>> Hi Darrick,
>>
>> On 09/01/2020 16:50, Darrick J. Wong wrote:
>>> This sounds like gcc getting confused by the zero length array.  Though
>>> it's odd that randconfig breaks, but defconfig doesn't?  This sounds
>>> like one of the kernel gcc options causing problems.
>>>
>>
>> This is what I started suspecting as well.
> 
> The important bit into the configuration is
> 
> # CONFIG_AEABI is not set
> 
> With ARM OABI (which you get when EABI is disabled), structures are padded
> to multiples of 32 bits. See commits 8353a649f577 ("xfs: kill
> xfs_dir2_sf_off_t")
> and aa2dd0ad4d6d ("xfs: remove __arch_pack"). Those could be partially
> reverted to fix it again, but it doesn't seem worth it as there is
> probably nobody
> running XFS on OABI machines (actually with the build failure we can
> be fairly sure there isn't ;-).
> 

Thanks for this, for some reasons I was convinced that CONFIG_AEABI was set in
this configuration file as I reported as well in my previous email.
Since it is OABI makes sense disabling xfs for randconfig purposes.

-- 
Regards,
Vincenzo
