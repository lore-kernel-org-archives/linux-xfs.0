Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BA9AC43334
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jun 2022 18:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376686AbiFVS7C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 14:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377349AbiFVS6S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 14:58:18 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 835B7BDD
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 11:57:54 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 037AA5196E4;
        Wed, 22 Jun 2022 13:57:02 -0500 (CDT)
Message-ID: <66855f31-32a0-7ccf-4cc2-ab56e39fe4f2@sandeen.net>
Date:   Wed, 22 Jun 2022 13:57:52 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Content-Language: en-US
To:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>, david@fromorbit.com
References: <20220525053630.734938-1-chandan.babu@oracle.com>
 <20220525053630.734938-2-chandan.babu@oracle.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 1/5] xfs_repair: check filesystem geometry before allowing
 upgrades
In-Reply-To: <20220525053630.734938-2-chandan.babu@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/25/22 12:36 AM, Chandan Babu R wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> Currently, the two V5 feature upgrades permitted by xfs_repair do not
> affect filesystem space usage, so we haven't needed to verify the
> geometry.
> 
> However, this will change once we start to allow the sysadmin to add new
> metadata indexes to existing filesystems.  Add all the infrastructure we
> need to ensure that the log will still be large enough, that there's
> enough space for metadata space reservations, and the root inode will
> still be where we expect it to be after the upgrade.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> [Recompute transaction reservation values; Exit with error if upgrade fails]

This is a lot to digest; I'd like to go ahead and merge 3 patches out of
this 5 patch series and leave this + the upgrade patch until I get a chance
to digest it a bit more.

One thing at least, though:


> +	/*
> +	 * Would we have at least 10% free space in the data device after all
> +	 * the upgrades?
> +	 */
> +	if (mp->m_sb.sb_fdblocks < mp->m_sb.sb_dblocks / 10)
> +		printf(_("Filesystem will be low on space after upgrade.\n"));
> +

This should be removed, IMHO; what is the point? The user can't do anything about
it, it proceeds anyway, and for all we know they started with less than 10% free.
So why bother printing something that might generate questions and support
calls? I don't think it's useful or actionable information.

Thanks,
-Eric
