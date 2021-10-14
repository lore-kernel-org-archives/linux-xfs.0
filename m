Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C8D4C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 16:58:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4047D60F6F
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 16:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbhJNRAU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 13:00:20 -0400
Received: from smtprelay0066.hostedemail.com ([216.40.44.66]:47232 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231327AbhJNRAT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Oct 2021 13:00:19 -0400
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Oct 2021 13:00:19 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave01.hostedemail.com (Postfix) with ESMTP id 39235183AB0B7
        for <linux-xfs@vger.kernel.org>; Thu, 14 Oct 2021 16:52:04 +0000 (UTC)
Received: from omf07.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id AA5AC182CED2A;
        Thu, 14 Oct 2021 16:52:02 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf07.hostedemail.com (Postfix) with ESMTPA id 54A4C315D79;
        Thu, 14 Oct 2021 16:52:01 +0000 (UTC)
Message-ID: <c8ee50d4bc36ff9d38e0ffe4cd8e28be0424918b.camel@perches.com>
Subject: Re: [PATCH] xfs: replace snprintf in show functions with sysfs_emit
From:   Joe Perches <joe@perches.com>
To:     Qing Wang <wangqing@vivo.com>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 14 Oct 2021 09:51:58 -0700
In-Reply-To: <1634095771-4671-1-git-send-email-wangqing@vivo.com>
References: <1634095771-4671-1-git-send-email-wangqing@vivo.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: n78zqpxar9xcf5mue7is394uj6phozjg
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: 54A4C315D79
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18LhRhzIELuab0K9xBuEwXc1HSgHPw0hN0=
X-HE-Tag: 1634230321-487330
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2021-10-12 at 20:29 -0700, Qing Wang wrote:
> coccicheck complains about the use of snprintf() in sysfs show functions.
> 
> Fix the coccicheck warning:
> WARNING: use scnprintf or sprintf.
> 
> Use sysfs_emit instead of scnprintf or sprintf makes more sense.
[]
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
[]
> @@ -104,7 +104,7 @@ bug_on_assert_show(
>  	struct kobject		*kobject,
>  	char			*buf)
>  {
> -	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.bug_on_assert ? 1 : 0);
> +	return sysfs_emit(buf, "%d\n", xfs_globals.bug_on_assert ? 1 : 0);

trivia:

The ?: is not necessary as xfs_globals.bug_on_assert is a bool
and would have an implicit cast done.

	return sysfs_emit(buf, "%d\n", xfs_globals.bug_on_assert);


