Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52751C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 02:47:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbiERCrm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 22:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiERCrk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 22:47:40 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 61D1A2EA09
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 19:47:39 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 93A35170B67;
        Tue, 17 May 2022 21:47:26 -0500 (CDT)
Message-ID: <f0ee9151-4eba-0197-c0b3-b48e3765372a@sandeen.net>
Date:   Tue, 17 May 2022 21:47:37 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <165176689880.252326.13947902143386455815.stgit@magnolia>
 <165176692113.252326.17366876599203152992.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 4/4] xfs_scrub: don't revisit scanned inodes when
 reprocessing a stale inode
In-Reply-To: <165176692113.252326.17366876599203152992.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/5/22 11:08 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If we decide to restart an inode chunk walk because one of the inodes is
> stale, make sure that we don't walk an inode that's been scanned before.
> This ensure we always make forward progress.
> 
> Found by observing backwards inode scan progress while running xfs/285.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Would you mind if I nitpicked a:

/* ensure forward progress if we retried */

comment above the inode number test before I commit? 

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
