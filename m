Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41471 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753492AbdHXWLS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Aug 2017 18:11:18 -0400
From: NeilBrown <neilb@suse.com>
Date: Fri, 25 Aug 2017 08:11:05 +1000
Subject: Re: Filesystem configuration parsers - (was: Re: [RESEND][PATCH] xfs: add online uevent for mount operation)
In-Reply-To: <20170824180441.GL27873@wotan.suse.de>
References: <1503582115-37220-1-git-send-email-houtao1@huawei.com> <20170824171028.GF4796@magnolia> <20170824180441.GL27873@wotan.suse.de>
Message-ID: <87a82ok45i.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Hou Tao <houtao1@huawei.com>, linux-xfs@vger.kernel.org, david@fromorbit.com, linux-fsdevel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>, Tso Ted <tytso@mit.edu>, Dmitri Pal <dpal@redhat.com>

--=-=-=
Content-Type: text/plain

On Thu, Aug 24 2017, Luis R. Rodriguez wrote:
>
> Just saying, we better damn be sure this is the way we want to go.
>

Just to provide contrast, NFS has a config file which can provide
certain defaults for mounted filesystems.  However it doesn't require a
udev event to achieve this.

Instead, it provides "/sbin/mount.nfs" which imposes the defaults at
mount time, rather than just after mount time.

There could, conceivably, be an "/sbin/mount.xfs" which read the config
file and set all the defaults concurrently with the mount operation.

I'm not necessarily saying this is a better way to go, but I agree with
the need to be sure, and this provides evidence that other approaches
are possible and worth considering.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlmfTvoACgkQOeye3VZi
gbmHBQ//RKm4qdqBWM7Hhqhu62HJ1FLquSWpoJqPLI4A90/b9ij6aut09WRuNq/v
vVxkqsj4u22JNUb3exsTgpwzlSIMonrj0LVjnc8FPJY+2AGEzMoq61ILglJq0EwF
wt2ly26lVcg26/ZM330PeVXjgFaTxm0LTKe35JVQucOruvxZBVUP3lNhTSjSpvRD
OhG0u983Uw0dHtb5W/GkmA8jM8oAcCq8d0SEyTmpi039Kuhp9KKb2zF5LhbBz1bq
h/QRb2+e/inzgUKL0gqKBYdbHQqCcsw6GDk2c5bD/11N0CvAyuVpgrg/q9p/0gMC
BVe3sIFZBB4lgw0GiI9plPfZGju1Szf8ABDVLW4hco25hCFhcgg+MnCeJarDv2W0
bHaD7chGzBPTf2GS6pCRql/3NNiPIW666GfYGTiIHdqNIR8PEp0cN36GGs/CUPRO
vQ8qtYLBJlblYs90OAO2ICHsZ+h37MMbtu6XnOjG1jYWK77Mpfz7S/LjoHcNso83
xp0O7Cs7D+MH0ybIEHNF+22awtBG0T5ytqJj+nHk6DPLBeZRmj/9LkqjkqFcy86G
QwHoTYAJnJisMNAxrOHB9TmC4tb8JnnOrmpCI/ZbbBUGTxzuu3GDW+Df9/kDSIj/
J3YynLgOJ4b0Xhv0GI6cilwlX+jLGxszltGwBMTkQHDC4ZPvO10=
=qd+G
-----END PGP SIGNATURE-----
--=-=-=--
