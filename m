Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC25CC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 06:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 878BE61963
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 06:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbhCaGCB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 Mar 2021 02:02:01 -0400
Received: from sonic307-54.consmr.mail.gq1.yahoo.com ([98.137.64.30]:41940
        "EHLO sonic307-54.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233708AbhCaGB2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Mar 2021 02:01:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1617170488; bh=91VNpc7UTdmVIXsiJAS9kY5zqN6CR1bKOOSIwifQP3k=; h=From:To:Cc:Subject:Date:References:From:Subject:Reply-To; b=RnU84/tSXYtcMCDuaw1z/BmKGVQZ4z+0P1UZ6yUoDvFM42p59yOfZqnf5lkv3nqfo3VvLZOrqJF84dEm3xOdO9IZI3xz6k3pwaPjFqt/tNgMFfkEZu7rln+kC4HwSzS0SK5uMxrNeQwfjvG5KpL2UDesjZorTd0tQbteA5iKfTmmeoXhmANbvmnR6E8bNOIOqfoIRi/cUqikqssZJu+oLQ9wF+mlOklYAI8Hdy2il+/s8sTG2wcqYGa+48Yvb4GeVo4hV7xSpAkiTyTuSCCZNqhIQEapYbtC/eJZ/Rw2y/Vvfam9/cRpKShPdjTGiCm2N/Pl7vkO7qka27BGh5QFTQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1617170488; bh=/N1+HHvJDyZ8g3jJW8WXTJlvszTTaucrRDHGKWKYBdx=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=hvpiMPn55ktBrrT0/SmO7RPRfky3+oekpfm43sZm/BFx7Z6cVYdqYywaQhLNXSLFQIGFoM0wFoXy6LymW0BKdCz/jnhiKW7o8+DiYJjM0wKojgpiyPnUSj0h6GVj/0W2D7nCgGrDE4FSTTTVVBekgpCsyeyoq1zO3D4fii/6RWoHPWgp5HPJ6qz5tYa+Jjw/IwsArYJHCg2bCPrnr5dOOcXURXiuVXqpY9HHwU/Xk+lUNbCVoajZivY/BLlSLfuf+RGrjoFxmKk/tPkOKL6TEtgvNamii2oEBGkeM2KKk6zNAXyceaErKq0s89+/hOSD4cKklTVP1dEilDffy15huA==
X-YMail-OSG: dvf2L8QVM1mk6yTdN1dPgljJ0lwcgwhNUU2Nd_rN6loZA69FgGICGGqnrw80AuV
 42_S.sB_2pZHAO15vq6H2Vz4_HGGBmZRbib7rGu9H_dnv9xXbEe94q5fE9PsPaD95Q0TJE4ZHE69
 eSEANN_k3TVBATzuaXrLWrSfgR_n_1F9rva04oRk5dcW9KvtMKKkmFVGdbdSFn49Bc6DGE4n6c4T
 ulHxUYwOzshz2DM.S1uUljGXUhucJ30b_KpCqbkuJ.s_abZxktRvoPSt4eCQfPaJAfXoW_SJ.Du7
 o9Ft_uUijrq0Ja6SMbHJvZLN1UI7B0s3rrCuxGVXc7i2nrePjkKDM8qExSPRhN_9AC8H0poYasYD
 jDSSS51JGr_sDBpH9Z2ngvsow5m2wkHmtjOOxHxVU5R.vbuJgPmAZCk0hd6q0qY3amvsbNrwWv9a
 gy9Pb4dN5IQug5oS.pEILonZeYrpMxM00LdyPc9zd16ZTLFJEKmkaAgHxv4g7feKtEPsYFeJLswe
 MqDZfgUP8_8Nw9TYXWulP83jvkU20SkW9ITHNi15G7gZlH8ew27noAMkow.lmvJ2zQYciSQR.Rnw
 _B8fSD_eJ.PSh.ywh6Zn2EPmh2nOjJ2iDNNYMBd_qKppbDOEWJ6_JeD8oRqnevWq70xO6SXVYQMW
 Sxe.cCWIkx5qV56_6jmUBe0CWbgF0wuzsYacVyg7qigvEmOlIU2DHyk1ITZtJLT3TdgRmG73nBoZ
 IQ_LkErGMzsomktDLS.o2UhiCHRPYjSLCxuphcMqcLyjim783_f9OcwMVKqGKByyGnFy171cQcoC
 cC2Ui8DDXSg9B0R_P.fEp7Chsf6c57RdcdvX0tOd1qXAlK4RPNTREv6rXDeSWSoDtUSOZpYZWioa
 bDV1V7RniyJEAkT3qoRe99AUvG_a9pxf2iKdnoj5fPtYKIcLSizZU0CmjPnBKdjEMLXjEOyoImhf
 JBwkL4u1WxXFZ9xD7QnrdRDqRWCIJBTc1.clTFjouBqCWTK1E2n9T90ilmf5xkQRRZmIn4hrzH2D
 PJaWt8.6BKF4y7HrfbaJH0DAfzpJ5ZNI662xhH_v9nclKM1vSzHY7OgNPE40XaROQI615WjxxY1E
 1fMx2e9C_XlqsY7gccaMyWlMbde7FOfHrh5aWdLDbuT0ELzrg80Sy2NzJvouTohaLb_w0G1w7OZC
 vp35Nnot0dbDWDGbd8nGNUmmcLX.EoUIj2w_dbH1WG3phN8Xx7HsOh3Z3i0eaYzSaTeHYrgt5QgK
 bf6hflQGXwHfb3UWOeZjKAXr.2O71xTvcRxplozDe9QJCNzVFPV8Lh2tcuhDpsvv38D3zU8tdrQ_
 mk2cuKKo5rCbIKxjpLAHzqn9ZtMGffxD6nEONAi6myOVtTyl0RPS9XjYoMr0.0qyLuCNWerpjvF4
 UJdhAE3UOslKl13h6kbhXAPBBy9nridYi38FEvmj6HfD4blePx8297tH9XIb4khExdPqTGk4BqSv
 mAEO2C9rkmQsYIwePEuD6iNRQlPpDNQW.7_ulw23ASdVgRUoPJFIunFSqFtCt7bAfIhwbaEm1.ao
 B66BYaJx.5ttnnn46a2ozm0s5b4feP2oWLPgVGoySTogg.PIjLxh2oerubQ8bHgZllRou3uPalrw
 jiB89bQvsCNH3Y.yfOw9JxOdrZCmqoVkLSPbrLkeg4ZnS0c3x_6REim7cXH5F1BEWT5Gi3_vcimo
 p_WtSsQ38C_.iecLYUmaDuXwpv7rc7op2jjQ9y6BHpZlqFDnpocOfvPu9dqrBEpzbtWF7EKd43y1
 VzrivBBuB.NH1CJrasWHbEirY5aUTHlt3TjRoYGk7B5f90m4A9kfR_0DyclPA7Ok97mEU3YNdT5Q
 YIhZElBeAOi7JfPi3LVcPeXaN0K4c6z1bCuPX.GgDG9BsPSQ8G1gTgpVbvnIVQbkCXgBq5jLnEb2
 tPa8JwopCEEZJXlu8C.t4q9MQT2JEBXrZE3a8tl4SdzA7qZIQOz2FMy8D4HfnruxTGT2lZcDZiqo
 reCcXKErqe_ROLCpWqAjqaCmFZvwoaP0B61NCF7N71FxDQ7qI.w8YTL.lxNRdC6UrN8ZcGQhW9hC
 glQoE1f5KRXzkm65u1mNqgM4ToOcqWMYaEQrb6TXjmmGEpmNEe97ca2ytvtmhg7FfCS._JpnQVOD
 wd44nEzf99r01OvulhCxbUQLe0qLha4LgDAN.yKWFZMPTWFvYYRwSnprV2aN.FrYQw2to7DPdroY
 IeFZbClsipj5pb1wUJmoulEcHOPP.dWnG7RQMgvumHaTF94gS1ufkHDI29SiFzuFk2Kc2i_7gTBZ
 8EAc3tLy7CmXkWMJ1_Bzl7PbAoHyaQ84cfhBffNAM_NvHAQWExi8bVgj8Y2fa.vY6YJA0v.Bhox5
 FPQOhlXK3eYWeR9BnEWNFYjdQO7_3yAJyoH7wm9lrFaYLSM0lD_IN6IodrrN6iiTw2mUDfks22TS
 SCTuHY.7KkaKx0YmUP03QunYaXjub3SqRjHVKIfYn_NNLxd297TmjZv7mtl.QzG.qxJ1C2kvid.2
 qHRC4MvESja4hlH8zJrvuniSVCMtoITk-
X-Sonic-MF: <hsiangkao@aol.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.gq1.yahoo.com with HTTP; Wed, 31 Mar 2021 06:01:28 +0000
Received: by kubenode525.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 190a809d5456af9661811acc5a61b089;
          Wed, 31 Mar 2021 06:01:24 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     linux-xfs@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v4 0/7] repair: Phase 6 performance improvements
