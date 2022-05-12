Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E545C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 May 2022 21:02:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352818AbiELVCX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 May 2022 17:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239241AbiELVCX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 May 2022 17:02:23 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 69A6C55211
        for <linux-xfs@vger.kernel.org>; Thu, 12 May 2022 14:02:22 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 5711F4CEBA8;
        Thu, 12 May 2022 16:02:20 -0500 (CDT)
Message-ID: <fd16bf30-5c71-1eae-a60f-535dde4f4c93@sandeen.net>
Date:   Thu, 12 May 2022 16:02:21 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <165176686186.252160.2880340500532409944.stgit@magnolia>
 <165176688430.252160.7374263325275359962.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 4/6] xfs_scrub: don't try any file repairs during phase 3
 if AG metadata bad
In-Reply-To: <165176688430.252160.7374263325275359962.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/5/22 11:08 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Currently, phase 3 tries to repair file metadata even after phase 2
> tells us that there are problems with the AG metadata.  While this
> generally won't cause too many problems since the repair code will bail
> out on any obvious corruptions it finds, this isn't totally foolproof.
> If the filesystem space metadata are not in good shape, we want to queue
> the file repairs to run /after/ the space metadata repairs in phase 4.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
