Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 06 Oct 2006 04:57:55 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k96BviaG027152
	for <xfs@oss.sgi.com>; Fri, 6 Oct 2006 04:57:45 -0700
Received: from ipmail02.adl2.internode.on.net (ipmail02.adl2.internode.on.net [203.16.214.141])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C42CDD17B0E7
	for <xfs@oss.sgi.com>; Fri,  6 Oct 2006 03:49:45 -0700 (PDT)
Subject: Re: XFS filesystem structure document
From: Stewart Smith <stewart@flamingspork.com>
In-Reply-To: <200610050632.QAA03593@larry.melbourne.sgi.com>
References: <200610050632.QAA03593@larry.melbourne.sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LnuZ+iRfbCs5Nt9EasW2"
Date: Fri, 06 Oct 2006 20:49:41 +1000
Message-Id: <1160131781.4385.104.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@melbourne.sgi.com>
Cc: xfs@oss.sgi.com

--=-LnuZ+iRfbCs5Nt9EasW2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2006-10-05 at 16:38 +1000, Barry Naujok wrote:
> I have attached a PDF document describing the on-disk layout of the XFS
> filesystem for review. It's a first draft and some sections are still
> incomplete. When it is in a suitable state, it will be published on the
> oss.sgi.com website.

Heya Barry, long time no see!

Hope things are well.

a few comments and suggestions:

Introduction
------------
 perhaps expand introduction to have a bit about history of XFS and
explicitly state that this is on-disk format documentation

- state what endian everything is stored in (or if both, later describe
how)

Common XFS Types
----------------
first time mentioning Allocation Groups, write as two words, instead of
AG
perhaps describe (explicitly) that all xfs types are xfs_TYPE_t, but may
be structs.
also why some are xfs_dBLAH_t (i.e. what d stands for - or the
hysterical raisins).

Perhaps first it needs explaining of the idea of subvolumes? journal,
data and realtime?=20

Allocation Groups
-----------------
edit (add the and): "Immediately after a mkfs.xfs, the primary AG has
the following disk layout *AND* the subsequent AGs do not have any
inodes allocated:"

probably need to have quick 1 sentence explanation of interpretation of
sector and block.

Superblocks
-----------
may want to explicitly state that these structs don't have padding.
maybe sizeof() as well? so as to know how much "free" space in a block
with a struct of these? and what this "free" space should be initialized
to (if anything).

In list of fields with descriptions, would be also useful to list type
next to it (along with definition such as "unsigned 64bit int").

Mentions "real time device" when previously was described as sub volume.

perhaps explicitly mention of sb_logblocks is/isn't set for external
logs.

"The value must be 4 including the following flags:" except there's a
lot of flags there. perhaps needs to be more precise.

Wouldn't XFS_SB_VERSION_DRV2BIT and XFS_SB_VERSION_EXTFLGBIT not be set
on really really really old file systems? Can't you also disable
unwritten extents with an mkfs option, or am i just dreaming (err...
nightmaring :) ?

Would be good to state if sb_inodesize can be bigger than sb_blocksize
and if so, what the value of sb_inopblock would be - or if in this case
the FS is not valid.

encoding of sb_fname, or if it's just a bunch of bytes and we don't
care.

shouldn't log2 have the 2 as subscript not super?

for sb_logsectlog and sb_logsectsize, what should be values if internal
log?

AG Free List
------------
May need to more explictly state that the free list is always full, and
in what situations it isn't, and how that's represented on disk.


looks like a good start though!

(look forward to reading the journaling part especilaly)
--=20
Stewart Smith (stewart@flamingspork.com)
http://www.flamingspork.com/


--=-LnuZ+iRfbCs5Nt9EasW2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQBFJjTEKglWCUL+FDoRAvXLAJ9X2oP+TonTzR9/dpCzWeoU4tq93gCdHWIN
bNSMKwgpFpvaRueznO8EM9A=
=2A8j
-----END PGP SIGNATURE-----

--=-LnuZ+iRfbCs5Nt9EasW2--
