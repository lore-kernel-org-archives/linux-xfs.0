Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AB83C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Dec 2021 20:29:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240833AbhLQU30 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Dec 2021 15:29:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240819AbhLQU3S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Dec 2021 15:29:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6BB7C061574
        for <linux-xfs@vger.kernel.org>; Fri, 17 Dec 2021 12:29:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7424F62384
        for <linux-xfs@vger.kernel.org>; Fri, 17 Dec 2021 20:29:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2C4C36AE5;
        Fri, 17 Dec 2021 20:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639772956;
        bh=ExDTGK7D9bk4ltdJ8mYF6sD8UU4tOBIF+0yzXgii8cM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eTE7wIchZ2mIyofGT0Hmm4y35v8mY9NnHJeAC5YNWXosJmYlNj7nz2rfiyGu+Kxvc
         S/otKQNshpLpblNwrLM/kMXQ3PeTA6WX78fqHmmZt02fUayLxfA7xuC8ZsYnalpSEa
         /niTfoMF3DxHfPPXuRiyEoSy5sxKJcbbrNbDqbAEpjtK3MD98/IilWgC0CzJu3Ut6y
         O+n33N64oiEtefCNW5QDyRkib+oEt0i9X/IijNa9tAollxOiCq3w38/p8bWu6C+ato
         jlagYuVgxF8IqUI1wq/U9f64i7ybY8Z08IRsrJouSmEWWjWPieA2iD3DMI9wiWdfyn
         B1awKdSNY6Mxw==
Date:   Fri, 17 Dec 2021 12:29:16 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_quota: fix up dump and report documentation
Message-ID: <20211217202916.GN27664@magnolia>
References: <20211217202050.14922-1-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217202050.14922-1-sandeen@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 17, 2021 at 02:20:50PM -0600, Eric Sandeen wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> Documentation for these commands was a bit of a mess.
> 
> 1) The help args were respecified in the _help() functions, overwriting
>    the strings which had been set up in the _init functions as all
>    other commands do. Worse, in the report case, they differed.
> 
> 2) The -L/-U dump options were not present in either short help string.
> 
> 3) The -L/-U dump options were not documented in the xfs_quota manpage.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  man/man8/xfs_quota.8 |  9 ++++++++-
>  quota/report.c       | 10 ++++------
>  2 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
> index 59e603f0..fd4562a1 100644
> --- a/man/man8/xfs_quota.8
> +++ b/man/man8/xfs_quota.8
> @@ -393,7 +393,7 @@ option outputs the numeric ID instead of the name. The
>  .B \-L
>  and
>  .B \-U
> -options specify lower and upper ID bounds to report on.  If upper/lower
> +options specify lower and/or upper ID bounds to report on.  If upper/lower
>  bounds are specified, then by default only the IDs will be displayed
>  in output; with the
>  .B \-l
> @@ -558,6 +558,8 @@ report an error.
>  [
>  .BR \-g " | " \-p " | " \-u
>  ] [
> +.BR \-L " | " \-U
> +] [
>  .B \-f
>  .I file
>  ]
> @@ -565,6 +567,11 @@ report an error.
>  Dump out quota limit information for backup utilities, either to
>  standard output (default) or to a
>  .IR file .
> +The
> +.B \-L
> +and
> +.B \-U
> +options specify lower and/or upper ID bounds to dump.
>  This is only the limits, not the usage information, of course.
>  .HP
>  .B restore
> diff --git a/quota/report.c b/quota/report.c
> index 6ac55490..2eb5b5a9 100644
> --- a/quota/report.c
> +++ b/quota/report.c
> @@ -18,14 +18,14 @@ static cmdinfo_t report_cmd;
>  static void
>  dump_help(void)
>  {
> -	dump_cmd.args = _("[-g|-p|-u] [-f file]");
> -	dump_cmd.oneline = _("dump quota information for backup utilities");
>  	printf(_(
>  "\n"
>  " create a backup file which contains quota limits information\n"
>  " -g -- dump out group quota limits\n"
>  " -p -- dump out project quota limits\n"
>  " -u -- dump out user quota limits (default)\n"
> +" -L -- lower ID bound to dump\n"
> +" -U -- upper ID bound to dump\n"
>  " -f -- write the dump out to the specified file\n"
>  "\n"));
>  }
> @@ -33,8 +33,6 @@ dump_help(void)
>  static void
>  report_help(void)
>  {
> -	report_cmd.args = _("[-bir] [-gpu] [-ahntlLNU] [-f file]");
> -	report_cmd.oneline = _("report filesystem quota information");
>  	printf(_(
>  "\n"
>  " report used space and inodes, and quota limits, for a filesystem\n"
> @@ -757,7 +755,7 @@ report_init(void)
>  	dump_cmd.cfunc = dump_f;
>  	dump_cmd.argmin = 0;
>  	dump_cmd.argmax = -1;
> -	dump_cmd.args = _("[-g|-p|-u] [-f file]");
> +	dump_cmd.args = _("[-g|-p|-u] [-LU] [-f file]");
>  	dump_cmd.oneline = _("dump quota information for backup utilities");
>  	dump_cmd.help = dump_help;
>  	dump_cmd.flags = CMD_FLAG_FOREIGN_OK;
> @@ -767,7 +765,7 @@ report_init(void)
>  	report_cmd.cfunc = report_f;
>  	report_cmd.argmin = 0;
>  	report_cmd.argmax = -1;
> -	report_cmd.args = _("[-bir] [-gpu] [-ahnt] [-f file]");
> +	report_cmd.args = _("[-bir] [-gpu] [-ahntlLNU] [-f file]");
>  	report_cmd.oneline = _("report filesystem quota information");
>  	report_cmd.help = report_help;
>  	report_cmd.flags = CMD_FLAG_ONESHOT | CMD_FLAG_FOREIGN_OK;
> -- 
> 2.33.1
> 
