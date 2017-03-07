Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55902 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755608AbdCGURB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 Mar 2017 15:17:01 -0500
Subject: Re: [PATCH 0/9] mkfs.xfs: add mkfs.xfs.conf support
References: <20170303231316.12716-1-mcgrof@kernel.org>
 <6de0c7e4-8d20-ea90-fc49-d47a787e3939@sandeen.net>
 <20170304045615.GL17542@dastard>
 <7a6509ef-1c2b-cc9c-ecb5-d0a39b5f31db@sandeen.net>
 <49d92fb6-61f6-61c7-15dc-5cfac4c7033e@suse.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2bd62db0-66b0-a6ca-cf98-af4128cb3aa3@sandeen.net>
Date: Tue, 7 Mar 2017 14:09:10 -0600
MIME-Version: 1.0
In-Reply-To: <49d92fb6-61f6-61c7-15dc-5cfac4c7033e@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="sk2inQ6gKrmd1vxVUHHvUgcbiMGmLQI2B"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Mahoney <jeffm@suse.com>, Dave Chinner <david@fromorbit.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org, jack@suse.com, okurz@suse.com, lpechacek@suse.com

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sk2inQ6gKrmd1vxVUHHvUgcbiMGmLQI2B
Content-Type: multipart/mixed; boundary="8dl2Aj6b0WdTCdACsgkIkcJn9oXp4LnS4";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: Jeff Mahoney <jeffm@suse.com>, Dave Chinner <david@fromorbit.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org,
 jack@suse.com, okurz@suse.com, lpechacek@suse.com
Message-ID: <2bd62db0-66b0-a6ca-cf98-af4128cb3aa3@sandeen.net>
Subject: Re: [PATCH 0/9] mkfs.xfs: add mkfs.xfs.conf support
References: <20170303231316.12716-1-mcgrof@kernel.org>
 <6de0c7e4-8d20-ea90-fc49-d47a787e3939@sandeen.net>
 <20170304045615.GL17542@dastard>
 <7a6509ef-1c2b-cc9c-ecb5-d0a39b5f31db@sandeen.net>
 <49d92fb6-61f6-61c7-15dc-5cfac4c7033e@suse.com>
In-Reply-To: <49d92fb6-61f6-61c7-15dc-5cfac4c7033e@suse.com>

--8dl2Aj6b0WdTCdACsgkIkcJn9oXp4LnS4
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 3/7/17 2:07 PM, Jeff Mahoney wrote:
> On 3/5/17 7:08 PM, Eric Sandeen wrote:
>> On 3/3/17 10:56 PM, Dave Chinner wrote:
>>> On Fri, Mar 03, 2017 at 09:49:58PM -0600, Eric Sandeen wrote:
>>>> On 3/3/17 5:13 PM, Luis R. Rodriguez wrote:
>>>>> This series adds mkfs.xfs.conf support, so that options can now be
>>>>> shoved into a configuration file. This enables certain defaults to =
be
>>>>> saved for folks sticking to certain values, but more importantly it=

>>>>> also enables distributions to override certain defaults so that new=

