Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27433 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751052AbdGaVG4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Jul 2017 17:06:56 -0400
Subject: [PATCH 0/7] xfsprogs: 4.13 rollup
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Jul 2017 14:06:46 -0700
Message-ID: <150153520589.26081.8786864874176090813.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here are a few patches I have for xfsprogs 4.13.  The first two continue
some cleanups we did in libxfs, and a fix for 4.12's metadump stdout
switcheroo.  The next two are patches to xfs_db to enable dumping and
writing of directory and attribute block fields.  Finally, introduce the
fuzz command that enables us to do easy fuzz testing of XFS metadata.

--Darrick