Date:   Wed, 31 Mar 2021 14:01:10 +0800
Message-Id: <20210331060117.28159-1-hsiangkao@aol.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20210331060117.28159-1-hsiangkao.ref@aol.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

Hi folks,

This version addresses previous comments mentioned in
https://lore.kernel.org/r/20210330142531.19809-1-hsiangkao@aol.com

Changelog since v3:
 - drop the modifications to the bad inode list suggested by Dave
   on IRC (since the patchset forms well, even AVL tree optimization
           is another story);
 - update a comment suggested by Darrick.

Original description:

Phase 6 is single threaded, processing a single AG at a time and a
single directory inode at a time.  Phase 6 if often IO latency bound
despite the prefetching it does, resulting in low disk utilisation
and high runtimes. The solution for this is the same as phase 3 and
4 - scan multiple AGs at once for directory inodes to process. This
patch set enables phase 6 to scan multiple AGS at once, and hence
requires concurrent updates of inode records as tehy can be accessed
and modified by multiple scanning threads now. We also need to
protect the bad inodes list from concurrent access and then we can
enable concurrent processing of directories.

However, directory entry checking and reconstruction can also be CPU
bound - large directories overwhelm the directory name hash
structures because the algorithms have poor scalability - one is O(n
+ n^2), another is O(n^2) when the number of dirents greatly
outsizes the hash table sizes. Hence we need to more than just
parallelise across AGs - we need to parallelise processing within
AGs so that a single large directory doesn't completely serialise
processing within an AG.  This is done by using bound-depth
workqueues to allow inode records to be processed asynchronously as
the inode records are fetched from disk.

