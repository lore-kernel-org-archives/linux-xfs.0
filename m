Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A8F8E7CA0
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 16:56:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6AA7C8F804B
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 14:56:09 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	wK6MCttuWoPH10EB for <xfs@oss.sgi.com>;
	Thu, 24 Mar 2016 14:56:05 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1ajDEZ-0001SS-2e
	for xfs@oss.sgi.com; Fri, 25 Mar 2016 08:56:03 +1100
Date: Fri, 25 Mar 2016 08:56:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hung task in xfs_ail_push_all_sync() when unmounting FS
	after disk failure/recovery
Message-ID: <20160324215603.GD11812@dastard>
References: <f049419a2ab10f8e3c4fef0e4f4ca1ba@mail.gmail.com>
	<20160322121922.GA53693@bfoster.bfoster>
	<6457b1d9de271ec6cca6bc2626aac161@mail.gmail.com>
	<20160322140345.GA54245@bfoster.bfoster>
	<0f3832c45509f444f55fda2aaf9c9deb@mail.gmail.com>
	<20160323123010.GA43073@bfoster.bfoster>
	<20160323153221.GA19456@redhat.com>
	<20160323223747.GX30721@dastard>
	<20160324165244.GA17555@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160324165244.GA17555@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Thu, Mar 24, 2016 at 05:52:44PM +0100, Carlos Maiolino wrote:
> I can now reproduce it, or at least part of the problem.
> =

> Regarding your question Dave, yes, it can be unmounted after I issue xfs_=
io shutdown
> command. But, if a umount is issued before that, then we can't find the
> mountpoint anymore.
> =

> I'm not sure if I'm correct, but, what it looks like to me, as you already
> mentioned, is that we keep getting IO errors but we never actually shutdo=
wn
> the filesystem while doing async metadata writes.

*nod*

> I believe I've found the problem. So, I will try to explain it, so you gu=
ys
> can review and let me know if I'm right or not
> =

> I was looking the code, and for me, looks like async retries are designed=
 to
> keep retrying forever, and rely on some other part of the filesystem to a=
ctually
> shutdown it.

*nod*

[snip description of metadata IO error behaviour]

Yes, that is exactly how the code is expected to behave - in fact,
that's how it was originally designed to behave.

> Looks like, somebody already noticed it:
> =

>         /*
>         =A6* If the write was asynchronous then no one will be looking fo=
r the
>         =A6* error.  Clear the error state and write the buffer out again.
>         =A6*
>         =A6* XXX: This helps against transient write errors, but we need =
to find
>         =A6* a way to shut the filesystem down if the writes keep failing.
>         =A6*
>         =A6* In practice we'll shut the filesystem down soon as non-trans=
ient
>         =A6* errors tend to affect the whole device and a failing log wri=
te
>         =A6* will make us give up.  But we really ought to do better here.
>         =A6*/
> =

> =

> So, if I'm write in how we hit this problem, and IIRC, Dave's patchset for
> setting limits to IO errors can be slightly modified to fix this issue to=
o, but,

The patchset I have doesn't need modification to fix this issue - it
has a patch specifically to address this, and it changes the default
behaviour to "fail async writes at unmount":

http://oss.sgi.com/archives/xfs/2015-08/msg00092.html

> the problem is that the user must set it BEFORE he tries to unmount the
> filesystem, otherwise it will get stuck here.

Yes, but that doesn't answer the big question: why don't the
periodic log forces that are failing with EIO cause a filesystem
shutdown? We issue a log force every 30s even during unmount, and a
failed log IO must cause the filesystem to shut down. So why aren't
these causing the filesystem to shutdown as we'd expect when the
device has been pulled?

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
