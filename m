Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48516 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752387AbdLHDjO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Dec 2017 22:39:14 -0500
Subject: [PATCH 0/5] xfs: logging fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 07 Dec 2017 19:38:57 -0800
Message-ID: <151270433736.12194.14709247629624139846.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, libor.klepac@bcom.cz, bfoster@redhat.com, alex@zadarastorage.com, david@fromorbit.com

Hi all,

Here's a rollup of all the logging fixes that I've accumulated over the
past couple of weeks.  The first pair of patches adds the ability to
maintain a buffer lock across xfs_defer_finish and amends the xattr
shortform -> leaf conversion to take advantage of this (so the AIL won't
be able to write out a half-baked buffer).  The last three patches fix
the rmap recovery problems that Brian discovered -- incorrect ordering
of deferred rmap ops and confused handling of OWN_UNKNOWN/OWN_NULL rmap
updates.

--D
