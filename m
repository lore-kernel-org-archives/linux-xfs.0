Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12CD6C433C1
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 23:59:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3B6161A19
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 23:59:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbhCXX65 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 19:58:57 -0400
Received: from sandeen.net ([63.231.237.45]:47256 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232003AbhCXX6t (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Mar 2021 19:58:49 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id B8E4E2B41;
        Wed, 24 Mar 2021 18:58:03 -0500 (CDT)
To:     L A Walsh <xfs@tlinx.org>, linux-xfs <linux-xfs@vger.kernel.org>
References: <605BB7AA.4050500@tlinx.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: xfsdump | xfsrestore resulting in files->orphanage
Message-ID: <529ae732-9525-4152-3399-290c38355026@sandeen.net>
Date:   Wed, 24 Mar 2021 18:58:47 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <605BB7AA.4050500@tlinx.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/24/21 5:05 PM, L A Walsh wrote:
> copying a disk to a replacing disk I am using
> xfsdump on the fromdir and xfsrestore on the todir.
> 
> I finish another disk a short while ago with no probs, but this
> disk starts out with a weird message from xfsdump:
> 
> 
> xfsdump: NOTE: root ino 192 differs from mount dir ino 256, bind mount?
> 
> Then later, when it starts restoring files on the target,
> all the files end up in the orphanage:
> 
> xfsrestore: 9278 directories and 99376 entries processed
> xfsrestore: directory post-processing
> xfsrestore: restoring non-directory files
> xfsrestore: NOTE: ino 709 salvaging file, placing in orphanage/256.0/Library/Music/ Maria/Cover-Inside.jpg
> xfsrestore: NOTE: ino 710 salvaging file, placing in orphanage/256.0/Library/Music/ Maria/Cover-Outside.jpg
> 
> The files look "fine" on the source
> Never had a simply "copy" go so wrong...
> 
> What might be causing this?

This is a bug in root inode detection that Gao has fixed, and I really
need to merge.

In the short term, you might try an older xfsdump version, 3.1.6 or earlier.

(Assuming you don't actually have a bind mount)

Sorry about that.

-Eric
