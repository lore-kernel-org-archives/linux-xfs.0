Return-Path: <SRS0=ckLY=XT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FECBC432C1
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 11:41:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EAF0214AF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 11:41:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="k2BD4Szz";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="giITRHnj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbfIXLl3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 07:41:29 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:57073 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728221AbfIXLl3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Sep 2019 07:41:29 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 5A13221443;
        Tue, 24 Sep 2019 07:41:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 24 Sep 2019 07:41:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        yET7uB5F9WhD4fpxfnjysAdXEKb0BUtrMsLf+sV3r+8=; b=k2BD4SzzMj16FV5o
        syT2AGT33XApVoVk4Fl77IdmpZsU7zT7BojWPeh6RmiHYTBfTQYbRbcGJJF+XRzb
        Inbv3sEcexoBadfqNoWLUiuSbEPR1/ZHilUXMPD7d0gk5cK+HmZt+s0p/YqNdqvd
        zfGfbhvoyUOcLsWqfG/LCOnqP6EWGEVvDAQ2yKy4yg2i7QJ3xAEHcjUtIeIh24W3
        uWchYi28r6fhZKHWesoN1yoDzTTczL000qQz7XlMX9TPSEsiSKl+ogf8Wrg0Bnqj
        sehHbVO98cd1ucz7mFItTpvqMfPWyZRYpIKrOe/PeHIB4k/7V2ICmQ6YaFhcVrFs
        oQzGiw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=yET7uB5F9WhD4fpxfnjysAdXEKb0BUtrMsLf+sV3r
        +8=; b=giITRHnjCQ/dKgcoFv8iIdsFKRXUQtirKhG1fK7eBB+NDY0iedmrwKXgj
        bBT3q6BCUSIhFp6m4Fwc9ag8Lq538wcMLU9W18wBwUljJU9AuOQ12DUuX9rcejZw
        7mOeBYGTww1vG1YTLwmpN4J7l2dLSUPLrhxPsILbfQGOLuoRuVE9PWfMzYmkymRA
        SRkHGS6OWHCLZMQats+9TBl5UrClBzWFPPBmXwcx52oTz90CWM2hVPs+I2NBWHaD
        5jdYUJDKzNF8LA5KeuvQ0Fln5ztnXZrjC13JcdFtTuJb4vJT39GWXOqdkvz59oL7
        co7WtUx1BRS29Cgz/4Q7fmK5ZPcaw==
X-ME-Sender: <xms:5wCKXQ7MWNSdIHP-EhgrycQ2yYKcQQxmfbudCC9rJ1g_p_B6r1hZtw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrfedtgdegvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtkeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdekrd
    duieefrddvvdefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgr
    fidrnhgvthenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:5wCKXRdgxlbB5V6Rf6H1HSIC1nJ4RQSnWwlI8niaMTXPmtl7Q7ofJg>
    <xmx:5wCKXY0XSzAR7gS5CG4qhrsTUYEYHGGi1aidjyAT0UpRtjZpc9FEFA>
    <xmx:5wCKXd8cgy-eHlxbFe3bvTt2H8EQIKKFxr4x6GefTgfi1DhUs9Z3ZQ>
    <xmx:6ACKXfjulBXIjGJd4TIxmIZyF5vwyNsGUi1mELtMHFqb33-yRH_-Yw>
Received: from mickey.themaw.net (unknown [118.208.163.223])
        by mail.messagingengine.com (Postfix) with ESMTPA id AF43D80068;
        Tue, 24 Sep 2019 07:41:24 -0400 (EDT)
Message-ID: <1e1209db19ac68132bdc03966ce1a5e1cc3b2ee6.camel@themaw.net>
Subject: Re: [PATCH v3 07/16] xfs: mount-api - move xfs_parseargs()
 validation to a helper
From:   Ian Kent <raven@themaw.net>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Tue, 24 Sep 2019 19:41:19 +0800
In-Reply-To: <20190924105614.GI13820@bfoster>
References: <156897321789.20210.339237101446767141.stgit@fedora-28>
         <156897336977.20210.76910391411183299.stgit@fedora-28>
         <20190924105614.GI13820@bfoster>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2019-09-24 at 06:56 -0400, Brian Foster wrote:
