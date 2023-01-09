Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43D68C5479D
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Jan 2023 16:53:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjAIQxw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Jan 2023 11:53:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236196AbjAIQxH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2023 11:53:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00EF941664
        for <linux-xfs@vger.kernel.org>; Mon,  9 Jan 2023 08:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673283094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zH0iIm/82e8/+vbOmbtlqd9kWO2ASu2512CGHEzjOz4=;
        b=YghmDgzEKzr5Qx09DfHFegxeDYA07cgaCwJAGTm+HDa8TXaamMD0o5/jsT+GrNChnrgn4t
        5ZNe1sYRy4ueBrCXHKR3O5Luf5+Yey4lbDL0pgk/0RudIGm9vrUe43xAdAVjx+BcGAUjxO
        tBfTJbGNi1UWHHlEjhABHz10ofOAoYI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-609-SXFfZ-IBMje6KFdWNPS7bw-1; Mon, 09 Jan 2023 11:51:33 -0500
X-MC-Unique: SXFfZ-IBMje6KFdWNPS7bw-1
Received: by mail-ed1-f69.google.com with SMTP id v8-20020a056402348800b0048db0688c80so5669729edc.15
        for <linux-xfs@vger.kernel.org>; Mon, 09 Jan 2023 08:51:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zH0iIm/82e8/+vbOmbtlqd9kWO2ASu2512CGHEzjOz4=;
        b=gNltTuomy3qjpT7wqFYM8ixzK0x6kfyheaWMTB6At99Zl91qWbgEwp4Zjc2R4142NS
         sAJ/fN6e3KBIV055xW8Bf40L/2XyBxyupt8g4BxM58BgBJ5qISQgmrIyCAb1PCxSQWf8
         f1b/9Yzi04r/n7klW5z12r/UDj3diDxBJm+/BKCJ+pThF2t7upFGtcPFyyh0jJFDc6MC
         VVvVCTQbMncQKgwoNag7qtq9oLYxHJJ4uC3UJ7sCqNBwNvi5YJzTDXLhgnykCAGBylof
         XCzPEIxYlzmeSptM/xhg0BHyNuiD/d3N3isC8Hx3ZRMY0bMz1Oy1/ySx870zt7T1jo5I
         Ck2A==
X-Gm-Message-State: AFqh2kqNLLpuw3YhNRPD+wvH5d8jMmT9HwT9slPoMfrfswb/+nZeF2dI
        1J4f1SHwgKucE70Zb6rV8CVhplk07LYHc0WUOgBomX2rQZm/+8eZL1lzsyC7/KWFntneiuH2Q0J
        waPKRdpUJ5ShXXKyqvTI=
X-Received: by 2002:aa7:d752:0:b0:499:bcfc:f47b with SMTP id a18-20020aa7d752000000b00499bcfcf47bmr2384274eds.16.1673283092008;
        Mon, 09 Jan 2023 08:51:32 -0800 (PST)
X-Google-Smtp-Source: AMrXdXu8E1jgjThO9ffI96XDW5cVmIvQxVnT+jpvilrs0fzNH3qtf0G8n2DXIql8yjJlJPZn96Y00w==
X-Received: by 2002:aa7:d752:0:b0:499:bcfc:f47b with SMTP id a18-20020aa7d752000000b00499bcfcf47bmr2384268eds.16.1673283091883;
        Mon, 09 Jan 2023 08:51:31 -0800 (PST)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id ch17-20020a0564021bd100b004585eba4baesm3943653edb.80.2023.01.09.08.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 08:51:31 -0800 (PST)
Date:   Mon, 9 Jan 2023 17:51:29 +0100
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 05/11] xfs: add inode on-disk VERITY flag
Message-ID: <20230109165129.ztwml2wnjlk77oed@aalbersh.remote.csb>
References: <20221213172935.680971-1-aalbersh@redhat.com>
 <20221213172935.680971-6-aalbersh@redhat.com>
 <20221214012928.GE3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214012928.GE3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 14, 2022 at 12:29:28PM +1100, Dave Chinner wrote:
> On Tue, Dec 13, 2022 at 06:29:29PM +0100, Andrey Albershteyn wrote:
> > Add flag to mark inodes which have fs-verity enabled on them (i.e.
> > descriptor exist and tree is built).
> .....
> > 
> >  static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
> >  {
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index f08a2d5f96ad4..8d9c9697d3619 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -636,6 +636,8 @@ xfs_ip2xflags(
> >  			flags |= FS_XFLAG_DAX;
> >  		if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
> >  			flags |= FS_XFLAG_COWEXTSIZE;
> > +		if (ip->i_diflags2 & XFS_DIFLAG2_VERITY)
> > +			flags |= FS_VERITY_FL;
> >  	}
> 
> Ah, attribute flag confusion - easy to do. xflags (FS_XFLAG*) are a
> different set of (extended) flags than the standard VFS inode flags
> (FS_*_FL).
> 
> To place the verity enabled state in the extended flags, you would
> need to define FS_XFLAG_VERITY in include/uapi/linux/fs.h. You'll
> also need to add the conversion from FS_VERITY_FL to FS_XFLAG_VERITY
> to fileattr_fill_flags() and vice versa to fileattr_fill_xflags()
> 
> This will allow both the VFS inode flags UAPI and the
> FS_IOC_FSGETXATTR extended flag API to see the inode has verity
> enabled on it.
> 
> Once FS_XFLAG_VERITY is defined, changing the code in XFS to use it
> directly instead of FS_VERITY_FL will result in everything working
> correct throughout the code.

Oh I see, thanks for the explanation. They are truly confusing :( I
will adjusted it as suggested

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

-- 
- Andrey

