Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 582797F78
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 15:06:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1A434304043
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 13:06:23 -0700 (PDT)
Received: from mail-pa0-f45.google.com (mail-pa0-f45.google.com
	[209.85.220.45]) by cuda.sgi.com with ESMTP id KSEABJZPq0066ToS
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 30 Jul 2014 13:06:21 -0700 (PDT)
Received: by mail-pa0-f45.google.com with SMTP id eu11so2141544pac.4
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 13:06:20 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 2/6] fiemap: add fe_phys_length and EXTENT_PHYS_LENGTH flag
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <f257ce29393707293c0ce056bd8c6a7b3daa6082.1406739708.git.dsterba@suse.cz>
Date: Wed, 30 Jul 2014 14:06:16 -0600
Message-Id: <D8092848-4221-4590-93F6-B99DAC1C9340@dilger.ca>
References: <cover.1406739708.git.dsterba@suse.cz>
	<f257ce29393707293c0ce056bd8c6a7b3daa6082.1406739708.git.dsterba@suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4724574834393056654=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: David Sterba <dsterba@suse.cz>
Cc: linux-nilfs@vger.kernel.org, mfasheh@suse.com, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com


--===============4724574834393056654==
Content-Type: multipart/signed; boundary="Apple-Mail=_00E7CCA7-83E9-400E-95F1-80CEB4C45037"; protocol="application/pgp-signature"; micalg=pgp-sha1


--Apple-Mail=_00E7CCA7-83E9-400E-95F1-80CEB4C45037
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii


On Jul 30, 2014, at 11:18 AM, David Sterba <dsterba@suse.cz> wrote:
> Add a new member to fiemap_extent that represents the physical extent
> length. This value is undefined if the flag EXTENT_PHYS_LENGTH is not
> set.

The description here of PHYS_LENGTH makes sense...

The patch description should also mention the name of the new member,
namely "fe_phys_length"

> +#define FIEMAP_EXTENT_PHYS_LENGTH	0x00000010 /* Physical length of extent
> +						    * not the same as logical */

But the comment doesn't match.  This implies that if PHYS_LENGTH is
set, fe_phys_length != fe_logi_length, but I don't think that is
necessarily correct.  I think it makes more sense to just set
PHYS_LENGTH when fe_phys_length is valid, and if PHYS_LENGTH is not
set then fe_phys_length aware applications should just use
fe_phys_length = fe_logi_length, and older applications would just
use fe_length for both as they would already today.

Cheers, Andreas






--Apple-Mail=_00E7CCA7-83E9-400E-95F1-80CEB4C45037
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU9lQOHKl2rkXzB/gAQKpuw/6A2AImmTn8LGApwztQs9J/443KmMAIP8K
OBKsMaLL8K84nsoFqnp6WnZKCmPDGb7GhVDNMcJgBgGdNd1aQWCeuy9+8H89GLQP
62iYI9LR+d3bypthFMdjtJaNA7Uk+Wz5ShnBnJFuewPu0IF5xydxEM5TlRcKmqyV
JtSwxyYZduU43lPfmtbjxWDlZWL+MybLFn9dcYzw8oFQNn7iJIVpswDvHdT93l17
rBAs8xvZovNuXSrbSvrULhUncDw3iS7eK6wev76qQ9iY8BnVwJ3+0c/gWIAnXHQp
b1du3ccLpMrc9YNhQn2yM3gNV6AKNV/u3dBUOtRV+qVw5nPBApAtLpD4HOuZ6ORG
0x1h/4I2p3HtgwoEYOK5Y1nsQQho7b5IkYhk7GikYZdAdBZ3m0Ym7qMVPGLKPgNx
hq//wzT1wUih6w0EbaI3dnmLv8haGMgL2vRKvhnvit4dLHDYew42vqAVB9TohjkG
DKQlUgv6eyaVzxrTopQHm4J1AWocGvqGf4J3tiABg2Z53KS9858qkFIJl/U5m009
qLcv0vpbV7bNRGKceN1W5Ji9tfWjU3FR5U+f+U8xMvm0DNxE5Muddke1+NwLjBvE
4ODmIFb9Tfwa1aWn1tPWRa0/Uv/pG+pwVKYaoCNIYFIzRhuATqhnHlQR2V43hom3
APmgbwvUYQw=
=S2WY
-----END PGP SIGNATURE-----

--Apple-Mail=_00E7CCA7-83E9-400E-95F1-80CEB4C45037--


--===============4724574834393056654==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4724574834393056654==--
