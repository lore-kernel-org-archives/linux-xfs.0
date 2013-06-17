Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6A54B7F37
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 06:19:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0094AAC004
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 04:19:43 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Xx0o3gYeF4i5f1GV for <xfs@oss.sgi.com>;
	Mon, 17 Jun 2013 04:19:42 -0700 (PDT)
Date: Mon, 17 Jun 2013 21:19:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: definitions for /proc/fs/xfs/stat
Message-ID: <20130617111940.GM29338@dastard>
References: <CAC2B=ZFP_Fg34aFpk857stgB7MGcrYs9tybRS-ttw1CXNeU41Q@mail.gmail.com>
	<20130615020414.GB29338@dastard>
	<CAC2B=ZEUkd+ADnQLUKj9S-3rdo2=93WbW0tbLbwwHUvkh6v7Rw@mail.gmail.com>
	<CAC2B=ZGgr5WPWOEehHDHKekM8yHgQ3QS4HMzM8+j217AfEoPyQ@mail.gmail.com>
	<20130616001130.GE29338@dastard>
	<CAC2B=ZFZskLnp5baVJK+R1xrpOfTkr1QXpA9jyHvxfk5Wd4yDg@mail.gmail.com>
	<419435719.1662203.1371431489790.JavaMail.root@redhat.com>
	<20130617024603.GJ29338@dastard>
	<1597962722.1767244.1371447710942.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1597962722.1767244.1371447710942.JavaMail.root@redhat.com>
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
To: Nathan Scott <nathans@redhat.com>
Cc: Mark Seger <mjseger@gmail.com>, xfs@oss.sgi.com

On Mon, Jun 17, 2013 at 01:41:50AM -0400, Nathan Scott wrote:
> Hey Dave,
> 
> ----- Original Message -----
> > ...
> > Must be an old version of RHEL6, because 6.4 doesn't do any IO at
> > all, same as upstream. This test workload is purely a metadata only
> > workload (no data is written) and so it all gets gathered up by
> > delayed logging.
> 
> *nod* - RHEL6.3.
> 
> > > I think it is still possible, FWIW.  One could use python ctypes (as in
> > > Marks test program) and achieve a page-aligned POSIX memalign,
> > 
> > I wasn't aware you could get memalign() through python at all. I
> > went looking for this exact solution a couple of month ago when
> > these problems started to be reported and couldn't find anything
> > ...
> 
> Yes, on reflection it doesn't jive too well with the way python wants
> to do reads, in particular - os.read takes a file and a size, there's
> no buffer exposed at the API level (for input).
> 
> It would need to be a separate python module to the core set I guess
> (with a C component), and a slightly different API - or at least some
> additional APIs which can take in an aligned buffer, rather than just
> allocating one each time - but I believe it's still feasible.

Oh, there were modules written to do this years ago. e.g this from
2006:

https://pypi.python.org/pypi/directio/1.0

There were even patches to provide a native interface in 2004, but
they got shot down, like all the future enhancement requests that
have happened since, mainly because the python maintainers don't
beleive that Direct IO is necessary.

I mean, Linus said Direct IO is for deranged monkeys, so nobody
should ever use direct IO, right? ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
