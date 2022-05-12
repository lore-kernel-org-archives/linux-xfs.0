Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35CD6C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 12 May 2022 20:52:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346283AbiELUwV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 May 2022 16:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358290AbiELUwV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 May 2022 16:52:21 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 64DDA65433
        for <linux-xfs@vger.kernel.org>; Thu, 12 May 2022 13:52:20 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 593DF4A136F;
        Thu, 12 May 2022 15:52:18 -0500 (CDT)
Message-ID: <82271752-38eb-2695-5dcb-9cf6c72437b8@sandeen.net>
Date:   Thu, 12 May 2022 15:52:18 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <165176686186.252160.2880340500532409944.stgit@magnolia>
 <165176687314.252160.7990093715132347267.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 2/6] xfs_scrub: in phase 3, use the opened file descriptor
 for scrub calls
In-Reply-To: <165176687314.252160.7990093715132347267.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/5/22 11:07 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While profiling the performance of xfs_scrub, I noticed that phase3 only
> employs the scrub-by-handle interface.  The kernel has had the ability
> to skip the untrusted iget lookup if the fd matches the handle data
> since the beginning, and using it reduces the phase 3 runtime by 5% on
> the author's system.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

