Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E53C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 16 May 2022 21:47:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234245AbiEPVrD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 May 2022 17:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348658AbiEPVrC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 May 2022 17:47:02 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 63B902A246
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 14:47:01 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id EAFC9490A;
        Mon, 16 May 2022 16:46:50 -0500 (CDT)
Message-ID: <a6f30caf-78d5-6fe3-f4f1-27db97c2c8a0@sandeen.net>
Date:   Mon, 16 May 2022 16:46:59 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH 1/4] xfs_scrub: widen action list length variables
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <165176689880.252326.13947902143386455815.stgit@magnolia>
 <165176690438.252326.914958822000727760.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <165176690438.252326.914958822000727760.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/5/22 11:08 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> On a 32-bit system it's possible for there to be so many items in the
> repair list that we overflow a size_t.  Widen this to unsigned long
> long.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
