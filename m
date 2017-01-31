Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39882 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754574AbdAaAXH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jan 2017 19:23:07 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v0V0N6su017302
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jan 2017 00:23:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v0V0N5KW026038
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jan 2017 00:23:06 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v0V0N52C001863
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jan 2017 00:23:05 GMT
Subject: [PATCH 0/7] xfs: random fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 30 Jan 2017 16:23:04 -0800
Message-ID: <148582218411.12293.806854574193653038.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here are some fixes for various hangs and crashes I've seen while
running the field-fuzzing xfstests.  I'm aiming for 4.11 for these.
So far they don't seem to cause any auto group regressions.

--Darrick
