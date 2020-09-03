Return-Path: <SRS0=br+O=CM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45E6BC433E9
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 10:36:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F417F20767
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 10:36:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JIDIk+6u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgICKgq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Sep 2020 06:36:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46440 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725984AbgICKgp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Sep 2020 06:36:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599129403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dXzWxiSexDzQ+wXkiUJzhPSd2ps6tlya2pSHapdNsnU=;
        b=JIDIk+6ubgrQcM/LnPPGbpqEYoAiNIrt5WFyVeRCtSmKOrqL/SadtH7v+74u6QMvCmx+Xv
        edkKum1zrxexm8MPwq968OSnjOSS+IvE6JdPS9AOCec9GPd2H8pItChnB/olotVeKdgJfW
        Zn3gx+yg465ommUKvacOQuUNT5jjJ0M=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-7fwaiZAPPwyyfos9av6mdQ-1; Thu, 03 Sep 2020 06:36:41 -0400
X-MC-Unique: 7fwaiZAPPwyyfos9av6mdQ-1
Received: by mail-wr1-f72.google.com with SMTP id v12so921662wrm.9
        for <linux-xfs@vger.kernel.org>; Thu, 03 Sep 2020 03:36:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=dXzWxiSexDzQ+wXkiUJzhPSd2ps6tlya2pSHapdNsnU=;
        b=njwebF1oLtm1XgtLnmr1VPPoCoSXCjMPWBkPZwaoT/o26DVIB2BtjYq/5RMmYMR2Xo
         01zzGWTJ4zg0lzgvuShhJ7D90XgUJa5R+Qm533O4gX0iqoHWpySEqYg4pBhPtNQUJ8R+
         5NMdTA9OfPJbXQlLQeVi3Sey4z4QsECXDrwOaYFiVcGUauyULGJ8AvB1nIEO2EQ9CRAx
         V1DjnYU0OBWtvzG1TW2j87XeusCpucLsz+nTqPjl5bqxxANKNIOqwp9iZ8rjeUc7an9D
         +sFn4vFTpb8FGJh4xaaU0lkjC+sI8HF/kSgC32i67C6+dNc3uxeh1iSV7n04Q1J6vJy2
         ly4w==
X-Gm-Message-State: AOAM532EdFUj14NVkOP429Y5XWiGIXFJ9w+NFd7s67SLlK7ddpN8bGpU
        ECGLg4e0cQiraXekV9VwN35Gx5c++bsSoXK80hbL/W8qQvF4zzyMjZSGTIPna3y8ZrzTuW8zr+O
        grJk7pKjPK9+gjcpYx0gs
X-Received: by 2002:a5d:4fcc:: with SMTP id h12mr1727139wrw.199.1599129400619;
        Thu, 03 Sep 2020 03:36:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzgusBvZ0lc/LKPAisl8A8nT0HfQM/TN7DGYqw78AvkEIax1r0CD4xXR9kd4ihVxZdkn8JnbQ==
X-Received: by 2002:a5d:4fcc:: with SMTP id h12mr1727121wrw.199.1599129400409;
        Thu, 03 Sep 2020 03:36:40 -0700 (PDT)
Received: from eorzea (ip-89-102-9-109.net.upcbroadband.cz. [89.102.9.109])
        by smtp.gmail.com with ESMTPSA id f17sm3928404wru.13.2020.09.03.03.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 03:36:39 -0700 (PDT)
Date:   Thu, 3 Sep 2020 12:36:37 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 4/4] xfs: Convert xfs_attr_sf macros to inline
 functions
Message-ID: <20200903103637.ngs3vhx7oodpry3u@eorzea>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
References: <20200902144059.284726-1-cmaiolino@redhat.com>
 <20200902144059.284726-5-cmaiolino@redhat.com>
 <20200902175457.GX6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902175457.GX6096@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> 
> /me suspects you could (ab)use struct_size here too, e.g.
> 
> 	return struct_size((struct xfs_attr_sf_entry *)NULL, nameval,
> 			nlen + vlen);
> 
> Though now I look at the casting mess and think NAH.
> Ok never mind. :)

I think this could work, yes, but it just makes the inline function hard to read
with no real gain IMHO.

> 
> The patch looks ok, modulo that spacing thing from above.

Fixing. Thanks for the review :)

> 
> --D
> 
> > +}
> > +
> > +/* space an entry uses */
> > +static inline int xfs_attr_sf_entsize(struct xfs_attr_sf_entry *sfep) {
> > +	return struct_size(sfep, nameval, sfep->namelen + sfep->valuelen);
> > +}
> > +
> > +/* next entry in struct */
> > +static inline struct xfs_attr_sf_entry *
> > +xfs_attr_sf_nextentry(struct xfs_attr_sf_entry *sfep) {
> > +	return (struct xfs_attr_sf_entry *)((char *)(sfep) +
> > +					    xfs_attr_sf_entsize(sfep));
> > +}
> >  
> >  #endif	/* __XFS_ATTR_SF_H__ */
> > diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> > index 4eb1d6faecfb2..8f8837fe21cf0 100644
> > --- a/fs/xfs/xfs_attr_list.c
> > +++ b/fs/xfs/xfs_attr_list.c
> > @@ -96,7 +96,7 @@ xfs_attr_shortform_list(
> >  			 */
> >  			if (context->seen_enough)
> >  				break;
> > -			sfe = XFS_ATTR_SF_NEXTENTRY(sfe);
> > +			sfe = xfs_attr_sf_nextentry(sfe);
> >  		}
> >  		trace_xfs_attr_list_sf_all(context);
> >  		return 0;
> > @@ -136,7 +136,7 @@ xfs_attr_shortform_list(
> >  		/* These are bytes, and both on-disk, don't endian-flip */
> >  		sbp->valuelen = sfe->valuelen;
> >  		sbp->flags = sfe->flags;
> > -		sfe = XFS_ATTR_SF_NEXTENTRY(sfe);
> > +		sfe = xfs_attr_sf_nextentry(sfe);
> >  		sbp++;
> >  		nsbuf++;
> >  	}
> > -- 
> > 2.26.2
> > 
> 

-- 
Carlos

