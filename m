Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Aug 2006 10:36:09 -0700 (PDT)
Received: from woody.linuxathome.me (host81-151-221-214.range81-151.btcentralplus.com [81.151.221.214])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k71HZtDW019535
	for <xfs@oss.sgi.com>; Tue, 1 Aug 2006 10:35:59 -0700
Date: Tue, 1 Aug 2006 16:39:51 +0100
From: Hedi Berriche <hedi@berriche.co.uk>
Subject: Re: xfs_check refuses to work on readonly fs
Message-ID: <20060801153951.GB17036@linuxathome.me>
References: <1154433320.2160.267361956@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FFoLq8A0u+X9iRU8"
Content-Disposition: inline
In-Reply-To: <1154433320.2160.267361956@webmail.messagingengine.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: CN <cnliou9@fastmail.fm>
Cc: xfs@oss.sgi.com

--FFoLq8A0u+X9iRU8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Based on the info you provided I infer that you're running Linux.

On Tue, Aug 01, 2006 at 14:00 CN <cnliou9@fastmail.fm> wrote:
| Hi!
|
| # init 1
| # mount -o ro,remount /
| # mount
| /dev/hda1 on / type xfs (rw)
| # xfs_check /dev/hda1
| xfs_check: /dev/hda1 contains a mounted and writable filesystem
|
| xfs_check/xfs_repair are willing to work only when I boot from a disk
| and check/repair the other unmounted disk.
|
| Why "mount" shows (rw) instead of (ro) even "mount -o ro,remount /" is
| issued?

Because mount is relying on /etc/mtab which couldn't be updated
precisely because / was remounted ro.

You'll need a recent xfsprogs version, at least 2.7.17 IIRC, one
that uses that uses /proc/mounts instead of /etc/mtab to check
filesystem status.

Or you can use a dirty and quick hack

    - prior to remounting ro, edit /etc/mtab and change the root fs entry from
    rw to ro.
    - remount ro
    - run your xfs_check/xfs_repair in dangerous mode.

FWIW the safe thing to do after a repair on a mounted root FS is to reboot.

Cheers,
Hedi.

--FFoLq8A0u+X9iRU8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFEz3XHzLYXAd7ekr0RAmccAJ9qSDms78A5zFs6KZcEU1v00jiGXwCfZr4A
20UbpNSSHtDpmN8JGEGZFDM=
=it3F
-----END PGP SIGNATURE-----

--FFoLq8A0u+X9iRU8--