>>>>> filesystems remain compatible with older distributions.
>>>>>
>>>>> This has been based on top of xfsprogs-dev v4.9.0-rc1.
>>>>>
>>>>> Given we already have an existinsg infrastructure to validate argum=
ent
>>>>> values this reuses that infrastructure by first adding helpers and =
porting
>>>>> over the argument parsing suppor to use these helpers.
>>>>
>>>> I'm not necessarily the final word on this, but I have to say
>>>> I'm not a huge fan of having mkfs config files.  I've lived=20
>>>> through that in mke2fs land, and my personal feeling is that
>>>> it can lead to confusion when distros start shipping config
>>>> files with different defaults than upstream ships in the
>>>> code itself.
>>>>
>>>> I guess I can see the argument for shipping old/compatible
>>>> defaults with newer progs and older kernels, but by the
>>>> time a distro ships a custom old default config file they could
>>>> also patch out the new features just as easily... (which
>>>> is also confusing, I guess ;) )
>>>>
>>>> After 25+ years of no external config file, I'm concerned
>>>> about principal of least surprise when the same xfsprogs version
>>>> starts behaving differently on different boxes based on a new
>>>> file that popped up in /etc ...
>>>>
>>>> At the very least, I would like to /not/ ship or install any
>>>> config file with xfsprogs by default; the code itself should
>>>> be the canonical, single point of truth for defaults for a stock
>>>> "make && make install" installation.
>>>
>>> Hence my suggestion of libconfig - it can /write config files/ based
>>> on the current mkfs config. So there's no need to ship default
>>> config files - if a user wants a special config they can use mkfs to
>>> generate it and they can install it appropriately.
>>>
>>> e.g. 'mkfs -W <options>' outputs a config file to stdout that
>>> matches the config specified on the command line, but does not make
>>> the filesystem (similar to the "-n" option). If no options are
>>> specified, the default config is emitted....
>>
>> That sounds nice, but I guess I'd like to get some other thoughts
>> on the overall upsides and downsides of having config files which
>> alter a bare mkfs.xfs command's behavior.
>=20
> The biggest upside is that we can package up the latest xfsprogs on any=

> distro release and have it work for the user without any surprises.  If=

> we do that now, we end up with a mkfs that creates file systems that th=
e
> kernel can't actually use.  The most obvious example is using a modern
> mkfs.xfs on a system that doesn't support v5 superblocks.  There's
> actually nothing in the man page that will tell a user how to interpret=

> the error message and create a usable file system.  Defaults changing
> over time is good practice, but having a way to keep the old defaults o=
n
> older systems is useful.  Being able to dump the defaults to a file is
> helpful so that we can check whether the defaults have changed
> programmatically without having to know about new options ahead of time=
=2E

Ok, I'm getting convinced.  Thanks for convincing.  :)

-Eric

> That said, by default, we shouldn't install a config file from 'make
> install.'  If distros want to add one, they're welcome to do that eithe=
r
> in their xfsprogs package or via some per-release mechanism.
>=20
> -Jeff
>=20


--8dl2Aj6b0WdTCdACsgkIkcJn9oXp4LnS4--

--sk2inQ6gKrmd1vxVUHHvUgcbiMGmLQI2B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJYvxNuAAoJECCuFpLhPd7g/DgQAIYom7xAYQrxiOhTIYHRqAMD
LD6JZljuXQAnSvWyDvdFFmAHTxaVyxgJLZRK36wyQfAUSVPcTzgyixOUUZOH+PuM
ylfo0nSdg+RLr/ytWWNMeyJ+8csYozpExH+YD59A6N6QcsWD1ugV2WW1gofb+do+
0eYJu9ArYEzzOTRfcN9/YKwbOPy8GLpo+h8uBYuYpIz1HBZW97qfbiQV3s9CWSuy
egMnCFaHCISjIEAIlSoFEPOzVj4s/ksK7E4OvFZXtGOWmT3GVjEB2eStHLDej0lo
//b1F9gbVdfzswBFFTgZth2jzRAa4pE0d14988nx0kfg5uT5dk3cQc7P/UfxAgmN
nmeOFCEgdAZCluneNFau5Zd1dgSFKKb0BAaNeKglLFZIcr+8lwX2+llS6tR/pGFH
ukyIwRZFPe4LkzymQsesoSclSNCoRdo93shM4SLgP1gk1viRBvy6AyKKmkUIPSa0
6LtFNGkI9rJtxL/ys5zGxHTyz/SYMuHFBa/45d5ESbaj0jCJpS4An6IJ0neYmg7b
JOdf34UwZ/1LraFr80HB4x62QRP6hYeVaJgy2SvwqSAnrbMXu+NIOYni//cnfJ+J
aSMmb4HhchM83godpdt23urgWqnNx7TfEYyuVovBhVwfAZuNxOQ+k385H9zAyp7f
IXydayoFqzk5aZVKM/yk
=P4dc
-----END PGP SIGNATURE-----

--sk2inQ6gKrmd1vxVUHHvUgcbiMGmLQI2B--
