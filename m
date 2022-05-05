Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7042AC433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 20:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377038AbiEEURa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 16:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236285AbiEEUR2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 16:17:28 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A9B9A5F8F4
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 13:13:47 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id CA91E4909;
        Thu,  5 May 2022 15:13:12 -0500 (CDT)
Message-ID: <0264f767-9249-4a4b-a0dd-30a2c0c95977@sandeen.net>
Date:   Thu, 5 May 2022 15:13:46 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <165176665416.246985.13192803422215905607.stgit@magnolia>
 <165176666532.246985.13522676978486453410.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 2/2] xfs_repair: warn about suspicious btree levels in AG
 headers
In-Reply-To: <165176666532.246985.13522676978486453410.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/5/22 11:04 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Warn about suspicious AG btree levels in the AGF and AGI.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

