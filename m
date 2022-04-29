Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 565D0C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Apr 2022 14:25:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377253AbiD2O23 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Apr 2022 10:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377256AbiD2O2Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Apr 2022 10:28:24 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B018592301
        for <linux-xfs@vger.kernel.org>; Fri, 29 Apr 2022 07:24:58 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id B4BD6149482
        for <linux-xfs@vger.kernel.org>; Fri, 29 Apr 2022 09:24:31 -0500 (CDT)
Message-ID: <28907293-8c3d-bed6-562d-5ffc663c20ca@sandeen.net>
Date:   Fri, 29 Apr 2022 09:24:56 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Content-Language: en-US
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs-5.16.0-rc0 released
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------YEXdzTOglOf7CqsHIAVGndTG"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------YEXdzTOglOf7CqsHIAVGndTG
Content-Type: multipart/mixed; boundary="------------I3KWhWh5tAx8kSyI0X03hl6l";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <28907293-8c3d-bed6-562d-5ffc663c20ca@sandeen.net>
Subject: [ANNOUNCE] xfsprogs-5.16.0-rc0 released

--------------I3KWhWh5tAx8kSyI0X03hl6l
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This is the libxfs-5.16 sync, so the vast majority of these=20
changes are just that, other than a couple prep patches (thanks
Darrick!) to facilitate the sync.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

That said: You may have noticed that I've been behind. *cough*

In an effort to get caught up, I plan to make minimal changes to
this release before making it final.  I'll then skip forward ASAP
to 5.17 and 5.18, and start pulling in actual non-libxfs content there,
so that anyone else who needs to work on xfsprogs with an up to date
shared libxfs has something reasonable.

Apologies for the delays recently, and huge, huge thanks to djwong
for his (almost) infinite patience and help with this work.

-Eric

The new head of the master branch is commit:

f88fad88 (HEAD -> libxfs-5.16-sync, tag: v5.16.0-rc0, korg/master, korg/l=
ibxfs-5.16-sync, korg/for-next, refs/patches/libxfs-5.16-sync/patch_5.16.=
0-rc0.patch) xfsprogs: Release v5.16.0-rc0

New Commits:

Brian Foster (4):
      [b7921824] xfs: fold perag loop iteration logic into helper functio=
n
      [02ff0b2b] xfs: rename the next_agno perag iteration variable
      [6c18fde8] xfs: terminate perag iteration reliably on agcount
      [9619d9e7] xfs: fix perag reference leak on iteration race with gro=
wfs

Christoph Hellwig (3):
      [7328ea6e] xfs: remove the xfs_dinode_t typedef
      [045b32d5] xfs: remove the xfs_dsb_t typedef
      [bf0f6e17] xfs: remove the xfs_dqblk_t typedef

Darrick J. Wong (30):
      [14ccd02b] xfs_db: fix metadump level comparisons
      [2e9720d5] xfs_repair: fix AG header btree level comparisons
      [b445674e] xfs: formalize the process of holding onto resources acr=
oss a defer roll
      [7d6b86ac] xfs: port the defer ops capture and continue to resource=
 capture
      [0571c857] xfs: fix maxlevels comparisons in the btree staging code=

      [ec924d04] xfs: remove xfs_btree_cur_t typedef
      [883b087c] xfs: check that bc_nlevels never overflows
      [547a82cd] xfs: remove xfs_btree_cur.bc_blocklog
      [4c0ddd16] xfs: reduce the size of nr_ops for refcount btree cursor=
s
      [5df9b067] xfs: prepare xfs_btree_cur for dynamic cursor heights
      [1640bbbd] xfs: rearrange xfs_btree_cur fields for better packing
      [1586915a] xfs: refactor btree cursor allocation function
      [100a1b52] xfs: encode the max btree height in the cursor
      [22f64346] xfs: dynamically allocate cursors based on maxlevels
      [4aa2259d] xfs: rename m_ag_maxlevels to m_allocbt_maxlevels
      [6afce48f] xfs: compute maximum AG btree height for critical reserv=
ation calculation
      [3024d6c9] xfs: clean up xfs_btree_{calc_size,compute_maxlevels}
      [4a9e48bf] xfs: compute the maximum height of the rmap btree when r=
