Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECFEAEB64DA
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 13:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233066AbjGLNJf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 09:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjGLNJe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 09:09:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7611E12F;
        Wed, 12 Jul 2023 06:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=y+HHeCvAOXV5q9biRuHur/SvAyLum8IsX8WCp/AOBKU=; b=RNWajCoD8vf/f6AogJWiREP9C6
        Rl6p8WxPQo4lEfPt0QCCaX+R+9LnEARlYIKK1/lhpnp3rTChpeYV75s+2eH0gVm1vLYojkCNp03Ka
        30+Jeo6goaqVvXCzIyIPsJqLmH17A2GPJ+Z0AwhFDsxhrsKh0lS9/QFnxEbrmmxvlWepCmokYWHwF
        y96AOllNDYFNbTtU0nHE+rH9Jjdn7Yt/g7rMH4mQeXSqBaSPdYy73SA+mSfG5oM1qyMvmhY9S4RSh
        xzoCPJNUA1sX1LCkPx132t4SWLmu3xuLw94qlYmPCI82MpY+H/EGz0kwcYKqTeLDmHcoT0iTW9O5p
        ufoh6lWQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qJZb1-0002eu-2G;
        Wed, 12 Jul 2023 13:09:31 +0000
Date:   Wed, 12 Jul 2023 06:09:31 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Carlos Maiolino <cem@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Jeff Layton <jlayton@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-xfs@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] libxfs: Redefine 1-element arrays as flexible arrays
Message-ID: <ZK6mC1npjONMoGMD@infradead.org>
References: <20230711222025.never.220-kees@kernel.org>
 <20230712053738.GD108251@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712053738.GD108251@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 11, 2023 at 10:37:38PM -0700, Darrick J. Wong wrote:
> Here's my version, where I go for a straight a[1] -> a[] conversion and
> let downstream attrlist ioctl users eat their lumps.  What do you think
> of the excess-documentation approach?

I think this is roughtly the right thing, with one big caveat:

> +	/* In Linux 6.5 this flex array was changed from list[1] to list[]. */

For all the format headers there's no need for these comments.  We've
done this for various other structures that had the old one size arrays
and never bothered.

> diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
> index 9c60ebb3..8927ecb2 100644
> --- a/libxfs/xfs_fs.h
> +++ b/libxfs/xfs_fs.h
> @@ -588,16 +588,19 @@ typedef struct xfs_attrlist_cursor {
>   *
>   * NOTE: struct xfs_attrlist must match struct attrlist defined in libattr, and
>   * struct xfs_attrlist_ent must match struct attrlist_ent defined in libattr.
> + *
> + * WARNING: In Linux 6.5, al_offset and a_name were changed from array[1] to
> + * array[].  Anyone using sizeof is (already) broken!
>   */
>  struct xfs_attrlist {
>  	__s32	al_count;	/* number of entries in attrlist */
>  	__s32	al_more;	/* T/F: more attrs (do call again) */
> -	__s32	al_offset[1];	/* byte offsets of attrs [var-sized] */
> +	__s32	al_offset[];	/* byte offsets of attrs [var-sized] */
>  };
>  
>  struct xfs_attrlist_ent {	/* data from attr_list() */
>  	__u32	a_valuelen;	/* number bytes in value of attr */
> -	char	a_name[1];	/* attr name (NULL terminated) */
> +	char	a_name[];	/* attr name (NULL terminated) */
>  };

Now these are currently exposed in a xfsprogs headeer and IFF someone
is using them it would break them in nasty ways.  That being said,
xfsprogs itself doesn't use them as it relies on identically layed
out but differntly named structures from libattr.

So I think we should just move these two out of xfs_fs.h, because
while they document a UAPI, they aren't actually used by userspace.

With that the need for any caution goes away and we can just fix the
definition without any caveats.
