Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7600BC433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 11:27:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40175207DA
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 11:27:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jLiyA9wP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgHQL1u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 07:27:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20343 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726171AbgHQL1t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 07:27:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597663668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ilBjHA0+71cO+ztHUebGRB2X0P1zw4GSlPmlRcAsAoo=;
        b=jLiyA9wPBbC+fulRd5pKqekwCoETv8dbsQyJQwmhKQinvic35ycp+6XvzdtsRKPYhs5Fya
        vPs8qKWRRbq4ZAU6Dig/3eXVFZDJCyxUqbkh5fihuE4MCRQFPSs6npj8oBScHDBk9nu9X2
        jrgUbWPppAAotebfv/5/CwiGlZHW3VI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-OrC-9Tq8N8Wb-jzmYVsQfQ-1; Mon, 17 Aug 2020 07:27:46 -0400
X-MC-Unique: OrC-9Tq8N8Wb-jzmYVsQfQ-1
Received: by mail-wr1-f69.google.com with SMTP id d6so6913786wrv.23
        for <linux-xfs@vger.kernel.org>; Mon, 17 Aug 2020 04:27:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=ilBjHA0+71cO+ztHUebGRB2X0P1zw4GSlPmlRcAsAoo=;
        b=udTq7F4F+w2Xh10RcnsIim4iPu+pTC76LugJ6xaWYt20l4YktuO0BWnQBrk57Uk6Fp
         ChlDSNhrq44qdSY8T9OXufIOhmIjAXyHi6i3h83wflTWgqOcvm7ITR3PKQy/sYawOk3b
         9kNjngoEHwM3br47/iQyUZNJ7XAHp+2vQjsAMoxpaMRz75aQs0jc+Jm+f/sIgszo1TB0
         f07/ejhEfIcOQQCiytNbLLxdocww8gCdFg7+3XxDxt+4VwDiuyFeAiZsbCl2g8TyKJyU
         tso+gh0efEfRvfFKxVyB7EShD0hVyQfpu8OuF4YTcVAeDxlmeA8eoiajT42NejbW4HE3
         5Unw==
X-Gm-Message-State: AOAM533PzugRThHFXJsEJg7A3ue1EWktS09zaefAYnetdAnJMrnfkJ6l
        ghMo0ziE/AD6/YJI7XLrXqqwWui3+PYfad5mNNK3fzQit2JRU91+P9QFEs8Q8TwKJz4TU3KFQUf
        1nmmynKnIyiyjKNQMs5KA
X-Received: by 2002:a1c:4944:: with SMTP id w65mr13733509wma.169.1597663665015;
        Mon, 17 Aug 2020 04:27:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxPut85qJ0ZBela6R1R3E6hl+KaTjK2wk6QwsP3PXZjqOnfrver0Gdoc+MifcqoIQqF4ugXaA==
X-Received: by 2002:a1c:4944:: with SMTP id w65mr13733497wma.169.1597663664841;
        Mon, 17 Aug 2020 04:27:44 -0700 (PDT)
Received: from eorzea (ip-86-49-45-232.net.upcbroadband.cz. [86.49.45.232])
        by smtp.gmail.com with ESMTPSA id 124sm29686161wmd.31.2020.08.17.04.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 04:27:44 -0700 (PDT)
Date:   Mon, 17 Aug 2020 13:27:42 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] man: update mkfs.xfs inode flag option documentation
Message-ID: <20200817112742.7vlkbfn4uroxrwmx@eorzea>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        sandeen@sandeen.net, linux-xfs@vger.kernel.org
References: <159736123670.3063459.13610109048148937841.stgit@magnolia>
 <159736125533.3063459.18063990185908155478.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159736125533.3063459.18063990185908155478.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 13, 2020 at 04:27:35PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The mkfs manpage says that the extent size, cow extent size, realtime,
> and project id inheritance bits are passed on to "newly created
> children".  This isn't technically true -- it's only passed on to newly
> created regular files and directories.  It is not passed on to special
> files.
> 
> Fix this minor inaccuracy in the documentation.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  man/man8/mkfs.xfs.8 |   12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index 9d762a43011a..7d3f3552ff12 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -285,7 +285,8 @@ Set the copy-on-write extent size hint on all inodes created by
>  .BR mkfs.xfs "."
>  The value must be provided in units of filesystem blocks.
>  If the value is zero, the default value (currently 32 blocks) will be used.
> -Directories will pass on this hint to newly created children.
> +Directories will pass on this hint to newly created regular files and
> +directories.
>  .TP
>  .BI name= value
>  This can be used to specify the name of the special file containing
> @@ -380,20 +381,23 @@ this information.
>  If set, all inodes created by
>  .B mkfs.xfs
>  will be created with the realtime flag set.
> -Directories will pass on this flag to newly created children.
> +Directories will pass on this flag to newly created regular files and
> +directories.
>  .TP
>  .BI projinherit= value
>  All inodes created by
>  .B mkfs.xfs
>  will be assigned this project quota id.
> -Directories will pass on the project id to newly created children.
> +Directories will pass on the project id to newly created regular files and
> +directories.
>  .TP
>  .BI extszinherit= value
>  All inodes created by
>  .B mkfs.xfs
>  will have this extent size hint applied.
>  The value must be provided in units of filesystem blocks.
> -Directories will pass on this hint to newly created children.
> +Directories will pass on this hint to newly created regular files and
> +directories.
>  .RE
>  .TP
>  .B \-f
> 

-- 
Carlos

