Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B6EDEB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jul 2023 05:44:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbjGMFoy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Jul 2023 01:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232641AbjGMFox (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2023 01:44:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868451989;
        Wed, 12 Jul 2023 22:44:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23B4761A24;
        Thu, 13 Jul 2023 05:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7361CC433C8;
        Thu, 13 Jul 2023 05:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689227091;
        bh=6XCJ3zXa9Yfor+KTu4kClEjr5YTvx3XG0W6PUIBvJgw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XTVmWzDPSv1Nkby5x97GOJHvh7hc11w1GC1heEkW/FEgs3OTB+N2jp6Da/D1rAclD
         l+vOzUHModm+y+JXOKWuSelpyC5D+b4PTvFoKOsqug9u3eN/K0J9jRdAEhqc9dMDYV
         /gg/fuTv7Rs4oxdX27ZOC6XzxIb0wVTVnTTpHJ48A7hHwPPGbmSZ6SnHoJFQxBDe9a
         K15fzypJaKzu5NbY4cEmB5uYqFjs2Ed0LSlavD/+bHOwMqJNDj+LhPl/Xk82zn93Vu
         R0ViGF6fI3czvdmGc3Ad7YMLteN7qQWMJdv/HkSldPKBXIoR0fPYReWWGK6joR/hH8
         x20Cp+yaPAFGw==
Date:   Wed, 12 Jul 2023 22:44:50 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Carlos Maiolino <cem@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Jeff Layton <jlayton@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-xfs@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] libxfs: Redefine 1-element arrays as flexible arrays
Message-ID: <20230713054450.GQ108251@frogsfrogsfrogs>
References: <20230711222025.never.220-kees@kernel.org>
 <20230712053738.GD108251@frogsfrogsfrogs>
 <ZK6mC1npjONMoGMD@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZK6mC1npjONMoGMD@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 12, 2023 at 06:09:31AM -0700, Christoph Hellwig wrote:
> On Tue, Jul 11, 2023 at 10:37:38PM -0700, Darrick J. Wong wrote:
> > Here's my version, where I go for a straight a[1] -> a[] conversion and
> > let downstream attrlist ioctl users eat their lumps.  What do you think
> > of the excess-documentation approach?
> 
> I think this is roughtly the right thing, with one big caveat:
> 
> > +	/* In Linux 6.5 this flex array was changed from list[1] to list[]. */
> 
> For all the format headers there's no need for these comments.  We've
> done this for various other structures that had the old one size arrays
> and never bothered.

<nod> Dave looked at an earlier version and wanted the comments for
xfs_da_format.h to steer people at the entsize helpers.  I more or less
agree that it's overkill everywhere else though.

> > diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
> > index 9c60ebb3..8927ecb2 100644
> > --- a/libxfs/xfs_fs.h
> > +++ b/libxfs/xfs_fs.h
> > @@ -588,16 +588,19 @@ typedef struct xfs_attrlist_cursor {
> >   *
> >   * NOTE: struct xfs_attrlist must match struct attrlist defined in libattr, and
> >   * struct xfs_attrlist_ent must match struct attrlist_ent defined in libattr.
> > + *
> > + * WARNING: In Linux 6.5, al_offset and a_name were changed from array[1] to
> > + * array[].  Anyone using sizeof is (already) broken!
> >   */
> >  struct xfs_attrlist {
> >  	__s32	al_count;	/* number of entries in attrlist */
> >  	__s32	al_more;	/* T/F: more attrs (do call again) */
> > -	__s32	al_offset[1];	/* byte offsets of attrs [var-sized] */
> > +	__s32	al_offset[];	/* byte offsets of attrs [var-sized] */
> >  };
> >  
> >  struct xfs_attrlist_ent {	/* data from attr_list() */
> >  	__u32	a_valuelen;	/* number bytes in value of attr */
> > -	char	a_name[1];	/* attr name (NULL terminated) */
> > +	char	a_name[];	/* attr name (NULL terminated) */
> >  };
> 
> Now these are currently exposed in a xfsprogs headeer and IFF someone
> is using them it would break them in nasty ways.  That being said,
> xfsprogs itself doesn't use them as it relies on identically layed
> out but differntly named structures from libattr.
> 
> So I think we should just move these two out of xfs_fs.h, because
> while they document a UAPI, they aren't actually used by userspace.
> 
> With that the need for any caution goes away and we can just fix the
> definition without any caveats.

So I looked at the libattr headers for Ubuntu 22.04 and saw this:

/*
 * List the names and sizes of the values of all the attributes of an object.
 * "Cursor" must be allocated and zeroed before the first call, it is used
 * to maintain context between system calls if all the attribute names won't
 * fit into the buffer on the first system call.
 * The return value is -1 on error (w/errno set appropriately), 0 on success.
 */
extern int attr_list(const char *__path, char *__buffer, const int __buffersize,
		int __flags, attrlist_cursor_t *__cursor)
	__attribute__ ((deprecated ("Use listxattr or llistxattr instead")));
extern int attr_listf(int __fd, char *__buffer, const int __buffersize,
		int __flags, attrlist_cursor_t *__cursor)
	__attribute__ ((deprecated ("Use flistxattr instead")));

I take that as a sign that they could drop all these xfs-specific APIs
one day, which means we ought to keep them in xfs_fs.h.

--D
