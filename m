Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53482 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751774AbeCOVZv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Mar 2018 17:25:51 -0400
Subject: Re: [PATCH 4/9] build: update AC_PACKAGE_WANT_GDBM() and src/dbtest.c
 to build
References: <20171213004519.29340-1-mcgrof@kernel.org>
 <20171213004519.29340-5-mcgrof@kernel.org>
 <20171214055102.GE2749@eguan.usersys.redhat.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <ead4a973-966a-1c79-4301-4090a4dbc974@suse.com>
Date: Thu, 15 Mar 2018 17:25:46 -0400
MIME-Version: 1.0
In-Reply-To: <20171214055102.GE2749@eguan.usersys.redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bwZntOFkZ55s58S8wKDvxzWwdyzdHJWSD"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bwZntOFkZ55s58S8wKDvxzWwdyzdHJWSD
Content-Type: multipart/mixed; boundary="ZmX7fn7A10ivvFP31IJGHDo2W1oj8znGk";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Eryu Guan <eguan@redhat.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <ead4a973-966a-1c79-4301-4090a4dbc974@suse.com>
Subject: Re: [PATCH 4/9] build: update AC_PACKAGE_WANT_GDBM() and src/dbtest.c
 to build
References: <20171213004519.29340-1-mcgrof@kernel.org>
 <20171213004519.29340-5-mcgrof@kernel.org>
 <20171214055102.GE2749@eguan.usersys.redhat.com>
In-Reply-To: <20171214055102.GE2749@eguan.usersys.redhat.com>

--ZmX7fn7A10ivvFP31IJGHDo2W1oj8znGk
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 12/14/17 12:51 AM, Eryu Guan wrote:
> On Tue, Dec 12, 2017 at 04:45:14PM -0800, Luis R. Rodriguez wrote:
>> Modern gdbm-devel packages bundle together gdbm.h and ndbm.h.
>> The old m4 macro had detection support for some old gdbm libraries
>> but not for new ones.
>>
>> We fix compilation of src/dbtest.c by making the autoconf helper
>> check for this new arrangement:
>>
>> If both gdbm.h and gdbm.h are found define set both gdbm_ndbm_=3Dtrue,=

>                      ^^^^^^ ndbm.h?
>> and have_db=3Dtrue, and define HAVE_GDBM_H. The src/dbtest.c already
>> had a HAVE_GDBM_H but there was never a respective autoconf settter fo=
r
>> it. We can just re-use this and fix it for new arrangement.
>>
>> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
>=20
> This looks fine to me.
>=20
> The only system I have by hand that have both <gdbm.h> and <ndbm.h> but=

> not any <gdbm/[gn]dbm.h> is openSUSE Tumbleweed. Without this patch,
> dbtest was not built on openSUSE, and was built successfully with this
> patch applied. And dbtest is still built on RHEL6/7 and Fedora.
>=20
> BTW, I'll queue patch 3 and this patch for next fstests release, while
> other patches seem not necessary, I agreed with Dave that groups are no=
t
> for excluding tests, the required tools and environments should be
> detected by tests and _notrun if not met. (The README change looks fine=
,
> but it doesn't apply due to the "fsgqa-381" change, so I drop it too fo=
r
> now.)

Hi guys -

This change breaks on older releases like SLES 11 where both <ndbm.h>
and <gdbm.h> define datum, so we get build failures.  The failure is
new, but not because it used to pass and now doesn't.  It's apparently
never built on SLES releases since we ship /usr/include/ndbm.h and then
we notrun the test that uses.  Now that we're looking for gdbm.h and
find it, we attempt to build src/dbtest and fail.

This fix isn't the right solution.  The problem is that we have a couple
layers of old cruft that needs to be cleaned out.

1) As Luis notes, nothing sets HAVE_GDBM_H.  The thing is that there is
no version of gdbm.h that exports the NDBM interface.  Further, looking
at the git history, nothing has ever set HAVE_GDBM_H.  It was dead code
when it was committed initially as best I can tell.
2) openSUSE Tumbleweed doesn't need <gdbm.h> at all.  It needs <ndbm.h>
and this fix works because Luis added it to the HAVE_GDBM_H stanza.
3) AC_PACKAGE_WANT_NDBM used to check for <ndbm.h> but it was a check
for IRIX and the caller was removed ages ago.  It wouldn't matter if it
were called anyway since libndbm is an IRIX library.  Linux, IIRC, has
never shipped a libndbm.

I'll post a few patches following this to clean it up and get it working
on SLES11.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--ZmX7fn7A10ivvFP31IJGHDo2W1oj8znGk--

--bwZntOFkZ55s58S8wKDvxzWwdyzdHJWSD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCAAtFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlqq5NsPHGplZmZtQHN1
c2UuY29tAAoJEB57S2MheeWyRwYP/1xIKbEot0ylNjy4ZUUcDWXJl0DPbssDrjSW
gU3yCEZuimZda9vz2lr9n8/DAyQGQXM7sWtST9DLsjWU4OuxoE+jXT9G0biZB2h3
02L3ywCve5jhDiS4y97Q4+2BNgXCNu3dHG0vbqTCKib/V+gT/VGaTpfpgaHdyNYG
J5HRZUihd7hflIhHPc0SQScNKm9YDPWwMwNRzTPE9gxoxdX6xHMEuu0LZZ3DmIYr
t2QNcqM+cZTUduliKOcPAK0pG6MAzj02/iCf2HKtzcHF/gK/s+c0Jrr0PNzeVhpX
d0tRzd9pQbLu1U4xpT2RGHy/XGauL1jgJV5/Pqkoe47BlrPLPtihyeGBO8HFHAgh
pupzRM39zYh7Jkcmgf+pCn8xdXgmOo1W4b15P2j4Y+F8qWt7O3cUtecBLlRKhzOv
jleV4zjKpYgf/emWNBeXAqx0Yssg6YqhknTo8mqBMWVh2Cw3QbYOgPsKH3Syb/sF
prQ6sFt9loRKS0+KxgrVlH0Kvyfw9Fh6PMpT7WRn+h5ELGu8VxWGrDeiXNPLj9bB
//MJmk4cdUFFXkddjUBAuAEYVmIQYdCl0uVdshTcsHrwcUY/VrlFgAhRfKP5lag4
LCGg8GZosBMFrbYfvcB6+kGPsOYoZ+LKNmw2kaKqClvcxrZ4FnihIKzB8IZ4qXln
BHHKwLDL
=mR1E
-----END PGP SIGNATURE-----

--bwZntOFkZ55s58S8wKDvxzWwdyzdHJWSD--
