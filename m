Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx143.netapp.com ([216.240.21.24]:51967 "EHLO mx143.netapp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753223AbeDJUKI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Apr 2018 16:10:08 -0400
From: "Vairavanathan, Emalayan" <Emalayan.Vairavanathan@netapp.com>
Subject: Re: [Question] Behaviour of directory listing in XFS with concurrent
 deletes
Date: Tue, 10 Apr 2018 20:10:05 +0000
Message-ID: <BLUPR0601MB09292620D53828FAB014F186F1BE0@BLUPR0601MB0929.namprd06.prod.outlook.com>
References: <BLUPR0601MB0929603CF85A26259FA94D32F1BB0@BLUPR0601MB0929.namprd06.prod.outlook.com>
 <20180406011808.GQ23861@dastard>
 <BLUPR0601MB0929F6CB22C71DE3E6E65F28F1BF0@BLUPR0601MB0929.namprd06.prod.outlook.com>,<20180410092001.GW23861@dastard>
In-Reply-To: <20180410092001.GW23861@dastard>
Content-Language: en-CA
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

Thank you Dave. This helps a lot.

>> [ Please word wrap your emails at 72 columns! ]

I will remember to do this in future.

- Emalayan

From: Dave Chinner <david@fromorbit.com>
Sent: April 10, 2018 2:20 AM
To: Vairavanathan, Emalayan
Cc: linux-xfs@vger.kernel.org
Subject: Re: [Question] Behaviour of directory listing in XFS with concurre=
nt deletes
=A0=20

[ Please word wrap your emails at 72 columns! ]

On Tue, Apr 10, 2018 at 12:24:55AM +0000, Vairavanathan, Emalayan
wrote:
> Hi Dave,
>=20
> Thank you for getting back to me. Please see my response inline.
>=20
> >> What's does "false-negative" mean?=A0 I don't know what your
> >> application is trying to do, so I don't know what your failure
> >> criteria is...
>=20
> Assume the following :
>=20
> 1) No failures (application crash OR disk / sector errors OR any
> form of disk or memory corruption)
> 2) xfs file-system is mounted with dirsync option.
> 3) A directory in XFS with 1.2 million files. fsync() was called
> on each file after creation.

Directory Size, dirsync, fsync, and failures are irrelevant to
readdir vs concurrent unlink behaviour.

> 4) An application with two threads (Thread-A and Thread-B) that
> uses this directory. Thread-A iterates through the directory and
> lists the names of all the files in the directory using readdir
> calls. The Thread-B=A0 concurrently deletes some files from the
> directory.
> 5) Files can be only deleted from the directory. No new files will
> be created once the directory listing is started and we have a
> coordination layer to ensure this.=20

> Given this context:
> - False-positive means a file that was deleted by Thread-B is seen
> by Thread-A.=20
> - False-negative means a file=A0that is already in the directory is
> not seen by Thread-A (due to concurrent deletes of some other
> files in the directory).
>=20
> Does this make sense ?

Yes.

> I know that false-positives are possible in this context.

Right, POSIX explicitly states that behaviour of readdir() w.r.t.
files added/deleted after opendir()/rewinddir() is unspecified.

> Is it possible to see false negatives in this
> context?=20

No.

-Dave.
--=20
Dave Chinner
david@fromorbit.com
      =
