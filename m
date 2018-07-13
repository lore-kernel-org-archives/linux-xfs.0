Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46586 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731387AbeGMU47 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Jul 2018 16:56:59 -0400
Subject: Re: [ANN] oscheck: wrapper for fstests check.sh - tracking and
 working with baselines
References: <CAB=NE6UjcBgQhoQvZoWKXnPWoHVNMbeYdyGfYsHdgeA=L1M4wQ@mail.gmail.com>
 <CAOQ4uxgd+Z2ADUXdLk3odP9F6KOsrE4HfRpg-1dpP9HS-zbi=Q@mail.gmail.com>
 <20180713164420.GA3620@garbanzo.do-not-panic.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <e4485816-9c42-c798-0a80-ece79948ae0c@suse.com>
Date: Fri, 13 Jul 2018 16:40:39 -0400
MIME-Version: 1.0
In-Reply-To: <20180713164420.GA3620@garbanzo.do-not-panic.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vcZ2jeCqkPNBb9HpalBpnwTjcoxkwS4Es"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Chamberlain" <mcgrof@kernel.org>, Amir Goldstein <amir73il@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Sasha Levin <Alexander.Levin@microsoft.com>, Sasha Levin <levinsasha928@gmail.com>, Valentin Rothberg <valentinrothberg@gmail.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vcZ2jeCqkPNBb9HpalBpnwTjcoxkwS4Es
Content-Type: multipart/mixed; boundary="zlglAmfPGrbRb2iim93BWJQ6HuN4L8gVC";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: "Luis R. Chamberlain" <mcgrof@kernel.org>,
 Amir Goldstein <amir73il@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
 xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>,
 Sasha Levin <Alexander.Levin@microsoft.com>,
 Sasha Levin <levinsasha928@gmail.com>,
 Valentin Rothberg <valentinrothberg@gmail.com>
Message-ID: <e4485816-9c42-c798-0a80-ece79948ae0c@suse.com>
Subject: Re: [ANN] oscheck: wrapper for fstests check.sh - tracking and
 working with baselines
References: <CAB=NE6UjcBgQhoQvZoWKXnPWoHVNMbeYdyGfYsHdgeA=L1M4wQ@mail.gmail.com>
 <CAOQ4uxgd+Z2ADUXdLk3odP9F6KOsrE4HfRpg-1dpP9HS-zbi=Q@mail.gmail.com>
 <20180713164420.GA3620@garbanzo.do-not-panic.com>
In-Reply-To: <20180713164420.GA3620@garbanzo.do-not-panic.com>

--zlglAmfPGrbRb2iim93BWJQ6HuN4L8gVC
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/13/18 12:44 PM, Luis R. Chamberlain wrote:
> On Fri, Jul 13, 2018 at 11:39:55AM +0300, Amir Goldstein wrote:
>> On Fri, Jul 13, 2018 at 5:43 AM, Luis R. Chamberlain <mcgrof@kernel.or=
g> wrote:
>>> I had volunteered at the last LSF/MM to help with the stable work for=

>>> XFS. To help with this, as part of this year's SUSE Hackweek, I've
>>> first generalized my own set of scripts to help track a baseline of
>>> results from fstests [0], and extended it to be able to easily ramp u=
p
>>> with fstests on different distributions, and I've also created a
>>> respective baseline of results against these distributions as a
>>> further example of how these scripts and wrapper framework can be use=
d
>>
>> Hi Luis!
>>
>> Thanks a lot for doing this work!
>>
>> Will take me some time to try it out, but see some questions below...
>>
>>> [1]. The distributions currently supported are:
>>>
>>>   * Debian testing
>>>   * OpenSUSE Leap 15.0
>>>   * Fedora 28
>>>
>>> The stable work starts with creating a baseline for v4.17.3. The
>>> results are visible as a result of expunge files which categorize the=

>>> failures for the different sections tested.
>>
>> So the only "bad" indication is a test failure?
>=20
> That is correct to a certain degree, ie, if xfsprogs / the kernel
> config could run it we can assume it passed.
>=20
>> How about indication about a test that started to pass since baseline?=

>=20
> Indeed, that is desirable.
>=20
> We have a few options. One is share the entire results directory for
> a release / section, however this is rather big. For instance for a
> full v4.17.3 run this is about 292 MiB alone. I don't think this
> scales. IMHO lgogs should only be supplied onto bug reports, not this
> framework.
>=20
> The other option is to use -R xunit to generate the report in the
> specified unit. I have not yet run this, or tried it, however IIRC
> it does record success runs? Does it also keep logs? Hopefully not.  I'=
m
> assuming it does not as of yet. I should note if one hits CTRL-C in the=

