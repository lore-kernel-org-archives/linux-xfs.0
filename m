Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:31007 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941402AbdDTILp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Apr 2017 04:11:45 -0400
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Subject: RE: [PATCH 0/5] fs, xfs refcount conversions
Date: Thu, 20 Apr 2017 08:11:41 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C8D726@IRSMSX102.ger.corp.intel.com>
References: <1488963219-11709-1-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1488963219-11709-1-git-send-email-elena.reshetova@intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "darrick.wong@oracle.com" <darrick.wong@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>


 
> v3:
>  * fixed header file inclusion

I don't think I have heard anything back on this v3 patch set. 
Is there still smth here to fix or could you take the changes in?

Best Regards,
Elena.

> 
> Now when new refcount_t type and API are finally merged
> (see include/linux/refcount.h), the following
> patches convert various refcounters in the xfs susystem from atomic_t
> to refcount_t. By doing this we prevent intentional or accidental
> underflows or overflows that can led to use-after-free vulnerabilities.
> 
> 
> Elena Reshetova (5):
>   fs, xfs: convert xfs_bui_log_item.bui_refcount from atomic_t to
>     refcount_t
>   fs, xfs: convert xfs_efi_log_item.efi_refcount from atomic_t to
>     refcount_t
>   fs, xfs: convert xlog_ticket.t_ref from atomic_t to refcount_t
>   fs, xfs: convert xfs_cui_log_item.cui_refcount from atomic_t to
>     refcount_t
>   fs, xfs: convert xfs_rui_log_item.rui_refcount from atomic_t to
>     refcount_t
> 
>  fs/xfs/xfs_bmap_item.c     |  4 ++--
>  fs/xfs/xfs_bmap_item.h     |  2 +-
>  fs/xfs/xfs_extfree_item.c  |  4 ++--
>  fs/xfs/xfs_extfree_item.h  |  2 +-
>  fs/xfs/xfs_linux.h         |  1 +
>  fs/xfs/xfs_log.c           | 10 +++++-----
>  fs/xfs/xfs_log_priv.h      |  2 +-
>  fs/xfs/xfs_refcount_item.c |  4 ++--
>  fs/xfs/xfs_refcount_item.h |  2 +-
>  fs/xfs/xfs_rmap_item.c     |  4 ++--
>  fs/xfs/xfs_rmap_item.h     |  2 +-
>  11 files changed, 19 insertions(+), 18 deletions(-)
> 
> --
> 2.7.4

