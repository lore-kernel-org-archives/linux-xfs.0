Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41094 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389961AbfBMU6H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Feb 2019 15:58:07 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1DKsKeI145960
        for <linux-xfs@vger.kernel.org>; Wed, 13 Feb 2019 20:58:06 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2qhrekmdrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Feb 2019 20:58:06 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1DKw5nR000671
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Feb 2019 20:58:05 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1DKw5Tn030907
        for <linux-xfs@vger.kernel.org>; Wed, 13 Feb 2019 20:58:05 GMT
Date: Wed, 13 Feb 2019 12:58:04 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/3] xfs: don't overflow xattr listent buffer
Message-ID: <20190213205804.GE32253@magnolia>
References: <155009104740.32028.193157199378698979.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155009104740.32028.193157199378698979.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Bah, I forgot to send the cover letter.  Oh well.

xfs: various fixes

The first patch fixes a memory corruption that syzkaller found in the
attr listent code; see "generic: posix acl extended attribute memory
corruption test" for the relevant regression test.

Patches 2 fixes problems found in XFS's unlinked inode recovery code
that were unearthed by some new testcases.  We're logging nlink==1 temp
files on the iunlinked list (and then the vfs sets nlink to 0 without
telling us) which means that we leak them in recovery if we crash
immediately after the committing the creation of the temp file.

Patch 3 fixes the problem that ifree during recovery can expand the
finobt but we need to force the ifree code to reserve blocks for the
transaction because perag reservations aren't set up yet.

See "[PATCH v2 2/2] generic: check the behavior of programs opening a
lot of O_TMPFILE files" for the regression test.

--D
