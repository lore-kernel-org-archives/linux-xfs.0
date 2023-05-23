Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC7DC7EE23
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 17:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237916AbjEWRCZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 13:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237917AbjEWRCS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 13:02:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E544119
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 10:02:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D981C634B0
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 17:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40834C433D2;
        Tue, 23 May 2023 17:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684861333;
        bh=3cCXfLn2NBrRtvkiYPPfZJTfQ68z80XPacVnxECjHoQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MqhzeEfq7vlmY6BwZeqsIaZ3Pb+/i7SKtmZ4fo95LL4FLrBCL3cBAyBYGlR4Mb/SY
         3NYH/JMsOMdEUQhIKuPGD3udo5gdl2wsw7BSlt8Qip0S8BTLPfaCyHfwOpLZFfWeLj
         cJv/R+J5DY/QAumMIjuZVvtbLNKNV6bRjR66k/9TX2xjxuZbyh7QC0iGvs+F80ywyV
         LQDpsNWZW3LvxJEtRMInnZ4xkmDM4WQSN22Z2m0IquM2GUzty9YPty1w/io2QBmUIJ
         Ke6rR0xcbOEoJg0Y27Ddfpzd1elR2uQy+Qktmf1irE6GRKoRWHT10lbEAqbNLiInUE
         CG8MrDQoQsnDQ==
Date:   Tue, 23 May 2023 10:02:12 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/24] metadump: Dump external log device contents
Message-ID: <20230523170212.GM11620@frogsfrogsfrogs>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-7-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523090050.373545-7-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 02:30:32PM +0530, Chandan Babu R wrote:
> metadump will now read and dump from external log device when the log is
> placed on an external device and metadump v2 is supported by xfsprogs.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  db/metadump.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index e7a433c21..62a36427d 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -2921,7 +2921,7 @@ copy_sb_inodes(void)
>  }
>  
>  static int
> -copy_log(void)
> +copy_log(enum typnm log_type)
>  {
>  	struct xlog	log;
>  	int		dirty;
> @@ -2934,7 +2934,7 @@ copy_log(void)
>  		print_progress("Copying log");
>  
>  	push_cur();
> -	set_cur(&typtab[TYP_LOG], XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
> +	set_cur(&typtab[log_type], XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
>  			mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN, NULL);
>  	if (iocur_top->data == NULL) {
>  		pop_cur();
> @@ -3038,6 +3038,7 @@ metadump_f(
>  	char 		**argv)
>  {
>  	xfs_agnumber_t	agno;
> +	enum typnm	log_type;
>  	int		c;
>  	int		start_iocur_sp;
>  	int		outfd = -1;
> @@ -3110,9 +3111,13 @@ metadump_f(
>  	}
>  
>  	/* If we'll copy the log, see if the log is dirty */
> -	if (mp->m_sb.sb_logstart) {
> +	if (mp->m_logdev_targp == mp->m_ddev_targp || metadump.version == 2) {
> +		log_type = TYP_LOG;
> +		if (mp->m_logdev_targp != mp->m_ddev_targp)
> +			log_type = TYP_ELOG;
> +
>  		push_cur();
> -		set_cur(&typtab[TYP_LOG],
> +		set_cur(&typtab[log_type],
>  			XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
>  			mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN, NULL);
>  		if (iocur_top->data) {	/* best effort */
> @@ -3185,9 +3190,10 @@ metadump_f(
>  	if (!exitcode)
>  		exitcode = !copy_sb_inodes();
>  
> -	/* copy log if it's internal */
> -	if ((mp->m_sb.sb_logstart != 0) && !exitcode)
> -		exitcode = !copy_log();
> +	/* copy log */
> +	if (!exitcode && (mp->m_logdev_targp == mp->m_ddev_targp ||
> +				metadump.version == 2))

Version 2?  I don't think that's been introduced yet. ;)

--D

> +		exitcode = !copy_log(log_type);
>  
>  	/* write the remaining index */
>  	if (!exitcode)
> -- 
> 2.39.1
> 
