Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9AE967CA0
	for <xfs@oss.sgi.com>; Thu, 19 May 2016 20:53:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4CDC88F8035
	for <xfs@oss.sgi.com>; Thu, 19 May 2016 18:53:35 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	d3bdYKWDECslOFpA for <xfs@oss.sgi.com>;
	Thu, 19 May 2016 18:53:32 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1b3Zd4-0004AY-IR
	for xfs@oss.sgi.com; Fri, 20 May 2016 11:53:30 +1000
Date: Fri, 20 May 2016 11:53:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated
Message-ID: <20160520015330.GD26977@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3303859741353842456=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============3303859741353842456==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DSayHWYpDlRfCAAQ"
Content-Disposition: inline


--DSayHWYpDlRfCAAQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated. This is pretty much everything that I will
ask Linus to pull next week after a couple of days in linux-next.
If I've missed anythign critical, let me know.

-Dave.

The new head of the for-next branch is commit:

555b67e Merge branch 'xfs-4.7-inode-reclaim' into for-next

New Commits:

Alex Lyakas (1):
      [32b43ab] xfs: optimise xfs_iext_destroy

Brian Foster (1):
      [9bdd9bd] xfs: buffer ->bi_end_io function requires irq-safe lock

Carlos Maiolino (7):
      [192852b] xfs: configurable error behavior via sysfs
      [ffd40ef] xfs: introduce metadata IO error class
      [df30939] xfs: add configurable error support to metadata buffers
      [ef6a50f] xfs: introduce table-based init for error behaviors
      [a5ea70d] xfs: add configuration of error failure speed
      [e0a431b3] xfs: add configuration handlers for specific errors
      [e6b3bb7] xfs: add "fail at unmount" error handling configuration

Christoph Hellwig (1):
      [690a787] xfs: fix warning in xfs_finish_page_writeback for non-debug=
 builds

Dave Chinner (17):
      [8179c03] xfs: remove xfs_fs_evict_inode()
      [b1438f4] xfs: xfs_iflush_cluster fails to abort on error
      [51b07f3] xfs: fix inode validity check in xfs_iflush_cluster
      [7d3aa7f] xfs: skip stale inodes in xfs_iflush_cluster
      [1f2dcfe] xfs: xfs_inode_free() isn't RCU safe
      [8a17d7d] xfs: mark reclaimed inodes invalid earlier
      [5a90e53] xfs: xfs_iflush_cluster has range issues
      [1942936] xfs: rename variables in xfs_iflush_cluster for clarity
      [545c088] xfs: simplify inode reclaim tagging interfaces
      [ad438c4] xfs: move reclaim tagging functions
      [8b7a242] Merge branch 'xfs-4.7-writeback-bio' into for-next
      [d6bd961] Merge branch 'xfs-4.7-trans-type-cleanup' into for-next
      [5b911354] Merge branch 'xfs-4.7-optimise-inline-symlinks' into for-n=
ext
      [a7792aa] Merge branch 'xfs-4.7-cleanup-attr-listent' into for-next
      [2a4ad58] Merge branch 'xfs-4.7-misc-fixes' into for-next
      [544ad71] Merge branch 'xfs-4.7-error-cfg' into for-next
      [555b67e] Merge branch 'xfs-4.7-inode-reclaim' into for-next


Code Diffstat:

 fs/xfs/libxfs/xfs_inode_fork.c |  27 ++--
 fs/xfs/xfs_aops.c              |   5 +-
 fs/xfs/xfs_buf.c               |  12 +-
 fs/xfs/xfs_buf.h               |  20 +++
 fs/xfs/xfs_buf_item.c          | 121 +++++++++++-------
 fs/xfs/xfs_icache.c            | 290 +++++++++++++++++++++++--------------=
------
 fs/xfs/xfs_inode.c             | 104 ++++++++++------
 fs/xfs/xfs_mount.c             |  22 +++-
 fs/xfs/xfs_mount.h             |  34 ++++++
 fs/xfs/xfs_super.c             |  28 ++---
 fs/xfs/xfs_sysfs.c             | 291 +++++++++++++++++++++++++++++++++++++=
++++++-
 fs/xfs/xfs_sysfs.h             |   3 +
 fs/xfs/xfs_trace.h             |   1 -
 13 files changed, 702 insertions(+), 256 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--DSayHWYpDlRfCAAQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXPm4ZAAoJEK3oKUf0dfodUJcP/j5crT2HxCNJqdP7MD6bVghd
3G9bfs9CsoY3UZHcHoGM5iSAAsz30SN0FTmo+YENPqhHVVFg0Y7il6CkjfKH5Rgk
scqFDgYKeTuT8+QLTXCFVLY6pfKFHgCuWOFI5od5a/xNW1ktKc+LhwLe2DBuUpcr
qE5E9gZkaPQ/PboVXPrlhXAToTq+hFF8FdsGzkZZ1uF2SgWr2x0vqRxFmxl1YySk
qbLAemxtRblDcSAvAEDNsMRR8rSKfNJxlW4/IJRVErFMLtoyPaBQrPlChd4bY6+S
kqmMHfQ/ETF6PLhU1dOy/ydQsKfezxlPXe7vFDjmVC+GMcEg/u+MVmRTTAebj1iU
Tfgq+mc8HR370KohNcOJuQZzPsaOKnts5Nzgh6f6gRNUhGfW/KPtiilWm/UKZEHX
KQsiUPdSHqHK1t7u7vepLkbxodbmCseR3OeZVxvgkMJxcaHHtRu6gnr70I/93TfJ
qhEksCYGJxWAtJhXMCHj52TwHKYiCnngX7B20kibzPI+gXNpzQkRabDMBMF5m7gD
13w06eVhNt8KbUtyd2JSTQFKUWJYdqUbAsGYO2CTlYO/mzDjKumFR6Uu5gcKwoFe
mc5TXt8Iq++sh9FQPCxf9vwpPOKBp83DEIaa27udy2ydGJ0X6EJuJZFgmMQp9RD9
0C98g6o7xivE/CLF3ExR
=KTKG
-----END PGP SIGNATURE-----

--DSayHWYpDlRfCAAQ--


--===============3303859741353842456==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3303859741353842456==--
