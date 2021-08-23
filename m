Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8626C4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 22:45:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9203F613AD
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 22:45:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbhHWWqE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Aug 2021 18:46:04 -0400
Received: from sandeen.net ([63.231.237.45]:47208 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229632AbhHWWqE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Aug 2021 18:46:04 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 4270722E5;
        Mon, 23 Aug 2021 17:45:04 -0500 (CDT)
To:     Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org
References: <20210802215024.949616-1-preichl@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 0/8] xfsprogs: Drop the 'platform_' prefix
Message-ID: <e74bab4c-1330-4ade-2ea7-cfe9ab23ccda@sandeen.net>
Date:   Mon, 23 Aug 2021 17:45:20 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210802215024.949616-1-preichl@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/2/21 4:50 PM, Pavel Reichl wrote:
> Hi,
> 
> Eric recently suggested that removing prefix 'platform_' from function names in xfsprogs could be a good idea.

So, that wasn't *quite* what I had in mind. I'm less worried about function
names, and more interested in getting rid of indirections that have become
pointless after we removed the other "platforms" (irix, bsd, osx)

For example:

char *
platform_findrawpath(char *path)
{
         return path;
}

char *
platform_findblockpath(char *path)
{
         return path;
}

int
platform_direct_blockdev(void)
{
         return 1;
}

Those did something more interesting or complex under some other OS, but for
the code today, they're just pointless and confusing.  So my suggestion is
to remove them (and anything similarly pointless) to make the code less
confusing.

Later on if we want to remove the "platform_" namespace altogether that might
be fine but for now, let's just remove the silly stuff like shown above.

Thanks,
-Eric
