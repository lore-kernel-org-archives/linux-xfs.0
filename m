Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0AE457F5E
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 14:02:14 -0500 (CDT)
Message-ID: <520BD459.1040500@sgi.com>
Date: Wed, 14 Aug 2013 14:02:49 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfsprogs: Remove incore use of XFS_OQUOTA_ENFD and
	XFS_OQUOTA_CHKD
References: <1375385101-3673-1-git-send-email-sekharan@us.ibm.com>
	<1375385101-3673-2-git-send-email-sekharan@us.ibm.com>
In-Reply-To: <1375385101-3673-2-git-send-email-sekharan@us.ibm.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On 08/01/2013 02:25 PM, Chandra Seetharaman wrote:
> Remove incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD. Instead,
> start using XFS_GQUOTA_.* XFS_PQUOTA_.* counterparts.
>
> On disk version still uses XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD.
>
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> ---
>   db/check.c          |    8 +++---
>   include/xfs_quota.h |   59 ++++++++++++++++++++++++++------------------------
>   libxfs/xfs_mount.c  |   52 ++++++++++++++++++++++++++++++++++++++++++++
>   repair/versions.c   |   18 +++------------
>   repair/xfs_repair.c |    5 +--
>   5 files changed, 93 insertions(+), 49 deletions(-)
>

Looks good.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
