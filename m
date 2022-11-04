Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B6ABC4332F
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Nov 2022 16:53:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbiKDQw7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Nov 2022 12:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbiKDQwY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2022 12:52:24 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E6DE340446
        for <linux-xfs@vger.kernel.org>; Fri,  4 Nov 2022 09:51:23 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 537844421;
        Fri,  4 Nov 2022 11:49:32 -0500 (CDT)
Message-ID: <afaaeda1-3290-2110-2939-bda7a4b21c47@sandeen.net>
Date:   Fri, 4 Nov 2022 11:51:22 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>
Cc:     Lukas Czerner <lczerner@redhat.com>,
        xfs <linux-xfs@vger.kernel.org>,
        Lukas Herbolt <lukas@herbolt.com>
References: <l2a3zCkMp4g9yjUsn7MdftktWgI6xqW45ngK9WGU8-OQp_SWHRFpO5xZbUySxT3QRk1C4PyeLgqoVEY3VRRH_w==@protonmail.internalid>
 <f23e8ec8-b4cc-79d2-95b5-df4821878f91@sandeen.net>
 <20221103133252.ycw5awieh7ckiih7@ovpn-192-135.brq.redhat.com>
 <20221103205107.GG3600936@dread.disaster.area> <Y2RDvUWqLY1kQ24X@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfs: Print XFS UUID on mount and umount events.
In-Reply-To: <Y2RDvUWqLY1kQ24X@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/3/22 5:42 PM, Darrick J. Wong wrote:

...

> /me wonders what problem is needing to be solved here -- if support is
> having difficulty mapping fs uuids to block devices for $purpose, then
> why not capture the blkid output in the sosreport and go from there?

Because the sosreport is frequently a post-mortem, and device name to uuid
mapping may have changed by that time.

> That said, I thought logging the super device name ("sda1") and the fs
> uuid in dmesg was sufficient to accomplish that task?

I think it is.

-Eric
