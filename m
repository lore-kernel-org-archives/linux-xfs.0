Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2EK2Tai225110 for <xfs@oss.sgi.com>; Sat, 14 Mar 2009 15:02:50 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1D95F198F0C
	for <xfs@oss.sgi.com>; Sat, 14 Mar 2009 13:02:06 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id FeXrbt9C2dr1EiX4 for <xfs@oss.sgi.com>;
	Sat, 14 Mar 2009 13:02:06 -0700 (PDT)
Message-ID: <49BC0D38.5060106@sandeen.net>
Date: Sat, 14 Mar 2009 15:02:00 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: LWN article: ext4 and data loss
References: <200903121239.35442@zmi.at>	<200903121514.12732.Martin@lichtvoll.de>	<49B92423.4020708@sandeen.net>	(sfid-20090312_171308_416656_6FF6859A)
	<200903142042.51574.Martin@lichtvoll.de>
In-Reply-To: <200903142042.51574.Martin@lichtvoll.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: xfs@oss.sgi.com

Martin Steigerwald wrote:
> Am Donnerstag 12 M=E4rz 2009 schrieb Eric Sandeen:
...

>> Filesystems can hack around some heuristics to try to make unsafe apps
>> safer, but in the end, it's the app's job to make sure a buffered write
>> hits permanent storage when it matters.
> =

> Hmmm, okay. So here is:
> =

> http://bugs.kde.org/187172
> =

> Feel free to add there. You'd need a bugzilla login tough.
> =

> Ciao,

Perhaps you can try this and add info if you like.

There is an environment variable KDE_EXTRA_FSYNC, put in with this
changelog:

Do not paranoidly sync every time, it causes I/O performance problems
for some users. People who still want it for whatever reason like using
XFS can set $KDE_EXTRA_FSYNC to 1."

This is not "extra" - it is necessary if you actually want the data to
be on-disk.

See also: http://lists.kde.org/?l=3Dkde-devel&m=3D120880682813170&w=3D2

(note however that xfs is _not_ "zeroing just to be sure...")

http://api.kde.org/4.x-api/kdelibs-apidocs/kde3support/html/k3tempfile_8cpp=
-source.html

 bool
 K3TempFile::sync()
    int result =3D 0;

    if (mStream)
    {
       do {
          result =3D fflush(mStream); // We need to flush first otherwise
fsync may not have our data
       }
       while ((result =3D=3D -1) && (errno =3D=3D EINTR));

       if (result)
       {
          kWarning() << "K3TempFile: Error trying to flush " << mTmpName
 " << strerror(errno);
          mError =3D errno;
       }
    }

    if (mFd >=3D 0)
    {
       if( qgetenv( "KDE_EXTRA_FSYNC" ) =3D=3D "1" )
       {
          result =3D FDATASYNC(mFd);
          if (result)
          {
             kWarning() << "K3TempFile: Error trying to sync " <<
mTmpName << ": " << strerror(errno);
             mError =3D errno;
          }
       }
    }

    return (mError =3D=3D 0);
 }

So somebody knew it was the right thing to do, but then turned it off,
probably because of ext3's painful behavior on fsync (see also: firefox
"bug" from a while ago)

what's interesting is that the sync() method isn't automatically called
from the other methods, near as I can tell, so it's up to the api user
to invoke it; and even then it only does fflush() not fsync() by
default, which doesn't actually push things to disk.

I'd suggest turning on this KDE_EXTRA_FSYNC and see how things go from
there on.

Although, the API refs say that this is deprecated in favor of
KTemporaryFile, and I find no reference whatsoever to "sync" of any kind
in ktemporaryfile.cpp.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
