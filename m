Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02EA6C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 13:04:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9D5D610FA
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 13:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234280AbhHSNFN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Aug 2021 09:05:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51294 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229670AbhHSNFN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Aug 2021 09:05:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629378276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L/S+GRb7xWT+tyWUsQFoKr02qKsvZ6KhRRj8UShq54c=;
        b=DPIkfU23b5dbfufGBw0mhIIZ0REVahAQR5Ii9Bswcu4t2gW8TteZJ0EAVarbrOep2/0He0
        3hUAH1zsmLvXDYiUIDrKqBr7fh+Mn1fzBRGpg/OgGSREhc9erUXI0TjtaLwk/3KDUfSVEA
        0pRdQMLYXNDrc6Nn7OtuxNMvKl2hegg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-MvrYrpehPpauKlzJ3rbXkQ-1; Thu, 19 Aug 2021 09:04:35 -0400
X-MC-Unique: MvrYrpehPpauKlzJ3rbXkQ-1
Received: by mail-ed1-f70.google.com with SMTP id p2-20020a50c9420000b02903a12bbba1ebso2780201edh.6
        for <linux-xfs@vger.kernel.org>; Thu, 19 Aug 2021 06:04:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=L/S+GRb7xWT+tyWUsQFoKr02qKsvZ6KhRRj8UShq54c=;
        b=CP2YeGs103ITnJ03d+JFzcuauVeKLQtBK0QtgVU0DIyXpU1vwM2tKgY4X2BQSf6lS/
         NAEpl6ORdFoZt0RsaREIjo8M4LgIMph1qg1+D5nFm4JdpII1qK2UpNncVB1EZeicsj6T
         yPpGMlzbRcPIQ1iKVQ8rBuzG3ii68Wpa4bCjyET7mbH2rt2MyeLekCsGIU63vjFzM2Xy
         6Ogk2PyVkL5CjjCyHEpNZgIIzc4Y28FmlMZee8LegnE5oJf9qk9Z52q5bZ6FLNAp3aAe
         Gv63X0uQvXVmoxLhdh/67TeswBnK02uEIyAlOxlr0oQfjo3Z8gwZw2ysUY8yesz1O2Ap
         EyCA==
X-Gm-Message-State: AOAM532xes8w+tWByJz0wSGJUdC/CRApejuhAd0IOqbf4PElPXKQti26
        bbyYOtyyaOAd7lHRANXDF54yOO4uPNLUcPC3lyzHjfNTK/59GJ0O/LtUvbDXNVW86NI4wJWRJ7g
        894ULlDcZ5O3ce9BOEZ8i
X-Received: by 2002:a05:6402:1299:: with SMTP id w25mr16765808edv.30.1629378273954;
        Thu, 19 Aug 2021 06:04:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhMZRixb6RpONRJaQ0sFyfRXiD8GylIz6N3jZt/7LEFbSY4bSE+93IHlpYCkHkUSnF0MNXtg==
X-Received: by 2002:a05:6402:1299:: with SMTP id w25mr16765794edv.30.1629378273790;
        Thu, 19 Aug 2021 06:04:33 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id n13sm1245482ejk.97.2021.08.19.06.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 06:04:33 -0700 (PDT)
Date:   Thu, 19 Aug 2021 15:04:31 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/15] xfs: decode scrub flags in ftrace output
Message-ID: <20210819130431.awr7u335rctgjrym@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        david@fromorbit.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
 <162924381463.761813.16823449335256904439.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162924381463.761813.16823449335256904439.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 17, 2021 at 04:43:34PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When using pretty-printed scrub tracepoints, decode the meaning of the
> scrub flags as strings for easier reading.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/trace.h |   14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> 
> 
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index 2777d882819d..e9b81b7645c1 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -79,6 +79,16 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_FSCOUNTERS);
>  	{ XFS_SCRUB_TYPE_PQUOTA,	"prjquota" }, \
>  	{ XFS_SCRUB_TYPE_FSCOUNTERS,	"fscounters" }
>  
> +#define XFS_SCRUB_FLAG_STRINGS \
> +	{ XFS_SCRUB_IFLAG_REPAIR,		"repair" }, \
> +	{ XFS_SCRUB_OFLAG_CORRUPT,		"corrupt" }, \
> +	{ XFS_SCRUB_OFLAG_PREEN,		"preen" }, \
> +	{ XFS_SCRUB_OFLAG_XFAIL,		"xfail" }, \
> +	{ XFS_SCRUB_OFLAG_XCORRUPT,		"xcorrupt" }, \
> +	{ XFS_SCRUB_OFLAG_INCOMPLETE,		"incomplete" }, \
> +	{ XFS_SCRUB_OFLAG_WARNING,		"warning" }, \
> +	{ XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED,	"norepair" }
> +
>  DECLARE_EVENT_CLASS(xchk_class,
>  	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
>  		 int error),
> @@ -103,14 +113,14 @@ DECLARE_EVENT_CLASS(xchk_class,
>  		__entry->flags = sm->sm_flags;
>  		__entry->error = error;
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx type %s agno 0x%x inum 0x%llx gen 0x%x flags 0x%x error %d",
> +	TP_printk("dev %d:%d ino 0x%llx type %s agno 0x%x inum 0x%llx gen 0x%x flags (%s) error %d",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
>  		  __entry->agno,
>  		  __entry->inum,
>  		  __entry->gen,
> -		  __entry->flags,
> +		  __print_flags(__entry->flags, "|", XFS_SCRUB_FLAG_STRINGS),
>  		  __entry->error)
>  )
>  #define DEFINE_SCRUB_EVENT(name) \
> 

-- 
Carlos

