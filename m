Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BCB9CDB465
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Oct 2023 12:36:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbjJPMgF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Oct 2023 08:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233095AbjJPMgE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2023 08:36:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1E1AD
        for <linux-xfs@vger.kernel.org>; Mon, 16 Oct 2023 05:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697459716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fnlyZ/CR5vsw8OMZxmx5aDd65PDqqyZREj3O4xB3j3o=;
        b=LMXsnBpKppCPhpZNf9G0UU8Gsfb6fg0pn4WCt6fUajakzWszMNmeExwxNfCCLxHpdelAcX
        I/8l2Uo3Ojd0vImjZLMfZ/2gj8mC1rFAF1y7a1+JrrcvsR4nq6Rvf3SIdpmA38G/9+FdLA
        WaDNTRTqChiY8UVsYd1uUHu01N5MMso=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-37-2UtzgdIRPrKpgOkn4py6qw-1; Mon, 16 Oct 2023 08:35:15 -0400
X-MC-Unique: 2UtzgdIRPrKpgOkn4py6qw-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5218b9647a8so3337375a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 16 Oct 2023 05:35:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697459714; x=1698064514;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fnlyZ/CR5vsw8OMZxmx5aDd65PDqqyZREj3O4xB3j3o=;
        b=KfB6VHFzZjzX64DhCIMqZWVyCaQNcoB54DDO8HYKBeKay3YjQX2J0tDgtQG8CLERBR
         55f7bKuG9Z8b5e6TIwB0YUFFlMceRphLt36JDgsGD8f87DK6HxJs70yXqLNvULI2kyaN
         QmGhnLCeB52HYuJRgNgFyjeF14DcGKo1eitvaquX9xehYl4DVU3jOpGoRyzVy+jUM5ZU
         zVzqHfWgqyV8vrx/4CpdhGQoL1MpCIsH49LZTnKJzHuAPgCBhq5EhwE88Em9KQEewnzO
         SkEiL+wWA1aJ7ilSjZwbEyvYqHUZy7vfHJbDsCUrXbqP8p3rC5gdl8BngA2l6kCenWfO
         sCvQ==
X-Gm-Message-State: AOJu0YyjU+jf66LArNsOp5IlJ4+cq+zDdrigA1cUfymqJ0N7in+g0K/I
        E020E5DT67wRHL2Y24TTrlDlVsH+7ArNwiMT2X9LcDbadqhfE3JjMwz1Zgg4eA5E23H7B67yOnu
        QkYxgQI7LsJEUhNX9NLs=
X-Received: by 2002:a17:907:785:b0:9bf:ad86:ece8 with SMTP id xd5-20020a170907078500b009bfad86ece8mr3919678ejb.25.1697459714002;
        Mon, 16 Oct 2023 05:35:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHqAlWgKovauCzw+CvDXuoKXPDymeOPBUmFvlvX4u/xw/mh1KisWyrhFdlyfV1pcUFxK+1bRA==
X-Received: by 2002:a17:907:785:b0:9bf:ad86:ece8 with SMTP id xd5-20020a170907078500b009bfad86ece8mr3919659ejb.25.1697459713646;
        Mon, 16 Oct 2023 05:35:13 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id e8-20020a17090681c800b009be23a040cfsm3928853ejx.40.2023.10.16.05.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 05:35:13 -0700 (PDT)
Date:   Mon, 16 Oct 2023 14:35:12 +0200
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev, ebiggers@kernel.org, david@fromorbit.com,
        dchinner@redhat.com
Subject: Re: [PATCH v3 11/28] iomap: pass readpage operation to read path
Message-ID: <owraoh7xqk4dhf2mh4pdnh5iwh4on5asmwbpyg5nturzqnqcin@ticdzwwyj2kw>
References: <20231006184922.252188-1-aalbersh@redhat.com>
 <20231006184922.252188-12-aalbersh@redhat.com>
 <20231011183117.GN21298@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231011183117.GN21298@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2023-10-11 11:31:17, Darrick J. Wong wrote:
> On Fri, Oct 06, 2023 at 08:49:05PM +0200, Andrey Albershteyn wrote:
> > diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> > index 96dd0acbba44..3565c449f3c9 100644
> > --- a/include/linux/iomap.h
> > +++ b/include/linux/iomap.h
> > @@ -262,8 +262,25 @@ int iomap_file_buffered_write_punch_delalloc(struct inode *inode,
> >  		struct iomap *iomap, loff_t pos, loff_t length, ssize_t written,
> >  		int (*punch)(struct inode *inode, loff_t pos, loff_t length));
> >  
> > -int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops);
> > -void iomap_readahead(struct readahead_control *, const struct iomap_ops *ops);
> > +struct iomap_readpage_ops {
> > +	/*
> > +	 * Filesystems wishing to attach private information to a direct io bio
> > +	 * must provide a ->submit_io method that attaches the additional
> > +	 * information to the bio and changes the ->bi_end_io callback to a
> > +	 * custom function.  This function should, at a minimum, perform any
> > +	 * relevant post-processing of the bio and end with a call to
> > +	 * iomap_read_end_io.
> > +	 */
> > +	void (*submit_io)(const struct iomap_iter *iter, struct bio *bio,
> > +			loff_t file_offset);
> > +	struct bio_set *bio_set;
> 
> Needs a comment to mention that iomap will allocate bios from @bio_set
> if non-null; or its own internal bioset if null.

Sure.

> > +};
> 
> It's odd that this patch adds this ops structure but doesn't actually
> start using it until the next patch.

I wanted to separate iomap changes with xfs changes so it's easier
to go through, but I fine with merging these two.

-- 
- Andrey

