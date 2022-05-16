Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57F4CC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 16 May 2022 22:33:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbiEPWdP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 May 2022 18:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbiEPWdO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 May 2022 18:33:14 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 353D7369FF
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 15:33:13 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 3EAC9490A;
        Mon, 16 May 2022 17:33:03 -0500 (CDT)
Message-ID: <b59d40d3-22ed-0d84-aa4a-8576b8b2214e@sandeen.net>
Date:   Mon, 16 May 2022 17:33:11 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <165176689880.252326.13947902143386455815.stgit@magnolia>
 <165176690995.252326.17449415006879561373.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 2/4] xfs_scrub: prepare phase3 for per-inogrp worker
 threads
In-Reply-To: <165176690995.252326.17449415006879561373.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/5/22 11:08 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In the next patch, we're going to rewrite scrub_scan_all_inodes to
> schedule per-inogrp workqueue items that will run the iterator function.
> In other words, the worker threads in phase 3 wil soon cease to be
> per-AG threads.
> 
> To prepare for this, we must modify phase 3 so that any writes to shared
> state are protected by the appropriate per-AG locks.  As far as I can
> tell, the only updates to shared state are the per-AG action lists, so
> create some per-AG locks for phase 3 and create locked wrappers for the
> action_list_* functions if we find things to repair.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks fine.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

