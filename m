Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F3BFA3728
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 18:18:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BA5621A49
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 18:18:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qIT++b6s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389716AbfJPSSc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Oct 2019 14:18:32 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37334 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732498AbfJPSSc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Oct 2019 14:18:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=sIFsfop4tHWGwTY/zdKRdrFVdghFbqGpiDbb4Lb7CeI=; b=qIT++b6s7fUyYXgCXiYbxQTrH
        Jk/UYnbSLFS7kJ6BWnfzMHlT3BYfE26ZuqJHW75c6GV6mm89zM9kb1p0KVef3DazmTgwwPrtRUZCw
        6WS0WqGjstB0vIC6y5MfKMg/0Vz1sy3fmWQwE7TceKWRjoa/bkmIMvXO0V0ReGVod0BZ9sTlrzLvo
        J/54H6izzyaCOuA+n7D258kAyVEV0LQxqzCoJqHlt9vxd34LgHnRLsJ/dhWOxfEZi+B2Z/yodXpg9
        atbK8dt/kQCNYuEsiLPit3A0OKLKGmhc0kVgC82DSH5TtaSpCH5+Vs9lJoC2yi+Puw3o0vgGaDGCm
        5iIb34EZA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iKnsT-00058T-VQ; Wed, 16 Oct 2019 18:18:29 +0000
Date:   Wed, 16 Oct 2019 11:18:29 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v6 12/12] xfs: switch to use the new mount-api
Message-ID: <20191016181829.GA4870@infradead.org>
References: <157118625324.9678.16275725173770634823.stgit@fedora-28>
 <157118650856.9678.4798822571611205029.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157118650856.9678.4798822571611205029.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 16, 2019 at 08:41:48AM +0800, Ian Kent wrote:
> +static const struct fs_parameter_description xfs_fs_parameters = {
> +	.name		= "XFS",
> +	.specs		= xfs_param_specs,
> +};

Well spell xfs in lower case in the file system type, so I think we should
spell it the same here.

Btw, can we keep all the mount code together where most of it already
is at the top of the file?  I know the existing version has some remount
stuff at the bottom, but as that get entirely rewritten we might as well
move it all up.

> +	int			silent = fc->sb_flags & SB_SILENT;

The silent variable is only used once, so we might as well remove it.

> +	struct xfs_mount	*mp = fc->s_fs_info;
> +
> +	/*
> +	 * mp and ctx are stored in the fs_context when it is
> +	 * initialized. mp is transferred to the superblock on
> +	 * a successful mount, but if an error occurs before the
> +	 * transfer we have to free it here.
> +	 */
> +	if (mp) {
> +		xfs_free_names(mp);
> +		kfree(mp);
> +	}

We always pair xfs_free_names with freeing the mount structure.
I think it would be nice to add an xfs_free_mount that does both
as a refactoring at the beginning of the series. 

> +static const struct fs_context_operations xfs_context_ops = {
> +	.parse_param = xfs_parse_param,
> +	.get_tree    = xfs_get_tree,
> +	.reconfigure = xfs_reconfigure,
> +	.free        = xfs_fc_free,
> +};

Should these all get a prefix like xfs_fc_free?  Maybe xfs_fsctx
to be a little bit more descriptive?
