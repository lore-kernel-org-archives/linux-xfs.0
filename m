Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 665D6C4360C
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 08:29:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F93321848
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 08:29:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KDNACzPR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfJPI3C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Oct 2019 04:29:02 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:47422 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732272AbfJPI26 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Oct 2019 04:28:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Cd2QMFecVDemp5Tm0c7UH7eCFyJbF9CquKx4cwgvI+c=; b=KDNACzPRjOhoPQZlup66LRBAd
        p11H8Vg2DQIzeKolh/ycLv9PgOH7FFOcXehr5qQJjlmw91EhhmEyMJZeq6g7ztNy6JY7/mDm0nhP3
        QX+MFxMChz2eS8FxHMqD0h3GQ21/Yq3G26rcqFdEg9pS4P46Nx2zXeOSrwi9qP+LBaCTL6WTun9OD
        pCChk1lax3NcAuoni1H7Nc16PBduL9f23qmrURTrgjZWvZAaqZ/Q0PHy/lF5kJWGUqih417aACZIT
        J9S9UYZ7LK6bWQl2a6MH+SpQ5lp58DBq/iQrjU9C9VjF9KO3eMPE9zzTGiQI7+WmRiElPIgpdeSw+
        C98ptYvCg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iKefy-00027o-1O; Wed, 16 Oct 2019 08:28:58 +0000
Date:   Wed, 16 Oct 2019 01:28:58 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v6 05/12] xfs: dont use XFS_IS_QUOTA_RUNNING() for option
 check
Message-ID: <20191016082858.GD29140@infradead.org>
References: <157118625324.9678.16275725173770634823.stgit@fedora-28>
 <157118646832.9678.14900204464012668551.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157118646832.9678.14900204464012668551.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 16, 2019 at 08:41:08AM +0800, Ian Kent wrote:
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 5876c2b551b5..f8770206b66e 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -349,7 +349,7 @@ xfs_parseargs(
>  	}
>  
>  #ifndef CONFIG_XFS_QUOTA
> -	if (XFS_IS_QUOTA_RUNNING(mp)) {
> +	if (mp->m_qflags != 0) {
>  		xfs_warn(mp, "quota support not available in this kernel.");
>  		return -EINVAL;
>  	}

Please also convert to use !IS_ENABLED while you are at it.
