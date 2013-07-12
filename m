Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0A6C77F51
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 22:16:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EC589304032
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 20:16:01 -0700 (PDT)
Received: from members.tip.net.au (haggis.pcug.org.au [203.10.76.10]) by
	cuda.sgi.com with ESMTP id 36kIclyWbUxsBfPX for
	<xfs@oss.sgi.com>; Thu, 11 Jul 2013 20:15:57 -0700 (PDT)
Date: Fri, 12 Jul 2013 13:15:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the akpm tree with the xfs tree
Message-Id: <20130712131546.61d05ef97d33d58a28c728db@canb.auug.org.au>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5558456188828386839=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, linux-next@vger.kernel.org, Glauber Costa <glommer@openvz.org>

--===============5558456188828386839==
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__12_Jul_2013_13_15_46_+1000_+ZSBWRLm1HQHWOJT"

--Signature=_Fri__12_Jul_2013_13_15_46_+1000_+ZSBWRLm1HQHWOJT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
fs/xfs/xfs_qm.h between commit 92f8ff73f186 ("xfs: Add pquota fields
where gquota is used") from the xfs tree and commit  "xfs: convert dquot
cache lru to list_lru" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/xfs/xfs_qm.h
index 579d6a0,cf2ad1f..0000000
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@@ -44,14 -44,10 +44,12 @@@ extern struct kmem_zone	*xfs_qm_dqtrxzo
  typedef struct xfs_quotainfo {
  	struct radix_tree_root qi_uquota_tree;
  	struct radix_tree_root qi_gquota_tree;
 +	struct radix_tree_root qi_pquota_tree;
  	struct mutex qi_tree_lock;
 -	xfs_inode_t	*qi_uquotaip;	 /* user quota inode */
 -	xfs_inode_t	*qi_gquotaip;	 /* group quota inode */
 +	struct xfs_inode	*qi_uquotaip;	/* user quota inode */
 +	struct xfs_inode	*qi_gquotaip;	/* group quota inode */
 +	struct xfs_inode	*qi_pquotaip;	/* project quota inode */
- 	struct list_head qi_lru_list;
- 	struct mutex	 qi_lru_lock;
- 	int		 qi_lru_count;
+ 	struct list_lru	 qi_lru;
  	int		 qi_dquots;
  	time_t		 qi_btimelimit;	 /* limit for blks timer */
  	time_t		 qi_itimelimit;	 /* limit for inodes timer */

--Signature=_Fri__12_Jul_2013_13_15_46_+1000_+ZSBWRLm1HQHWOJT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR33TnAAoJEECxmPOUX5FEdj4P/3q79Hko10rAF8RPkZ310xDm
gH2yFo7ncjndKq0y74dqTQGSY08UpwAZPSCT7QaLrpTvHzEz/eKRytnQO7HrpePZ
EiqPc3JeHX+i+XN5+jXSFRtNGHLg2hI8QsHoRzWaMKsfYk0/C9wgHgQKWdAwAsdW
g65RVvePnAhDr8ZTC+YGVSWOhUuBlBoYdSODs9IX9qAzjGP5IBWvVuQOdekBq0QS
Ij6497vO87UtQLf0NXECHQ8oSXXDsR3asjQElv0Rk11I5mEvVgwAZ5JCovPBHT1g
XqXgQjh6TiVqQiKxdPVomUTxOHHw4gTJTxuiu9laul4a2zlzGy3EYhJU32ERvSqf
osXMQJMKCTIYyagHfvGTPtM1Xemy+9tLvgK1rv9osHy6JmWo6zz/apWvoST/EvIC
qJU6oS/CYEVUe94PhiFK5MOkvxnZX8qgOOnGTLqlFR4Y1MJwGQQueClSIZeH8b0N
5NtE6Vs4U8koBDAWwYawye6NFcRG6z+XzO2cFXmS2WQVTceQlauheKYUUvvZoNLz
4VaA/LB7WBmoSH5WBQ733xQJ2VrBVtq0RhhOkpr9IslmIvvSfQB5HA6pu7lAgbOF
XINRIbI2DO5xNvFnAnDrOIl59wnfvaR5pjEqTx3UtuWjnYHllqEMF7x/jSdWV6KO
cpqRxrHpyHgwplUpJ061
=yhcL
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Jul_2013_13_15_46_+1000_+ZSBWRLm1HQHWOJT--


--===============5558456188828386839==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5558456188828386839==--