eflink enabled
      [716b497a] xfs_db: stop using XFS_BTREE_MAXLEVELS
      [2074423c] xfs_repair: stop using XFS_BTREE_MAXLEVELS
      [c967ee0a] xfs: kill XFS_BTREE_MAXLEVELS
      [441815c7] xfs: compute absolute maximum nlevels for each btree typ=
e
      [7d10d094] xfs: use separate btree cursor cache for each btree type=

      [5c35b317] xfs: remove kmem_zone typedef
      [2e1394fc] xfs: rename _zone variables to _cache
      [8a702e68] xfs: compact deferred intent item structures
      [1577541c] xfs: create slab caches for frequently-used deferred ite=
ms
      [7d84b02d] xfs: rename xfs_bmap_add_free to xfs_free_extent_later
      [6d72c6ea] xfs: reduce the size of struct xfs_extent_free_item
      [63b67bb6] xfs: remove unused parameter from refcount code

Eric Sandeen (2):
      [4b49bebf] xfs: #ifdef out perag code for userspace
      [f88fad88] xfsprogs: Release v5.16.0-rc0

Rustam Kovhaev (1):
      [76bbe2c2] xfs: use kmem_cache_free() for kmem_cache objects

Yang Guang (1):
      [016bb3d1] xfs: use swap() to make dabtree code cleaner

Yang Xu (1):
      [d2431276] xfs: Fix the free logic of state in xfs_attr_node_hasnam=
e


Code Diffstat:

 VERSION                     |   4 +-
 configure.ac                |   2 +-
 copy/xfs_copy.c             |   2 +-
 copy/xfs_copy.h             |   2 +-
 db/bmap.c                   |  28 ++--
 db/bmroot.c                 |  18 +--
 db/check.c                  |  84 +++++------
 db/dquot.c                  |   8 +-
 db/field.c                  |   8 +-
 db/frag.c                   |  28 ++--
 db/inode.c                  | 144 +++++++++----------
 db/metadump.c               |  30 ++--
 doc/CHANGES                 |   3 +
 estimate/xfs_estimate.c     |   2 +-
 include/kmem.h              |  33 +++--
 include/platform_defs.h.in  |   3 +
 include/xfs_mount.h         |   5 +-
 include/xfs_trans.h         |   3 -
 libxfs/defer_item.c         |  32 +++--
 libxfs/init.c               |  79 +++++++----
 libxfs/kmem.c               |  45 +++---
 libxfs/libxfs_priv.h        |  11 +-
 libxfs/logitem.c            |   8 +-
 libxfs/rdwr.c               |  20 +--
 libxfs/trans.c              |  14 +-
 libxfs/util.c               |   2 +-
 libxfs/xfs_ag.c             |   2 +-
 libxfs/xfs_ag.h             |  36 +++--
 libxfs/xfs_ag_resv.c        |   3 +-
 libxfs/xfs_alloc.c          | 120 +++++++++++++---
 libxfs/xfs_alloc.h          |  38 ++++-
 libxfs/xfs_alloc_btree.c    |  63 +++++++--
 libxfs/xfs_alloc_btree.h    |   5 +
 libxfs/xfs_attr.c           |  17 +--
 libxfs/xfs_attr_leaf.c      |   2 +-
 libxfs/xfs_bmap.c           | 101 +++++---------
 libxfs/xfs_bmap.h           |  35 +----
 libxfs/xfs_bmap_btree.c     |  62 +++++++--
 libxfs/xfs_bmap_btree.h     |   5 +
 libxfs/xfs_btree.c          | 333 +++++++++++++++++++++++++++-----------=
