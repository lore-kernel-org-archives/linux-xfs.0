Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49126 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731639AbeGMVUV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Jul 2018 17:20:21 -0400
Subject: Re: [ANN] oscheck: wrapper for fstests check.sh - tracking and
 working with baselines
References: <CAB=NE6UjcBgQhoQvZoWKXnPWoHVNMbeYdyGfYsHdgeA=L1M4wQ@mail.gmail.com>
 <CAOQ4uxgd+Z2ADUXdLk3odP9F6KOsrE4HfRpg-1dpP9HS-zbi=Q@mail.gmail.com>
 <20180713164420.GA3620@garbanzo.do-not-panic.com>
 <e4485816-9c42-c798-0a80-ece79948ae0c@suse.com>
 <20180713205038.GB3620@garbanzo.do-not-panic.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <dc2c2b79-6124-4673-301b-47429b29119e@suse.com>
Date: Fri, 13 Jul 2018 17:03:56 -0400
MIME-Version: 1.0
In-Reply-To: <20180713205038.GB3620@garbanzo.do-not-panic.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="F5y12eML0CtX7t4dagcNDdPEZV8qmXsw9"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Chamberlain" <mcgrof@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Sasha Levin <Alexander.Levin@microsoft.com>, Sasha Levin <levinsasha928@gmail.com>, Valentin Rothberg <valentinrothberg@gmail.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--F5y12eML0CtX7t4dagcNDdPEZV8qmXsw9
Content-Type: multipart/mixed; boundary="APSXahQ7MLNfcLDz1ko3Bhj1hojdXM8n0";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: "Luis R. Chamberlain" <mcgrof@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>,
 Linux FS Devel <linux-fsdevel@vger.kernel.org>,
 xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>,
 Sasha Levin <Alexander.Levin@microsoft.com>,
 Sasha Levin <levinsasha928@gmail.com>,
 Valentin Rothberg <valentinrothberg@gmail.com>
Message-ID: <dc2c2b79-6124-4673-301b-47429b29119e@suse.com>
Subject: Re: [ANN] oscheck: wrapper for fstests check.sh - tracking and
 working with baselines
References: <CAB=NE6UjcBgQhoQvZoWKXnPWoHVNMbeYdyGfYsHdgeA=L1M4wQ@mail.gmail.com>
 <CAOQ4uxgd+Z2ADUXdLk3odP9F6KOsrE4HfRpg-1dpP9HS-zbi=Q@mail.gmail.com>
 <20180713164420.GA3620@garbanzo.do-not-panic.com>
 <e4485816-9c42-c798-0a80-ece79948ae0c@suse.com>
 <20180713205038.GB3620@garbanzo.do-not-panic.com>
In-Reply-To: <20180713205038.GB3620@garbanzo.do-not-panic.com>

--APSXahQ7MLNfcLDz1ko3Bhj1hojdXM8n0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/13/18 4:50 PM, Luis R. Chamberlain wrote:
> On Fri, Jul 13, 2018 at 04:40:39PM -0400, Jeff Mahoney wrote:
>> On 7/13/18 12:44 PM, Luis R. Chamberlain wrote:
>>> On Fri, Jul 13, 2018 at 11:39:55AM +0300, Amir Goldstein wrote:
>>>> On Fri, Jul 13, 2018 at 5:43 AM, Luis R. Chamberlain <mcgrof@kernel.=
org> wrote:
>>>>> I had volunteered at the last LSF/MM to help with the stable work f=
or
>>>>> XFS. To help with this, as part of this year's SUSE Hackweek, I've
>>>>> first generalized my own set of scripts to help track a baseline of=

>>>>> results from fstests [0], and extended it to be able to easily ramp=
 up
>>>>> with fstests on different distributions, and I've also created a
>>>>> respective baseline of results against these distributions as a
>>>>> further example of how these scripts and wrapper framework can be u=
sed
>>>>
>>>> Hi Luis!
>>>>
>>>> Thanks a lot for doing this work!
>>>>
>>>> Will take me some time to try it out, but see some questions below..=
=2E
>>>>
>>>>> [1]. The distributions currently supported are:
>>>>>
>>>>>   * Debian testing
>>>>>   * OpenSUSE Leap 15.0
>>>>>   * Fedora 28
>>>>>
>>>>> The stable work starts with creating a baseline for v4.17.3. The
>>>>> results are visible as a result of expunge files which categorize t=
he
>>>>> failures for the different sections tested.
>>>>
>>>> So the only "bad" indication is a test failure?
>>>
>>> That is correct to a certain degree, ie, if xfsprogs / the kernel
>>> config could run it we can assume it passed.
>>>
>>>> How about indication about a test that started to pass since baselin=
e?
>>>
>>> Indeed, that is desirable.
>>>
>>> We have a few options. One is share the entire results directory for
>>> a release / section, however this is rather big. For instance for a
>>> full v4.17.3 run this is about 292 MiB alone. I don't think this
>>> scales. IMHO lgogs should only be supplied onto bug reports, not this=

