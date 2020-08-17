Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE3BC433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 11:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9F932072E
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 11:26:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HvjsdCwP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgHQL0e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 07:26:34 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43291 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgHQL0a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 07:26:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597663589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9uCsjtxOb0MXDQ4Gg7xcYoL5rIj8Z5WIn6TL6ksfYyY=;
        b=HvjsdCwPkK73ZDpOSKfbAZIcV2UGJWku4JIVxMUn2ljXD6NyIIMXvWd6LMBVdKb2wKGIgu
        LD0OQaE3j6+T+iswSPuFy10hiEuKKFkAm8Hhqn92rTlpScNWy2VHcB60gEBlZ2+0bf0tAw
        OLfBnKnPMxhaS0Rd5ZX7rll5laiBUdE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-fv08XPs0Onqv3AYQd3OznQ-1; Mon, 17 Aug 2020 07:26:26 -0400
X-MC-Unique: fv08XPs0Onqv3AYQd3OznQ-1
Received: by mail-wr1-f72.google.com with SMTP id t3so6920899wrr.5
        for <linux-xfs@vger.kernel.org>; Mon, 17 Aug 2020 04:26:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=9uCsjtxOb0MXDQ4Gg7xcYoL5rIj8Z5WIn6TL6ksfYyY=;
        b=JGYR1rVjasSr0EyAxhHL09J+Ar3cjonltsIomURY210KQxwsaqnEERNSX2epGYM6hi
         b4ZRMRIPSvl3F/8W4fW81kKTd7CGeH1kZW6vm9jh6PgRGprob9feFXMg6NPDJ1KrcGYm
         Hc7UszhJYkrPCq4KTIIX0PKf8IKPiu5STX9gANJqTMdEXAH+U8VmQ5iSa5XwFEONg4Vr
         uliNiwSoruX9+v79eXCrIKN1xfu5JxLoing2gSl1y/DU0fcyjZVStqOVs+GJWw4kdYuo
         MU8ZNwvp/Mo+p1Q+2TNOnx5P07zrWrzZKyg+I/y4tu5lHJ0V/c8+EJhVdDdpeU0gzLrz
         OqXw==
X-Gm-Message-State: AOAM530nX94FC6vJN5shFCuWsX5yEHJZkStaUvK1e8s9sUFSoK21oaow
        3rnfhaoYDY/NtsAeTQufsDql69DeRAEsZvNf8DWnqem4E1gfo7aXh7jvHLxtmKmmKQ/YaXO+lch
        /IgvWXBq0JITkUUqkFBrq
X-Received: by 2002:a5d:4e8c:: with SMTP id e12mr14990623wru.19.1597663585789;
        Mon, 17 Aug 2020 04:26:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw7f1yJIZVZx2eJ8y6Po7C8YZ9FpTVlCZaHf+9u/J4Xz3cR3V8m9arka7/b7qPR2wEh9E0Jjg==
X-Received: by 2002:a5d:4e8c:: with SMTP id e12mr14990609wru.19.1597663585613;
        Mon, 17 Aug 2020 04:26:25 -0700 (PDT)
Received: from eorzea (ip-86-49-45-232.net.upcbroadband.cz. [86.49.45.232])
        by smtp.gmail.com with ESMTPSA id e5sm32694642wrc.37.2020.08.17.04.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 04:26:25 -0700 (PDT)
Date:   Mon, 17 Aug 2020 13:26:23 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs_db: report the inode dax flag
Message-ID: <20200817112623.b5tr5o6xkbhvu6rq@eorzea>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        sandeen@sandeen.net, linux-xfs@vger.kernel.org
References: <159736123670.3063459.13610109048148937841.stgit@magnolia>
 <159736124924.3063459.16692986145242990855.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159736124924.3063459.16692986145242990855.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 13, 2020 at 04:27:29PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Report the inode DAX flag when we're printing an inode, just like we do
> for other v3 inode flags.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  db/inode.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> 
> diff --git a/db/inode.c b/db/inode.c
> index 3ae5d18f9887..f13150c96aa9 100644
> --- a/db/inode.c
> +++ b/db/inode.c
> @@ -172,6 +172,9 @@ const field_t	inode_v3_flds[] = {
>  	{ "cowextsz", FLDT_UINT1,
>  	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_COWEXTSIZE_BIT-1), C1,
>  	  0, TYP_NONE },
> +	{ "dax", FLDT_UINT1,
> +	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_DAX_BIT - 1), C1,
> +	  0, TYP_NONE },
>  	{ NULL }

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  };
>  
> 

-- 
Carlos

