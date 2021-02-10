Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC776C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 21:42:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 909BB60233
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 21:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbhBJVmg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Feb 2021 16:42:36 -0500
Received: from sandeen.net ([63.231.237.45]:49036 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232439AbhBJVme (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Feb 2021 16:42:34 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 48E644872E4;
        Wed, 10 Feb 2021 15:41:52 -0600 (CST)
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284385516.3057868.355176047687079022.stgit@magnolia>
 <20210209172131.GG14273@bfoster> <20210209181738.GU7193@magnolia>
 <20210209185939.GK14273@bfoster> <20210209195920.GZ7193@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 09/10] xfs_repair: add a testing hook for NEEDSREPAIR
Message-ID: <acfe3b90-9364-85d5-84e7-7a1b888bae9e@sandeen.net>
Date:   Wed, 10 Feb 2021 15:41:52 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210209195920.GZ7193@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/9/21 1:59 PM, Darrick J. Wong wrote:
>> # ./repair/xfs_repair -c needsrepair=1 /dev/test/scratch 
>> Phase 1 - find and verify superblock...
>> Marking filesystem in need of repair.
>> writing modified primary superblock
>> Phase 2 - using internal log
>>         - zero log...
>> ERROR: The filesystem has valuable metadata changes in a log which needs to
>> ...
>> # mount /dev/test/scratch /mnt/
>> mount: /mnt: wrong fs type, bad option, bad superblock on /dev/mapper/test-scratch, missing codepage or helper program, or other error.
>> #
>>
>> It looks like we can set a feature upgrade bit on the superblock before
>> we've examined the log and potentially discovered that it's dirty (phase
>> 2). If the log is recoverable, that puts the user in a bit of a bind..
> Heh, funny that I was thinking that the upgrades shouldn't really be
> happening in phase 1 anyway--
> 
> I've (separately) started working on a patch to make it so that you can
> add reflink and finobt to a filesystem.  Those upgrades require somewhat
> more intensive checks of the filesystem (such as checking free space in
> each AG), so I ended up dumping them into phase 2, since the xfs_mount
> and buffer cache aren't fully initialized until after phase 1.
> 
> So, yeah, the upgrade code should move to phase2() after log zeroing and
> before the AG scan.

Oh, whoops - 

based on this, I think that the prior patch
[PATCH 08/10] xfs_repair: allow setting the needsrepair flag
needs to be adjusted as well, right; we don't want to set it in phase 1
or we might set it then abort on a dirty log and the user is stuck.

So maybe I should merge up through 

[PATCH 07/10] xfs_repair: set NEEDSREPAIR when we deliberately corrupt directories

and hold off on the rest? Or should I just hold off on the series and let
you reassemble (again?)

(Am I right that the upgrade bits will need to be moved and the series resent?)

-Eric
