Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 956B4C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 12 May 2022 20:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344542AbiELUtl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 May 2022 16:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbiELUtl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 May 2022 16:49:41 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4B38F2655E2
        for <linux-xfs@vger.kernel.org>; Thu, 12 May 2022 13:49:40 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 434904A136F;
        Thu, 12 May 2022 15:49:38 -0500 (CDT)
Message-ID: <ac6eb02c-0def-f56e-02ea-b937c9a1f027@sandeen.net>
Date:   Thu, 12 May 2022 15:49:38 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <165176686186.252160.2880340500532409944.stgit@magnolia>
 <165176686756.252160.8793537742478889025.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 1/6] xfs_scrub: collapse trivial file scrub helpers
In-Reply-To: <165176686756.252160.8793537742478889025.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/5/22 11:07 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Remove all these trivial file scrub helper functions since they make
> tracing code paths difficult and will become annoying in the patches
> that follow.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

yay

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
