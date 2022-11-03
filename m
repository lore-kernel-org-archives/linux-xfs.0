Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F283AC43219
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Nov 2022 14:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbiKCO5Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Nov 2022 10:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbiKCO5X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Nov 2022 10:57:23 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 161011A043
        for <linux-xfs@vger.kernel.org>; Thu,  3 Nov 2022 07:57:22 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 2BE3CEF8;
        Thu,  3 Nov 2022 09:55:32 -0500 (CDT)
Message-ID: <8b64a70a-0872-b7c3-6507-44b4f95c8028@sandeen.net>
Date:   Thu, 3 Nov 2022 09:57:20 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Content-Language: en-US
To:     Lukas Czerner <lczerner@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Lukas Herbolt <lukas@herbolt.com>
References: <l2a3zCkMp4g9yjUsn7MdftktWgI6xqW45ngK9WGU8-OQp_SWHRFpO5xZbUySxT3QRk1C4PyeLgqoVEY3VRRH_w==@protonmail.internalid>
 <f23e8ec8-b4cc-79d2-95b5-df4821878f91@sandeen.net>
 <20221103133252.ycw5awieh7ckiih7@ovpn-192-135.brq.redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfs: Print XFS UUID on mount and umount events.
In-Reply-To: <20221103133252.ycw5awieh7ckiih7@ovpn-192-135.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/3/22 8:32 AM, Lukas Czerner wrote:
> On Tue, Nov 01, 2022 at 12:19:06PM -0500, Eric Sandeen wrote:
>> From: Lukas Herbolt <lukas@herbolt.com>
>>
>> As of now only device names are printed out over __xfs_printk().
>> The device names are not persistent across reboots which in case
>> of searching for origin of corruption brings another task to properly
>> identify the devices. This patch add XFS UUID upon every mount/umount
>> event which will make the identification much easier.
>>
>> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
>> [sandeen: rebase onto current upstream kernel]
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Hi,
> 
> it is a simple enough, nonintrusive change so it may not really matter as
> much, but I was wondering if there is a way to map the device name to
> the fs UUID already and I think there may be.
> 
> I know that udev daemon is constantly scanning devices then they are
> closed in order to be able to read the signatures. It should know
> exactly what is on the device and I know it is able to track the history
> of changes. What I am not sure about is whether it is already logged
> somewhere?
> 
> If it's not already, maybe it can be done and then we can cross
> reference kernel log with udev log when tracking down problems to see
> exactly what is going on without needing to sprinkle UUIDs in kernel log ?
> 
> Any thoughts?

Hm, I'm not that familiar with udev or what it logs, so I can't really say
offhand. If you know for sure that this mapping is possible to achieve in
other ways, that may be useful.

I guess I'm still of the opinion that having the device::uuid mapping clearly
stated at mount time in the kernel logs is useful, though; AFAIK there is no
real "cost" to this, and other subsystems already print UUIDs for various
reasons so it's not an unusual thing to do.

(I'd have hesitated to add yet another printk for this purpose, but extending
an existing printk seems completely harmless...)

-Eric
