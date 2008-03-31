Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 31 Mar 2008 16:32:35 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2VNWMcQ028298
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2008 16:32:28 -0700
Received: from ext.agami.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4A07671BBEF
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2008 16:32:59 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177]) by cuda.sgi.com with ESMTP id DQ5ttPpR1iKxF9gc for <xfs@oss.sgi.com>; Mon, 31 Mar 2008 16:32:59 -0700 (PDT)
Received: from agami.com (mail [192.168.168.5])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id m2VMj62L019621
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2008 15:45:06 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id m2VMj6wB006571
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2008 15:45:06 -0700
Message-ID: <47F16988.2080406@agami.com>
Date: Mon, 31 Mar 2008 15:45:28 -0700
From: Michael Nishimoto <miken@agami.com>
MIME-Version: 1.0
Subject: Definition of XFS_DQUOT_LOGRES()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: XFS Mailing List <xfs@oss.sgi.com>

The comment for XFS_DQUOT_LOGRES states that we need to reserve space
for 3 dquots.  I can't figure out why we need to add this amount to *all*
operations and why this amount wasn't added after doing a runtime
quotaon check.

Comments?

     Michael

/*
  * In the worst case, when both user and group quotas are on,
  * we can have a max of three dquots changing in a single transaction.
  */
#define XFS_DQUOT_LOGRES(mp)    (sizeof(xfs_disk_dquot_t) * 3)