> On Fri, Sep 20, 2019 at 05:56:09PM +0800, Ian Kent wrote:
> > Move the validation code of xfs_parseargs() into a helper for later
> > use within the mount context methods.
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> > ---
> 
> More compile issues:
> 
> $ make -j 8 M=fs/xfs
>   CC [M]  fs/xfs/xfs_super.o
> ...
> fs/xfs/xfs_super.c:543:7: note: each undeclared identifier is
> reported only once for each function it appears in
> fs/xfs/xfs_super.c:569:2: error: ‘ret’ undeclared (first use in this
> function); did you mean ‘net’?
>   ret = xfs_validate_params(mp, &context, false);
>   ^~~
>   net
> fs/xfs/xfs_super.c:572:1: warning: control reaches end of non-void
> function [-Wreturn-type]
>  }
>  ^
> make[1]: *** [scripts/Makefile.build:280: fs/xfs/xfs_super.o] Error 1
> make: *** [Makefile:1624: _module_fs/xfs] Error 2
> 
> I'll probably stop here for now since clearly this and the previous
> patch need some tweaks and I'd rather not review around compile
> errors.

Yep, I've found the series that should have been posted.
There are some other changes later on too to remove a couple
of function defined but not used warnings.

Let me repost the series.
I should check again to make absolutely sure I have them
right though so give me a bit.