Further, we need to fix the bad alogrithmic scalability of the in
memory directory tracking structures. This is done through a
combination of better structures and more appropriate dynamic size
choices.

The results on a filesystem with a single 10 million entry directory
containing 400MB of directory entry data is as follows:

v5.6.0 (Baseline)

       XFS_REPAIR Summary    Thu Oct 22 12:10:52 2020

Phase           Start           End             Duration
Phase 1:        10/22 12:06:41  10/22 12:06:41
Phase 2:        10/22 12:06:41  10/22 12:06:41
Phase 3:        10/22 12:06:41  10/22 12:07:00  19 seconds
Phase 4:        10/22 12:07:00  10/22 12:07:12  12 seconds
Phase 5:        10/22 12:07:12  10/22 12:07:13  1 second
Phase 6:        10/22 12:07:13  10/22 12:10:51  3 minutes, 38 seconds
Phase 7:        10/22 12:10:51  10/22 12:10:51

Total run time: 4 minutes, 10 seconds

real	4m11.151s
user	4m20.083s
sys	0m14.744s


5.9.0-rc1 + patchset:

        XFS_REPAIR Summary    Thu Oct 22 13:19:02 2020

Phase           Start           End             Duration
Phase 1:        10/22 13:18:09  10/22 13:18:09
Phase 2:        10/22 13:18:09  10/22 13:18:09
Phase 3:        10/22 13:18:09  10/22 13:18:31  22 seconds
Phase 4:        10/22 13:18:31  10/22 13:18:45  14 seconds
Phase 5:        10/22 13:18:45  10/22 13:18:45
Phase 6:        10/22 13:18:45  10/22 13:19:00  15 seconds
Phase 7:        10/22 13:19:00  10/22 13:19:00

Total run time: 51 seconds

real	0m52.375s
user	1m3.739s
sys	0m20.346s


Performance improvements on filesystems with small directories and
really fast storage are, at best, modest. The big improvements are
seen with either really large directories and/or relatively slow
devices that are IO latency bound and can benefit from having more
IO in flight at once.

Thanks,
Gao Xiang

Dave Chinner (7):
  workqueue: bound maximum queue depth
  repair: Protect bad inode list with mutex
  repair: protect inode chunk tree records with a mutex
  repair: parallelise phase 6
  repair: don't duplicate names in phase 6
  repair: convert the dir byaddr hash to a radix tree
  repair: scale duplicate name checking in phase 6.

 libfrog/radix-tree.c |  46 +++++
 libfrog/workqueue.c  |  42 ++++-
 libfrog/workqueue.h  |   4 +
 repair/dir2.c        |  34 ++--
 repair/dir2.h        |   2 +-
 repair/incore.h      |  23 +++
 repair/incore_ino.c  |  15 ++
 repair/phase6.c      | 395 +++++++++++++++++++++----------------------
 8 files changed, 339 insertions(+), 222 deletions(-)

-- 
2.20.1

