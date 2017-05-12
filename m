Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48335 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1757756AbdELRFJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 May 2017 13:05:09 -0400
Subject: Re: [PATCH 0/9] mkfs.xfs: add mkfs.xfs.conf support
References: <20170303231316.12716-1-mcgrof@kernel.org>
 <83a0df73-be0e-e3f9-df47-9b5c4a226498@sandeen.net>
 <20170309005130.GC14437@wotan.suse.de>
 <ac91cbba-83b7-31d4-0fc9-cdb52286acdf@sandeen.net>
 <20170309175750.GE14437@wotan.suse.de> <20170309223435.GT17542@dastard>
 <20170424050010.GD28800@wotan.suse.de>
 <CACj3i70n4RctOrBVY4Jh8+p7=8NzfPDMp0o4+05nE76AV7ofSA@mail.gmail.com>
 <CAB=NE6XoEoRo-iBP8vgC7shNQoK9j=unM6_YpDs1p26+i+wQ7A@mail.gmail.com>
 <20170511224603.GA28800@wotan.suse.de>
 <646aa740-a9fc-98df-df9f-6b89bbed7261@sandeen.net>
 <CAB=NE6VDPunttSgH9qEhcPSHDdCvzUTskBbzPyhwnJ8Y9Jny2w@mail.gmail.com>
 <142427e4-658a-3df2-9ff3-77beb868f48d@sandeen.net>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <a206c22c-c4df-5793-6399-9113d8f5c38a@suse.com>
Date: Fri, 12 May 2017 13:05:03 -0400
MIME-Version: 1.0
In-Reply-To: <142427e4-658a-3df2-9ff3-77beb868f48d@sandeen.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kaXT34gIpwT6k00GMk2C72QGAG18DfGL6"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Jan Tulak <jtulak@redhat.com>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, jack@suse.com, okurz@suse.com, Libor Pechacek <lpechacek@suse.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kaXT34gIpwT6k00GMk2C72QGAG18DfGL6
Content-Type: multipart/mixed; boundary="idqW80wt9F6FgM7gOFqeSRImoDtjC2Tl3";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Eric Sandeen <sandeen@sandeen.net>, "Luis R. Rodriguez"
 <mcgrof@kernel.org>
Cc: Jan Tulak <jtulak@redhat.com>, Dave Chinner <david@fromorbit.com>,
 linux-xfs@vger.kernel.org, jack@suse.com, okurz@suse.com,
 Libor Pechacek <lpechacek@suse.com>
Message-ID: <a206c22c-c4df-5793-6399-9113d8f5c38a@suse.com>
Subject: Re: [PATCH 0/9] mkfs.xfs: add mkfs.xfs.conf support
References: <20170303231316.12716-1-mcgrof@kernel.org>
 <83a0df73-be0e-e3f9-df47-9b5c4a226498@sandeen.net>
 <20170309005130.GC14437@wotan.suse.de>
 <ac91cbba-83b7-31d4-0fc9-cdb52286acdf@sandeen.net>
 <20170309175750.GE14437@wotan.suse.de> <20170309223435.GT17542@dastard>
 <20170424050010.GD28800@wotan.suse.de>
 <CACj3i70n4RctOrBVY4Jh8+p7=8NzfPDMp0o4+05nE76AV7ofSA@mail.gmail.com>
 <CAB=NE6XoEoRo-iBP8vgC7shNQoK9j=unM6_YpDs1p26+i+wQ7A@mail.gmail.com>
 <20170511224603.GA28800@wotan.suse.de>
 <646aa740-a9fc-98df-df9f-6b89bbed7261@sandeen.net>
 <CAB=NE6VDPunttSgH9qEhcPSHDdCvzUTskBbzPyhwnJ8Y9Jny2w@mail.gmail.com>
 <142427e4-658a-3df2-9ff3-77beb868f48d@sandeen.net>
In-Reply-To: <142427e4-658a-3df2-9ff3-77beb868f48d@sandeen.net>

--idqW80wt9F6FgM7gOFqeSRImoDtjC2Tl3
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 5/12/17 12:05 PM, Eric Sandeen wrote:
> On 5/11/17 6:08 PM, Luis R. Rodriguez wrote:
>> On Thu, May 11, 2017 at 3:57 PM, Eric Sandeen <sandeen@sandeen.net> wr=
ote:
>>> On 5/11/17 5:46 PM, Luis R. Rodriguez wrote:
>>>
>>>> FWIW, I've looked at ways to address this without your future work J=
an, ie
>>>> backporting this feature, and ultimately have decided to *not* allow=
 any
>>>> command line overwrite for options specified in the configuration fi=
le. So
>>>> for the backported versions of this feature a user will only be able=
 to
>>>> overwrite if the config file is commented out or removed.
>>>>
>>>> How we end up doing this upstream may differ given we may have a way=
 to
>>>> properly do sanity checks overall and treat "defaults" as real "defa=
ults".
>>>> But without such mechanisms implementing a sensible way to overwrite=
 things
>>>> in a compatible way was just crap.
>>>>
>>>> As such for the backported versions of this feature I'll make this b=
ig note
>>>> on the man page:
>>>
>>> I'm a little confused - backported from where to where?  I'm not sure=
 what
