Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ECFCC43461
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 11:44:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F27F0613CC
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 11:44:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239587AbhDFLoi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Apr 2021 07:44:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58111 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245734AbhDFLoQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Apr 2021 07:44:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617709448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eVhU9aiJGijrkAVoBK3bb6soVHRR64FmtmF1IdoMZBc=;
        b=BNqfds0QY0LLfYd5sDTdlZfTs9ugQw6JYbWnOxRLNCowlZiFQ/UkaInEQ5kbQOI/C8b4sZ
        eEEbBeGEErud1XlZV7eOlO0rxNDjnQ1i9TrOoF2iwv7ULLPpFv0F76wYw+ay3t+peiW7im
        Ip4yv0K/m55kDns5syHhJnYhcB9JU8Y=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-8y7wNMIEP16ooo18phjd1g-1; Tue, 06 Apr 2021 07:44:06 -0400
X-MC-Unique: 8y7wNMIEP16ooo18phjd1g-1
Received: by mail-ej1-f70.google.com with SMTP id d6so5321458ejd.15
        for <linux-xfs@vger.kernel.org>; Tue, 06 Apr 2021 04:44:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=eVhU9aiJGijrkAVoBK3bb6soVHRR64FmtmF1IdoMZBc=;
        b=ZXlocXwA1v5KLUT7ZK+Z8u/9K8Oq7CwzG1SqscU9GF6NldmyPpNBe1SGaBjP3OUrne
         yLps22gWCa4IT5V9pUm4eYWlsoJH37yLiBHFDIV5iInGzqoSL4ygiHqVPTAkoNfRcNhw
         dXFQEk5IFDW/y8XBgDEQwJ+ncGDVj79w7cX6gBg86bUwoMvxCPkdsQ9cAvv8O+JBQy/2
         Q7bV6pPQ5uViQCgceLJ00FQ+IscVcg8RvmW3y5DeKT0PYFaYguE/FpdkNR6fSbV6lVnR
         8a3QVsJgAs+r4tAYGNs7vcS6fCWNsRdnOk+TbajGOv0IhkDOhqsHEzutfrMwWk7CID8y
         5hGA==
X-Gm-Message-State: AOAM5312GTtEOYTCViJa6XTRZWaWnSuTe7T3aFviXakgunzjtnwGfw6s
        4bHvsEwi3bpJGNOLXmVfwMCFBKyqyPzsaEhw6HDojmkqH5FqPvR0Kb4YGV1M6O8VejzmNiIabp5
        XydZz6uQtvrR5GINjzjFz
X-Received: by 2002:a50:d5d9:: with SMTP id g25mr17004956edj.47.1617709445349;
        Tue, 06 Apr 2021 04:44:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw+0CqG+yk2C3IqzQrMgNa44X8ltdMWGNbNxU/zszB3PLyh1N0EwskleFhtWWQQRqPeOcxVjQ==
X-Received: by 2002:a50:d5d9:: with SMTP id g25mr17004943edj.47.1617709445154;
        Tue, 06 Apr 2021 04:44:05 -0700 (PDT)
Received: from andromeda.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id g11sm13816862edt.35.2021.04.06.04.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 04:44:04 -0700 (PDT)
Date:   Tue, 6 Apr 2021 13:44:02 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] Add dax mount option to man xfs(5)
Message-ID: <20210406114402.yif2onaailmwkfmo@andromeda.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org
References: <20210315150250.11870-1-cmaiolino@redhat.com>
 <20210401153333.GD4090233@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401153333.GD4090233@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 01, 2021 at 08:33:33AM -0700, Darrick J. Wong wrote:
> On Mon, Mar 15, 2021 at 04:02:50PM +0100, Carlos Maiolino wrote:
> > Details are already in kernel's documentation, but make dax mount option
> > information accessible through xfs(5) manpage.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  man/man5/xfs.5 | 18 ++++++++++++++++++
> >  1 file changed, 18 insertions(+)
> > 
> > diff --git a/man/man5/xfs.5 b/man/man5/xfs.5
> > index 7642662f..46b0558a 100644
> > --- a/man/man5/xfs.5
> > +++ b/man/man5/xfs.5
> > @@ -133,6 +133,24 @@ by the filesystem.
> >  CRC enabled filesystems always use the attr2 format, and so
> >  will reject the noattr2 mount option if it is set.
> >  .TP
> > +.BR dax=value
> > +Set DAX behavior for the current filesystem. This mount option accepts the
> 
> It might be worth defining what DAX (the acronym) is...
> 
> "Set CPU direct access (DAX) behavior for regular files in the
> filesystem."
> 
> > +following values:
> > +
> > +"dax=inode" DAX will be enabled only on files with FS_XFLAG_DAX applied.
> 
> "...enabled on regular files..."
> 
> > +
> > +"dax=never" DAX will be disabled by the whole filesystem including files with
> > +FS_XFLAG_DAX applied"
> 
> "DAX will not be enabled for any files.  FS_XFLAG_DAX will be ignored."
> 
> > +
> > +"dax=always" DAX will be enabled to every file in the filesystem inclduing files
> 
> "DAX will be enabled for all regular files, regardless of the
> FS_XFLAG_DAX state."
> 
> > +without FS_XFLAG_DAX applied"
> > +
> > +If no option is used when mounting a pmem device, dax=inode will be used as
> 
> "If no option is used when mounting a filesystem stored on a device
> capable of DAX access modes, dax=inode...."
> 
> (DAX is a possibility with more than just persistent memory now...)
> 

Thanks for the review Darrick. All the changes make sense to me, I'll apply them
and send a V2.

Cheers.

-- 
Carlos

