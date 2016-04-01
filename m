Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 394517CBE
	for <xfs@oss.sgi.com>; Fri,  1 Apr 2016 07:31:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A6383AC003
	for <xfs@oss.sgi.com>; Fri,  1 Apr 2016 05:31:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0DLSRuusKDIDiFXO (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 01 Apr 2016 05:31:09 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 7B6967FD44
	for <xfs@oss.sgi.com>; Fri,  1 Apr 2016 12:31:08 +0000 (UTC)
Received: from redhat.com (gfs-i24c-02.mpc.lab.eng.bos.redhat.com
	[10.16.144.214])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u31CV63U016816
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>; Fri, 1 Apr 2016 08:31:08 -0400
Date: Fri, 1 Apr 2016 08:31:06 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: XFS hung task in xfs_ail_push_all_sync() when unmounting FS
	after disk failure/recovery
Message-ID: <20160401123106.GB44113@redhat.com>
References: <f049419a2ab10f8e3c4fef0e4f4ca1ba@mail.gmail.com>
	<20160322121922.GA53693@bfoster.bfoster>
	<6457b1d9de271ec6cca6bc2626aac161@mail.gmail.com>
	<20160322140345.GA54245@bfoster.bfoster>
	<0f3832c45509f444f55fda2aaf9c9deb@mail.gmail.com>
	<20160323123010.GA43073@bfoster.bfoster>
	<20160323153221.GA19456@redhat.com>
	<20160323223747.GX30721@dastard>
	<20160324165244.GA17555@redhat.com>
	<20160324215603.GD11812@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160324215603.GD11812@dastard>
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

On Fri, Mar 25, 2016 at 08:56:03AM +1100, Dave Chinner wrote:
> On Thu, Mar 24, 2016 at 05:52:44PM +0100, Carlos Maiolino wrote:
> > I can now reproduce it, or at least part of the problem.
> > =

> > Regarding your question Dave, yes, it can be unmounted after I issue xf=
s_io shutdown
> > command. But, if a umount is issued before that, then we can't find the
> > mountpoint anymore.
> > =

> > I'm not sure if I'm correct, but, what it looks like to me, as you alre=
ady
> > mentioned, is that we keep getting IO errors but we never actually shut=
down
> > the filesystem while doing async metadata writes.
> =

> *nod*
> =

> > I believe I've found the problem. So, I will try to explain it, so you =
guys
> > can review and let me know if I'm right or not
> > =

> > I was looking the code, and for me, looks like async retries are design=
ed to
> > keep retrying forever, and rely on some other part of the filesystem to=
 actually
> > shutdown it.
> =

> *nod*
> =

> [snip description of metadata IO error behaviour]
> =

> Yes, that is exactly how the code is expected to behave - in fact,
> that's how it was originally designed to behave.
> =

> > Looks like, somebody already noticed it:
> > =

> >         /*
> >         =A6* If the write was asynchronous then no one will be looking =
for the
> >         =A6* error.  Clear the error state and write the buffer out aga=
in.
> >         =A6*
> >         =A6* XXX: This helps against transient write errors, but we nee=
d to find
> >         =A6* a way to shut the filesystem down if the writes keep faili=
ng.
> >         =A6*
> >         =A6* In practice we'll shut the filesystem down soon as non-tra=
nsient
> >         =A6* errors tend to affect the whole device and a failing log w=
rite
> >         =A6* will make us give up.  But we really ought to do better he=
re.
> >         =A6*/
> > =

> > =

> > So, if I'm write in how we hit this problem, and IIRC, Dave's patchset =
for
> > setting limits to IO errors can be slightly modified to fix this issue =
too, but,
> =

> The patchset I have doesn't need modification to fix this issue - it
> has a patch specifically to address this, and it changes the default
> behaviour to "fail async writes at unmount":
> =

> http://oss.sgi.com/archives/xfs/2015-08/msg00092.html
> =

> > the problem is that the user must set it BEFORE he tries to unmount the
> > filesystem, otherwise it will get stuck here.
> =

> Yes, but that doesn't answer the big question: why don't the
> periodic log forces that are failing with EIO cause a filesystem
> shutdown? We issue a log force every 30s even during unmount, and a
> failed log IO must cause the filesystem to shut down. So why aren't
> these causing the filesystem to shutdown as we'd expect when the
> device has been pulled?
> =


Right, good point, I'll take a look on it

> Cheers,
> =

> Dave.
> -- =

> Dave Chinner
> david@fromorbit.com
> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- =

Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