> middle one does not get the results. An alternative was being worked on=

> by Jeff which would sprinkle IIRC .ok files for tests which succeed,
> then you could just scrape the results directory to determine which
> tests did pass -- but you run into the same size problem as above.

Eryu didn't like that idea, so I abandoned it.  What I have now is a -R
files mode that creates a bunch of files with the goal of just archiving
the results for later comparison or import into a results db.

For each test, there are:
$seq.result.start.txt - start timestamp
$seq.result.stop.txt - stop timestamp
$seq.result.result.txt - simple result: pass/fail/expunged/notrun
$seq.result.detail.txt - contains the contents of $seq.notrun/$seq.expung=
ed
$seq.result.{dmesg,kmemleak,full,check}.txt - contains the contents of
the corresponding files

As an aside, IIRC, -R xunit doesn't catch all kinds of failures.  Also,
as you mentioned, if it's interrupted, all results are lost.  This makes
it difficult to identify test failures that crashed or hung the test syst=
em.

I have some basic scripts that parse the output and generate an HTML
report/table (and it does do what Amir asks WRT tests that started passin=
g).

-Jeff

> Since we are establishing a full baseline, and using expunge files
> to skip failures, we *should* be able to complete a full run now
> though, and be able to capture the results into this xunit format.
> I'll try that out and see how big the file is.
>=20
> I think having that *and* the expunge list would work well.
>=20
> We'd have to then process that file to scrape out which tests were
> passed, if a user wanted that. Do we have scripts for processing
> xunit files?
>=20
> Having the expunge files separately helps as we can annotate bug URLs t=
o
> them optionally. Ie, we should be able to process both expunge lists
> and xunit file to construct a nice db schema to process results
> in a more easily viewable manner in the future.
>=20
> So to establish a baseline, one first manually contstructs the expunge
> files needed to run a full test. In the future hopefully we can have
> a set of scripts to do all this for us.
>=20
> Once the baseline is in place, a full run with all sections is done,
> to generate the -R xunit file. This annotates again failures but also
> success.
>=20
> Thoughts?
>=20
>> Tested that started to notrun since baseline?
>=20
> Its unclear if xunit captures this. Otherwise we have some work to do.
>=20
>> Are we interested in those?
>=20
> Sure, if we can capture this. Does xunit gather this?
>=20
> I'd much prefer we tune our kernel to be able to run most tests,
> likewise also ensure the dependenciecs for fstests are met, through
> the oscheck helpers.sh which handles --install-deps properly.
>=20
> A side question is -- do we want to keep track of results separately
> per filesystem tools version used? Right now fstests does not annotate
> this on the results directory, but perhaps it should.
>=20
> At least for XFS, the configuration file stuff should enable in
> the future deployment of the latest xfsprogs on older releases.
> Before this, it was rather hard to do this due to the differing
> defaults, so another option may be to just only rely on assuming
> one is using the latest userspace tool.
>=20
> Right now I'm using the latest tool on each respective latest distro.
> The stable tests are using Debian testing, so whatever xfsprogs
> is in debian testing, right now that is 4.15.1-1.
>=20
>>> Other than careful manual
>>> inspection of each stable candidate patch, one of the goals will also=

>>> be to ensure such stable patches do not regress the baseline. Work is=

>>> currently underway to review the first set of stable candidate patche=
s
>>> for v4.17.3, if they both pass review and do not regress the
>>> established baseline, I'll proceed to post the patches for further
>>> evaluation from the community.
>>>
>>> Note that while I used this for XFS, it should be easy to add support=

>>> for other filesystems, should folks wish to do something similar for
>>> their filesystems. The current XFS sections being tested are as
>>> follows, please let me know if we should consider extending this
>>> further:
>>>
>>> # Matches what we expect to be default on the latests xfsprogs
>>> [xfs]
>>> MKFS_OPTIONS=3D'-f -m crc=3D1,reflink=3D0,rmapbt=3D0, -i sparse=3D0'
>>> USE_EXTERNAL=3Dno
>>> FSTYP=3Dxfs
>>
>> Please add a LOGWRITES_DEV to all "internal log" configs.
>> This is needed to utilize the (relatively) new crash consistency tests=

