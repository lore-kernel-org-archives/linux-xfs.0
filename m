Return-Path: <SRS0=Xde3=3T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF283C33C9E
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 04:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9500420707
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 04:33:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OslseKr1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgA3EdU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jan 2020 23:33:20 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:30565 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbgA3EdU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 23:33:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580358799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FOaFQL6Nzm8OiPjWEUa02hgCjlBIo20DODkhhF5ZVIo=;
        b=OslseKr16Szbo4jM6/5Xd5WuXfjApGTFX+IHLR24wJcyeR5269jxKYi3Y1mQCU4Kfuf9zl
        UX3OjF8/XG5bj+o+vH7Ec4W0MomNmrxL7YUKZW38Sz4++082cq+QcM7wyt30I5o7vfHZ5T
        Tej43FVJpydFUCOZDMGHA7DoPncRDho=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-NtIM4A5uM4icka3YrZ0dGA-1; Wed, 29 Jan 2020 23:33:15 -0500
X-MC-Unique: NtIM4A5uM4icka3YrZ0dGA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2CA9CA0CBF;
        Thu, 30 Jan 2020 04:33:14 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 976EA19756;
        Thu, 30 Jan 2020 04:33:13 +0000 (UTC)
Date:   Thu, 30 Jan 2020 12:42:51 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH xfsprogs] xfs_io: add support for linkat()
 AT_LINK_REPLACE
Message-ID: <20200130044251.GL14282@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: Omar Sandoval <osandov@osandov.com>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
References: <cover.1580251857.git.osandov@fb.com>
 <ff4b873f356ed8ff63ee582bc57c4babea947159.1580253398.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff4b873f356ed8ff63ee582bc57c4babea947159.1580253398.git.osandov@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 29, 2020 at 12:58:29AM -0800, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---

And this patch would be better to send to/cc linux-xfs@vger.kernel.org to get
xfsprogs maintainers/developers review.

>  io/link.c         | 24 ++++++++++++++++++++----
>  man/man8/xfs_io.8 |  9 ++++++++-
>  2 files changed, 28 insertions(+), 5 deletions(-)
> 
> diff --git a/io/link.c b/io/link.c
> index f4f4b139..3fc3e24d 100644
> --- a/io/link.c
> +++ b/io/link.c
> @@ -12,6 +12,9 @@
>  #ifndef AT_EMPTY_PATH
>  #define AT_EMPTY_PATH	0x1000
>  #endif
> +#ifndef AT_LINK_REPLACE
> +#define AT_LINK_REPLACE	0x10000
> +#endif
>  
>  static cmdinfo_t flink_cmd;
>  
> @@ -22,6 +25,7 @@ flink_help(void)
>  "\n"
>  "link the open file descriptor to the supplied filename\n"
>  "\n"
> +" -f -- overwrite the target filename if it exists (AT_LINK_REPLACE)\n"
>  "\n"));
>  }
>  
> @@ -30,10 +34,22 @@ flink_f(
>  	int		argc,
>  	char		**argv)
>  {
> -	if (argc != 2)
> +	int		flags = AT_EMPTY_PATH;
> +	int		c;
> +
> +	while ((c = getopt(argc, argv, "f")) != EOF) {
> +		switch (c) {
> +		case 'f':
> +			flags |= AT_LINK_REPLACE;
> +			break;
> +		default:
> +			return command_usage(&flink_cmd);
> +		}
> +	}
> +	if (optind != argc - 1)
>  		return command_usage(&flink_cmd);
>  
> -	if (linkat(file->fd, "", AT_FDCWD, argv[1], AT_EMPTY_PATH) < 0) {
> +	if (linkat(file->fd, "", AT_FDCWD, argv[optind], flags) < 0) {
>  		perror("flink");
>  		return 0;
>  	}
> @@ -46,9 +62,9 @@ flink_init(void)
>  	flink_cmd.name = "flink";
>  	flink_cmd.cfunc = flink_f;
>  	flink_cmd.argmin = 1;
> -	flink_cmd.argmax = 1;
> +	flink_cmd.argmax = -1;
>  	flink_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK | CMD_FLAG_ONESHOT;
> -	flink_cmd.args = _("filename");
> +	flink_cmd.args = _("[-f] filename");
>  	flink_cmd.oneline =
>  		_("link the open file descriptor to the supplied filename");
>  	flink_cmd.help = flink_help;
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index c69b295d..f79b3a59 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -807,8 +807,15 @@ for the full list) is available via the
>  .B help
>  command.
>  .TP
> -.BI "flink " path
> +.BI "flink [ \-f ]" " path"
>  Link the currently open file descriptor into the filesystem namespace.
> +.RS 1.0i
> +.PD 0
> +.TP 0.4i
> +.B \-f
> +overwrite the target path if it exists (AT_LINK_REPLACE).
> +.PD
> +.RE
>  .TP
>  .BR stat " [ " \-v "|" \-r " ]"
>  Selected statistics from
> -- 
> 2.25.0
> 

