Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55894 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfDOCHo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 Apr 2019 22:07:44 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3F24QN0156414
        for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2019 02:07:43 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2ru59cv4bu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2019 02:07:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3F26JXP117231
        for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2019 02:07:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2rubq5g25q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2019 02:07:41 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3F27fNg013210
        for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2019 02:07:41 GMT
Subject: [PATCH v2 0/3] xfs: merged io completions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 14 Apr 2019 19:07:42 -0700
Message-ID: <155529406249.243484.1307333973877627694.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here's a quick patchset reworking writeback ioend completion processing
into per-inode completion queues so that we don't have a thundering herd
of unwritten/cow completion kworkers contending for the ILOCK that then
tie up log reservation space and cause deadlocks.  The third patch
combines adjacent ioends when possible to reduce the overhead further.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=merged-completions
