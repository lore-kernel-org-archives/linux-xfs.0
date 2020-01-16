Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01AF8C33CB6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 06:25:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD2CD2077B
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 06:25:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="u5kIlz7d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgAPGZx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 01:25:53 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:34784 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730503AbgAPGZx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 01:25:53 -0500
Received: by mail-ot1-f65.google.com with SMTP id a15so18406483otf.1
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jan 2020 22:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0Q2Zze5PAbfGbIfzFdliXA62Y52BTomvMStI7KfWGBk=;
        b=u5kIlz7dq16rp2yrD78FB1VQ+w1Zq+JiSjBNilh5DRi9ac08AhhG0XDF9+gWsQ0qpy
         nPrmueWrxcoVKW2xQHkgjSCC/HAtaGq0F6o9mZiYIGXE2M+/oHKLChi/3SET+h2/jMge
         gdHRJFQskIPzuAAr2erbVkd1Vqf7B2Y9TpzL0K6Y09YJPlyumzeQ6+QXVQIqUZGH0KdP
         Ry+UfAL5nFVEdgiEYfWttB5EMFSnUtR7TlsE7HcXkBVw6yjtV1mebrsumkUQFFqveDNT
         BtjNugC2mm6DAp/slfvOUwzsk8q08hJISlAspgP1j4TZN69MyuzNRRaGYp0xWsEvnCkM
         XPig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0Q2Zze5PAbfGbIfzFdliXA62Y52BTomvMStI7KfWGBk=;
        b=Y+fLW/dpXjshzPOO/rxl/qhTq7EApBfXICyw6Z8gAYogUJO5ZbQSTiZj6Y1OwCcG5L
         z37iMY8Hpi0m65j+5L3nZ/q0UVyDJMOqDsi016aT5F+531HjpB6GzwDHo2lg0Y8DyXmx
         QoyCmDx91DcFA4moXhGhSd4xDqvxikvQyYip/iRRZiLf/T9kAat9fA6KBTWYU4dCjts0
         haerJfmXqb+XACGk0y/x/UAhApqlvuOIYAml0k0FzbxgJjshXrDaASpB+mgHYdFLgIFV
         GOyClM2FCdalX1hRkDY6uImpHSjkl2J5rLD3Nn4vj/meZpvszyTpCNgA4/Z38VWjue9/
         ouvA==
X-Gm-Message-State: APjAAAUA6UTC9iFgFsYlu2VYsbSvGh3gmp2EZFYOJWLqQzCC2IlTcxsW
        4etoKDYej31WgnLq0e7QYE8UELhPsthb/E4dzAVhjw==
X-Google-Smtp-Source: APXvYqwxrSywPSe+bSWTFb7guE1CCafYs03qvFymeop4ETyO8OyklXF9wh2bDlRNzFN+MYAZpycyHsRnLkWFEZhvIJE=
X-Received: by 2002:a9d:6f11:: with SMTP id n17mr838191otq.126.1579155952021;
 Wed, 15 Jan 2020 22:25:52 -0800 (PST)
MIME-Version: 1.0
References: <20200110192942.25021-1-ira.weiny@intel.com> <20200110192942.25021-2-ira.weiny@intel.com>
 <20200115113715.GB2595@quack2.suse.cz> <20200115173834.GD8247@magnolia>
 <20200115194512.GF23311@iweiny-DESK2.sc.intel.com> <CAPcyv4hwefzruFj02YHYiy8nOpHJFGLKksjiXoRUGpT3C2rDag@mail.gmail.com>
 <20200115223821.GG23311@iweiny-DESK2.sc.intel.com> <20200116053935.GB8235@magnolia>
 <CAPcyv4jDMsPj_vZwDOgPkfHLELZWqeJugKgKNVKbpiZ9th683g@mail.gmail.com> <20200116061804.GI8257@magnolia>
In-Reply-To: <20200116061804.GI8257@magnolia>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 15 Jan 2020 22:25:41 -0800
Message-ID: <CAPcyv4gy7wkxCgmDtFjiS=abcRFUY77A4mcyCbMGuheqEV755w@mail.gmail.com>
Subject: Re: [RFC PATCH V2 01/12] fs/stat: Define DAX statx attribute
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 15, 2020 at 10:18 PM Darrick J. Wong
<darrick.wong@oracle.com> wrote:
>
> On Wed, Jan 15, 2020 at 10:05:00PM -0800, Dan Williams wrote:
> > On Wed, Jan 15, 2020 at 9:39 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > [..]
> > > >         attempts to minimize software cache effects for both I/O and
> > > >         memory mappings of this file.  It requires a file system which
> > > >         has been configured to support DAX.
> > > >
> > > >         DAX generally assumes all accesses are via cpu load / store
> > > >         instructions which can minimize overhead for small accesses, but
> > > >         may adversely affect cpu utilization for large transfers.
> > > >
> > > >         File I/O is done directly to/from user-space buffers and memory
> > > >         mapped I/O may be performed with direct memory mappings that
> > > >         bypass kernel page cache.
> > > >
> > > >         While the DAX property tends to result in data being transferred
> > > >         synchronously, it does not give the same guarantees of
> > > >         synchronous I/O where data and the necessary metadata are
> > > >         transferred together.
> > >
> > > (I'm frankly not sure that synchronous I/O actually guarantees that the
> > > metadata has hit stable storage...)
> >
> > Oh? That text was motivated by the open(2) man page description of O_SYNC.
>
> Eh, that's just me being cynical about software.  Yes, the O_SYNC docs
> say that data+metadata are supposed to happen; that's good enough for
> another section in the man pages. :)
>

Ah ok, yes, "all storage is a lie".
