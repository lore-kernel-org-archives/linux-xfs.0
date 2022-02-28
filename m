Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 663CBC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Feb 2022 21:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbiB1Vjc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 16:39:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbiB1Vjc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 16:39:32 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8DD9314ACB6
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 13:38:52 -0800 (PST)
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 20E7A116E2;
        Mon, 28 Feb 2022 15:37:53 -0600 (CST)
Message-ID: <cf23f057-61c7-6517-7360-69ae1303726f@sandeen.net>
Date:   Mon, 28 Feb 2022 15:38:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v3 12/17] xfs_scrub: report optional features in version
 string
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Theodore Ts'o <tytso@mit.edu>, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
 <164263816090.863810.16834243121150635355.stgit@magnolia>
 <20220226025339.GX8313@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20220226025339.GX8313@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/25/22 8:53 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Ted Ts'o reported brittleness in the fstests logic in generic/45[34] to
> detect whether or not xfs_scrub is capable of detecting Unicode mischief
> in directory and xattr names.  This is a compile-time feature, since we
> do not assume that all distros will want to ship xfsprogs with libicu.
> 
> Rather than relying on ldd tests (which don't work at all if xfs_scrub
> is compiled statically), let's have -V print whether or not the feature
> is built into the tool.  Phase 5 still requires the presence of "UTF-8"
> in LC_MESSAGES to enable Unicode confusable detection; this merely makes
> the feature easier to discover.
> 
> Reported-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2: correct the name of the reporter
> v3: only report if -VV specified

Thanks.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
