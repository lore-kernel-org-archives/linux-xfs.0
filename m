Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57158 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754575AbeARAHO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jan 2018 19:07:14 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0I06vst165865
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2018 00:07:13 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2fjcsch4r4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2018 00:07:13 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0I07CD9010521
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2018 00:07:12 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0I07CBP017262
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2018 00:07:12 GMT
Subject: [RFC 0/5] xfs-4.17: fix v5 AGFL wrapping
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 17 Jan 2018 16:07:11 -0800
Message-ID: <151623403113.4727.2418454911805718650.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here's a bunch of patches fixing the AGFL padding problem once and for
all.  When the v5 disk format was rolled out, the AGFL header definition
had a different padding size on 32-bit vs 64-bit systems, with the
result that XFS_AGFL_SIZE reports different maximum lengths depending on
the compiler.  In Linux 4.5 we fixed the structure definition, but this
has lead to sporadic corruption reports on filesystems that were
unmounted with a pre-4.5 kernel and a wrapped AGFL and then remounted on
a 4.5+ kernel.

To deal with these corruption problems, we introduce a new ROCOMPAT
feature bit to indicate that the AGFL has been scanned and guaranteed
not to wrap.  We then amend the mounting code to find broken wrapping,
fix the wrapping, and (unconditionally) set the new ROCOMPAT flag.  This
totally blows since old kernels will no longer mount(!) the filesystem
after we do this, so either we need to have a massive upstream/LTS
kernel/xfsprogs flag day or find a less crappy solution.

No, this is NOT going into 4.16.

--D
