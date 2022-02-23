Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0069C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Feb 2022 06:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238180AbiBWGSY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Feb 2022 01:18:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234623AbiBWGSX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Feb 2022 01:18:23 -0500
Received: from mail.flyingcircus.io (mail.flyingcircus.io [IPv6:2a02:238:f030:102::1064])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E3AE4CD5E
        for <linux-xfs@vger.kernel.org>; Tue, 22 Feb 2022 22:17:55 -0800 (PST)
Content-Type: multipart/signed;
        boundary="Apple-Mail=_B6B54484-D948-4790-9375-B5C61A8A3FAA";
        protocol="application/pgp-signature";
        micalg=pgp-sha512
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flyingcircus.io;
        s=mail; t=1645597069;
        bh=A9qfQ3FXmS55Shrb8a9onPHVrwXZPZOEHWesqctwuyQ=;
        h=Subject:From:In-Reply-To:Date:Cc:References:To;
        b=rRK5Li/yIlsPlW3OwJfbi4Ng/O8SCIL9C5J7dlwEXs+eGVd9z0bbOxIUngqZYmOjC
         JCWXp3rSDrL4vQXL6DKskJwC027LkMTWzN11yaWpfEGxLS2UyZEbI+v/H0gxrkvxQ+
         +Y7/bMxAOga72UD0bVd2rMJ4iMVeW8Fj2pv7zvZY=
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.60.0.1.1\))
Subject: Re: Help deciding about backported patch (kernel bug 214767,
 19f4e7cc8197 xfs: Fix CIL throttle hang when CIL space used going backwards)
From:   Christian Theune <ct@flyingcircus.io>
In-Reply-To: <20220219211419.GG59715@dread.disaster.area>
Date:   Wed, 23 Feb 2022 07:17:48 +0100
Cc:     linux-xfs@vger.kernel.org
Message-Id: <0A8FD7B2-77F2-4A75-A9BA-EC96FCC8DCF9@flyingcircus.io>
References: <C1EC87A2-15B4-45B1-ACE2-F225E9E30DA9@flyingcircus.io>
 <20220219211419.GG59715@dread.disaster.area>
To:     Dave Chinner <david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


--Apple-Mail=_B6B54484-D948-4790-9375-B5C61A8A3FAA
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi Dave,

thanks a lot - those are the instructions I was missing!

Unfortunately I mixed up the results directories and the test baseline =
output tat goes to the /tmp directory, so I don=E2=80=99t have the true =
full diffs available, only what=E2=80=99s in the stdout log. In any =
case, here=E2=80=99s what I found:

Baseline
--------

On my vanilla kernel (5.10.76) I get between 18 and 20 test failures =
when running auto mode as you instructed. The affected tests on vanilla =
are:

generic/035 generic/050 generic/388 generic/452 generic/594 generic/623 =
generic/646 generic/670* xfs/031 xfs/033 xfs/071 xfs/154 xfs/158 xfs/177 =
xfs/185 xfs/506 xfs/513 xfs/539 xfs/540 xfs/542

Notable here is generic/670 which only failed in the baseline but not =
the patched kernel:

generic/670 10s ... - output mismatch (see =
/home/ctheune/fc-nixos/results/generic/670.out.bad)
     Reflink and mmap reread the files!
    +61 61 61 61 61 61 61 61 61 62 62 62 62 62 62 62
     Finished reflinking

Patched
-------

On my patched kernel I get between 18 and 22 test failures. I=E2=80=99m =
listing only the ones not failing in the baseline:

generic/471
    -RWF_NOWAIT time is within limits.
    +RWF_NOWAIT took 0.2517 seconds

generic/475
     Silence is golden.
    +your 131072x1 screen size is bogus. expect trouble
    +your 131072x1 screen size is bogus. expect trouble
    +your 131072x1 screen size is bogus. expect trouble
    +your 131072x1 screen size is bogus. expect trouble
    +your 131072x1 screen size is bogus. expect trouble
    ...

generic/648
     Silence is golden.
    +your 131072x1 screen size is bogus. expect trouble

Also notable is that only the second run on the patched kernel contained =
additional failures compared to the baseline. The first and third run =
were =E2=80=9Cclean=E2=80=9D compared to the baseline.

I=E2=80=99m guessing that the =E2=80=9Cscreen size is bogus=E2=80=9D =
messages are due to me running the tests in a =E2=80=98screen=E2=80=99 + =
sudo environment. Leaves the generic/471 which doesn=E2=80=99t sound too =
bad, but honestly I have no idea =E2=80=A6 :)

Also, I=E2=80=99d be happy to pay back a bit by adding your instructions =
to the documentation or wiki (or wherever googling has a higher chance =
of finding them).

Kind regards,
Christian

