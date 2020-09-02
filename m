Return-Path: <SRS0=53rf=CL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67A2CC433E7
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 11:14:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 389A920758
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 11:14:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DycVY8ju"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgIBLOn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Sep 2020 07:14:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45631 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726124AbgIBLOG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Sep 2020 07:14:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599045235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G15IfTBSE1COeRK0SS2UAl5dEUY0dCzEbuu69grUsok=;
        b=DycVY8ju4YGhPrt6viwd70obHff9B9sybEkSDsp/9gQHQmWdRwR4yw+xf0MTh0ivIwgHmr
        fvBFEuK6gUzFHcazSLLUjH/AVBjQpcCbK/H0AxPstU2j2qp1QH5FzNwYZy186feVzgf80+
        1W0Kr5fUINJj9I9yyFxGDhKUpxZ2NiU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-jH06nqUFPMaRFRipIrgeBg-1; Wed, 02 Sep 2020 07:13:54 -0400
X-MC-Unique: jH06nqUFPMaRFRipIrgeBg-1
Received: by mail-wm1-f71.google.com with SMTP id z1so1771096wmk.1
        for <linux-xfs@vger.kernel.org>; Wed, 02 Sep 2020 04:13:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=G15IfTBSE1COeRK0SS2UAl5dEUY0dCzEbuu69grUsok=;
        b=UOXGY2kid/5aUhF0TYnSnzui9vtRIL8GAc6YBIpi//23OxK71B5Hy0ERMZlN7JfCns
         TH7Gd0zg80QTepqM8GVc4nXTNt9yF/0u9A1SBd8ACw6y26IxGUFF9AfVaXVuYVSANrq2
         Fb5bMqycpMHnkOgoU6IZGBigCsL2zmQohvQCY5NwDsccQ96yvA2xzC5DBRJOUv5xp79o
         Mi11UHdlh7GqcN6trFkKfE/WyoeP1D3YwsEsP5tDunZz+HaXigRUdCZG7uyth1A24Ht2
         iQRv1aKKgQmf44JUu4C3xGs4kVlVctuxTs+kch+gyaH3r3K+7KsiC+Z8m34+5KzGH3Fk
         0tog==
X-Gm-Message-State: AOAM5308j67dDXyccJ2TeiOIcvOTgNcl5s8cM2WNfsIt4ExQrYVun8D8
        uAVI3CWJ3uFAePvRCGQ0YCZs9UmYx0N0W4K0Ua8f6v3KAh7729E1B+YlV/WWIP/r4GzjSIN6ep6
        Nv0kP67uuCw/DeenEFuEX
X-Received: by 2002:a5d:4a48:: with SMTP id v8mr6677771wrs.304.1599045232837;
        Wed, 02 Sep 2020 04:13:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzAMp/45YllICGVlAqab75Zg1H14wcmgkC8sd5Sgq/vTiDbnYDSB1wCNYQcw5rCwOAgrnLT4w==
X-Received: by 2002:a5d:4a48:: with SMTP id v8mr6677756wrs.304.1599045232652;
        Wed, 02 Sep 2020 04:13:52 -0700 (PDT)
Received: from eorzea (ip-89-102-9-109.net.upcbroadband.cz. [89.102.9.109])
        by smtp.gmail.com with ESMTPSA id h186sm6147085wmf.24.2020.09.02.04.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 04:13:51 -0700 (PDT)
Date:   Wed, 2 Sep 2020 13:13:50 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: Use variable-size array for nameval in
 xfs_attr_sf_entry
Message-ID: <20200902111350.5gmasccljlbg2j3n@eorzea>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
References: <20200831130423.136509-1-cmaiolino@redhat.com>
 <20200831130423.136509-2-cmaiolino@redhat.com>
 <20200831153126.GA6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831153126.GA6096@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi.

> >  #define XFS_ATTR_SF_ENTSIZE(sfep)		/* space an entry uses */ \
> > -	((int)sizeof(xfs_attr_sf_entry_t)-1 + (sfep)->namelen+(sfep)->valuelen)
> > +	((int)sizeof(xfs_attr_sf_entry_t) + (sfep)->namelen+(sfep)->valuelen)
> 
> Can this (and ENTSIZE_BYNAME) use struct_sizeof?

Regarding our talk on #xfs, I've been playing with it a while today, and IMHO,
converting xfs_attr_sf_entsize to use struct_size() is ok, although,
entsize_byname, I don't think it's worth it. entsize_byname doesn't get a
xfs_attr_sf_entry as argument, so it will require to change the callers to
actually pass a struct xfs_attr_sf_entry, and the respective sizes, but, some
callers actually don't even have a xfs_attr_sf_entry to pass into it, so IMHO, I
don't think it's worth to change it, but by any means, I'll send today a V2 of
my patchset containing the changes from V1, and adding the struct_size() into
xfs_attr_sf_entry.

Cheers.

> 
> --D
> 
> >  #define XFS_ATTR_SF_NEXTENTRY(sfep)		/* next entry in struct */ \
> >  	((xfs_attr_sf_entry_t *)((char *)(sfep) + XFS_ATTR_SF_ENTSIZE(sfep)))
> >  #define XFS_ATTR_SF_TOTSIZE(dp)			/* total space in use */ \
> > diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
> > index 059ac108b1b39..e86185a1165b3 100644
> > --- a/fs/xfs/libxfs/xfs_da_format.h
> > +++ b/fs/xfs/libxfs/xfs_da_format.h
> > @@ -589,7 +589,7 @@ typedef struct xfs_attr_shortform {
> >  		uint8_t namelen;	/* actual length of name (no NULL) */
> >  		uint8_t valuelen;	/* actual length of value (no NULL) */
> >  		uint8_t flags;	/* flags bits (see xfs_attr_leaf.h) */
> > -		uint8_t nameval[1];	/* name & value bytes concatenated */
> > +		uint8_t nameval[];	/* name & value bytes concatenated */
> >  	} list[1];			/* variable sized array */
> >  } xfs_attr_shortform_t;
> >  
> > -- 
> > 2.26.2
> > 
> 

-- 
Carlos

