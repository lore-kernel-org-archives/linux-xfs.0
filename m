Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 28 Sep 2008 18:22:50 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8T1Mkwa015659
	for <xfs@oss.sgi.com>; Sun, 28 Sep 2008 18:22:46 -0700
Message-ID: <48E02E3D.3000104@sgi.com>
Date: Mon, 29 Sep 2008 11:24:13 +1000
From: Peter Leckie <pleckie@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Clean up dquot pincount code
References: <48DC6102.2040602@sgi.com>
In-Reply-To: <48DC6102.2040602@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, xfs-dev <xfs-dev@sgi.com>

This is a fix for patch " Clean up dquot pincount code"
which introduced a build breakage due to a missing & in
xfs_qm_dquot_logitem_pin.


Signed-off-by: Peter Leckie <pleckie@sgi.com>

Index: 2.6.x-xfs/fs/xfs/quota/xfs_dquot_item.c
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/quota/xfs_dquot_item.c
+++ 2.6.x-xfs/fs/xfs/quota/xfs_dquot_item.c
@@ -96,7 +96,7 @@ xfs_qm_dquot_logitem_pin(
        xfs_dquot_t *dqp = logitem->qli_dquot;

        ASSERT(XFS_DQ_IS_LOCKED(dqp));
-       atomic_inc(dqp->q_pincount);
+       atomic_inc(&dqp->q_pincount);
 }

 /*
