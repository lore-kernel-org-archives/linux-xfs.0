Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7EBFC35254
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0F8F2070B
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:35:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pGrKpnTR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgBQNfW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 08:35:22 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:48120 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbgBQNfW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:35:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BaLm7hKpcAEbJyNKLllCxD5ZCfXZWEqQp6p/nRbOEsk=; b=pGrKpnTRQSWYcF2zKOsXqUA45J
        5vMVX+mejf8Bw5pPV2UoSgGxKoMdmU5bHF2zmbodhiiXdVvcXA4mUo8e5Kb0CpDdXqcjiDGI8RNL1
        XMxpmA2PS8DAHglV4OpDXdo39+YEM46qC9UrDq/Z+wSErpnNIcvVMrjxwK/uIQotjcjG71+Wmr99S
        pmX+KPdERcnMPdrHxLrfh/yHWOh/i0tHjrXB5s1AIZw1hB5dXMMYLUz4RpBc6lbyX5KgTGfApudbZ
        MXbgNLAJC43q5tS7srglGZGXDNK0R2GicGDrtzbxEe0xB6W1PvtHWIs2k4HuhMSyGueGi4OGokbTh
        MJeWBiVA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3gYT-00027B-Ur; Mon, 17 Feb 2020 13:35:21 +0000
Date:   Mon, 17 Feb 2020 05:35:21 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 1/4] xfs: Refactor xfs_isilocked()
Message-ID: <20200217133521.GD31012@infradead.org>
References: <20200214185942.1147742-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214185942.1147742-1-preichl@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 14, 2020 at 07:59:39PM +0100, Pavel Reichl wrote:
> Refactor xfs_isilocked() to use newly introduced __xfs_rwsem_islocked().
> __xfs_rwsem_islocked() is a helper function which encapsulates checking
> state of rw_semaphores hold by inode.
> 
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> Suggested-by: Dave Chinner <dchinner@redhat.com>
> Suggested-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 54 ++++++++++++++++++++++++++++++++--------------
>  fs/xfs/xfs_inode.h |  2 +-
>  2 files changed, 39 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c5077e6326c7..3d28c4790231 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -345,32 +345,54 @@ xfs_ilock_demote(
>  }
>  
>  #if defined(DEBUG) || defined(XFS_WARN)
> -int
> +static inline bool
> +__xfs_rwsem_islocked(
> +	struct rw_semaphore	*rwsem,
> +	bool			shared,
> +	bool			excl)
> +{
> +	bool locked = false;
> +
> +	if (!rwsem_is_locked(rwsem))
> +		return false;
> +
> +	if (!debug_locks)
> +		return true;
> +
> +	if (shared)
> +		locked = lockdep_is_held_type(rwsem, 0);
> +
> +	if (excl)
> +		locked |= lockdep_is_held_type(rwsem, 1);
> +
> +	return locked;

This could use some comments explaining the logic, especially why we
need the shared and excl flags, which seems very confusing given that
a lock can be held either shared or exclusive, but not neither and not
both.
