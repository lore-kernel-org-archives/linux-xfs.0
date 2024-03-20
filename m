Received: from xmailer.gwdg.de (xmailer.gwdg.de [134.76.10.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055B138F84
	for <linux-xfs@vger.kernel.org>; Wed, 20 Mar 2024 09:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.76.10.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710926605; cv=none; b=BIlba558+j4J4TpXNm7z9pcwhrnfwENp3cGqj5VlwlbhA1bO4T6adrwzyH76U73yuNHtvFopruoQMmNbYyWW4BQpHJf9tCXkhzuTFU37tma1cAM5bdYMWiaNP/gxHo62kJdMSNK4HimRQjv4hUpeKh/uMvb/+em59QUtJrE6yGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710926605; c=relaxed/simple;
	bh=+AwrJhG/bsFnIVXX++qompnRVxQJl6LH6WyfHj0wU6Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qmIpSd9gveMDZn875Q84NWbP8/66Jd7hTRdA08o3ZPJRkRz7LR/5okvUBfZh1Zx84g1ZSY8YqWmkrMUp1JV4i2k0n1ymzi1BklEwU7ExeHEm7laBFxX/NrqeKV6aoIf+PRGMPYmVpcrB4Yge0wlfcBUQSqc/HRWQVeALdposS5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuebingen.mpg.de; spf=pass smtp.mailfrom=tuebingen.mpg.de; arc=none smtp.client-ip=134.76.10.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuebingen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuebingen.mpg.de
Received: from mailgw.tuebingen.mpg.de ([192.124.27.5] helo=tuebingen.mpg.de)
	by mailer.gwdg.de with esmtp (GWDG Mailer)
	(envelope-from <maan@tuebingen.mpg.de>)
	id 1rmrUJ-0002Ps-1x;
	Wed, 20 Mar 2024 09:39:58 +0100
Received: from [10.35.40.80] (HELO mailhost.tuebingen.mpg.de)
  by tuebingen.mpg.de (CommuniGate Pro SMTP 6.2.6)
  with SMTP id 47078568; Wed, 20 Mar 2024 09:39:57 +0100
Received: by mailhost.tuebingen.mpg.de (sSMTP sendmail emulation); Wed, 20 Mar 2024 09:39:57 +0100
Date: Wed, 20 Mar 2024 09:39:57 +0100
From: Andre Noll <maan@tuebingen.mpg.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: reactivate XFS_NEED_INACTIVE inodes from
 xfs_iget
Message-ID: <Zfqg3b3mC8Se7GMU@tuebingen.mpg.de>
References: <20240319001707.3430251-1-david@fromorbit.com>
 <20240319001707.3430251-5-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GRf8CFhb1TN1zPgJ"
Content-Disposition: inline
In-Reply-To: <20240319001707.3430251-5-david@fromorbit.com>
User-Agent: Mutt/2.2.13 (00d56288) (2024-03-09)
X-Spam-Level: $
X-Virus-Scanned: (clean) by clamav


--GRf8CFhb1TN1zPgJ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 19, 11:16, Dave Chinner wrote
> +		/*
> +		 * Well, that sucks. Put the inode back on the inactive queue.
> +		 * Do this while still under the ILOCK so that we can set the
> +		 * NEED_INACTIVE flag and clear the INACTIVATING flag an not
> +		 * have another lookup race with us before we've finished
> +		 * putting the inode back on the inodegc queue.
> +		 */
> +		spin_unlock(&ip->i_flags_lock);
> +		ip->i_flags |=3D XFS_NEED_INACTIVE;
> +		ip->i_flags &=3D ~XFS_INACTIVATING;
> +		spin_unlock(&ip->i_flags_lock);

This doesn't look right. Shouldn't the first spin_unlock() be spin_lock()?

Also, there's a typo in the comment (s/an/and).

Best
Andre
--=20
Max Planck Institute for Biology
Tel: (+49) 7071 601 829
Max-Planck-Ring 5, 72076 T=C3=BCbingen, Germany
http://people.tuebingen.mpg.de/maan/

--GRf8CFhb1TN1zPgJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSHtF/cbZGyylvqq1Ra2jVAMQCTDwUCZfqg2gAKCRBa2jVAMQCT
D68wAJ9m5+7YMmHqSxX2rHsJTXzqi9MHvACfabzgp0v7JptyMukJWidYwDqDsDg=
=kg5j
-----END PGP SIGNATURE-----

--GRf8CFhb1TN1zPgJ--
