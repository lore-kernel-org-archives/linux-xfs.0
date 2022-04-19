Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C003C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Apr 2022 17:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355693AbiDSRGE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Apr 2022 13:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355538AbiDSRF2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Apr 2022 13:05:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 662AF4704A
        for <linux-xfs@vger.kernel.org>; Tue, 19 Apr 2022 09:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650387365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qWg8tAHOYckYnfLrTKiESl8dWoV4SRJNOSGDwagA6Ok=;
        b=IU8/C9+/c55R4wFpalbBZ2HQXwcxEFigny2HA9LPn/0vFDmoOxg6PRW5iZTWk5QiLyt56O
        6+nx3hViqMHBerof4kHEJDM7w4j4FDz20megacyVoYfhR9ZYfNU1kiZGZuLqdNkFLUB10h
        Tl0ce5WXgTd2gRN4mrZCpKkcpSuVcbo=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-wE-MiUM8ON2fh2QdWAhGew-1; Tue, 19 Apr 2022 12:56:04 -0400
X-MC-Unique: wE-MiUM8ON2fh2QdWAhGew-1
Received: by mail-ej1-f72.google.com with SMTP id oz37-20020a1709077da500b006e88d00043dso6273644ejc.15
        for <linux-xfs@vger.kernel.org>; Tue, 19 Apr 2022 09:56:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qWg8tAHOYckYnfLrTKiESl8dWoV4SRJNOSGDwagA6Ok=;
        b=MCNUCgeZCoDcCO1eWETsPCxjJwEGWfYtxTXUPjP4TS4Mnz9a1uxSxgiwKV1zgQlr38
         XapJ+UFgf6ncG79xASQrN4Y8VJuHh3v1YOzRS97UgXt9mR5KfaN+/ciEfqbKbafpVzM4
         v1ICRAs8s7OQKfTVcRLBgT4JRS+Y3W+EmUpzsQVf3pzDbmO7RjHBLsUb0YXCriNXHPaY
         xqinrVB5Cz2Jw4IWPzV6ExmkLucOaHd1do9fuLXm853kOjidfWF9i1TfT2tnnZEodtpi
         vqHTcVNSWcl1JAxNP6D9S1YVNKxmpP/Aypp2qnxmQUMbrC5V0Cu9JPOTBBGiEQCDMpLw
         OehA==
X-Gm-Message-State: AOAM533xPZuDS73ImUsc8ZfF4UJLa4JEFGfBVxg9srKo7SFzEnvKLh7z
        OSDfVpM9gEyBDkna8y2HjbIcNwDa1LHpdO7v5DhaPnauPJpfpfBg4h02rJsYMZ3KZazRQ+mPL4Z
        SVRPyCMDazfbq7mYtgEw=
X-Received: by 2002:a05:6402:448a:b0:41d:793d:8252 with SMTP id er10-20020a056402448a00b0041d793d8252mr18137310edb.6.1650387362528;
        Tue, 19 Apr 2022 09:56:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzDx+dXqOw357d9UFa3Myaj4WqYq/bS6D+lvHsWVBIy6zdFIcE7frfEBBEv4l/0hhMqKB5Wkg==
X-Received: by 2002:a05:6402:448a:b0:41d:793d:8252 with SMTP id er10-20020a056402448a00b0041d793d8252mr18137290edb.6.1650387362192;
        Tue, 19 Apr 2022 09:56:02 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id g1-20020a170906348100b006efc26c7b1dsm1786473ejb.195.2022.04.19.09.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 09:56:01 -0700 (PDT)
Date:   Tue, 19 Apr 2022 18:56:00 +0200
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_db: take BB cluster offset into account when using
 'type' cmd
Message-ID: <Yl7poFqm7X9+M3Up@aalbersh.remote.csb>
References: <20220419121951.50412-1-aalbersh@redhat.com>
 <20220419154750.GI17025@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419154750.GI17025@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 19, 2022 at 08:47:50AM -0700, Darrick J. Wong wrote:
> On Tue, Apr 19, 2022 at 02:19:51PM +0200, Andrey Albershteyn wrote:
> > Changing the interpretation type of data under the cursor moves the
> > cursor to the beginning of BB cluster. When cursor is set to an
> > inode the cursor is offset in BB buffer. However, this offset is not
> > considered when type of the data is changed - the cursor points to
> > the beginning of BB buffer. For example:
> > 
> > $ xfs_db -c "inode 131" -c "daddr" -c "type text" \
> > 	-c "daddr" /dev/sdb1
> > current daddr is 131
> > current daddr is 128
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > ---
> >  db/io.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/db/io.c b/db/io.c
> > index df97ed91..107f2e11 100644
> > --- a/db/io.c
> > +++ b/db/io.c
> > @@ -589,6 +589,7 @@ set_iocur_type(
> >  	const typ_t	*type)
> >  {
> >  	int		bb_count = 1;	/* type's size in basic blocks */
> > +	int boff = iocur_top->boff;
> 
> Nit: Please line up the variable names.

sure ;)

> 
> >  
> >  	/*
> >  	 * Inodes are special; verifier checks all inodes in the chunk, the
> > @@ -613,6 +614,9 @@ set_iocur_type(
> >  		bb_count = BTOBB(byteize(fsize(type->fields,
> >  				       iocur_top->data, 0, 0)));
> >  	set_cur(type, iocur_top->bb, bb_count, DB_RING_IGN, NULL);
> > +	iocur_top->boff = boff;
> > +	iocur_top->off = ((xfs_off_t)iocur_top->bb << BBSHIFT) + boff;
> > +	iocur_top->data = (void *)((char *)iocur_top->buf + boff);
> 
> It seems reasonable to me to preserve the io cursor's boff when we're
> setting /only/ the buffer type, but this function and off_cur() could
> share these three lines of code that (re)set boff/off/data.
> 
> Alternately, I guess you could just call off_cur(boff, BBTOB(bb_count))
> here.

This won't pass the second condition in off_cur(). I suppose the
purpose of off_cur() was to shift io cursor in BB buffer. But
changing the type changes the blen which could be smaller (e.g.
inode blen == 32 -> text blen == 1). Anyway, will try to come up
with a meaningful name for this 3 lines function :)

I think the other solution could be to set boff in set_cur(), but
this will require more refactoring and I suppose this is the only
place where newly added argument would be used.

> 
> --D
> 
> >  }
> >  
> >  static void
> > -- 
> > 2.27.0
> > 
> 

-- 
- Andrey

