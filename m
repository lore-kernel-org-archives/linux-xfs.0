Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52413 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752087AbdCCXzP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Mar 2017 18:55:15 -0500
From: NeilBrown <neil@brown.name>
Date: Sat, 04 Mar 2017 10:55:04 +1100
Subject: Re: [RFC PATCH v1 11/30] fs: new API for handling i_version
In-Reply-To: <1482339827-7882-12-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com> <1482339827-7882-12-git-send-email-jlayton@redhat.com>
Message-ID: <8737etncfb.fsf@notabene.neil.brown.name>
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

On Wed, Dec 21 2016, Jeff Layton wrote:

> We already have inode_inc_iversion. Add inode_set_iversion,
> inode_get_iversion, inode_cmp_iversion and inode_iversion_need_inc.

This list of added interfaces is incomplete.
And some of these interfaces could really use some justification up
front.

You later add a "force" parameter to inode_inc_version.
Why not do that up front here?

> +
> +/**
> + * inode_get_iversion - read i_version for later use
> + * @inode: inode from which i_version should be read
> + *
> + * Read the inode i_version counter. This should be used by callers that wish
> + * to store the returned i_version for later comparison.
> + */
> +static inline u64
> +inode_get_iversion(const struct inode *inode)
> +{
> +	return inode_get_iversion_raw(inode);
> +}

I don't understand why this can use the _raw version rather than the
_read version.
Surely you need to know about any changes after this read.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAli6AlgACgkQOeye3VZi
gbmgpA/+Jvdv8FSZ8uY3DCx8phipNwrzX0yRr3pH2isCbNyBSDo8humzA+046YnM
AQUakqeUzXzJKkXL5kiYjyoRyQ2JecSfHHETQeUrhlMAAnROdU/mvkeLBcg8mCf1
qTI+QxHLKmBzGbnS5vsGkX/1sOk+adlnz9bhKWB6q14zTeANs4oapsqZZgwNWeFl
VJ29tbL+VCzXfJ3yedgK7en2WQw/5VOP6gkoqeTrhXldy1PvF8en77oOnEScXnIp
Q0h90vZxQfbIx2WFNdNh2z2CELl/fq8WC6tpVGoDsXEe1oHTa9jmHc1hTXSZogk4
IbCCUt8D3gy7FLINO4eoe4GSz4w2rtibdyJ6+kKs2TCjwaYCUS9TCYm803WXAVoT
IgNJhaNKez42Yszb5Q1m/FKnKviMWlP9iBVHi8tNBex4QtA+crnbZCUfeiJozkJj
owMOc9ckIjndcgydGwCpvovjnFACrSmiomfyVdbMIyVYPyiKlL461rRMU1mSSqum
jgcxIlJBSz+xL2T2KnkQp8dX1AG8STQDSr3rTUwlm3WUAHVoRsHteqO2I+1eTh3Q
VEBCilylvv/s2pE93YxoC6DegVVjWvdmdIDRIKhInCH01Nd34YvOxrK22D3ifJnt
qJRRFy5TfKFhuQhwzsTfaPLMO+L+G3uEN6GcL2XXUpGYXob0I7I=
=UjhU
-----END PGP SIGNATURE-----
--=-=-=--
