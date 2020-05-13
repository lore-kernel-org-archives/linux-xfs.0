Return-Path: <SRS0=Dhh5=63=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57767C2D0F9
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 09:19:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4438820769
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 09:19:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgEMJTn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 May 2020 05:19:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:40686 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727063AbgEMJTl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 May 2020 05:19:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DCEE4AEB9;
        Wed, 13 May 2020 09:19:42 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id AEB081E12AE; Wed, 13 May 2020 11:19:39 +0200 (CEST)
Date:   Wed, 13 May 2020 11:19:39 +0200
From:   Jan Kara <jack@suse.cz>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     Jan Kara <jack@suse.cz>,
        Petr =?utf-8?B?UMOtc2HFmQ==?= <ppisar@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] quota-tools: pass quota type to QCMD for Q_XFS_GETQSTAT
Message-ID: <20200513091939.GA27709@quack2.suse.cz>
References: <0dcda75e-0142-043f-2df2-9155cb6b7ed1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0dcda75e-0142-043f-2df2-9155cb6b7ed1@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri 08-05-20 14:36:46, Eric Sandeen wrote:
> Older kernels ignored the type sent to Q_XFS_GETQSTAT, and returned
> timer information for the first quota type which was found to be
> enabled.
> 
> As of 555b2c3da1fc ("quota: honor quota type in Q_XGETQSTAT[V] calls")
> the kernel now honors the quota type requested, so send that from the
> Q_XFS_GETQSTAT calls in quota tools.
> 
> Older kernels ignore the type altogether, so this change should be
> backwards compatible with no change in behavior.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks for the patch. I've added it to my tree.

								Honza

> ---
> 
> diff --git a/quotaio_xfs.c b/quotaio_xfs.c
> index 56daf89..b22c7b4 100644
> --- a/quotaio_xfs.c
> +++ b/quotaio_xfs.c
> @@ -81,7 +81,7 @@ static int xfs_init_io(struct quota_handle *h)
>  	struct xfs_mem_dqinfo info;
>  	int qcmd;
>  
> -	qcmd = QCMD(Q_XFS_GETQSTAT, 0);
> +	qcmd = QCMD(Q_XFS_GETQSTAT, h->qh_type);
>  	memset(&info, 0, sizeof(struct xfs_mem_dqinfo));
>  	if (quotactl(qcmd, h->qh_quotadev, 0, (void *)&info) < 0)
>  		return -1;
> diff --git a/quotaon_xfs.c b/quotaon_xfs.c
> index d557a75..d137240 100644
> --- a/quotaon_xfs.c
> +++ b/quotaon_xfs.c
> @@ -32,7 +32,7 @@ static int xfs_state_check(int qcmd, int type, int flags, const char *dev, int r
>  	if (flags & STATEFLAG_ALL)
>  		return 0;	/* noop */
>  
> -	if (quotactl(QCMD(Q_XFS_GETQSTAT, 0), dev, 0, (void *)&info) < 0) {
> +	if (quotactl(QCMD(Q_XFS_GETQSTAT, type), dev, 0, (void *)&info) < 0) {
>  		errstr(_("quotactl() on %s: %s\n"), dev, strerror(errno));
>  		return -1;
>  	}
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
