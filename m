Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28608 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751460AbdJZWO7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 18:14:59 -0400
Subject: [PATCH 00/10] xfsprogs: 4.14 rollup
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 26 Oct 2017 15:14:47 -0700
Message-ID: <150905608689.28563.9670731739870415773.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here is a rollup of everything I still have queued for xfsprogs 4.14.
This rollup supersedes all the previous xfsprogs patches I've sent,
though the first three patches in this series haven't changed since
then.

The first six patches fix various bugs I found while testing metadump
and repair.  The middle three patches enable developers to turn on the
undefined behavior sanitizer, the address sanitizer, and the thread
sanitizer that are now in gcc.  The last patch fixes some ubsan
problems.

--D
