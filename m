Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E10E5C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 11:25:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92D012072E
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 11:25:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TutTdqH6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgHQLZe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 07:25:34 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56611 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726171AbgHQLZd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 07:25:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597663531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VpnlKwlABrM/Tq/doMa8NH6eXkffK0bXe5gDa70qCkY=;
        b=TutTdqH6LMA+D4w5Nm8X3M7oTQYJhqiEUzxBrKeVMOFdjEnXsoEM+3RZpMQe7pTkaWxXNs
        NvbZ8aSvOWFGsvCBgCb6rslMWqnAAZd5lH6Mr6Utop3TIQOZLlECoVeGptNxlQayZTCxxO
        zBYfWXh5URmgNQ/0hjh3BNk9D565roU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-fJSyb5NkM4eQAWGNE2nUKQ-1; Mon, 17 Aug 2020 07:25:30 -0400
X-MC-Unique: fJSyb5NkM4eQAWGNE2nUKQ-1
Received: by mail-wr1-f69.google.com with SMTP id l14so6928476wrp.9
        for <linux-xfs@vger.kernel.org>; Mon, 17 Aug 2020 04:25:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=VpnlKwlABrM/Tq/doMa8NH6eXkffK0bXe5gDa70qCkY=;
        b=eTiWIRNjbchZE5HbABkmwf2zO73sDLSCGI2s5V2Gy3qHZCjIEEe//9t7HC94QgbQ/9
         0syUoaHILOfzIFY0XUUZmb7QlyUUMGo7LlSYeKXFvJ2MS85jgEWCRL3cpSl2XKVKtRq4
         TMEsA3imwrRpasSA8aJhtNeRvToyqb2X+kjGUlggRoVAFjXhKEcQ6lpwNichyijJwr1x
         2OnPL9WrbH65Pabx87GNHOFewtbQAFpDOKACx7eolEuikK4ZQAkU5HWz9KVuDUVlrMe3
         QzCcfGrAK7EO24nxoSwI3YQO3hP4WoL3Ja+DgBlK4bFMOBl3CG8ObPuNOPx4YsTXG9xR
         SKAg==
X-Gm-Message-State: AOAM533aEn/I6owOPz4y2Ihc4djMFtfy/6bJMvFJwVuUeD4Pbn4oK8I9
        DSLJZrSpBiXPyEAqkRcK8teV72HdzJPPSWAbM3b//9a54B8Fr4hXwBsOr2/1elvb3iU+Zna2Xp2
        WcHJ6DHO/WvRFXk6W6Ey9
X-Received: by 2002:adf:a192:: with SMTP id u18mr16267544wru.158.1597663528964;
        Mon, 17 Aug 2020 04:25:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxyge5mVa+qadHrcCM/X1KDuIsNH53gd8srtsJP3MRj+TBORbOorMsVgUrhzYmVYfaRYKv/dw==
X-Received: by 2002:adf:a192:: with SMTP id u18mr16267525wru.158.1597663528742;
        Mon, 17 Aug 2020 04:25:28 -0700 (PDT)
Received: from eorzea (ip-86-49-45-232.net.upcbroadband.cz. [86.49.45.232])
        by smtp.gmail.com with ESMTPSA id h6sm30362836wrv.40.2020.08.17.04.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 04:25:28 -0700 (PDT)
Date:   Mon, 17 Aug 2020 13:25:26 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, Eric Sandeen <sandeen@redhat.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs_db: fix nlink usage in check
Message-ID: <20200817112526.istt7y6bpkfsuaoa@eorzea>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        sandeen@sandeen.net, Eric Sandeen <sandeen@redhat.com>,
        linux-xfs@vger.kernel.org
References: <159736123670.3063459.13610109048148937841.stgit@magnolia>
 <159736124295.3063459.16896525594275470708.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159736124295.3063459.16896525594275470708.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 13, 2020 at 04:27:22PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> process_inode uses a local convenience variable to abstract the
> differences between the ondisk nlink fields in a v1 inode and a v2
> inode.  Use this variable for checking and reporting errors.
> 
> Fixes: 6526f30e4801 ("xfs_db: stop misusing an onstack inode")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  db/check.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)


Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> 
> 
> diff --git a/db/check.c b/db/check.c
> index c2233a0d1ba7..ef0e82d4efa1 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -2797,10 +2797,10 @@ process_inode(
>  					be64_to_cpu(dip->di_nblocks), ino);
>  			error++;
>  		}
> -		if (dip->di_nlink != 0) {
> +		if (nlink != 0) {
>  			if (v)
>  				dbprintf(_("bad nlink %d for free inode %lld\n"),
> -					be32_to_cpu(dip->di_nlink), ino);
> +					nlink, ino);
>  			error++;
>  		}
>  		if (dip->di_mode != 0) {
> 

-- 
Carlos

