Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it1-f195.google.com ([209.85.166.195]:32831 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbeJBDNr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Oct 2018 23:13:47 -0400
Received: by mail-it1-f195.google.com with SMTP id h6-v6so7197274ith.0
        for <linux-xfs@vger.kernel.org>; Mon, 01 Oct 2018 13:34:14 -0700 (PDT)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <D2D8FCF8-165B-44DE-ABC6-39C22C6E9A10@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_AD5824B2-7767-49B9-8F0D-027147B06E22";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [patch] file dedupe (and maybe clone) data corruption (was Re:
 [PATCH] generic: test for deduplication between different files)
Date: Mon, 1 Oct 2018 14:34:08 -0600
In-Reply-To: <20180921044013.GD11392@hungrycats.org>
References: <20180820010932.GV2234@dastard> <20180820153349.GA4334@magnolia>
 <20180823125849.GF13528@hungrycats.org> <20180830062743.GF5631@dastard>
 <20180831051045.GI26989@hungrycats.org> <20180906083809.GF27618@dastard>
 <20180907035305.GJ26989@hungrycats.org> <20180910090646.GB5631@dastard>
 <20180919041203.GA11397@hungrycats.org> <20180921025931.GI16550@dastard>
 <20180921044013.GD11392@hungrycats.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, fdmanana@kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org


--Apple-Mail=_AD5824B2-7767-49B9-8F0D-027147B06E22
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Sep 20, 2018, at 10:40 PM, Zygo Blaxell =
<ce3g8jdj@umail.furryterror.org> wrote:
>=20
> On Fri, Sep 21, 2018 at 12:59:31PM +1000, Dave Chinner wrote:
>> On Wed, Sep 19, 2018 at 12:12:03AM -0400, Zygo Blaxell wrote:
> [...]
>> With no DMAPI in the future, people with custom HSM-like interfaces
>> based on dmapi are starting to turn to fanotify and friends to
>> provide them with the change notifications they require....
>=20
> I had a fanotify-based scanner once, before I noticed btrfs =
effectively
> had timestamps all over its metadata.
>=20
> fanotify won't tell me which parts of a file were modified (unless it
> got that feature in the last few years?).  fanotify was pretty useless
> when the only file on the system that was being modified was a 13TB
> VM image.  Or even a little 16GB one.  Has to scan the whole file to
> find the one new byte.  Even on desktops the poor thing spends most of
> its time looping over /var/log/messages.  It was sad.
>=20
> If fanotify gave me (inode, offset, length) tuples of dirty pages in
> cache, I could look them up and use a dedupe_file_range call to =
replace
> the dirty pages with a reference to an existing disk block.  If my
> listener can do that fast enough, it's in-band dedupe; if it doesn't,
> the data gets flushed to disk as normal, and I fall back to a scan of
> the filesystem to clean it up later.
>=20
>>>> e.g. a soft requirement is that we need to scan the entire fs at
>>>> least once a month.
>>>=20
>>> I have to scan and dedupe multiple times per hour.  OK, the =
first-ever
>>> scan of a non-empty filesystem is allowed to take much longer, but =
after
>>> that, if you have enough spare iops for continuous autodefrag you =
should
>>> also have spare iops for continuous dedupe.
>>=20
>> Yup, but using notifications avoids the for even these scans - you'd
>> know exactly what data has changed, when it changed, and know
>> exactly that you needed to read to calculate the new hashes.
>=20
> ...if the scanner can keep up with the notifications; otherwise, the
> notification receiver has to log them somewhere for the scanner to
> catch up.  If there are missed or dropped notifications--or 23 hours a
> day we're not listening for notifications because we only have an hour
> a day maintenance window--some kind of filesystem scan has to be done
> after the fact anyway.

It is worthwhile to mention that Lustre has a persistent Changelog =
record
that is generated atomically with the filesystem transaction that the =
event
happened in.

Once there is a Changelog consumer that registers itself with the =
filesystem,
along with a mask of the event types that it is interested in, the =
Changelog
begins recording all such events to disk (e.g. create, mkdir, setattr, =
etc.).
The Changelog consumer periodically notifies the filesystem when it has
processed events up to X, so that it can purge old events from the log.  =
It
is possible to have multiple consumers registered, and the log is only =
purged
up to the slowest consumer.

If a consumer hasn't processed logs in some (relatively long) time (e.g. =
many
days or weeks), or if the filesystem is otherwise going to run out of =
space,
then the consumer is deregistered and the old log records are cleaned =
up.  This
also notifies the consumer that it is is no longer active, and it has to =
do a
full scan to update its state for the events that it missed.

Having a persistent changelog is useful for all kinds of event =
processing,
and avoids the need to do real-time processing.  If the userspace daemon =
fails,
or the system is restarted, etc. then there is no need to rescan the =
whole
filesystem, which is important when there are many billions of files =
therein.


Cheers, Andreas






--Apple-Mail=_AD5824B2-7767-49B9-8F0D-027147B06E22
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAluyhMEACgkQcqXauRfM
H+BWYQ/8DICsYTat4NTNg3KCHvp3VYtGBF7gt7NdwgHHrDPm/vpxG+IK57c5OSIP
A0Y+nqaJDg5SFB+SyPoQVkVWc5hx8xJq1Ah97T6loRlZC36oiS8fY7QNVvBr8+oj
vyGlaMTBc9ghoPCQNkJdwbvGotiqSukaSNHuOMCmyacCGk8zCrN158Ifn/ccYUQM
tSvDyQgak34blxR7+pIfgPMmXyzN+Osqbv7sfR64D0KY36iQhD7gqlBWmwKysXhJ
lMEhE7ZL8POAicDlCGoFwhRN86q75wjwL6devxbT7QTQU2O6adG5lTUxYrxGcNRk
0xdbESZDfBbLTya5aWDVEIdmfeX/4BzSqulbVzcCdh0objS/LDYcByqjk/cIsCvH
4+ZmIWMbbY9A6cUZE69ud3QAzTmaADsNhHcWrMFoGZ2QB5XzIPbzCOUGXbEwNHp7
7Tn8LjD39vWO3o69lNeoW6QAGNJe1jBrYAKpdtOPDWjX4I1EaLJDJSgP6X9moNX8
RTJv6uGsGLY1CCFlVPKk6c50RJSAFozgvPNZlTTwXePK3uoGJ4vyrCTbr7fLyeZt
hatyrzcdqANE6rWTJ/a2wwF0K5c5SonWLaCXVW+PtXvB29InqLMFhSFQy4vchDUf
InMuj3PQ8GfFH4XrdQCZWmq+zgJSTNXGjTkSpcNTapC9vyjlp60=
=L0Ao
-----END PGP SIGNATURE-----

--Apple-Mail=_AD5824B2-7767-49B9-8F0D-027147B06E22--
