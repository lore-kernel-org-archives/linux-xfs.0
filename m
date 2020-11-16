Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72AA8C63798
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Nov 2020 20:29:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 048B6221EB
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Nov 2020 20:29:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732731AbgKPU3u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Nov 2020 15:29:50 -0500
Received: from sandeen.net ([63.231.237.45]:54736 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730751AbgKPU3u (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Nov 2020 15:29:50 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id E53492A96;
        Mon, 16 Nov 2020 14:29:25 -0600 (CST)
Subject: Re: [PATCH v2 6/9] xfs_repair: check inode btree block counters in
 AGI
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, bfoster@redhat.com
Cc:     linux-xfs@vger.kernel.org
References: <160375518573.880355.12052697509237086329.stgit@magnolia>
 <160375522427.880355.15446960142376313542.stgit@magnolia>
 <20201116171924.GS9695@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <97e36adb-7546-cb06-c1c2-aab14e424333@sandeen.net>
Date:   Mon, 16 Nov 2020 14:29:48 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201116171924.GS9695@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/16/20 11:19 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure that both inode btree block counters in the AGI are correct.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: fix backwards complaint message, consolidate switch statements
> ---
>  repair/scan.c |   29 ++++++++++++++++++++++++++---

Looks like this fixes Brian's concerns, thanks both!

Reviewed-by: Eric Sandeen <sandeen@redhat.com>


