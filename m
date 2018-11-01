Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58094 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726129AbeKBBuS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Nov 2018 21:50:18 -0400
Subject: Re: [PATCH 1/2] xfsdump: remove trailing whitespaces
References: <20181101110130.19489-1-jtulak@redhat.com>
 <20181101110130.19489-2-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <4b0ac83d-bdd0-644e-113e-eff94d5b43fe@sandeen.net>
Date: Thu, 1 Nov 2018 11:46:32 -0500
MIME-Version: 1.0
In-Reply-To: <20181101110130.19489-2-jtulak@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On 11/1/18 6:01 AM, Jan Tulak wrote:
> There were many trailing whitespaces through the whole code. As the rate
> of changes in xfsdump is low, it should not cause trouble if we fix it
> in all files at once and avoid issues (unintended changes) with sensibly
> configured editors that automatically remove these on a file save.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

Looks fine, this always bugged me.  ;)

seems like truly nothing but trailing ws changes:

# grep " $" jtulak-ws1  | grep -v "^\-" | grep -v "^ "
#

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

(haven't seen PATCH 2/2 yet tho)

> ---
>  common/arch_xlate.c     |  24 +--
>  common/cleanup.c        |   2 +-
>  common/cleanup.h        |   2 +-
>  common/content.h        |   2 +-
>  common/content_inode.h  |   4 +-
>  common/dlog.c           |   2 +-
>  common/drive.c          |  12 +-
>  common/drive.h          |   8 +-
>  common/drive_minrmt.c   |  60 +++----
>  common/drive_scsitape.c |  71 ++++-----
>  common/drive_simple.c   |  10 +-
>  common/global.c         |   6 +-
>  common/global.h         |   4 +-
>  common/hsmapi.c         |   2 +-
>  common/inventory.c      | 120 +++++++-------
>  common/inventory.h      |  46 +++---
>  common/main.c           |  20 +--
>  common/media.c          |   4 +-
>  common/media_rmvtape.h  |   2 +-
>  common/mlog.c           |  16 +-
>  common/mlog.h           |   2 +-
>  common/qlock.c          |  10 +-
>  common/rec_hdr.h        |   2 +-
>  common/ring.c           |   4 +-
>  common/ring.h           |   2 +-
>  common/stream.c         |   2 +-
>  common/ts_mtio.h        |  60 +++----
>  common/types.h          |   2 +-
>  common/util.c           |   8 +-
>  common/util.h           |   2 +-
>  dump/content.c          |  84 +++++-----
>  dump/inomap.c           |   6 +-
>  inventory/inv_api.c     | 198 +++++++++++------------
>  inventory/inv_core.c    |  32 ++--
>  inventory/inv_fstab.c   |  58 +++----
>  inventory/inv_idx.c     | 129 ++++++++-------
>  inventory/inv_mgr.c     | 115 +++++++-------
>  inventory/inv_oref.c    |  98 ++++++------
>  inventory/inv_oref.h    |  12 +-
>  inventory/inv_priv.h    |  64 ++++----
>  inventory/inv_stobj.c   | 344 ++++++++++++++++++++--------------------
>  inventory/inventory.h   |  64 ++++----
>  inventory/testmain.c    |  81 +++++-----
>  invutil/fstab.c         |   6 +-
>  invutil/invidx.c        |  50 +++---
>  invutil/invutil.c       |  57 ++++---
>  invutil/list.h          |   1 -
>  invutil/menu.c          |   8 +-
>  invutil/screen.c        |   2 +-
>  invutil/stobj.c         |   6 +-
>  librmt/rmtaccess.c      |   2 -
>  librmt/rmtclose.c       |   2 -
>  librmt/rmtcommand.c     |   3 -
>  librmt/rmtcreat.c       |   2 -
>  librmt/rmtdev.c         |   2 -
>  librmt/rmtioctl.c       |  34 ++--
>  librmt/rmtlib.h         |   2 +-
>  librmt/rmtlseek.c       |   2 -
>  librmt/rmtstatus.c      |   3 -
>  restore/bag.c           |   2 +-
>  restore/content.c       | 110 ++++++-------
>  restore/dirattr.c       |   4 +-
>  restore/inomap.c        |   2 +-
>  restore/namreg.c        |   4 +-
>  restore/node.c          |   2 +-
>  restore/tree.c          |  62 ++++----
>  66 files changed, 1069 insertions(+), 1095 deletions(-)
> 
