Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4EMtn5C255091 for <xfs@oss.sgi.com>; Thu, 14 May 2009 17:55:49 -0500
Received: from mail-px0-f119.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C096A28952C
	for <xfs@oss.sgi.com>; Thu, 14 May 2009 15:55:56 -0700 (PDT)
Received: from mail-px0-f119.google.com (mail-px0-f119.google.com
	[209.85.216.119]) by cuda.sgi.com with ESMTP id
	0vULmIVnw3hZxw6v for <xfs@oss.sgi.com>;
	Thu, 14 May 2009 15:55:56 -0700 (PDT)
Received: by pxi17 with SMTP id 17so771182pxi.20
	for <xfs@oss.sgi.com>; Thu, 14 May 2009 15:55:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A0C45AA.3040307@sandeen.net>
References: <E1M4aRo-0000ri-0G@closure.thunk.org>
	<4A0C45AA.3040307@sandeen.net>
Date: Fri, 15 May 2009 08:55:55 +1000
Message-ID: <d38e348a0905141555g54e8f5cey7146a25bb072a2e9@mail.gmail.com>
Subject: Re: Questions about xfstests regarding porting it to test ext4
	filesystems
From: Timothy Shimmin <timothy.shimmin@gmail.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Theodore Ts'o <tytso@mit.edu>, xfs@oss.sgi.com

Hi there,

On Fri, May 15, 2009 at 2:24 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
>
> Theodore Ts'o wrote:
>
> > 2) =A0Why is the TESTDIR have to be a persistent xfs volume? =A0 I noti=
ced
> > that when testing UDF and NFS, the scratch volume is used (and $testdir
> > is set to the point at the scratch directory). =A0 Is there some
> > fundamental reason why there must be an XFS volume mounted, even if the
> > fundamental intention is to test some other filesystem type, whether
> > it's UDF, NFS, or Ext4?
>
> Hm I'll have to dig, not certain. =A0I thought that TESTDIR would usually
> be used for non-destructive testing, general IO etc, while SCRATCHDIR
> would usually be used for any test that required lots of repeatability,
> and could therefore be more fs-specific. =A0But that's handwaving.
>
Yeah, I'm not sure if there is a reason to have testdir as a
persistent xfs volume -
in particular I'm not sure on any constraints existing in the tests.
However, the initial TESTDIR intention was to do tests over an ageing files=
ystem
and one where obviously we didn't need to mkfs over it etc. It exists
and is checked
beforehand and it exists and is checked afterwards.

When doing UDF/IRIX testing we copied over a bunch of xfstests that were ge=
neral
enough to use on UDF for us. From distant memory, I don't think we
really cared for
a distinction between scratchdir and testdir, and just wanted one
volume to be necessary
for testing (and hence why the main interest for udf was in scratchdir).
Later, someone else ported back the udf tests into the xfstests in an
effort to make
things more filesystem independent.


> > I understand the primary purpose of
> > xfstests has to be to support XFS development, but looking at the
> > scripts, there is a *huge* amount of XFS-specific assumptions all over
> > the shell scripts. =A0As a result I'm still of two minds whether it will
> > be less work to start from scratch to develop a test suite for ext4 (and
> > from the beginning try to make it filesystem independent) or to try to
> > hack xfstests and try to make it more filesystem indpendent.
>
Tricky ;-)

> Yep, agreed. =A0I think it's worth evaluating whether the xfstests harness
> is within reach of the goal, though. =A0But you may be right about how
> much work it is to get there.
>
> Really the value to other filesystems is in the tests (those which are
> or could be made generic), more than the harness, I'd say.
>
I'd agree.
>From memory, the general filesystem handling for mkfs'ing, mounting, checki=
ng
and other stuff (in the common file scripts) was a bit messy and error pron=
e.
I think extracting out the useful/fs-generic tests might be more valuable t=
oo.
It would be nice to see a clear distinction between filesystem specific tes=
ts
and generic ones.

--Tim

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
