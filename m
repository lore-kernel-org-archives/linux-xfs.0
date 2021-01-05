Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8BDFC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 21:49:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F43422D73
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 21:49:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729225AbhAEVtv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jan 2021 16:49:51 -0500
Received: from sandeen.net ([63.231.237.45]:54100 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729510AbhAEVtu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Jan 2021 16:49:50 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 7FFE411664;
        Tue,  5 Jan 2021 15:47:46 -0600 (CST)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
References: <20210104113006.328274-1-zlang@redhat.com>
 <3c682608-3ba8-83bb-8d16-49c798e7258c@sandeen.net>
 <3194df4e-267f-8fb1-c183-ead1d4080c85@sandeen.net>
 <20210104185754.GI14354@localhost.localdomain>
 <20210104193142.GN6918@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] mkfs: make inobtcount visible
Message-ID: <c5f8d5c8-5f49-d0be-6381-94cdeba919be@sandeen.net>
Date:   Tue, 5 Jan 2021 15:49:09 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210104193142.GN6918@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/4/21 1:31 PM, Darrick J. Wong wrote:
> On Tue, Jan 05, 2021 at 02:57:54AM +0800, Zorro Lang wrote:
>> On Mon, Jan 04, 2021 at 10:29:21AM -0600, Eric Sandeen wrote:
>>>
>>>
>>> On 1/4/21 9:28 AM, Eric Sandeen wrote:
>>>> On 1/4/21 5:30 AM, Zorro Lang wrote:
>>>>> When set inobtcount=1/0, we can't see it from xfs geometry report.
>>>>> So make it visible.
>>>>>
>>>>> Signed-off-by: Zorro Lang <zlang@redhat.com>
>>>> Hi Zorro - thanks for spotting this.
>>>>
>>>> I think the libxfs changes need to hit the kernel first, then we can
>>>> pull it in and fix up the report_geom function.  Nothing calls
>>>> xfs_fs_geometry directly in userspace, FWIW.
>>>
>>> Hah, of course I forgot about libxfs_fs_geometry. o_O
>>>
>>> In any case, I think this should hit the kernel first, want to send
>>> that patch if it's not already on the list?
>>
>> I can give it a try, if Darrick haven't had one in his developing list :)
> 
> Why do we need to expose INOBTCNT/inobtcount via the geometry ioctl?
> It doesn't expose any user-visible functionality.

Just to follow up, my thought here is that mkfs output / xfs_info output
should reflect what's needed to create a filesystem w/ the same
geometry/features, and since this is a mkfs option, it should be reflected.

Darrick already RVB'd the kernel patch, so we're now just cruising along
like a well-oiled machine. ;)

-Eric