> 
> Brian
> 
> >  fs/xfs/xfs_super.c |  148 +++++++++++++++++++++++++++++++++-------
> > ------------
> >  1 file changed, 94 insertions(+), 54 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 041ab8b52a7d..5cb9a9fd1a15 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -356,6 +356,97 @@ xfs_parse_param(
> >  	return 0;
> >  }
> >  
> > +STATIC int
> > +xfs_validate_params(
> > +	struct xfs_mount        *mp,
> > +	struct xfs_fs_context   *ctx,
> > +	bool			nooptions)
> > +{
> > +	if (nooptions)
> > +		goto noopts;
> > +
> > +	/*
> > +	 * no recovery flag requires a read-only mount
> > +	 */
> > +	if ((mp->m_flags & XFS_MOUNT_NORECOVERY) &&
> > +	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
> > +		xfs_warn(mp, "no-recovery mounts must be read-only.");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if ((mp->m_flags & XFS_MOUNT_NOALIGN) && (ctx->dsunit || ctx-
> > >dswidth)) {
> > +		xfs_warn(mp,
> > +	"sunit and swidth options incompatible with the noalign
> > option");
> > +		return -EINVAL;
> > +	}
> > +
> > +#ifndef CONFIG_XFS_QUOTA
> > +	if (XFS_IS_QUOTA_RUNNING(mp)) {
> > +		xfs_warn(mp, "quota support not available in this
> > kernel.");
> > +		return -EINVAL;
> > +	}
> > +#endif
> > +
> > +	if ((ctx->dsunit && !ctx->dswidth) || (!ctx->dsunit && ctx-
> > >dswidth)) {
> > +		xfs_warn(mp, "sunit and swidth must be specified
> > together");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (ctx->dsunit && (ctx->dswidth % ctx->dsunit != 0)) {
> > +		xfs_warn(mp,
> > +	"stripe width (%d) must be a multiple of the stripe unit (%d)",
> > +			ctx->dswidth, ctx->dsunit);
> > +		return -EINVAL;
> > +	}
> > +
> > +noopts:
> > +	if (ctx->dsunit && !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
> > +		/*
> > +		 * At this point the superblock has not been read
> > +		 * in, therefore we do not know the block size.
> > +		 * Before the mount call ends we will convert
> > +		 * these to FSBs.
> > +		 */
> > +		mp->m_dalign = ctx->dsunit;
> > +		mp->m_swidth = ctx->dswidth;
> > +	}
> > +
> > +	if (mp->m_logbufs != -1 &&
> > +	    mp->m_logbufs != 0 &&
> > +	    (mp->m_logbufs < XLOG_MIN_ICLOGS ||
> > +	     mp->m_logbufs > XLOG_MAX_ICLOGS)) {
> > +		xfs_warn(mp, "invalid logbufs value: %d [not %d-%d]",
> > +			mp->m_logbufs, XLOG_MIN_ICLOGS,
> > XLOG_MAX_ICLOGS);
> > +		return -EINVAL;
> > +	}
> > +	if (mp->m_logbsize != -1 &&
> > +	    mp->m_logbsize !=  0 &&
> > +	    (mp->m_logbsize < XLOG_MIN_RECORD_BSIZE ||
> > +	     mp->m_logbsize > XLOG_MAX_RECORD_BSIZE ||
> > +	     !is_power_of_2(mp->m_logbsize))) {
> > +		xfs_warn(mp,
> > +			"invalid logbufsize: %d [not 16k,32k,64k,128k
> > or 256k]",
> > +			mp->m_logbsize);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (ctx->iosizelog) {
> > +		if (ctx->iosizelog > XFS_MAX_IO_LOG ||
> > +		    ctx->iosizelog < XFS_MIN_IO_LOG) {
> > +			xfs_warn(mp, "invalid log iosize: %d [not %d-
> > %d]",
> > +				ctx->iosizelog, XFS_MIN_IO_LOG,
> > +				XFS_MAX_IO_LOG);
> > +			return -EINVAL;
> > +		}
> > +
> > +		mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
> > +		mp->m_readio_log = ctx->iosizelog;
> > +		mp->m_writeio_log = ctx->iosizelog;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  /*
> >   * This function fills in xfs_mount_t fields based on mount args.
> >   * Note: the superblock has _not_ yet been read in.
> > @@ -445,16 +536,7 @@ xfs_parseargs(
> >  		ret = xfs_parse_param(&fc, &param);
> >  		kfree(param.string);
> >  		if (ret < 0)
> > -			return ret;
> > -	}
> > -
> > -	/*
> > -	 * no recovery flag requires a read-only mount
> > -	 */
> > -	if ((mp->m_flags & XFS_MOUNT_NORECOVERY) &&
> > -	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
> > -		xfs_warn(mp, "no-recovery mounts must be read-only.");
> > -		return -EINVAL;
> > +			goto done;
> >  	}
> >  
> >  	if ((mp->m_flags & XFS_MOUNT_NOALIGN) &&
> > @@ -484,51 +566,9 @@ xfs_parseargs(
> >  	}
> >  
> >  done:
> > -	if (ctx->dsunit && !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
> > -		/*
> > -		 * At this point the superblock has not been read
> > -		 * in, therefore we do not know the block size.
> > -		 * Before the mount call ends we will convert
> > -		 * these to FSBs.
> > -		 */
> > -		mp->m_dalign = ctx->dsunit;
> > -		mp->m_swidth = ctx->dswidth;
> > -	}
> > -
> > -	if (mp->m_logbufs != -1 &&
> > -	    mp->m_logbufs != 0 &&
> > -	    (mp->m_logbufs < XLOG_MIN_ICLOGS ||
> > -	     mp->m_logbufs > XLOG_MAX_ICLOGS)) {
> > -		xfs_warn(mp, "invalid logbufs value: %d [not %d-%d]",
> > -			mp->m_logbufs, XLOG_MIN_ICLOGS,
> > XLOG_MAX_ICLOGS);
> > -		return -EINVAL;
> > -	}
> > -	if (mp->m_logbsize != -1 &&
> > -	    mp->m_logbsize !=  0 &&
> > -	    (mp->m_logbsize < XLOG_MIN_RECORD_BSIZE ||
> > -	     mp->m_logbsize > XLOG_MAX_RECORD_BSIZE ||
> > -	     !is_power_of_2(mp->m_logbsize))) {
> > -		xfs_warn(mp,
> > -			"invalid logbufsize: %d [not 16k,32k,64k,128k
> > or 256k]",
> > -			mp->m_logbsize);
> > -		return -EINVAL;
> > -	}
> > +	ret = xfs_validate_params(mp, &context, false);
> >  
> > -	if (ctx->iosizelog) {
> > -		if (ctx->iosizelog > XFS_MAX_IO_LOG ||
> > -		    ctx->iosizelog < XFS_MIN_IO_LOG) {
> > -			xfs_warn(mp, "invalid log iosize: %d [not %d-
> > %d]",
> > -				ctx->iosizelog, XFS_MIN_IO_LOG,
> > -				XFS_MAX_IO_LOG);
> > -			return -EINVAL;
> > -		}
> > -
> > -		mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
> > -		mp->m_readio_log = ctx->iosizelog;
> > -		mp->m_writeio_log = ctx->iosizelog;
> > -	}
> > -
> > -	return 0;
> > +	return ret;
> >  }
> >  
> >  struct proc_xfs_info {
> > 

