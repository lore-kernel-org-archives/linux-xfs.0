Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:60000 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727161AbeGaFdv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jul 2018 01:33:51 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6V3sOeK010185
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jul 2018 03:55:40 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2kge0cy7hd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jul 2018 03:55:39 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w6V3tdHw009329
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jul 2018 03:55:39 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6V3tcN8000808
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jul 2018 03:55:39 GMT
Subject: [PATCH v2 0/4] xfs-4.19: superblock verifier cleanups
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 30 Jul 2018 20:55:37 -0700
Message-ID: <153300933773.5164.7520087911614107147.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This series refactors the superblock verification routines into three
predicates: one to handle checks that are only done at read time,
another for write time checks, and a third for checks common to both.
We then add some sanity checks for the summary counters to the write
verifier (a reworked version of Bill O'Donnell's earlier patch), and end
by addding a verifier for inode counts and adding that into the
superblock write checks.  A fourth patch adds feature bit sanity checks
for the write verifier.

Comments and questions are, as always, welcome.

--D
