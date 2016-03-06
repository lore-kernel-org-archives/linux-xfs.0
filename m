Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B861D7F55
	for <xfs@oss.sgi.com>; Sun,  6 Mar 2016 17:52:39 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 23026AC001
	for <xfs@oss.sgi.com>; Sun,  6 Mar 2016 15:52:38 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	7kvHUJYee2Uf4kML for <xfs@oss.sgi.com>;
	Sun, 06 Mar 2016 15:52:35 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1aciTQ-0000kD-Ui
	for xfs@oss.sgi.com; Mon, 07 Mar 2016 10:52:33 +1100
Date: Mon, 7 Mar 2016 10:52:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next rebased to 3c1a79f
Message-ID: <20160306235232.GT30721@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2029388106941661609=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============2029388106941661609==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O3RTKUHj+75w1tg5"
Content-Disposition: inline


--O3RTKUHj+75w1tg5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been rebased.

The rebase is really only a rework of the merge order of the patches
due to the torn log write detection fixes that Brian sent. These
need to go to Linus before anything, so I have pushed them into the
tree immediately after the commits that went into 4.5-rc4. Once
they've been in linux-next for a couple of days I'll send a pull-req
to Linus.

As a result, none of the original commit IDs have changed ias none
of the topic branches have been changed - only the merge commits
have changed.  This remerge also cleans up the double merge of the
xfs-dio-fix-4.6 topic branch which was done after adding an ext4 fix
to that branch.

I've also appended Darrick's fix for the writepage rework in that
topic branch, as it will make merging the rest of the fixes from him
simpler (now only one topic branch dependency, not two).

-Dave.

The new head of the for-next branch is commit:

3c1a79f Merge branch 'xfs-misc-fixes-4.6-2' into for-next

New Commits:

Brian Foster (4):
      [82ff6cc] xfs: separate log head record discovery from verification
      [65b99a0] xfs: refactor unmount record detection into helper
      [717bc0e] xfs: refactor in-core log state update to helper
      [7f6aff3] xfs: only run torn log write detection on dirty logs

Darrick J. Wong (1):
      [0df61da] xfs: ioends require logically contiguous file offsets

Dave Chinner (10):
      [9deed09] Merge branch 'xfs-torn-log-fixes-4.5' into for-next
      [c53473b] Merge branch 'xfs-rt-fixes-4.6' into for-next
      [1b186d2] Merge branch 'xfs-get-next-dquot-4.6' into for-next
      [acb3e26] Merge branch 'xfs-dio-fix-4.6' into for-next
      [6d247d4] Merge branch 'xfs-misc-fixes-4.6' into for-next
      [a2bbcb6] Merge branch 'xfs-gut-icdinode-4.6' into for-next
      [7f0ed54] Merge branch 'xfs-buf-macro-cleanup-4.6' into for-next
      [3d93ec0] Merge branch 'xfs-writepage-rework-4.6' into for-next
      [85a9f38] Merge branch 'xfs-dax-fixes-4.6' into for-next
      [3c1a79f] Merge branch 'xfs-misc-fixes-4.6-2' into for-next


Code Diffstat:

 fs/xfs/xfs_aops.c        |   3 +-
 fs/xfs/xfs_log_recover.c | 271 ++++++++++++++++++++++++++++++-------------=
------
 2 files changed, 170 insertions(+), 104 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--O3RTKUHj+75w1tg5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJW3MLAAAoJEK3oKUf0dfodVZ8QAMlA72Oc2aNHbj+9yVrZkngC
DbNC6yPj7DY2kOXnJTYILSa3huWrnLMEBNEMJhfHMgPOE9lMNz7cfAAOv4B/LiTs
aHk6DkN2m+I7AEBNe6x/DzDTJFvqPWyw8s0lZ4oQswQ3KiUCqj+98kpjkSHzmq4O
V5/Tr9IH/8bnzM3AlWAoLmL9qEC0S+skw5BIMjWdKrcRW/sjZRFUpv8b6VBX5UnH
vmDi3if3G6K1Ft8lwDfxzZ0Chnko24+OLylSlsc0Y1WO6Oh/IAU/xackGPm/A75k
0HPEYTLPLuv1RYFmRq7S8aM4+t2VbVd4cSQDY3OVwDYEbH4szmIJk98TWrGBpO0B
5irn3xzPE7AiHDdhWNFH0/xwedOPF5WkvIpVliUiLnX5Feqzy8EUNZ6ZK2P97iyZ
wSOX3FKiKTE9a0/9Y5eWee48xp4ESZwGQXd4OaJKD27C2QOmDyvzwlX9SwgEmsF6
Vkt3UldS1K444DYNTBBba9rwMtEplni//8jP/SSe2lV2g2BWTCE92IGL5nD0FOOM
JHewp2D+nabD0zhAW0tuOglt2Fwp5a1z5/cw58ZqpUeQDVtXe8i6dWMMaKsol+sC
Gc5Jk4b0VixlfT00ZPDyh9s3lI4/TDQfE5I1xESfDrBndfwW8yklP23GtlWRVZVq
TrsYYRZ/0ZKghJd9YF2D
=W6RE
-----END PGP SIGNATURE-----

--O3RTKUHj+75w1tg5--


--===============2029388106941661609==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2029388106941661609==--
