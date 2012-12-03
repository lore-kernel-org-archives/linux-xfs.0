Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3E1b2f201555 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 08:01:37 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id n7P0TSwX4m1qsgGB for
	<xfs@oss.sgi.com>; Mon, 03 Dec 2012 06:03:59 -0800 (PST)
Date: Mon, 3 Dec 2012 12:03:44 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfstests: fsck scratch device if it got used
Message-ID: <20121203140344.GA3546@andromeda.usersys.redhat.com>
References: <50B7B0AB.6040406@redhat.com> <20121130160616.GD5667@infradead.org>
	<50B8DA0E.4000605@redhat.com> <20121130222750.GC12955@dastard>
	<50B9335B.3000105@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50B9335B.3000105@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

> >>> This one looks good.
> >>
> >> Hm now that I think of it perhaps I should remove the explicit
> >> _check_scratch-es if they happen at the end of the run, just to
> >> try to speed things up.
> > 
> > *nod*
> 
> I'll send as another patch; I don't think there are really very
> many TBH.
> 
> >>>> Also recreate lost+found/ in one test so that e2fsck doesn't
> >>>> complain.
> >>>
> >>> This one I can't make any sense of.  Care to send it separately
> >>> with a good explanation?
> >>>
> >>
> >> Ok, sure.
> >>
> >> Basically, test does an rm -rf of the scrach mnt, but e2fsck
> >> thinks that a missing lost+found/ is cause for complaint and a
> >> failure exit code, which then stops the tests :(
> > 
> > Shouldn't e2fsck be fixed? i.e. if you have a corrupted filesystem
> > and it's missing lost+found, how are you expected to create it? by
> > mounting your corrupted filesystem and modifying it and potentially
> > making the corruption worse?
> 
> No, e2fsck fixes it, but reports that as an exit error condition
> even if nothing else is found.
> 

I know lots of users who use to just delete lost+found directory, so making the
lack of l+f an error is wrong.
IMHO, there is no reason to report an error when a l+f is not found, unless you
need to recover orphan'ed inodes, I've never seen any other usage for it, unless
during FS recovery time. (maybe I lack some knowledge of another usages for
lost+found directory?)

So, I believe that might be useful to print a warning about it, but consider it
as an error is wrong IMHO.

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
