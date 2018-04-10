Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx143.netapp.com ([216.240.21.24]:47464 "EHLO mx143.netapp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751799AbeDJAY7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Apr 2018 20:24:59 -0400
From: "Vairavanathan, Emalayan" <Emalayan.Vairavanathan@netapp.com>
Subject: Re: [Question] Behaviour of directory listing in XFS with concurrent
 deletes
Date: Tue, 10 Apr 2018 00:24:55 +0000
Message-ID: <BLUPR0601MB0929F6CB22C71DE3E6E65F28F1BF0@BLUPR0601MB0929.namprd06.prod.outlook.com>
References: <BLUPR0601MB0929603CF85A26259FA94D32F1BB0@BLUPR0601MB0929.namprd06.prod.outlook.com>,<20180406011808.GQ23861@dastard>
In-Reply-To: <20180406011808.GQ23861@dastard>
Content-Language: en-CA
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

Hi Dave,

Thank you for getting back to me. Please see my response inline.

>> What's does "false-negative" mean?  I don't know what your application i=
s trying to do, so I don't know what your failure criteria is...

Assume the following :

1) No failures (application crash OR disk / sector errors OR any form of di=
sk or memory corruption)
2) xfs file-system is mounted with dirsync option.
3) A directory in XFS with 1.2 million files. fsync() was called on each fi=
le after creation.
4) An application with two threads (Thread-A and Thread-B) that uses this d=
irectory. Thread-A iterates through the directory and lists the names of al=
l the files in the directory using readdir calls. The Thread-B=A0 concurren=
tly deletes some files from the directory.
5) Files can be only deleted from the directory. No new files will be creat=
ed once the directory listing is started and we have a coordination layer t=
o ensure this.=20

Given this context:
- False-positive means a file that was deleted by Thread-B is seen by Threa=
d-A.=20
- False-negative means a file=A0that is already in the directory is not see=
n by Thread-A (due to concurrent deletes of some other files in the directo=
ry).

Does this make sense ? I know that false-positives are possible in this con=
text. Is it possible to see false negatives in this context?=20

Thank you. I really appreciate your answers.
Emalayan



From: Dave Chinner <david@fromorbit.com>
Sent: April 5, 2018 6:18:08 PM
To: Vairavanathan, Emalayan
Cc: linux-xfs@vger.kernel.org
Subject: Re: [Question] Behaviour of directory listing in XFS with concurre=
nt deletes
=A0=20

On Thu, Apr 05, 2018 at 11:53:18PM +0000, Vairavanathan, Emalayan wrote:
> Hi There,
>=20
>=20
> We have an application that=A0 iterates through a large directory
> (that has around 1.2 million files)=A0 and lists the names of all
> the files in the directory.=20
>=20
> Files stored in the directory could be concurrently deleted by
> another thread in the application while the application lists the
> files.=20

XFS complies with Posix requirements for stable directory offsets.
i.e. that dirents don't change offset when other dirents are added
or removed. Hence sequential readdir calls will always start off at
the dirent offset the last call finished at.

However, this guarantees nothing about individual dirent state
when concurrent modifications occur between readdir calls.

> Our application can tolerate false positives when listing a
> directory. However false negatives in directory listing *cannot*
> be tolerated.
>=20
> To this end could someone tell=A0 me how=A0directory listing in XFS
> behaves with concurrent deletes? Is it=A0 possible to see false
> negatives ?

What's does "false-negative" mean? I don't know what your
application is trying to do, so I don't know what your failure
criteria is....

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com
     =
