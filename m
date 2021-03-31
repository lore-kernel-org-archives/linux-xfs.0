Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80FE2C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 17:07:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3881060FF1
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 17:07:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbhCaRGh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 Mar 2021 13:06:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:43264 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229787AbhCaRGI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Mar 2021 13:06:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1617210366; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SemqjPPzvEYV8sbLTRQCRq1Wgrq7JEKJiMtlxAHP6Zk=;
        b=iilfupjFT/3gTmyOz6X97ZZ/4WKm4JNoUqMEaDY45Ksm6NBfUTriACBLMCmX2Ulx0lYDXx
        AgjW+voPrMztCslgKXItsCFpPK50SHHrPhMtt7qgDYOLZU8LixQStDsM624c1G284RdrMl
        GxJxgXhzSNEnUwg6ARgciWosmHfzppw=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CEDB1AF2C;
        Wed, 31 Mar 2021 17:06:06 +0000 (UTC)
Date:   Wed, 31 Mar 2021 19:06:05 +0200
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: deprecate BMV_IF_NO_DMAPI_READ flag
Message-ID: <YGSr/Yyv5EaYSb35@technoir>
References: <20210331162617.17604-1-ailiop@suse.com>
 <20210331163114.GC4090233@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210331163114.GC4090233@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 31, 2021 at 09:31:14AM -0700, Darrick J. Wong wrote:
> On Wed, Mar 31, 2021 at 06:26:16PM +0200, Anthony Iliopoulos wrote:
> > Use of the flag has had no effect since kernel commit 288699fecaff
> > ("xfs: drop dmapi hooks"), which removed all dmapi related code, so
> > deprecate it.
> > 
> > Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
> > ---
> > changes since v1:
> >  - retain flag definition to prevent reuse and not break kabi, per
> >    Darrick's suggestion.
> > 
> >  fs/xfs/libxfs/xfs_fs.h | 4 ++--
> >  fs/xfs/xfs_ioctl.c     | 2 --
> >  2 files changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > index 6fad140d4c8e..4ef813e00e9e 100644
> > --- a/fs/xfs/libxfs/xfs_fs.h
> > +++ b/fs/xfs/libxfs/xfs_fs.h
> > @@ -65,13 +65,13 @@ struct getbmapx {
> >  
> >  /*	bmv_iflags values - set by XFS_IOC_GETBMAPX caller.	*/
> >  #define BMV_IF_ATTRFORK		0x1	/* return attr fork rather than data */
> > -#define BMV_IF_NO_DMAPI_READ	0x2	/* Do not generate DMAPI read event  */
> > +#define BMV_IF_NO_DMAPI_READ	0x2	/* Deprecated */
> >  #define BMV_IF_PREALLOC		0x4	/* rtn status BMV_OF_PREALLOC if req */
> >  #define BMV_IF_DELALLOC		0x8	/* rtn status BMV_OF_DELALLOC if req */
> >  #define BMV_IF_NO_HOLES		0x10	/* Do not return holes */
> >  #define BMV_IF_COWFORK		0x20	/* return CoW fork rather than data */
> >  #define BMV_IF_VALID	\
> > -	(BMV_IF_ATTRFORK|BMV_IF_NO_DMAPI_READ|BMV_IF_PREALLOC|	\
> > +	(BMV_IF_ATTRFORK|BMV_IF_PREALLOC|	\
> >  	 BMV_IF_DELALLOC|BMV_IF_NO_HOLES|BMV_IF_COWFORK)
> 
> What about the xfs/296 regression that the kernel robot reported?
> 
> I /think/ that's a result of removing this flag from BMV_IF_VALID, which
> is used to reject unknown input flags from the GETBMAP caller.  In the
> current upstream the flag is valid even if it does nothing, so we have
> to preserve that behavior.

In that case then it indeed needs to stay in BMV_IF_VALID. I assume it
is not worth putting flags into a deprecation schedule, so this will
have to stay there for as long as the ioctl exists. I'll send a v3.

Regards,
Anthony
