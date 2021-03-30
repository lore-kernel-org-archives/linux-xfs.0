Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 274D2C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 14:26:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE121619D6
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 14:26:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbhC3OZr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 10:25:47 -0400
Received: from sonic306-20.consmr.mail.gq1.yahoo.com ([98.137.68.83]:45379
        "EHLO sonic306-20.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231906AbhC3OZl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Mar 2021 10:25:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1617114341; bh=eUyVL5y4zGnTAzWF/zUmu0sEvjMsHVDUSmOANf6bzpk=; h=From:To:Cc:Subject:Date:References:From:Subject:Reply-To; b=lwNXTi32VQpyQ/w7znaegSrCW1mwNvl63kDO9yYrnckIK8LKAONY5N5iU8F7sRbdSbLAnjbpKkiivZbWp7Gs0c66Tg0Gdvwm1lHF9DorEXT1tfSFu5paLyJRqQVzkr+rg8Of+KKyCkz49Ycy3c1dTFktZlH72n3e+wiD1gEDD/LIkwcmPQ1D8koh82ePtW1qs3hiLs8DEo3zpq59t9HDh4mf2ksZi+P/Rx3/HR9tc0Jlmf0U4IMzGCwB4VVXGKi+ofRVsWoLJbUwV2hAjxhxg6xVwBhhQz/nO/cvp5wj05nEYqTKWINHXgFRKHeeIl0nPdNOqrbc9kvDo2BEmeBYDQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1617114341; bh=etj9OJqVFAoeDUopf0RWIOeRuFUkeMs6GrWsxBVnLo4=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=WXu4HSWi3VQvM33nNWumX6JOmkkNRJbsB1wQyCKHNGnSEFpQEbbtnXD9NV6Zugsa2zTLduIIqDO3ck5ZJJi1uXcT/Vb8dOHGvfUUNCpOIVHgtuLFo6UkFvgUTalUT5V9gL9p6R+huQCHOuC+kj+5Rab/pEVLdR9e7dD5QYhaV87Q46LtXIC7pXxBjghjfb0vNMz0dFO2qu0/BwFgryfXchUuY0iFzuWwYCcnCE2cuhk8mCOKLzb2UIFfmlBe+PpsKGsX/3WsLaf+ggsyplZtIlY9jnifmrfVRTldD5Q7bloFgKIyElN7e2J/GyK+1Fa2hFx0P64aVez4kkEE20qBEQ==
X-YMail-OSG: Yl7AxH0VM1nRdZD_bTQVuZpxEcfp4C1ODY.9ZmQCy45mCvFebojUGkUBjQks2oX
 9asGf_w8j6m2qgsmeyzZFjoM0W9Bq2ELIXF6dZrcvlfxIP.LKG3rvDZY91qCOljVG2j_UJIera4R
 w5ERXrv1em.VBUrGtZ_Ter4vIhqXRvp_bLACcon7lxu4IFBMhImF1uJEXWN4fJs6LNKfO5I_U9VW
 SJjm7bwAKbQX_0QlBIazy1p2czjiX_lmMEz2NpChnmuMP4Ee.dXTjCoBXnoE5n0XMXVy2kqZGwCy
 SJMIUL913YyC5fTZT3yrj68EEhcphnDJkaVwFu.Hz7TcT7UR8cZoEsH..nMULlfZnlsqX3eg0zkx
 KurhFrnRowbwLQbR7c9pw6KCgg0Kz3gbr1zHc.1ly6dHIxe8SdGOhL8MDe6M16sJNxP3v3fJTF6M
 i_30RNpMQxD61T.hEu0PlQHAgmWzBp_olVOYoIpn_U3.np7lUvM.aqnpGAMkSYPojig3kDcSQx..
 0dlr0A_y5IXdT6zeItUUE_QN1oq15.C43nDNjMcIs_f6LaZDViEOUhmRv5FNaZMAqgod6YHyB.yW
 gt1sLC7EIM467yBx7L97iG41TTIkaY_YGa_Msw8wlDQF536MjS_qOGQJOcPtdwKAWyQdJE93sAx9
 na4yHuVoZQNDTPkmSYsRVBhQAr26a0BHKfrU0d4TYmC5C1tf98IdlaPdV.OA0PA5G0itekuGJ3P5
 ksIIHZQqUtBL0SwwrOrmgVs7AuTMye6fkDXtl9IphPQHQZYx.KkWTpf5HrM.VH_5ISVAuTQQb9k3
 60Aehwf2ElJ0Y3sa5lCGxChngZ.uguFVV6.FPFlkmi7Hs1_wASf5Z4RkcsxYCNMsq6vqN0pBCuVh
 .BZg9V.4lzE4HAz0oBmhZzv4QLLlhn5.2dfUocSHyGLSn9M7CNzI45pvYazDyPiVSkyuQU.LmpX6
 JXawDel_VBNlpL1YYqdDaiiSVExa02VQNp89yM2DEWSkAU9.u431m_JD0.Xy5i1h84wTHiYLJbT0
 0ziRkW2eEOqLMh4YAwm5oWlInHLTKwjZ7QjYQeIAOmmKbvM.sX.B_AlJYZSuYGhgRfinyTo0kTfP
 zwvL640BPKaOJYb5AnV0IlvjzyaJHpY4qQugw5MiHO3CsCqg2XwQHv5XyLGfD7lNUqmXZAhItPao
 Rydj5Gi.wJ1RSLxkScdUfR_aK6lr2gZoRqtvUz0tG7vU_IdlR2gwW4zMQFo.n2Dn7rPlo.aoqY8F
 qWYM_R_tg2ZhK6aJlRPz6y2iOhS2s_6HiXBq8j1Cd_jAQrx50a.SK687OYhatzGiMW2QFCrSbOCh
 ShTXPHFodd5Bt5qs3ZeA46vp8LYez7PZrvkazNYbP3A4wOWIAS3WlY2OuDuFpc9aVtC6Z3qxMyXv
 32XpzPvdBzhS5rVF0vhYnSIkluXrdKYdRFbNVuzNtQ6NyvxQwoKRrVY1KDwvLjXhnG7opLvckK9x
 BT5vsycSiGnrjhhWKgYXClc5OCDPNC4JOHTW350wYLvQ53vLy2.96ioQaj6p0qYm7C2yfZ5uCu_7
 NG9dOwfAlKfLnioTrSeNvhBgbruY.FwW2S96qpHjPHfd_fQSyr9mB3N0VkNqOvcmtL46cvQM1Hui
 AlrAtgPc.EKv5m1I78bb0AffrKH9AaoeklRpD71i.bDYXJCxWxjrUW6JuVYzUJVxfptYybf7o2c3
 k2_Evb4azbBbKIJDiNjYYEPj0pfUl.YqV4azMVQWCuhi_63P8.ytgD9RRJ234pt7JmUl9Zja1es3
 IdQJKap9jgkuvkv2TkVekDsCovYPYRzVG1YlXsvwsu1C6bDRZp484G7hFPK9sE.GbYuuNB0rD9s8
 i97lRY.aWHChrMd7lYfrIQSc5yG0va1l8OGTaYpk.69.VXAQIX5tLkZRzZfYDBj14JtERco0S66S
 a7HqbIC4qxLPHIho2QhfwFgmJ9rDyByPDfP8YiNnzR07ldI.GKoXpAhPd0Dt4GCJVwcZgRItrgm3
 ZsysUYW8qPDeIseOSu1A4DKYgN9DJbVXv5lTAAI.RxncuzyhY9d_7MmODyiKVqWa0UKYIKrKdUos
 3rvFFTImTDMT0LH4dQls7ZoCFX6XXDw7oeK3n9ANIlSJeDsXYiDdiAs5Nq3eJUrDrGebf51y3aeL
 CBwEkRwkxqTwdB3PUw4ooD8iHlpnwkCUTUNg2ydG8wnbEUNt8v8x8wvKk.eUHVMOzcTKMWecmA6T
 DVfzrC5dZlugZ2JAoHGxKZWbHoaW_Kz.M8qHgTvQNkQX_pugAOEpWGkrC_ZtcmiAP_w9XU8pEQHE
 Y4qt21jQdhLObvo5fv2B59lwudrpSejUxY_WPeVNOhv6tek24160G8lBSpHjq3MPBf6eNmZRn88G
 4Hyjm7HvsAieXMB2v6QJhbjrWYx.KzXVye3HCPYoW6Ypsv4AdPoMMRSirBk23Vh_u9hUBWIs7l.f
 X4YRJMlPqWZsfYY7W1uDH_4BubmPevzP7mH7dIVDJGUtppqQp6QrqzCfsMIiR133tPvYuS1t_zNX
 Vs64VBAFig2Cy0UnjWo8.B0y2QoWORr8-
X-Sonic-MF: <hsiangkao@aol.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.gq1.yahoo.com with HTTP; Tue, 30 Mar 2021 14:25:41 +0000
Received: by kubenode575.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID d17ac850f756223f45b54c36ad526fbe;
          Tue, 30 Mar 2021 14:25:39 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     linux-xfs@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v3 0/8] repair: Phase 6 performance improvements
