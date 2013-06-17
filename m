Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 46F237F37
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 00:42:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C8AF8AC003
	for <xfs@oss.sgi.com>; Sun, 16 Jun 2013 22:41:58 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id khrsMagdEx6S0waw for
	<xfs@oss.sgi.com>; Sun, 16 Jun 2013 22:41:54 -0700 (PDT)
Date: Mon, 17 Jun 2013 01:41:50 -0400 (EDT)
From: Nathan Scott <nathans@redhat.com>
Message-ID: <1597962722.1767244.1371447710942.JavaMail.root@redhat.com>
In-Reply-To: <20130617024603.GJ29338@dastard>
References: <CAC2B=ZFP_Fg34aFpk857stgB7MGcrYs9tybRS-ttw1CXNeU41Q@mail.gmail.com>
	<20130615020414.GB29338@dastard>
	<CAC2B=ZEUkd+ADnQLUKj9S-3rdo2=93WbW0tbLbwwHUvkh6v7Rw@mail.gmail.com>
	<CAC2B=ZGgr5WPWOEehHDHKekM8yHgQ3QS4HMzM8+j217AfEoPyQ@mail.gmail.com>
	<20130616001130.GE29338@dastard>
	<CAC2B=ZFZskLnp5baVJK+R1xrpOfTkr1QXpA9jyHvxfk5Wd4yDg@mail.gmail.com>
	<419435719.1662203.1371431489790.JavaMail.root@redhat.com>
	<20130617024603.GJ29338@dastard>
Subject: Re: definitions for /proc/fs/xfs/stat
MIME-Version: 1.0
Reply-To: Nathan Scott <nathans@redhat.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Mark Seger <mjseger@gmail.com>, xfs@oss.sgi.com

Hey Dave,

----- Original Message -----
> ...
> Must be an old version of RHEL6, because 6.4 doesn't do any IO at
> all, same as upstream. This test workload is purely a metadata only
> workload (no data is written) and so it all gets gathered up by
> delayed logging.

*nod* - RHEL6.3.

> > I think it is still possible, FWIW.  One could use python ctypes (as in
> > Marks test program) and achieve a page-aligned POSIX memalign,
> 
> I wasn't aware you could get memalign() through python at all. I
> went looking for this exact solution a couple of month ago when
> these problems started to be reported and couldn't find anything
> ...

Yes, on reflection it doesn't jive too well with the way python wants
to do reads, in particular - os.read takes a file and a size, there's
no buffer exposed at the API level (for input).

It would need to be a separate python module to the core set I guess
(with a C component), and a slightly different API - or at least some
additional APIs which can take in an aligned buffer, rather than just
allocating one each time - but I believe it's still feasible.

cheers.

--
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