> On 19. Feb 2022, at 22:14, Dave Chinner <david@fromorbit.com> wrote:
>=20
> On Thu, Feb 17, 2022 at 10:22:49AM +0100, Christian Theune wrote:
>> Hi,
>>=20
>> I=E2=80=99ve been debugging an elusive XFS issue that I could not =
track
>> down to any other parameters than it being an xfs internal bug.
>> I=E2=80=99ve recorded what I=E2=80=99ve seen so far in
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D214767 and Dave
>> recommended that "19f4e7cc8197 xfs: Fix CIL throttle hang when CIL
>> space used going backwards=E2=80=9D is likely the issue. AFAICT this =
was
>> not backported to the 5.10 branch and we=E2=80=99ve been updating to
>> vanilla kernels diligently and still keep seeing this issue.
>> Unfortunately within a fleet of around 1k VMs it strikes about
>> once every week or so and there=E2=80=99s no way to predict when and
>> where.
>>=20
>> So, I took Dave=E2=80=99s pointer and applied the patch to our 5.10 =
series
>> (basd on 5.10.76 at that point) and it applied cleanly. The
>> machine boots fine and I ran the XFS test suite. However, I
>> haven=E2=80=99t done any tests using the test suite before and I=E2=80=99=
m getting
>> a number of errors where I don=E2=80=99t know how to interpret the
>> results. Some of those seem to be due to not having the DEBUG flag
>> set in the kernel, others =E2=80=A6 I=E2=80=99m not sure.
>=20
> Run the "auto" group tests ('-g auto') only, which will weed out
> tests that are broken, likely to fail or crash the machine (i.e.
> test-to-failure scenarios). You can ignore "not run" reports - they
> aren't failures, just indicative of the kernel not supporting that
> functionality (like not being built with DEBUG functionality).
>=20
> Then run the tests across an unmodified kernel 2-3 times to get a
> baseline set of results (should be identical each run), then do the
> same thing for the patched kernel.
>=20
> Now compare baseline vs patched results, looking for things that
> failed in the patched kernel that didn't fail in the baseline kernel
> - those are the regressions that need more investigation. If there
> are no regressions (very likely), you are good to go.
>=20
>> I=E2=80=99m attaching the test runner output, unfortunately I lost =
the
>> actual outputs as the test ran quite long and the outputs where
>> cleaned up by the tempfile watcher faster than I could retrieve
>> them. I can run them again, my estimation currently is it takes
>> around 3-4 days to complete them, though.
>=20
> The auto group tests should take ~3-6 hours to run a full cycle
> depending on storage config.
>=20
> Cheers,
>=20
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

Liebe Gr=C3=BC=C3=9Fe,
Christian Theune

--
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 http://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick


--Apple-Mail=_B6B54484-D948-4790-9375-B5C61A8A3FAA
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE80ZlPeF6USzYHxNLZWLmycyLMigFAmIV0YwACgkQZWLmycyL
MigdAhAAv4DOdJHpcOpKGz9/Y1pp9kEUUEbBF7yzWQPFWHBnTowg2hyJ1R3lPmHM
jQZp4vcaH/6VKDYblGpllnBenjqOzDG37yRBvulT1QyHHCZyfSY1Hxlx43iyzY9Z
0vnyWqwJ3Y1yq5sycZxLzT+3fUudqCRT1/l+xLE3Llo+OcIWnIwUo8P8iksH6cjJ
otKGn/tblL2LfKQV0HJRo9YbwZetH404i+KHbeIB2Kr5aHvZ8oOXbi8K7lwDb/QW
qiQGefJLh+oulLki/OP0X1FAGvdtI3FThw0yFoGQAsQHwKa0cr9pGSFD8Im7eppN
L2qmgKvBFQ5IJyx9pD4MWzwtMQe0Xj9lUFER3G1RbyyHliHi0PsWRgSgMpD9EgfW
Up216AgB/Yx12eCQD06joiEPrKPsnTA6EbvACkoJ/VEBBN6Nfv3ISa9YoPbO1yQo
UXdpngOHbpxOH2F+OPMkDbasmL0xkoz5Q+CpH9uZdCUIyJ+I3JWz/b7iyLEeGujb
E7PfVQSqJBKsV/xXOyPCuCRagf4oTITZ6oTxBQOKzHatLIWyFdiwvgTqzlrtDifn
36aT6APBWzwZ5nipDAsAoezTgKBgMyZ51FoDU42CvXBKlL32epTZ7AFzcOVmj+F2
/5zbJXBkQHIW+fKNXt2FsQgtxNrqxCqaBcuK3rQEvSmBLk1Ti4I=
=4YMk
-----END PGP SIGNATURE-----

--Apple-Mail=_B6B54484-D948-4790-9375-B5C61A8A3FAA--
