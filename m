Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C47DC678D4
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Mar 2023 11:32:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjCCLcl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Mar 2023 06:32:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjCCLck (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Mar 2023 06:32:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B248DD325
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 03:32:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D7D4617DF
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 11:31:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9925C433EF;
        Fri,  3 Mar 2023 11:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677843092;
        bh=erPZhXocNjj5ieUDYLVDYhIY+nbcDpQo9ITJ1gSAlgg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AoYowHtyux2QGheGBULKtovBa01gId4dmaPB03d/7h0fEKRJB0B8tHM5pZAMHyVF9
         MbEQ+YaIpQvN8qCD/bXY02rM9PV0qKwpVlDQ3oxCS4SmC6GHcbZQ9HVdbId1O600FU
         h7oE4Wx86S9zMTrfRdYQClVpUY/2KnUk4Ysaj21Rl7aJ86Pck3EzEOqLYwTH1vkDbZ
         6+0mCzhFeKLX9v3xQMQDJqtgnkETB8+43rUY3DTGE53YycetDq195nLEG+sGkbLbrp
         hvx4GCMkEMYUWbX+l2S7P9wcwNqmQUAdWAWwLxJO4KHb8y63KdOVzPmisdxa86aHKx
         G4omZivSgOqvw==
Date:   Fri, 3 Mar 2023 12:31:28 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, daan.j.demeyer@gmail.com
Subject: Re: [PATCH 3/3] mkfs: substitute slashes with spaces in protofiles
Message-ID: <20230303113128.vwmlfppxai2yw6gd@andromeda>
References: <167768672841.4130726.1758921319115777334.stgit@magnolia>
 <XeT92-lvrSnBKf-PqcSh1wLj6AiwbiI4QExkl0F-RD2vca2i7gpuQMFTNULQHbsCL7vDnClBLW6CjBZpsYz1Uw==@protonmail.internalid>
 <167768674540.4130726.6736563945489484289.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167768674540.4130726.6736563945489484289.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 01, 2023 at 08:05:45AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> A user requested the ability to specify directory entry names in a
> protofile that have spaces in them.  The protofile format itself does
> not allow spaces (yay 1973-era protofiles!) but it does allow slashes.
> Slashes aren't allowed in directory entry names, so we'll permit this
> one gross hack.  After this, the protofile:
> 
> /
> 0 0
> d--775 1000 1000
> : Descending path /code/t/fstests
>  get/isk.sh   ---775 1000 1000 /code/t/fstests/getdisk.sh
> $
> 
> Will produce "get isk.h" in the root directory when used thusly:
> 
> # mkfs.xfs -p slashes_are_spaces=1,/tmp/protofile -f /dev/sda
> 
> Requested-by: Daan De Meyer <daan.j.demeyer@gmail.com>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Thanks a lot for having made this change.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  man/man8/mkfs.xfs.8.in |    6 ++++++
>  mkfs/proto.c           |   31 +++++++++++++++++++++++++++++--
>  mkfs/proto.h           |    3 ++-
>  mkfs/xfs_mkfs.c        |   14 +++++++++++++-
>  4 files changed, 50 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
> index e1ca40e5da6..49e64d47ae4 100644
> --- a/man/man8/mkfs.xfs.8.in
> +++ b/man/man8/mkfs.xfs.8.in
> @@ -996,6 +996,12 @@ in the directory. A scan of the protofile is
>  always terminated with the dollar (
>  .B $
>  ) token.
> +.TP
> +.BI slashes_are_spaces= value
> +If set to 1, slashes ("/") in the first token of each line of the protofile
> +are converted to spaces.
> +This enables the creation of a filesystem containing filenames with spaces.
> +By default, this is set to 0.
>  .RE
>  .TP
>  .B \-q
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index 7e3fc1b8134..ea31cfe5cfc 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -21,6 +21,7 @@ static int newfile(xfs_trans_t *tp, xfs_inode_t *ip, int symlink, int logit,
>  static char *newregfile(char **pp, int *len);
>  static void rtinit(xfs_mount_t *mp);
>  static long filesize(int fd);
> +static int slashes_are_spaces;
> 
>  /*
>   * Use this for block reservations needed for mkfs's conditions
> @@ -171,6 +172,30 @@ getstr(
>  	return NULL;
>  }
> 
> +/* Extract directory entry name from a protofile. */
> +static char *
> +getdirentname(
> +	char	**pp)
> +{
> +	char	*p = getstr(pp);
> +	char	*c = p;
> +
> +	if (!p)
> +		return NULL;
> +
> +	if (!slashes_are_spaces)
> +		return p;
> +
> +	/* Replace slash with space because slashes aren't allowed. */
> +	while (*c) {
> +		if (*c == '/')
> +			*c = ' ';
> +		c++;
> +	}
> +
> +	return p;
> +}
> +
>  static void
>  rsvfile(
>  	xfs_mount_t	*mp,
> @@ -586,7 +611,7 @@ parseproto(
>  			rtinit(mp);
>  		tp = NULL;
>  		for (;;) {
> -			name = getstr(pp);
> +			name = getdirentname(pp);
>  			if (!name)
>  				break;
>  			if (strcmp(name, "$") == 0)
> @@ -612,8 +637,10 @@ void
>  parse_proto(
>  	xfs_mount_t	*mp,
>  	struct fsxattr	*fsx,
> -	char		**pp)
> +	char		**pp,
> +	int		proto_slashes_are_spaces)
>  {
> +	slashes_are_spaces = proto_slashes_are_spaces;
>  	parseproto(mp, NULL, fsx, pp, NULL);
>  }
> 
> diff --git a/mkfs/proto.h b/mkfs/proto.h
> index 3c4010afd19..be1ceb45421 100644
> --- a/mkfs/proto.h
> +++ b/mkfs/proto.h
> @@ -7,7 +7,8 @@
>  #define MKFS_PROTO_H_
> 
>  char *setup_proto(char *fname);
> -void parse_proto(struct xfs_mount *mp, struct fsxattr *fsx, char **pp);
> +void parse_proto(struct xfs_mount *mp, struct fsxattr *fsx, char **pp,
> +		int proto_slashes_are_spaces);
>  void res_failed(int err);
> 
>  #endif /* MKFS_PROTO_H_ */
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 4248e6ec344..4399bf3792f 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -115,6 +115,7 @@ enum {
> 
>  enum {
>  	P_FILE = 0,
> +	P_SLASHES,
>  	P_MAX_OPTS,
>  };
> 
> @@ -651,6 +652,7 @@ static struct opt_params popts = {
>  	.ini_section = "proto",
>  	.subopts = {
>  		[P_FILE] = "file",
> +		[P_SLASHES] = "slashes_are_spaces",
>  		[P_MAX_OPTS] = NULL,
>  	},
>  	.subopt_params = {
> @@ -658,6 +660,12 @@ static struct opt_params popts = {
>  		  .conflicts = { { NULL, LAST_CONFLICT } },
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
> +		{ .index = P_SLASHES,
> +		  .conflicts = { { NULL, LAST_CONFLICT } },
> +		  .minval = 0,
> +		  .maxval = 1,
> +		  .defaultval = 1,
> +		},
>  	},
>  };
> 
> @@ -881,6 +889,7 @@ struct cli_params {
>  	int	loginternal;
>  	int	lsunit;
>  	int	is_supported;
> +	int	proto_slashes_are_spaces;
> 
>  	/* parameters where 0 is not a valid value */
>  	int64_t	agcount;
> @@ -1779,6 +1788,9 @@ proto_opts_parser(
>  	struct cli_params	*cli)
>  {
>  	switch (subopt) {
> +	case P_SLASHES:
> +		cli->proto_slashes_are_spaces = getnum(value, opts, subopt);
> +		break;
>  	case P_FILE:
>  		fallthrough;
>  	default:
> @@ -4368,7 +4380,7 @@ main(
>  	/*
>  	 * Allocate the root inode and anything else in the proto file.
>  	 */
> -	parse_proto(mp, &cli.fsx, &protostring);
> +	parse_proto(mp, &cli.fsx, &protostring, cli.proto_slashes_are_spaces);
> 
>  	/*
>  	 * Protect ourselves against possible stupidity
> 

-- 
Carlos Maiolino
