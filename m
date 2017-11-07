Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34558 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932605AbdKGBDX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2017 20:03:23 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA713NFw030141
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2017 01:03:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vA713MEj003927
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2017 01:03:22 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vA713M0H016277
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2017 01:03:22 GMT
Subject: [PATCH 0/5] xfs: various 4.15 scrub fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 06 Nov 2017 17:03:21 -0800
Message-ID: <151001660179.26786.15701876786383794673.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here are a few more online scrub patches that I would like to include
for 4.15.  The first patch fixes a problem where we failed to detect
duplicate block pointers in the AGFL; it's the same patch I sent solo
last week.  The four that come after it fix most of the smatch and
sparse complaints that came up over the weekend.

(smatch still complains about a check-after-use error in dabtree.c, but
I've yet to figure that one out...)

--Darrick
