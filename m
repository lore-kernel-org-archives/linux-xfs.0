Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1E4BC433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 19:34:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbiEEThv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 15:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355167AbiEEThu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 15:37:50 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6FB215C743
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 12:34:10 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 7E2D1328A0C;
        Thu,  5 May 2022 14:33:35 -0500 (CDT)
Message-ID: <c314d191-583f-8399-4eae-873a2b72bdf7@sandeen.net>
Date:   Thu, 5 May 2022 14:34:09 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH 2/2] xfs_db: fix a complaint about a printf buffer overrun
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <165176663972.246897.5479033385952013770.stgit@magnolia>
 <165176665092.246897.6105158987030874479.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <165176665092.246897.6105158987030874479.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/5/22 11:04 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> gcc 11 warns that stack_f doesn't allocate a sufficiently large buffer
> to hold the printf output.  I don't think the io cursor stack is really
> going to grow to 4 billion levels deep, but let's fix this anyway.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