>> (a.k.a. generic/replay) which caught a few nasty bugs.
>=20
> Will do!
>=20
>> Fun fact: the fix for stable 4.4 almost got missed, because your syste=
m
>> was not around ;-)
>> https://marc.info/?l=3Dlinux-xfs&m=3D152852844615666&w=3D2
>>
>> I've used a 10GB LOGWRITES_DEV, which seems to be enough
>> for the current tests.
>=20
> Will use that, thanks. Better yet, any chance you can send me a patch?
>=20
>> I don't think that the dmlogwrite tests play well with external logdev=
,
>=20
> I don't think its the only test which requires review for external logs=
=2E
> There are quite a bit of failures when using xfs_logdev and
> xfs_realtimedev and I'm suspecting this has to do with the output
> differing, and the output for the tests not considering an external
> log was used.
>=20
> The top of expunges/debian/testing/xfs/unassigned/xfs_logdev.txt has:
>=20
> # Based on a quick glance on the errors, one possibility is that       =
        =20
> # perhaps generic tests do not have the semantics necessary to         =
        =20
> # determine if an external log is used in a generic form and adjust    =
        =20
> # the test for this. But that does not seem to be the case for all     =
        =20
> # tests. A common error for at least two tests seems to be size        =
        =20
> # related, and that may be a limitation on the log size, and the       =
        =20
> # inability to generically detect the filesyste log size max allowed   =
        =20
> # to then invalidate the test. But note that we even have XFS specific =
        =20
> # tests which fail, so if its a matter of semantics this is all just   =
        =20
> # crap and are missing a lot of work for improvement.=20
>=20
>> so we could probably reuse the same device for LOGWRITES_DEV
>> for configs that don't use SCRATCH_LOGDEV.
>=20
> True, the recommended setup on oscheck actually is to create
> 12 x 20 GiB disks, gendisks.sh does this for you on loopback
> devices. In practice you end up only needing about 60 GiB
> as it stands today though for XFS, but indeed we can actually
> use any of the spare disks for LOGWRITES_DEV then.
>=20
> I do wonder how much more data the extra LOGWRITES_DEV will
> push the upper limit per required guest, we'll see!
>=20
>   Luis
>=20


--=20
Jeff Mahoney
SUSE Labs


--zlglAmfPGrbRb2iim93BWJQ6HuN4L8gVC--

--vcZ2jeCqkPNBb9HpalBpnwTjcoxkwS4Es
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAltJDkcACgkQHntLYyF5
5bLkVxAAuctAYbHJa7uCyG35BIHFKFmkgic5Y7UAmjamowa1pNZK8QZGRxjBQ+yv
MBJCEAXO7SpVELHEu4+C1EBGnmTCnsNGP5OEBPBBbHw88G8xxN4vxOg2qaqvXOvP
evrNOOsefHFBF4YgZesX5+GmTKLQxVoF0tc9eY2YnKLXYX2h8up4z3gEsvS0YdhZ
Ku3tkCknjRZucLLoOcRdZhpSH4hMJxot70OnGI392vKFJytrmv1tq8Q6NCmXe28S
8LmpfvmWwgpKVVSLm6qGI7pCxp6m3mRQUrmR1GFS8Ohz0DuvPN9gEVDkGX6PSFJ1
knvzrAyLD9zW7TM3HUGar/or1aCN9xWXyvfsiWWxJ1eAmFolsqrZqH7hiHR8dE1Q
KOcrWBtyDc58p/N+YBjRHumRTgo2ynd/mKLVpkbJ/eWvpXBN8o9gGjRN4vqflDtc
WpH0/S7FW5arNaEYXO6yG7goFirOGL2Sfs8o8qvXCEn86267Ti+br7ERFj8k70pK
3ZrfZkMEhw78E2pyVKXbPV2Gx1nHueSEAej9mfxwrTJUZq1g4Ezd4kkO/I73qE5m
ZMoHSiu56iqO8fM8RBNZODxERtyvjw3JzqWlN3ZCpLhWtwh/3WDu+TkN/GqHLJDa
LsX/Mz/fo7iJIDh0yFE0k7DOVtePZIIxDp+sWgjxGdVd8PC2398=
=922j
-----END PGP SIGNATURE-----

--vcZ2jeCqkPNBb9HpalBpnwTjcoxkwS4Es--