Date:   Tue, 30 Mar 2021 22:25:23 +0800
Message-Id: <20210330142531.19809-1-hsiangkao@aol.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20210330142531.19809-1-hsiangkao.ref@aol.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

Hi folks,

This version addresses comments except for some points I mentioned in
https://lore.kernel.org/r/20210324012655.GA2245176@xiangao.remote.csb

since I don't have such test setting, I just ran fstests and it
seems fine.. Hopefully of some help to this patchset and I don't
miss something.

Changelog since v2:
 - support multiple producers suggested by Darrick;
 - turn bad inode list into array, although no bulk allocation yet,
   and not sure if it'd help (Christoph);
 - use namebuf[] instead of pointer arithmetics (Christoph);

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

Gao Xiang (1):
  repair: turn bad inode list into array

 libfrog/radix-tree.c |  46 +++++
 libfrog/workqueue.c  |  42 ++++-
 libfrog/workqueue.h  |   4 +
 repair/dir2.c        |  43 +++--
 repair/dir2.h        |   2 +-
 repair/incore.h      |  23 +++
 repair/incore_ino.c  |  15 ++
 repair/phase6.c      | 395 +++++++++++++++++++++----------------------
 8 files changed, 343 insertions(+), 227 deletions(-)

-- 
2.20.1

