Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F33AEC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 12 May 2022 21:06:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349981AbiELVG4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 May 2022 17:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239241AbiELVG4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 May 2022 17:06:56 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 680B947046
        for <linux-xfs@vger.kernel.org>; Thu, 12 May 2022 14:06:54 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 615304CEBA8;
        Thu, 12 May 2022 16:06:52 -0500 (CDT)
Message-ID: <f7bd6876-c7bd-b804-1f4b-030b98b7490c@sandeen.net>
Date:   Thu, 12 May 2022 16:06:52 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH 6/6] xfs_scrub: in phase 3, use the opened file descriptor
 for repair calls
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <165176686186.252160.2880340500532409944.stgit@magnolia>
 <165176689554.252160.2539425122472885718.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <165176689554.252160.2539425122472885718.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/5/22 11:08 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While profiling the performance of xfs_scrub, I noticed that phase3 only
> employs the scrub-by-handle interface for repairs.  The kernel has had
> the ability to skip the untrusted iget lookup if the fd matches the
> handle data since the beginning, and using it reduces the repair runtime
> by 5% on the author's system.  Normally, we shouldn't be running that
> many repairs or optimizations, but we did this for scrub, so we should
> do the same for repair.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
