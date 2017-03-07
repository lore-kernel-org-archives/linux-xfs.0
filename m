Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56290 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751935AbdCGUHX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 Mar 2017 15:07:23 -0500
Subject: Re: [PATCH 0/9] mkfs.xfs: add mkfs.xfs.conf support
References: <20170303231316.12716-1-mcgrof@kernel.org>
 <6de0c7e4-8d20-ea90-fc49-d47a787e3939@sandeen.net>
 <20170304045615.GL17542@dastard>
 <7a6509ef-1c2b-cc9c-ecb5-d0a39b5f31db@sandeen.net>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <49d92fb6-61f6-61c7-15dc-5cfac4c7033e@suse.com>
Date: Tue, 7 Mar 2017 15:07:09 -0500
MIME-Version: 1.0
In-Reply-To: <7a6509ef-1c2b-cc9c-ecb5-d0a39b5f31db@sandeen.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8mbJ9cqB7xqlsWdxaSFLGDd88FX3vG8Af"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org, jack@suse.com, okurz@suse.com, lpechacek@suse.com

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8mbJ9cqB7xqlsWdxaSFLGDd88FX3vG8Af
Content-Type: multipart/mixed; boundary="bNsSfD8J9LD1EKuO22EOv29s5xtmcVKt0";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org,
 jack@suse.com, okurz@suse.com, lpechacek@suse.com
Message-ID: <49d92fb6-61f6-61c7-15dc-5cfac4c7033e@suse.com>
Subject: Re: [PATCH 0/9] mkfs.xfs: add mkfs.xfs.conf support
References: <20170303231316.12716-1-mcgrof@kernel.org>
 <6de0c7e4-8d20-ea90-fc49-d47a787e3939@sandeen.net>
 <20170304045615.GL17542@dastard>
 <7a6509ef-1c2b-cc9c-ecb5-d0a39b5f31db@sandeen.net>
In-Reply-To: <7a6509ef-1c2b-cc9c-ecb5-d0a39b5f31db@sandeen.net>

--bNsSfD8J9LD1EKuO22EOv29s5xtmcVKt0
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 3/5/17 7:08 PM, Eric Sandeen wrote:
> On 3/3/17 10:56 PM, Dave Chinner wrote:
>> On Fri, Mar 03, 2017 at 09:49:58PM -0600, Eric Sandeen wrote:
>>> On 3/3/17 5:13 PM, Luis R. Rodriguez wrote:
>>>> This series adds mkfs.xfs.conf support, so that options can now be
>>>> shoved into a configuration file. This enables certain defaults to b=
e
>>>> saved for folks sticking to certain values, but more importantly it
>>>> also enables distributions to override certain defaults so that new
>>>> filesystems remain compatible with older distributions.
>>>>
>>>> This has been based on top of xfsprogs-dev v4.9.0-rc1.
>>>>
>>>> Given we already have an existinsg infrastructure to validate argume=
nt
>>>> values this reuses that infrastructure by first adding helpers and p=
orting
>>>> over the argument parsing suppor to use these helpers.
>>>
>>> I'm not necessarily the final word on this, but I have to say
>>> I'm not a huge fan of having mkfs config files.  I've lived=20
>>> through that in mke2fs land, and my personal feeling is that
>>> it can lead to confusion when distros start shipping config
>>> files with different defaults than upstream ships in the
>>> code itself.
>>>
>>> I guess I can see the argument for shipping old/compatible
>>> defaults with newer progs and older kernels, but by the
>>> time a distro ships a custom old default config file they could
>>> also patch out the new features just as easily... (which
>>> is also confusing, I guess ;) )
>>>
>>> After 25+ years of no external config file, I'm concerned
>>> about principal of least surprise when the same xfsprogs version
>>> starts behaving differently on different boxes based on a new
>>> file that popped up in /etc ...
>>>
>>> At the very least, I would like to /not/ ship or install any
>>> config file with xfsprogs by default; the code itself should
>>> be the canonical, single point of truth for defaults for a stock
>>> "make && make install" installation.
>>
>> Hence my suggestion of libconfig - it can /write config files/ based
>> on the current mkfs config. So there's no need to ship default
>> config files - if a user wants a special config they can use mkfs to
>> generate it and they can install it appropriately.
>>
>> e.g. 'mkfs -W <options>' outputs a config file to stdout that
>> matches the config specified on the command line, but does not make
>> the filesystem (similar to the "-n" option). If no options are
>> specified, the default config is emitted....
>=20
> That sounds nice, but I guess I'd like to get some other thoughts
> on the overall upsides and downsides of having config files which
> alter a bare mkfs.xfs command's behavior.

The biggest upside is that we can package up the latest xfsprogs on any
distro release and have it work for the user without any surprises.  If
we do that now, we end up with a mkfs that creates file systems that the
kernel can't actually use.  The most obvious example is using a modern
mkfs.xfs on a system that doesn't support v5 superblocks.  There's
actually nothing in the man page that will tell a user how to interpret
the error message and create a usable file system.  Defaults changing
over time is good practice, but having a way to keep the old defaults on
older systems is useful.  Being able to dump the defaults to a file is
helpful so that we can check whether the defaults have changed
programmatically without having to know about new options ahead of time.

That said, by default, we shouldn't install a config file from 'make
install.'  If distros want to add one, they're welcome to do that either
in their xfsprogs package or via some per-release mechanism.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--bNsSfD8J9LD1EKuO22EOv29s5xtmcVKt0--

--8mbJ9cqB7xqlsWdxaSFLGDd88FX3vG8Af
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWL8S7h57S2MheeWyAQg53xAAwwsjawu00FP08Dn/G925oGOE21X6vEut
vAWLpsh0AhfYwnqvUGioOVDlNZI5uOjnDTpO4mvk9waRZglT9LqPGnLr4g6JbwwO
i9sydAu4ADp88wfq2p/x5cmnPia6UcYDSl8HgJVrCqed1v4svjn7OkWTT7PdFywn
JRvQGiA7My1HEAbwBOtS/rXQRHfdTOWpq2l9iOLtn2RgRWZFTUsxQiBIdZCdqoUR
Cq72J0h1d20wcjnhSRdrOu1Qq030aTZgPtHE1XgtMdvfeHmGaulJRPnwQny46XFo
98G6nBmlEBpx4BZe6U9ON4ex+C7oHbKOBlfV+r33RgrjSR4zNYSr7MkaA4tYPbVx
OFmL1LOM2UXaSw78y60RYlybgvmgivVymJCYkZsm5N0QXjrnl8sDYDNkM3HTrbSP
X9ZjNFcnlUq9T+WTG+utthTEhp7xudo/NLwY/v7wMh9Aw+wkQiPD+jra8j9PYI+N
7mvaJv2B49j/qS/wnCOvgTPprONlLOsd5JtV0hi/U8m/IoysEEkrCvry+2Y15qRk
Bt7X7dL1UflxZDoyGT0PKLqyNPDUP9MIhfjLwfwtUJvFaoJyde2WQCvUJUZBQuzN
OBwXxm2/i+H1G3bW2WPxGMJNYLiqUKhNZciudNlMum+SPXQ75EvYje7hbGSn1iNG
enjPruPcwxU=
=E61d
-----END PGP SIGNATURE-----

--8mbJ9cqB7xqlsWdxaSFLGDd88FX3vG8Af--
