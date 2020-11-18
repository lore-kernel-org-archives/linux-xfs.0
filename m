Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,LONGWORDS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58BD1C5519F
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Nov 2020 21:06:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0935222201
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Nov 2020 21:06:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgKRVFo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Nov 2020 16:05:44 -0500
Received: from sandeen.net ([63.231.237.45]:54224 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726243AbgKRVFo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Nov 2020 16:05:44 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id CD0F31164F;
        Wed, 18 Nov 2020 15:05:16 -0600 (CST)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, bfoster@redhat.com
Cc:     linux-xfs@vger.kernel.org
References: <160375518573.880355.12052697509237086329.stgit@magnolia>
 <160375521801.880355.2055596956122419535.stgit@magnolia>
 <20201116211351.GT9695@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v2 5/9] xfs_db: add inobtcnt upgrade path
Message-ID: <cd58a995-7146-abfc-f24e-76b57067cebb@sandeen.net>
Date:   Wed, 18 Nov 2020 15:05:42 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201116211351.GT9695@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/16/20 3:13 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Enable users to upgrade their filesystems to support inode btree block
> counters.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: set inprogress to force repair (which xfs_admin immediately does),
> clean up the code to pass around fewer arguments, and try to revert the
> change if we hit io errors
> ---

sooooo the inprogress thing sets off some unexpected behavior.

In testing this, I noticed that if we have inprogress set, and uknown features/
version on disk, we go looking for backup superblocks and actually end up
corrupting the filesystem before bailing out:

# xfs_repair /dev/pmem0p2 
Phase 1 - find and verify superblock...
bad primary superblock - filesystem mkfs-in-progress bit set !!!

attempting to find secondary superblock...
.found candidate secondary superblock...
verified secondary superblock...
writing modified primary superblock
sb realtime bitmap inode value 18446744073709551615 (NULLFSINO) inconsistent with calculated value 129
resetting superblock realtime bitmap inode pointer to 129
sb realtime summary inode value 18446744073709551615 (NULLFSINO) inconsistent with calculated value 130
resetting superblock realtime summary inode pointer to 130
Superblock has unknown compat/rocompat/incompat features (0x0/0x8/0x0).
Using a more recent xfs_repair is recommended.
Found unsupported filesystem features.  Exiting now.

# xfs_db -c check /dev/pmem0p2
disconnected inode 129, nlink 1
disconnected inode 130, nlink 1

so this seems to have exposed a hole in how repair deals with unknown features
when the inprogress bit is set.

And TBH scampering off to find backup superblocks to "repair" an inprogress
filesystem seems like ... not the right thing to do after a feature upgrade.

I'm not sure what's better, but 

> bad primary superblock - filesystem mkfs-in-progress bit set !!!

seems ... unexpected for this purpose.

-Eric

