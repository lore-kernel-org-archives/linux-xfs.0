Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29C38C433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 21:56:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AC28207CD
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 21:56:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726854AbgHZV4g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 17:56:36 -0400
Received: from sandeen.net ([63.231.237.45]:36650 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726753AbgHZV4f (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Aug 2020 17:56:35 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id C57FE324E4F;
        Wed, 26 Aug 2020 16:56:23 -0500 (CDT)
Subject: Re: [PATCH 2/3] mkfs: add initial ini format config file parsing
 support
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20200826015634.3974785-1-david@fromorbit.com>
 <20200826015634.3974785-3-david@fromorbit.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9a66f54e-c4ec-4a3f-5238-89a262bd45a1@sandeen.net>
Date:   Wed, 26 Aug 2020 16:56:34 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200826015634.3974785-3-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/25/20 8:56 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add the framework that will allow the config file to be supplied on
> the CLI and passed to the library that will parse it. This does not
> yet do any option parsing from the config file.

so we have "-c $SUBOPT=file"

From what I read in the cover letter, and from checking in IRC it seems
like you envision the ability to also specify defaults from a config file
in the future; to that end it might be better to name this $SUBOPT
"options=" instead of "file=" as the latter is very generic.

Then in the future, we could have one or both of :

-c defaults=file1 -c options=file2

i.e. configure the defaults, then configure the options

I guess this is just RFC but you want probably to drop the "Ini debug:"
printf eventually.

This will need a man page update, of course.

I think it should explain where "file" will be looked for; I assume it
is either a full path, or a relative path to the current directory.

(In the future it would be nice to have mkfs.xfs search somewhere
under /etc for these files as well, but I'm not bikeshedding!)

-Eric
