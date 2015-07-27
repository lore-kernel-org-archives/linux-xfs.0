Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C4CAE7FA1
	for <xfs@oss.sgi.com>; Mon, 27 Jul 2015 11:46:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2A65CAC005
	for <xfs@oss.sgi.com>; Mon, 27 Jul 2015 09:46:38 -0700 (PDT)
Received: from mx5-phx2.redhat.com (mx5-phx2.redhat.com [209.132.183.37]) by
	cuda.sgi.com with ESMTP id r8Lo0WBmZVyqGECg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 27 Jul 2015 09:46:35 -0700 (PDT)
Date: Mon, 27 Jul 2015 12:45:46 -0400 (EDT)
From: Jan Tulak <jtulak@redhat.com>
Message-ID: <1102937653.582757.1438015546541.JavaMail.zimbra@redhat.com>
In-Reply-To: <20150726163438.GD16659@infradead.org>
References: <1437397018-12864-1-git-send-email-jtulak@redhat.com>
	<1437397018-12864-5-git-send-email-jtulak@redhat.com>
	<20150726163438.GD16659@infradead.org>
Subject: Re: [PATCH v2 4/4] xfsprogs: OS X partial support
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com



----- Original Message -----
> From: "Christoph Hellwig" <hch@infradead.org>
> To: "Jan Tulak" <jtulak@redhat.com>
> Cc: xfs@oss.sgi.com
> Sent: Sunday, July 26, 2015 6:34:38 PM
> Subject: Re: [PATCH v2 4/4] xfsprogs: OS X partial support
> 
> I think this needs to be split into one patch per issue.  A few comments
> below:

Sure, I guess it is a good idea.

> 
> > -#include <malloc.h>
> 
> 
> malloc and friends need to be in stdlib.h per Posix, so the right
> fix is to drop every include of malloc.h and mae sure we include
> stdlib.h where needed.
> 

stdlib.h contains posix_memalign(), but the code is using memalign(). 
So should I prefix the calls?

Regarding the autoconf related issues, I'm looking on it, though it
can take me some time. I can't say I love the way autoconf is done... :)

[ snip autoconf related issues ]

> 
> > diff --git a/libxcmd/paths.c b/libxcmd/paths.c
> > index c0b1ddb..b360617 100644
> > --- a/libxcmd/paths.c
> > +++ b/libxcmd/paths.c
> > @@ -364,7 +364,7 @@ fs_table_initialise_mounts(
> >  			continue;
> >  		if (!realpath(stats[i].f_mntfromname, rmntfromname))
> >  			continue;
> > -		if (!realpath(stats[i].f_mntonname, rmnttomname)))
> > +		if (!realpath(stats[i].f_mntonname, rmntonname))
> 
> I don't understand this change.

Typo fix, which wasn't catched earlier due to #ifdef branching.
The 'rmnttomname' does not exists anywhere and looks like a hybrid
between rmntfromname and rmntonname. And because the previous if has
has 'fromname' on both arguments of realpath, I choose the same approach
when fixing it.

I'm making it a standalone patch too, though.

Cheers,
Jan
-- 
Jan Tulak
jtulak@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