------
 libxfs/xfs_btree.h          |  99 +++++++++----
 libxfs/xfs_btree_staging.c  |   8 +-
 libxfs/xfs_da_btree.c       |  11 +-
 libxfs/xfs_da_btree.h       |   3 +-
 libxfs/xfs_defer.c          | 241 ++++++++++++++++++++++++--------
 libxfs/xfs_defer.h          |  41 ++++--
 libxfs/xfs_dquot_buf.c      |   4 +-
 libxfs/xfs_format.h         |  12 +-
 libxfs/xfs_fs.h             |   2 +
 libxfs/xfs_ialloc.c         |   5 +-
 libxfs/xfs_ialloc_btree.c   |  90 ++++++++++--
 libxfs/xfs_ialloc_btree.h   |   5 +
 libxfs/xfs_inode_buf.c      |   6 +-
 libxfs/xfs_inode_fork.c     |  24 ++--
 libxfs/xfs_inode_fork.h     |   2 +-
 libxfs/xfs_refcount.c       |  46 ++++--
 libxfs/xfs_refcount.h       |   7 +-
 libxfs/xfs_refcount_btree.c |  65 +++++++--
 libxfs/xfs_refcount_btree.h |   5 +
 libxfs/xfs_rmap.c           |  21 ++-
 libxfs/xfs_rmap.h           |   7 +-
 libxfs/xfs_rmap_btree.c     | 116 +++++++++++----
 libxfs/xfs_rmap_btree.h     |   5 +
 libxfs/xfs_sb.c             |   4 +-
 libxfs/xfs_trans_resv.c     |  18 ++-
 libxfs/xfs_trans_space.h    |   9 +-
 logprint/log_print_all.c    |   2 +-
 logprint/logprint.c         |   2 +-
 mdrestore/xfs_mdrestore.c   |   6 +-
 repair/attr_repair.c        |  30 ++--
 repair/attr_repair.h        |   2 +-
 repair/da_util.h            |   2 +-
 repair/dino_chunks.c        |  20 +--
 repair/dinode.c             | 234 ++++++++++++++++---------------
 repair/dinode.h             |   6 +-
 repair/dir2.c               | 124 ++++++++---------
 repair/dir2.h               |  16 +--
 repair/incore.h             |   2 +-
 repair/prefetch.c           |   6 +-
 repair/rt.c                 |  54 +++----
 repair/rt.h                 |   6 +-
 repair/sb.c                 |   6 +-
 repair/scan.c               |   4 +-
 83 files changed, 1787 insertions(+), 1031 deletions(-)

--------------I3KWhWh5tAx8kSyI0X03hl6l--

--------------YEXdzTOglOf7CqsHIAVGndTG
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmJr9TgFAwAAAAAACgkQIK4WkuE93uBH
OQ//Wq/DCs79XDA5ANV4VuwxvntFF52yrhTF9MQdH3x5Wm5HaYMAZdasCX7t02rjN8sJZNydlUpI
lbybH8TCJotCCbSfNjSO0+5WoJVu59Z6ADSrBy66JlGOXfh5QRMLzj944hDve1oAe49pYHhNPO7t
3cL+YuJZIFYPb/YRilJUmC6yehVmdPCtlrlBCys0pirM/fCCZ0g+fUW6R9si9GtGnit2D6zbpSgO
iyLEdm6oeRR9iryM239T/wF9uOQUr5g+ckdkiu24SufHNnGhv66zvX0hzLm+QU/qvwShG8uGqhCE
R9NSUJC8BFhfVOqAeYB5H0fNqm5+XhqjiDnhynVlmI5EAzH6LRDNQi2/swrqUZyb/I7GRpTc61Dv
e6RABXFL32xytt8Pnmy66nmMwudVtFgaHmyqD1rIykHUlGFL3652CUFPqC0ooEXxrkCSyMMbXn7d
gy0XerTfsUnwWwOYG5f9zBgoKWKb5AW3fCNbGEmhXtOkoOd2ncJVPCnxNLMTfQLsgLvWy6hqaBZf
QNRuFbTYfNKrPG9Ah+SSu2V3gGOqY8NkZuqZ8h+kc7BNNSgHmiMdoiwIGYmG+YQGgAAY/FmZweQx
mzu5y7froftMXYjhAD9JCf4K23wUPC89GsH0pasOpUjycp4bltIFVoADuhsF9kaHbGp/i3ugnTFb
OoA=
=Sy7r
-----END PGP SIGNATURE-----

--------------YEXdzTOglOf7CqsHIAVGndTG--
