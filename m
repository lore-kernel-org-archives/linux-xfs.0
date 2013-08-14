Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2D2177F6A
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 14:02:34 -0500 (CDT)
Message-ID: <520BD46C.20308@sgi.com>
Date: Wed, 14 Aug 2013 14:03:08 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfsprogs: Start using pquotaino from on-disk
	superblock
References: <1375385101-3673-1-git-send-email-sekharan@us.ibm.com>
	<1375385101-3673-3-git-send-email-sekharan@us.ibm.com>
In-Reply-To: <1375385101-3673-3-git-send-email-sekharan@us.ibm.com>
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
> Start using the new field sb_pquotino from the on-disk superblock if the
> version of the superblock supports separate pquotino.
>
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> ---
>   db/check.c          |   12 +++++++-----
>   db/dquot.c          |   11 +++++++----
>   db/frag.c           |    3 ++-
>   db/inode.c          |    3 ++-
>   db/metadump.c       |    5 ++++-
>   include/xfs_sb.h    |    5 +++++
>   libxfs/xfs_mount.c  |   42 ++++++++++++++++++++++++++++++++++++++++++
>   mkfs/xfs_mkfs.c     |    2 +-
>   repair/agheader.c   |   13 +++++++++++++
>   repair/dinode.c     |    9 +++++++++
>   repair/dir2.c       |    5 +++++
>   repair/globals.h    |    1 +
>   repair/phase4.c     |   29 ++++++++++++++++++++++-------
>   repair/phase6.c     |    9 +++++++++
>   repair/sb.c         |    3 +++
>   repair/versions.c   |    5 +++++
>   repair/xfs_repair.c |    2 +-
>   17 files changed, 138 insertions(+), 21 deletions(-)
>
Looks good.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
