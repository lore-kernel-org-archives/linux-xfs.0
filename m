Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:38168 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbeLVCQd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Dec 2018 21:16:33 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wBM2EqIP164452
        for <linux-xfs@vger.kernel.org>; Sat, 22 Dec 2018 02:16:32 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2phasdg438-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 22 Dec 2018 02:16:32 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wBM2GPpo005440
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 22 Dec 2018 02:16:26 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wBM2GPEj017761
        for <linux-xfs@vger.kernel.org>; Sat, 22 Dec 2018 02:16:25 GMT
Date: Fri, 21 Dec 2018 18:16:24 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [DONOTUSE] xfs and stable kernels
Message-ID: <20181222021624.GF27208@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

Hi folks,

The 4.19.11 and 4.19.12 kernels include a patch from 4.20-rc6 that is
defective and causes memory corruption.  The patch was reverted upstream
and will not appear in 4.20, but is still present in the 4.19 series.

Stable kernels are quick to include upstream patches to core code that
have not had the time to soak for a couple of weeks for assessment of
the tree-wide impacts.  Unless you are doing your own stable kernel QA
on fstests & your own workloads, we do not recommend using stable kernels
at this time.

--D
