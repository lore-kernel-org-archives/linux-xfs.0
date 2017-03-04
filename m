Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54005 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752087AbdCDAXT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Mar 2017 19:23:19 -0500
From: NeilBrown <neil@brown.name>
Date: Sat, 04 Mar 2017 11:03:53 +1100
Subject: Re: [RFC PATCH v1 29/30] fs: track whether the i_version has been queried with an i_state flag
In-Reply-To: <1482339827-7882-30-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com> <1482339827-7882-30-git-send-email-jlayton@redhat.com>
Message-ID: <87wpc5lxg6.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 21 2016, Jeff Layton wrote:

> @@ -2072,7 +2093,12 @@ inode_cmp_iversion(const struct inode *inode, cons=
t u64 old)
>  static inline bool
>  inode_iversion_need_inc(struct inode *inode)
>  {
> -	return true;
> +	bool ret;
> +
> +	spin_lock(&inode->i_lock);
> +	ret =3D inode->i_state & I_VERS_BUMP;
> +	spin_unlock(&inode->i_lock);
> +	return ret;
>  }
>=20=20

I know this code gets removed, so this isn't really important.
By why do you take the spinlock here?  What are you racing again?

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAli6BGkACgkQOeye3VZi
gbk8bhAAjuwnDjbZG7OmHw6iTH67FFjq3WKPapRvHDxnrW3+I0XQwRrESBSRIf5O
WMOSg1+ptrkHadImPlieE+htFp4b4YUJqogoKo1L60iNh5IkjOXRNbvSek8Fw6a5
ev0tbMSOLc7pev4d5pfkYna+AbOcw7HXvQC20GWuj5wrjWs9k3z8iGuixEOW0lIt
jzvxpYsgr+5AiJkesVMIEVsG6PiGTKgu/5LeNqWm6DnWhptrwohaPMeXWfan0lM1
KvpMa1+oee7pa/tvlyub3G1t27PHd4aknPd4cIcVCuifBDsKWf1sYhUQpDmj2RRp
GdGRmB275aXylUsF8y6EvDV8lfRyJ4W4XJwNGJ6RRjqPb4OYMuIyteTgJ+fmWduN
4+LZPjnO2n8AgQPL0Xw+4nELqjgxucNeeecQ1oP3dEXj0xPxpfk5PV0ZIFtaiElz
yTxi+8mE9qqEqf0PdrQedYFjBrivC/6DLOck0Kf2yI+i4jnXgIqTsmSMQFB2+v0V
UzNXi1955IHo2NCXy3IPHiJettWWAaYI09uREYT1NBTX/i2HNQQu/L+AnyL6Jje/
rJ3OKbDlJvssiqF1xnYKDPqSzRmQBgoKx9RVzyypSFzSNrzjOcqJbJed0a/lqUX+
oKzzt3WPtELtHktqMDrLiILY/VjCHayEn3+uNLj0gcRKY01T/3I=
=pHrA
-----END PGP SIGNATURE-----
--=-=-=--
