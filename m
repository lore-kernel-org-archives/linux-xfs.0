Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F266CC5479D
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Jan 2023 16:37:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbjAIQh5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Jan 2023 11:37:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbjAIQh4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2023 11:37:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390A22AE2
        for <linux-xfs@vger.kernel.org>; Mon,  9 Jan 2023 08:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673282232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CaUmCofw67cYQpW+1L+v6UW3vJNvAD0zWauvjW5LLKI=;
        b=GBllzLLdgJuSP1Pk41woHEThBW80tANZIMHckIX0TRBoPeLUl3R/ZJelNqY2A+AFEuhjtv
        2AOhWVOP0aKmOJbQF2JvvSLPJ4rdCFTk9CwKhg3ihXHQ5uAytJw2J5nfNDfxFirY/MTp7q
        +hfJlMTQFPdlIvLWGUmq2oZnmqtAqls=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-380-7DgDcHpENrSo5u3gbHWtHg-1; Mon, 09 Jan 2023 11:37:11 -0500
X-MC-Unique: 7DgDcHpENrSo5u3gbHWtHg-1
Received: by mail-ej1-f70.google.com with SMTP id nb4-20020a1709071c8400b0084d4712780bso2082234ejc.18
        for <linux-xfs@vger.kernel.org>; Mon, 09 Jan 2023 08:37:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CaUmCofw67cYQpW+1L+v6UW3vJNvAD0zWauvjW5LLKI=;
        b=Dtg50hwdvU46Bt4Vx5P31vkHlA+36CLPRi6T7BgUZrbc5MHk1equ6/zw1dBL+3q+07
         XJEr2hN8AzqYs4q26d7dFQYxuRkR8ET4SfCVS/RaSykaGZYsk1KS6pbsDkEPUQxTBjaw
         03rBx7RiBgYAyupx6vW1VRBCmNv00kBDxz4LwfuCEbKrOd8uDB63LstpPrR+u7Ad/OwO
         ZjLNXsFKxGmChWk92SWwnsWDtpwdV3BF23XPvESNMEZabodFIbX0Bq6GxPzTM7eWeK2/
         IlrZvWcTW7gC8tX0NTsJML9DUwcmnjLK+XvLJXYgfHouR+Nl2w5jL0eTXoqeyAKoqFU1
         IHYw==
X-Gm-Message-State: AFqh2koP6+TdxVBE8rx83/5vF+4cPL2VmPL3ysPlsMp1/pZAs5aDqI5w
        cpe8GY0K/Fdw6IfizW0+qh7s2OXq27jQTYMBufyN/X8wXSUzQN2nmTOHUZHtOgTF/sczCknIFfw
        o6z8Z9awmx/prhU8rBYQ=
X-Received: by 2002:aa7:d281:0:b0:499:1ed2:6456 with SMTP id w1-20020aa7d281000000b004991ed26456mr5206897edq.22.1673282229973;
        Mon, 09 Jan 2023 08:37:09 -0800 (PST)
X-Google-Smtp-Source: AMrXdXscVCOYigmRoHTWb4vV/saLzV6ZfpNcVMsmtVCVgTbBhRfilAfUqkF4N52m/GSBKWuNy7yTow==
X-Received: by 2002:aa7:d281:0:b0:499:1ed2:6456 with SMTP id w1-20020aa7d281000000b004991ed26456mr5206889edq.22.1673282229825;
        Mon, 09 Jan 2023 08:37:09 -0800 (PST)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id j2-20020aa7de82000000b004972644b19fsm3706906edv.16.2023.01.09.08.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 08:37:09 -0800 (PST)
Date:   Mon, 9 Jan 2023 17:37:07 +0100
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 03/11] xfs: add attribute type for fs-verity
Message-ID: <20230109163707.v2c5vet2c4qkqegn@aalbersh.remote.csb>
References: <20221213172935.680971-1-aalbersh@redhat.com>
 <20221213172935.680971-4-aalbersh@redhat.com>
 <733b882c-30fc-eea0-db01-55d25f272d92@redhat.com>
 <20221214010356.GC3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214010356.GC3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 14, 2022 at 12:03:56PM +1100, Dave Chinner wrote:
> On Tue, Dec 13, 2022 at 11:43:42AM -0600, Eric Sandeen wrote:
> > On 12/13/22 11:29 AM, Andrey Albershteyn wrote:
> > > The Merkle tree pages and descriptor are stored in the extended
> > > attributes of the inode. Add new attribute type for fs-verity
> > > metadata. Skip fs-verity attributes for getfattr as it can not parse
> > > binary page names.
> > > 
> > > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > 
> > 
> > >  DECLARE_EVENT_CLASS(xfs_attr_list_class,
> > > diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> > > index 5b57f6348d630..acbfa29d04af0 100644
> > > --- a/fs/xfs/xfs_xattr.c
> > > +++ b/fs/xfs/xfs_xattr.c
> > > @@ -237,6 +237,9 @@ xfs_xattr_put_listent(
> > >  	if (flags & XFS_ATTR_PARENT)
> > >  		return;
> > >  
> > > +	if (flags & XFS_ATTR_VERITY)
> > > +		return;
> > > +
> > 
> > Just a nitpick, but now that there are already 2 cases like this, I wonder
> > if it would be wise to #define something like an XFS_ATTR_VISIBLE_MASK
> > (or maybe XFS_ATTR_INTERNAL_MASK) and use that to decide, rather than
> > testing each one individually?
> 
> Seems like a good idea to me.

Agreed.

> 
> There's also a couple of other spots that a comment about internal
> vs externally visible xattr namespaces might be appropriate. e.g
> xfs_attr_filter() in the ioctl code should never have internal xattr
> namespaces added to it, and similarly a comment at the top of
> fs/xfs/xfs_xattr.c that the interfaces implemented in the file are
> only for exposing externally visible xattr namespaces to users.

Thanks, will describe that.

> 
> That way it becomes more obvious that we handle internal vs external
> xattr namespaces very differently.
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