>>> a "backport" means in this context, when there is no upstream solutio=
n at this
>>> time.
>>
>> Since we're still waiting for a bit of delta before I can push this
>> work then from my development tree to a stable older release.
>>
>>>> """
>>>> One  of  the uses of the configuration file is to enable distributio=
ns
>>>> to provide mkfs.xfs(8) updates from a base distribution release and =
enable to
>>>> create filesystems which are sure to remain supported and compatible=
=2E As such
>>>> systems with a mkfs.xfs.conf(5) file present have very likely been w=
ell thought
>>>> out, and  overriding configuration  file  defaults is discouraged un=
less you
>>>> know what you are doing and are familiar with the associated risks. =
 If you
>>>> know what you are doing, wish to waive compatibility, and wish to ov=
erwrite the
>>>> configuration file provided the best option is to either remove or u=
ncomment
>>>> the  configuration  file  completely  as options cannot be overwritt=
en on the
>>>> command line.
>>>> """
>>>
>>> So are you planning a forked, non-upstream behavior for your distro?
>>
>> Right.
>=20
> I'm not really in a position to tell a distro what to do, other than ou=
t of
> concern for polluting user expectations with non-upstream behaviors.  W=
hich
> /is/ a concern; I'm not looking forward to complaints from your users t=
hat
> upstream has "broken" behavior w.r.t. your fork when we (finally...?) s=
hip a
> config-file capable mkfs.xfs.
>=20
> i.e. you go that route, your forked behavior will differ from any behav=
ior
> that we ever ship upstream.  Your users will eventually need to adapt t=
o
> considerably different behavior which is unique to your distro, and jus=
t to
> be clear: "but we already shipped it!" will not hold any weight whatsoe=
ver
> in future upstream behavior discussions...
>=20
> If you want to ship newer progs w/ older defaults, I really don't under=
stand
> why you can't just revert the patches that added the new defaults.

The goal is to have one package that we can distribute and update across
releases and /not/ impact the experience for the user.  We'd ship the
config file with the release as a separate package and could update
xfsprogs at will.

I don't like the idea that the config file is the "one true" config
file, though.  The user should still be able to override options on the
command line.  The divergence from the upstream package should be
limited *only* to the defaults, not to the user experience.

I'm fine having this depend on Jan's work to make the defaults more
sane.  This is a wish-list item for us and it doesn't need to land tomorr=
ow.

I really think the way it should work is as if the options from the
config file override the built-in options in the same way specifying
them on the command line would.  Subsequently, options on the actual
command line override those.  This seems to be the path to least user
surprise.  The weirdness with specifying units on the command line
affecting other options may make this a little more tricky than it's
laid out here, but the principle should be to surprise the user the
least.  Having this weird divergent "sorry you have a config file and
can't override anything anymore" violates that.  mkfs should issue a
message like "Using built-in defaults" or "Using defaults from <config
path>" so it's clear, especially for user reports, where the defaults
are coming from if there is unexpected behavior.

-Jeff


--=20
Jeff Mahoney
SUSE Labs


--idqW80wt9F6FgM7gOFqeSRImoDtjC2Tl3--

--kaXT34gIpwT6k00GMk2C72QGAG18DfGL6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWRXrQB57S2MheeWyAQhQ+A//eieRWQoq9l2byy6qVs1VRub5eTJsKEka
ZgiKdFwZOhQ6vG7ok/QLKhVvDlQdojXkwGEwl0ZNGfdSS9dOKioMuPZOfuJwyRSl
VoQnVEspTkWKA1+zXQgHMz1jStjl+hGQULtxvzXqpeJsI8Mxc28XFrm4rfUU0Kfs
dC7otEi/pQN3x7+0YxMaYSAmkjVWvpRD01Q4iM2VURTWruB+k9AslU3KRAqH7+Kf
oCpESAcc+/rDFWIUQdq/3jLo7TVesOBnshXNiA1jaWY+3XsmNzLgWLeKpSn8twJb
7fejELKMuwCN3ZnFIJCIJvRmYx57Y5Uh5C/xoG6ipyDSAIlriKsKogIVi2jXaoMx
eVsxxspXYHwzAoKWdjcUgkOQCz81Oc600vJQWOxIhpOaDIiaA5g1MejpaiZPxxx6
8EyY80MIC6M7iO3d0ORVV+P5fj8PaL9w++vavRXTjJ953lWBQFYPwPBw0kMYQqa9
X1k6u7vxC3qrtaOTWwuwHYHQolq3l+T5xMo5xYFeFW0ZnxOGsvOg8+qpByqrf4yp
Ihg8qD+g33JLgKB0abD2ykTqENoxuZeriI/w7AvhxLBXJ1Snt2YaLHTBDXTdwytH
76EFcaCDQq3xkwjZxiER2U0t+7OBrTPacYZPs1l0ovbt8/JzA6GrBOwsXkPlrBfG
lskAARx2VEc=
=QZH/
-----END PGP SIGNATURE-----

--kaXT34gIpwT6k00GMk2C72QGAG18DfGL6--
