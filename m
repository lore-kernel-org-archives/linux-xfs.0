Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1701C4320A
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 23:09:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB60160524
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 23:09:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbhG1XJn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 19:09:43 -0400
Received: from sandeen.net ([63.231.237.45]:60934 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232290AbhG1XJm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jul 2021 19:09:42 -0400
Received: from liberator.local (204-195-4-157.wavecable.com [204.195.4.157])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 308B033FA;
        Wed, 28 Jul 2021 18:08:17 -0500 (CDT)
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <162750698055.45897.6106668678411666392.stgit@magnolia>
 <162750699156.45897.5293513702700120618.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 2/2] xfs_quota: allow users to truncate group and project
 quota files
Message-ID: <cc85e4d5-42d1-5f2c-fbf3-83368673f45b@sandeen.net>
Date:   Wed, 28 Jul 2021 16:09:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <162750699156.45897.5293513702700120618.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/28/21 2:16 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In commit 79ac1ae4, I /think/ xfsprogs gained the ability to deal with
> project or group quotas.  For some reason, the quota remove command was
> structured so that if the user passes both -g and -p, it will only ask
> the kernel truncate the group quota file.

Probably because group & project used to be mutually exclusive. I wonder
if this is the last remnant of that relic. ;)

>  This is a strange behavior
> since -ug results in truncation requests for both user and group quota
> files, and the kernel is smart enough to return 0 if asked to truncate a
> quota file that doesn't exist.
> 
> In other words, this is a seemingly arbitrary limitation of the command.
> It's an unexpected behavior since we don't do any sort of parameter
> validation to warn users when -p is silently ignored.  Modern V5
> filesystems support both group and project quotas, so it's all the more
> surprising that you can't do group and project all at once.  Remove this
> pointless restriction.
> 
> Found while triaging xfs/007 regressions.
> 
> Fixes: 79ac1ae4 ("Fix xfs_quota disable, enable, off and remove commands Merge of master-melb:xfs-cmds:29395a by kenmcd.")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  quota/state.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/quota/state.c b/quota/state.c
> index 19d34ed0..260ef51d 100644
> --- a/quota/state.c
> +++ b/quota/state.c
> @@ -462,7 +462,8 @@ remove_extents(
>  	if (type & XFS_GROUP_QUOTA) {
>  		if (remove_qtype_extents(dir, XFS_GROUP_QUOTA) < 0)
>  			return;
> -	} else if (type & XFS_PROJ_QUOTA) {
> +	}
> +	if (type & XFS_PROJ_QUOTA) {
>  		if (remove_qtype_extents(dir, XFS_PROJ_QUOTA) < 0)
>  			return;
>  	}
> 
