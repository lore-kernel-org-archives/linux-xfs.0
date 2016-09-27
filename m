Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0D1757CA1
	for <xfs@oss.sgi.com>; Mon, 26 Sep 2016 23:14:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 84DDDAC002
	for <xfs@oss.sgi.com>; Mon, 26 Sep 2016 21:14:25 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id ZhxhGSUPATy0JyYK (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 26 Sep 2016 21:14:20 -0700 (PDT)
Date: Tue, 27 Sep 2016 05:14:14 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 04/12] splice: lift pipe_lock out of splice_to_pipe()
Message-ID: <20160927041414.GK19539@ZenIV.linux.org.uk>
References: <20160914042559.GC2356@ZenIV.linux.org.uk>
	<20160917082007.GA6489@ZenIV.linux.org.uk>
	<20160917190023.GA8039@ZenIV.linux.org.uk>
	<20160923190032.GA25771@ZenIV.linux.org.uk>
	<20160923190326.GB2356@ZenIV.linux.org.uk>
	<CA+55aFxzPH2AYvDVWSAomO6bN_sW4+qDv87Xbq8XHMyvBEYe+w@mail.gmail.com>
	<20160923201025.GJ2356@ZenIV.linux.org.uk>
	<CA+55aFyr-X_6FcWkSXBUcxV0p1BUZw8d=46wawv2x+8y7f8YcQ@mail.gmail.com>
	<20160924035951.GN2356@ZenIV.linux.org.uk>
	<CAELBmZCBo49dvi5mPK2NAYnSz0tv=kktTvcygW44e2hRJNpGkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAELBmZCBo49dvi5mPK2NAYnSz0tv=kktTvcygW44e2hRJNpGkQ@mail.gmail.com>
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
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, CAI Qian <caiqian@redhat.com>, Nick Piggin <npiggin@gmail.com>, xfs@oss.sgi.com, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>

On Mon, Sep 26, 2016 at 03:35:12PM +0200, Miklos Szeredi wrote:
> > -       if (spd.nr_pages <= 0)
> > -               ret = spd.nr_pages;
> > -       else
> > -               ret = splice_to_pipe(pipe, &spd);
> > -
> > +       pipe_lock(pipe);
> > +       ret = wait_for_space(pipe, flags);
> > +       if (!ret) {
> > +               spd.nr_pages = get_iovec_page_array(&from, spd.pages,
> > +                                                   spd.partial,
> > +                                                   spd.nr_pages_max);
> > +               if (spd.nr_pages <= 0)
> > +                       ret = spd.nr_pages;
> > +               else
> > +                       ret = splice_to_pipe(pipe, &spd);
> > +               pipe_unlock(pipe);
		    ^^^^^^^^^^^^^^^^
> > +               if (ret > 0)
> > +                       wakeup_pipe_readers(pipe);
> > +       }
> 
> Unbalanced pipe_lock()?

Reordering braindamage; fixed.

> Also, while it doesn't hurt, the constification of the "from" argument
> of get_iovec_page_array() looks only noise in this patch.

Rudiment of earlier variant, when we did a non-trivial loop in the caller.
Not needed anymore, removed.

Fixed variant force-pushed to the same branch

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
