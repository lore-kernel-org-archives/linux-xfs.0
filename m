Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95B68C63777
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Nov 2020 16:44:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4358822228
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Nov 2020 16:44:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725772AbgKRQon (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Nov 2020 11:44:43 -0500
Received: from sandeen.net ([63.231.237.45]:41504 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbgKRQom (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Nov 2020 11:44:42 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 48E78D70;
        Wed, 18 Nov 2020 10:44:15 -0600 (CST)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <160382541643.1203756.12015378093281554469.stgit@magnolia>
 <160382542877.1203756.11339393830951325848.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 2/2] xfs: test inobtcount upgrade
Message-ID: <de3588f9-e80a-b9ba-cb03-16d538060675@sandeen.net>
Date:   Wed, 18 Nov 2020 10:44:40 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <160382542877.1203756.11339393830951325848.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/27/20 2:03 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure we can actually upgrade filesystems to support inobtcounts.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  common/xfs        |   16 ++++++++++++
>  tests/xfs/910     |   72 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/910.out |    3 ++
>  tests/xfs/group   |    1 +
>  4 files changed, 92 insertions(+)
>  create mode 100755 tests/xfs/910
>  create mode 100644 tests/xfs/910.out
> 
> 
> diff --git a/common/xfs b/common/xfs
> index 3f5c14ba..e548a0a1 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -978,3 +978,19 @@ _require_xfs_copy()
>  	[ "$USE_EXTERNAL" = yes ] && \
>  		_notrun "Cannot xfs_copy with external devices"
>  }
> +
> +_require_xfs_mkfs_inobtcount()
> +{
> +	_scratch_mkfs_xfs_supported -m inobtcount=1 >/dev/null 2>&1 \
> +	   || _notrun "mkfs.xfs doesn't have inobtcount feature"
> +}

I'd like to also add:

+_require_xfs_admin_upgrade()
+{
+	local feature="$1"
+
+	_require_scratch
+	# Catch missing "-O" or missing feature handling
+	_scratch_xfs_admin -O $feature 2>&1 | grep "illegal option\|Cannot change" \
+		&& _notrun "xfs_admin does not support upgrading $1"
+}

and then:

...

> +# real QA test starts here
> +_supported_fs xfs
> +_require_command "$XFS_ADMIN_PROG" "xfs_admin"
> +_require_xfs_mkfs_inobtcount
> +_require_xfs_scratch_inobtcount

+_require_xfs_admin_upgrade "inobtcount"

to be sure that the upgrade command is also supported by xfs_admin.  By the time
we get to release, both mkfs & xfs_admin should both support it, but I'm hedging
my bets on the upgrade path just a little,and it seems best to explicitly test
both requirements.

that helper can be re-used on the bigtime upgrade test as well and anything else
that requires an xfs_admin upgrade path ...

Thanks,
-Eric
