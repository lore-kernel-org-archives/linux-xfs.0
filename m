Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 02 May 2008 14:01:14 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m42L14NI021673
	for <xfs@oss.sgi.com>; Fri, 2 May 2008 14:01:07 -0700
Received: from ext.agami.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C8F29AEA96E
	for <xfs@oss.sgi.com>; Fri,  2 May 2008 14:01:48 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177]) by cuda.sgi.com with ESMTP id 9bgRNDMkLEOhzSG6 for <xfs@oss.sgi.com>; Fri, 02 May 2008 14:01:48 -0700 (PDT)
Received: from agami.com (mail [192.168.168.5])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id m42L1PO8023171
	for <xfs@oss.sgi.com>; Fri, 2 May 2008 14:01:25 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id m42L1P1u016883
	for <xfs@oss.sgi.com>; Fri, 2 May 2008 14:01:25 -0700
MIME-Version: 1.0
Subject: question about xfs_alloc_fix_freelist()
Date: Fri, 2 May 2008 14:01:47 -0700
Message-ID: <038C959C13632143B902BE360CA5B58E3C552E@mx1.ddns.agami.com>
From: "Michael Nishimoto" <miken@agami.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


The following code can be found near the end of xfs_alloc_fix_freelist:

                if (targs.agbno == NULLAGBLOCK) {
                        if (flags & XFS_ALLOC_FLAG_FREEING)
                                break;
                        xfs_trans_brelse(tp, agflbp);
                        args->agbp = NULL;
                        return 0;
                }

Don't we need to release agbp too by calling xfs_trans_brelse(tp, agbp)?

   Michael



[[HTML alternate version deleted]]
