Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:56290 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbfHIViR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:38:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LZ7nE093158
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:15 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2u8hasj99t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LNLMX071982
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2u8x9fxk86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:15 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x79LcERJ002112
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:14 GMT
From: Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH v1 00/19] Delayed Attributes
Date: Fri,  9 Aug 2019 14:37:45 -0700
Message-Id: <20190809213804.32628-1-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This set applies the corresponding changes for delayed attributes to xfsprogs.  
The goal of the set is to provide basic utilities to replay and print the new
attribute log entries.

The first 18 patches synchronize libxfs with changes seen the kernel space
patches. The last patch adds routines for journal replay and printing. I will 
pick up the reviews from the kernel side series and mirror them here.  

Thanks all!
Allison

Allison Collins (18):
  xfsprogs: Remove all strlen in all xfs_attr_* functions for attr
    names.
  xfsprog: Replace attribute parameters with struct xfs_name
  xfsprogs: Set up infastructure for deferred attribute operations
  xfsprogs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
  xfsprogs: Add xfs_has_attr and subroutines
  xfsprogs: Factor out new helper functions xfs_attr_rmtval_set
  xfsprogs: Factor up trans handling in xfs_attr3_leaf_flipflags
  xfsprogs: Factor out xfs_attr_leaf_addname helper
  xfsprogs: Factor up commit from xfs_attr_try_sf_addname
  xfsprogs: Factor up trans roll from xfs_attr3_leaf_setflag
  xfsprogs: Add xfs_attr3_leaf helper functions
  xfsprogs: Factor out xfs_attr_rmtval_remove_value
  xfsprogs: Factor up trans roll in xfs_attr3_leaf_clearflag
  xfsprogs: Add delay context to xfs_da_args
  xfsprogs: Add delayed attribute routines
  xfsprogs: Roll delayed attr operations by returning EAGAIN
  xfsprogs: Enable delayed attributes
  xfsprogs: Add delayed attributes error tag

Allison Henderson (1):
  xfsprogs: Add log item printing for ATTRI and ATTRD

 db/attrset.c             |   13 +-
 io/inject.c              |    1 +
 libxfs/defer_item.c      |  174 ++++++-
 libxfs/libxfs_priv.h     |   12 +-
 libxfs/xfs_attr.c        | 1145 +++++++++++++++++++++++++++++++++++++++++-----
 libxfs/xfs_attr.h        |   49 +-
 libxfs/xfs_attr_leaf.c   |  167 +++++--
 libxfs/xfs_attr_leaf.h   |    4 +
 libxfs/xfs_attr_remote.c |   98 +++-
 libxfs/xfs_attr_remote.h |    5 +-
 libxfs/xfs_da_btree.h    |   23 +
 libxfs/xfs_defer.c       |    1 +
 libxfs/xfs_defer.h       |    3 +
 libxfs/xfs_errortag.h    |    4 +-
 libxfs/xfs_log_format.h  |   44 +-
 libxfs/xfs_types.h       |    1 +
 logprint/log_misc.c      |   31 +-
 logprint/log_print_all.c |   12 +
 logprint/log_redo.c      |  189 ++++++++
 logprint/logprint.h      |    7 +
 20 files changed, 1783 insertions(+), 200 deletions(-)

-- 
2.7.4
