Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56646 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754672AbdFWK1D (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Jun 2017 06:27:03 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 98BC130AF66
        for <linux-xfs@vger.kernel.org>; Fri, 23 Jun 2017 10:27:02 +0000 (UTC)
Date: Fri, 23 Jun 2017 05:26:58 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH v2] xfs_db: update sector size when type is set
Message-ID: <20170623102658.GA31188@redhat.com>
References: <20170622193352.22346-1-billodo@redhat.com>
 <20170622234535.30942-1-billodo@redhat.com>
 <20170623101602.6cmzx4os45nktgzj@eorzea.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170623101602.6cmzx4os45nktgzj@eorzea.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: cmaiolino@redhat.com

On Fri, Jun 23, 2017 at 12:16:02PM +0200, Carlos Maiolino wrote:
> Hey Bill,
> 
> > diff --git a/db/io.c b/db/io.c
> > index 9918a51..792cc0a 100644
> > --- a/db/io.c
> > +++ b/db/io.c
> > @@ -615,7 +615,13 @@ set_iocur_type(
> >  	const typ_t	*t)
> >  {
> >  	struct xfs_buf	*bp = iocur_top->bp;
> > +	int bb_count;
> >  
> > +	/* adjust cursor for types that contain fields */
> > +	if (t->fields) {
> > +		bb_count = BTOBB(byteize(fsize(t->fields, iocur_top->data, 0, 0)));
> 
> Doesn't byteize() requires:
> 
> #include "bit.h"
> 
> ?

Gah! Yes it's required. I had it on my test box, but missed it
in my v2 submit. I'll fix it.

Thanks!
Bill


> 
> I can't build xfsprogs with this patch without including bit.h
> 
> In file included from ../include/xfs.h:68:0,
>                  from ../include/libxfs.h:24,
>                  from io.c:19:
> io.c: In function ‘set_iocur_type’:
> io.c:600:20: warning: implicit declaration of function ‘byteize’
> [-Wimplicit-function-declaration]
>    bb_count = BTOBB(byteize(fsize(t->fields, iocur_top->data, 0, 0)));
>                     ^
> 
> 
> Although, after including it, the patch works fine, fixes the problem with
> different sector sizes.
> 
> After fixing the include above, you can add:
> 
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> 
> Cheers
> 
> 
> > +		set_cur(t, iocur_top->bb, bb_count, DB_RING_IGN, NULL);
> > +	}
> >  	iocur_top->typ = t;
> >  
> >  	/* verify the buffer if the type has one. */
> > -- 
> > 2.9.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> Carlos
