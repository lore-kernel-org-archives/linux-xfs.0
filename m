Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 21:22:52 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8Q4MgG5007792
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 21:22:43 -0700
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by relay2.corp.sgi.com (Postfix) with SMTP id 30106304106
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 21:24:14 -0700 (PDT)
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id OAA23821 for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 14:24:13 +1000
Date: Fri, 26 Sep 2008 14:28:05 +1000
Subject: [REVIEW] Check for valid agf_btreeblks with lazy counters enabled
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-ID: <op.uh2mo3zo3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Originally part of the libxfs/kernel sync up, the change to
xfs_alloc_read_agf() to check the agf_btreeblks value is less than
or equal to agf_length was unconditionally performed.

But, the actual implementation of maintaining agf_btreeblks
increments and decrements this regardless of whether lazy
counters are enabled or not. So, using a pre 2.6.23 filesystem
or a repaired one, this value could be anything.

So, in xfs_alloc_read_agf(), only validate agf_btreeblks if
lazy counters are in use.


--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -2272,6 +2272,9 @@ xfs_alloc_read_agf(
                 be32_to_cpu(agf->agf_flfirst) < XFS_AGFL_SIZE(mp) &&
                 be32_to_cpu(agf->agf_fllast) < XFS_AGFL_SIZE(mp) &&
                 be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp);
+       if (xfs_sb_version_haslazysbcount(&mp->m_sb))
+               agf_ok = agf_ok && be32_to_cpu(agf->agf_btreeblks) <=
+                                                
be32_to_cpu(agf->agf_length);
         if (unlikely(XFS_TEST_ERROR(!agf_ok, mp, XFS_ERRTAG_ALLOC_READ_AGF,
                         XFS_RANDOM_ALLOC_READ_AGF))) {
                 XFS_CORRUPTION_ERROR("xfs_alloc_read_agf",
@@ -2297,6 +2300,7 @@ xfs_alloc_read_agf(
  #ifdef DEBUG
         else if (!XFS_FORCED_SHUTDOWN(mp)) {
                 ASSERT(pag->pagf_freeblks ==  
be32_to_cpu(agf->agf_freeblks));
+               ASSERT(pag->pagf_btreeblks ==  
be32_to_cpu(agf->agf_btreeblks));
                 ASSERT(pag->pagf_flcount == be32_to_cpu(agf->agf_flcount));
                 ASSERT(pag->pagf_longest == be32_to_cpu(agf->agf_longest));
                 ASSERT(pag->pagf_levels[XFS_BTNUM_BNOi] ==
