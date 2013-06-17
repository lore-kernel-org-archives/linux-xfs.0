Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 38C7B7F37
	for <xfs@oss.sgi.com>; Sun, 16 Jun 2013 21:46:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AE8E0AC001
	for <xfs@oss.sgi.com>; Sun, 16 Jun 2013 19:46:13 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	AvJmNyRJKjsHnhG7 for <xfs@oss.sgi.com>;
	Sun, 16 Jun 2013 19:46:08 -0700 (PDT)
Date: Mon, 17 Jun 2013 12:46:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: definitions for /proc/fs/xfs/stat
Message-ID: <20130617024603.GJ29338@dastard>
References: <CAC2B=ZFP_Fg34aFpk857stgB7MGcrYs9tybRS-ttw1CXNeU41Q@mail.gmail.com>
	<504625587.1365681.1371255450937.JavaMail.root@redhat.com>
	<CAC2B=ZF+eMyNLPQmhA_onDPEUqgNfcgCdZVvobNH9pofvioN7Q@mail.gmail.com>
	<20130615020414.GB29338@dastard>
	<CAC2B=ZEUkd+ADnQLUKj9S-3rdo2=93WbW0tbLbwwHUvkh6v7Rw@mail.gmail.com>
	<CAC2B=ZGgr5WPWOEehHDHKekM8yHgQ3QS4HMzM8+j217AfEoPyQ@mail.gmail.com>
	<20130616001130.GE29338@dastard>
	<CAC2B=ZFZskLnp5baVJK+R1xrpOfTkr1QXpA9jyHvxfk5Wd4yDg@mail.gmail.com>
	<419435719.1662203.1371431489790.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <419435719.1662203.1371431489790.JavaMail.root@redhat.com>
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

On Sun, Jun 16, 2013 at 09:11:29PM -0400, Nathan Scott wrote:
> Hey guys,
> 
> ----- Original Message -----
> > ok, I have a simple reproducer.  try out the following, noting you'll
> > obviously have to change the directory pointed to by dname:
> > 
> > libc=ctypes.CDLL(ctypes.util.find_library('c'), use_errno=True)
> > falloc=getattr(libc, 'fallocate')
> > 
> 
> This is using the glibc fallocate wrapper - I have vague memories of an
> old libc which used to do per-page buffered writes providing a poor-mans
> implementation of fallocate, maybe somehow that older version/behaviour
> is being triggered.
> 
> Running the test case on a RHEL6 box here, you should see patterns like
> the attached ("pmchart -c XFSLog" - config attached too), which suggest
> log traffic dominates (though I have no stripe-fu setup like you, Mark,
> which adds another wrinkle).

Must be an old version of RHEL6, because 6.4 doesn't do any IO at
all, same as upstream. This test workload is purely a metadata only
workload (no data is written) and so it all gets gathered up by
delayed logging.

And that's something 2.6.38 (and RHEL6.0/6.1) doesn't have by
default, and so is going to write a fair bit of metadata to the log.
But I wouldn't have expected one IO per fallocate call. Oh, we fixed
this in 2.6.39:

8287889 xfs: preallocation transactions do not need to be synchronous

So, fallocate() is synchronous in 2.6.38 (and probably RHEL 6.0/6.1)
and the filesystem has a log stripe unit of 256k, so that would
explain the 256k IO per fallocate call - the log is forced and so
the ~500 bytes of dirty metadata gets padded to the full log stripe
(i.e. 256k) and written synchronously.

So there's the reason for the 256k write per file being written by
swift. Have I mentioned anything about weird side effects occurring
as a result of trying to emulate direct IO before? :)

> > > On Sat, Jun 15, 2013 at 12:22:35PM -0400, Mark Seger wrote:
> > > > I was thinking a little color commentary might be helpful from a
> > > > perspective of what the functionally is that's driving the need for
> > > > fallocate.  I think I mentioned somewhere in this thread that the
> > > > application is OpenStack Swift, which is  a highly scalable cloud object
> > > > store.
> > >
> > > I'm familiar with it and the problems it causes filesystems. What
> > > application am I talking about here, for example?
> > >
> > > http://oss.sgi.com/pipermail/xfs/2013-June/027159.html
> > >
> > > Basically, Swift is trying to emulate Direct IO because python
> > > does't support Direct IO. Hence Swift is hacking around that problem
> 
> I think it is still possible, FWIW.  One could use python ctypes (as in
> Marks test program) and achieve a page-aligned POSIX memalign,

I wasn't aware you could get memalign() through python at all. I
went looking for this exact solution a couple of month ago when
these problems started to be reported and couldn't find anything
related to direct IO on python with google except for "it can't be
done", "it doesn't work" and  a patch that
was rejected years ago to support it natively.

> and some
> quick googling suggests flags can be passed to open(2) via os.O_DIRECT.

Yup, the python manual that documents this kind of thing is I'd
expect to show up as the number one hit when you google "python
O_DIRECT open flags", wouldn't you think?  All I get with that is
"O_DIRECT doesn't work" bug reports and blog posts.  If drop the
O_DIRECT out of the search phrase, and the first post is the python
documentation about open flags and it documents that O_DIRECT can be
passed. And if I use different search phrases for memalign without
mentioning direct IO, I see lots of tricks people use to get this
functionality on python.

<sigh>

Google has been letting me down like this quite a bit over the past
few months when it comes to searching for stuff related to
development. It's getting harder to find stuff amongst in the noise
of whiny blogs, forums, and other places where people do nothing but
complain about broken shite that google seems to think is more
important than a real reference manual on the topic being searched.

Is there anything better out there yet? Like from years ago when the
google "I'm felling lucky" button used to pass you directly to the
exact page of the reference manual relevant to the topic being
searched?

Cheers,

Dave.


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
