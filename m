Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6C9DC61DD8
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Nov 2020 20:45:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B75EA2223D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Nov 2020 20:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732406AbgKPUpd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Nov 2020 15:45:33 -0500
Received: from sandeen.net ([63.231.237.45]:55456 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388202AbgKPUpa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Nov 2020 15:45:30 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id D88092A96;
        Mon, 16 Nov 2020 14:45:06 -0600 (CST)
Subject: Re: [PATCH 05/26] xfs_quota: convert time_to_string to use time64_t
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
 <160375527834.881414.2581158648212089750.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a668234e-acee-142b-9373-cccde86343fd@sandeen.net>
Date:   Mon, 16 Nov 2020 14:45:29 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <160375527834.881414.2581158648212089750.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/26/20 6:34 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Rework the time_to_string helper to be capable of dealing with 64-bit
> timestamps.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks ok to me, seems like hch's concern was resolved too.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

