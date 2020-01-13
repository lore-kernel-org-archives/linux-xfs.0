Return-Path: <SRS0=9ni0=3C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFA0CC33CAE
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 17:23:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C096D2467A
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 17:23:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728833AbgAMRXz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jan 2020 12:23:55 -0500
Received: from foss.arm.com ([217.140.110.172]:42310 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729009AbgAMRXz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Jan 2020 12:23:55 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B7DFA11B3;
        Mon, 13 Jan 2020 09:23:54 -0800 (PST)
Received: from [10.37.12.172] (unknown [10.37.12.172])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D94313F534;
        Mon, 13 Jan 2020 09:23:51 -0800 (PST)
Subject: Re: [PATCH] xfs: Fix xfs_dir2_sf_entry_t size check
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Christoph Hellwig <hch@lst.de>, Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200109141459.21808-1-vincenzo.frascino@arm.com>
 <c43539f2-aa9b-4afa-985c-c438099732ff@sandeen.net>
 <1a540ee4-6597-c79e-1bce-6592cb2f3eae@arm.com>
 <20200109165048.GB8247@magnolia>
 <435bcb71-9126-b1f1-3803-4977754b36ff@arm.com>
 <CAK8P3a0eY6Vm5PNdzR8Min9MrwAqH8vnMZ3C+pxTQhiFVNPyWA@mail.gmail.com>
 <20200113135800.GA8635@lst.de>
 <CAK8P3a0MZdDhY1DmdxjCSMXFqyu0G1ijsQdo7fmN9Ebxgr9cNw@mail.gmail.com>
 <20200113170105.GF8247@magnolia>
From:   Vincenzo Frascino <vincenzo.frascino@arm.com>
Message-ID: <8e2d0812-c76d-b0fd-3f4f-129c46ae60c5@arm.com>
Date:   Mon, 13 Jan 2020 17:26:49 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200113170105.GF8247@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

On 1/13/20 5:01 PM, Darrick J. Wong wrote:
> On Mon, Jan 13, 2020 at 03:06:50PM +0100, Arnd Bergmann wrote:
>> On Mon, Jan 13, 2020 at 2:58 PM Christoph Hellwig <hch@lst.de> wrote:
>>>
>>> On Mon, Jan 13, 2020 at 02:55:15PM +0100, Arnd Bergmann wrote:
>>>> With ARM OABI (which you get when EABI is disabled), structures are padded
>>>> to multiples of 32 bits. See commits 8353a649f577 ("xfs: kill
>>>> xfs_dir2_sf_off_t")
>>>> and aa2dd0ad4d6d ("xfs: remove __arch_pack"). Those could be partially
>>>> reverted to fix it again, but it doesn't seem worth it as there is
>>>> probably nobody
>>>> running XFS on OABI machines (actually with the build failure we can
>>>> be fairly sure there isn't ;-).
>>>
>>> Or just try adding a __packed to the xfs_dir2_sf_entry definition?
>>
>> Yes, that should be correct on all architectures, and I just noticed
>> that this is what we already have on xfs_dir2_sf_hdr_t directly
>> above it for the same reason.
> 
> Yeah, that sounds like a reasonable way forward, short of cleaning out
> all the array[0] cr^Hode... ;)
> 
> To the original submitter: can you add __packed to the structure
> definition and (assuming it passes oabi compilation) send that to the
> list, please?
> 

I will test it tomorrow morning as first thing and will send a patch out.
Thank you all for your help!

> --D
> 
>>
>>        Arnd

-- 
Regards,
Vincenzo