>>> framework.
>>>
>>> The other option is to use -R xunit to generate the report in the
>>> specified unit. I have not yet run this, or tried it, however IIRC
>>> it does record success runs? Does it also keep logs? Hopefully not.  =
I'm
>>> assuming it does not as of yet. I should note if one hits CTRL-C in t=
he
>>> middle one does not get the results. An alternative was being worked =
on
>>> by Jeff which would sprinkle IIRC .ok files for tests which succeed,
>>> then you could just scrape the results directory to determine which
>>> tests did pass -- but you run into the same size problem as above.
>>
>> Eryu didn't like that idea, so I abandoned it.  What I have now is a -=
R
>> files mode that creates a bunch of files with the goal of just archivi=
ng
>> the results for later comparison or import into a results db.
>>
>> For each test, there are:
>> $seq.result.start.txt - start timestamp
>> $seq.result.stop.txt - stop timestamp
>> $seq.result.result.txt - simple result: pass/fail/expunged/notrun
>> $seq.result.detail.txt - contains the contents of $seq.notrun/$seq.exp=
unged
>> $seq.result.{dmesg,kmemleak,full,check}.txt - contains the contents of=

>> the corresponding files
>=20
> This is sexy, it also gives the person interpretting the results to
> opt-in or not for the actuall full log of the output. You pick and
> choose what info you want.
>=20
> This is indeed nice.
>=20
>> As an aside, IIRC, -R xunit doesn't catch all kinds of failures.  Also=
,
>> as you mentioned, if it's interrupted, all results are lost.  This mak=
es
>> it difficult to identify test failures that crashed or hung the test s=
ystem.
>=20
> OK so indeed not my preference.
>=20
>> I have some basic scripts that parse the output and generate an HTML
>> report/table (and it does do what Amir asks WRT tests that started pas=
sing).
>=20
> These scripts, are they for parsing your new -R files output?

Yep.

> I take it the patches are still being worked on?

Yeah.  They just need a bit of review and cleaning up and I can post them=
=2E

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--APSXahQ7MLNfcLDz1ko3Bhj1hojdXM8n0--

--F5y12eML0CtX7t4dagcNDdPEZV8qmXsw9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAltJE7wACgkQHntLYyF5
5bLbsxAAjnwiKVplua5e0hps7ORA0p5PD29zFIDPqcosKrvPCIozAGM1Z1k66YW2
G96+JX7fOumJ5wVAhhDkaMzwNJJJtGVf6FI26gNm0rTK229pjntkpT9T+YY7ajsD
1Inteef6bWMg+3eyGp0uo0BbLdldtOJYE+C6+dqmTiV/ROPlXvUl9bTklTrDNSRd
sb7nJSZSrVOnJpNVK4rIvoV4Z+Y9HwKUbxsmZvlmF9ATV0nghbUrRt/cv2pSZhtF
yqoKsNDiSAN41vCYP+e+yz3tKnFbV2EH2zjgb5mgKzKNHDE0UGZkeBIUn3B2OqN0
UH3V/BEwRRAyHweq7YcESbEInLpGJzIZJv1Sc/hS+Alptu9qxdZPjmh+Wb6ToBqT
0zCka+fo905uhrjC4XheaWwCowiEkuvITW3ajk34EyjU3vjvn2ctEFiJahkPN8CU
BS6bbiLY2RVYoDb6yvleIa0jeb7iGvZUbaez2w+qZBH9WNbsLh1buIqwHcnG17oV
3LM3EYrQetULBYIjBVjMKIYLGnvzm2a+sZf77U5lBCQz937NN09P8k0d5e82x3lB
dqdnKF6b5NxfkT0F8yWBSuJ+kSSM9CazxdMEoLtHesix0za6FF8DqL87C3VUHhBF
AMxLpl4iwRjHbc5ww3ElADIJTs1uOPEVqygnmXX56LjBv/L2kk4=
=AePA
-----END PGP SIGNATURE-----

--F5y12eML0CtX7t4dagcNDdPEZV8qmXsw9--
