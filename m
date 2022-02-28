Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 559B1C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Feb 2022 21:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiB1ViQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 16:38:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbiB1ViP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 16:38:15 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 346E451E57
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 13:37:35 -0800 (PST)
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id AC43F116E2;
        Mon, 28 Feb 2022 15:36:35 -0600 (CST)
Message-ID: <7d358cb4-ab64-1e29-93e7-5e37afa524bd@sandeen.net>
Date:   Mon, 28 Feb 2022 15:37:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v2 16/17] mkfs: add a config file for x86_64 pmem
 filesystems
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
 <164263818283.863810.4750810429299999067.stgit@magnolia>
 <20220226025227.GW8313@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20220226025227.GW8313@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/25/22 8:52 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> We have a handful of users who continually ping the maintainer with
> questions about why pmem and dax don't work quite the way they want
> (which is to say 2MB extents and PMD mappings) because they copy-pasted
> some garbage from Google that's wrong.  Encode the correct defaults into
> a mkfs config file and ship that.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
