Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45326 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755690AbeEaQdr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 May 2018 12:33:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4VGVaPg039122
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 16:33:46 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2j9x4hctsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 16:33:46 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w4VGXkeX015183
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 16:33:46 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w4VGXj20001719
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 16:33:45 GMT
Subject: [PATCH 0/4] xfs-4.18: fix rtdev programming errors
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 31 May 2018 09:33:44 -0700
Message-ID: <152778442467.6891.15278589749191666547.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This is a fairly short series to fix some problems I found while playing
with the realtime device on a SMR drive with one rt extent per zone.
The first three patches fix various programming mistakes, and the fourth
one deals with unit analysis confusion in the rtalloc range query
functions, which only pop up if rextsize != 1.

Comments and questions are, as always, welcome.

--D
