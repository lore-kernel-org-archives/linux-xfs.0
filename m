Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53864 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751616AbeAJHAl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Jan 2018 02:00:41 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8D2AB25BBC
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2018 07:00:41 +0000 (UTC)
Date: Wed, 10 Jan 2018 15:00:37 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] db/print: bad character cause illegal memory access
Message-ID: <20180110070037.GO4684@dhcp12-143.nay.redhat.com>
References: <20180109062027.4570-1-zlang@redhat.com>
 <20180109155536.GA888@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180109155536.GA888@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 09, 2018 at 10:55:37AM -0500, Brian Foster wrote:
> On Tue, Jan 09, 2018 at 02:20:27PM +0800, Zorro Lang wrote:
> > xfs_db can print specified field values, likes:
> >   # xfs_db -c "inode $inum" -c "print core.nblocks" $dev
> > 
> > But when we give it some bad chararcters, the 'print' command will
> > crash:
> > 
> >   # xfs_db -r -c "inode 67211167" -c "print core.*" /dev/mapper/rhel-root
> >   bad character in field *
> >   *** Error in `xfs_db': free(): invalid pointer: 0x00007fa116e937b8 ***
> >   ...
> >   (crash messages)
> >   ...
> >   # xfs_db -r -c "inode 67211167" -c "print core.\"" /dev/mapper/rhel-root
> >   missing closing quote
> >   *** Error in `xfs_db': free(): invalid pointer: 0x00007f6e8e3c37b8 ***
> >   ...
> >   (crash messages)
> >   ...
> > 
> > The reason is xfs_db call ftok_free() to free ftok_t list, but
> > flist_split() forgets to set the tail to NULL. That cause ftok_free()
> > trys to free illegal memory address.
> > 
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > ---
> >  db/flist.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/db/flist.c b/db/flist.c
> > index e11acbfc..1a875b95 100644
> > --- a/db/flist.c
> > +++ b/db/flist.c
> > @@ -371,11 +371,14 @@ flist_split(
> >  	v = xmalloc(sizeof(*v));
> >  	v->tok = NULL;
> >  	while (*s) {
> > +		v = xrealloc(v, (nv + 1) * sizeof(*v));
> >  		/* need to add string handling */
> >  		if (*s == '\"') {
> >  			s++; /* skip first quote */
> >  			if ((a = strrchr(s, '\"')) == NULL) {
> >  				dbprintf(_("missing closing quote %s\n"), s);
> > +				v[nv].tok = NULL;
> > +				v[nv].tokty = TT_END;
> >  				ftok_free(v);
> >  				return NULL;
> >  			}
> > @@ -393,19 +396,21 @@ flist_split(
> >  			t = puncttypes[a - punctchars];
> >  		} else {
> >  			dbprintf(_("bad character in field %s\n"), s);
> > +			v[nv].tok = NULL;
> > +			v[nv].tokty = TT_END;
> >  			ftok_free(v);
> >  			return NULL;
> >  		}
> >  		a = xmalloc(l + 1);
> >  		strncpy(a, s, l);
> >  		a[l] = '\0';
> > -		v = xrealloc(v, (nv + 2) * sizeof(*v));
> >  		v[nv].tok = a;
> >  		v[nv].tokty = t;
> >  		nv++;
> >  		s += l + tailskip;
> >  		tailskip = 0;
> >  	}
> > +	v = xrealloc(v, (nv + 1) * sizeof(*v));
> >  	v[nv].tok = NULL;
> 
> Could we just move the above line into the loop (right after nv is
> bumped) to initialize .tok similar to the initial allocation before the
> loop?

Thanks for you review, Brian. I found djwong@ has fixed this bug on xfsprogs
for-next branch by:

commit 945e47e2fcc5d1cec693122286da06d8ab829c52
Author: Darrick J. Wong <darrick.wong@oracle.com>
Date:   Thu Jan 4 13:58:29 2018 -0600

    xfs_db: fix crash when field list selector string has trailing slash


Thanks for you help,
Zorro

> 
> Brian
> 
> >  	v[nv].tokty = TT_END;
> >  	return v;
> > -- 
> > 2.13.6
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
