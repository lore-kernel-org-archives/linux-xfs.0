Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 925ED7F37
	for <xfs@oss.sgi.com>; Mon, 22 Jul 2013 14:52:41 -0500 (CDT)
Date: Mon, 22 Jul 2013 14:52:38 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: Start using pquotaino from the superblock.
Message-ID: <20130722195238.GD3111@sgi.com>
References: <1374273362.8941.2086.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1374273362.8941.2086.camel@chandra-dt.ibm.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Fri, Jul 19, 2013 at 05:36:02PM -0500, Chandra Seetharaman wrote:
> Change from the previous version:
> Addressed Ben's comments
>  - removed unnecessary sb_gquotino == NULLFSINO check in
>    xfs_sb_quota_to_disk()
>  - Changed the fs_quota_stat logic to not fail with EINVAL if
>    both gquota and pquota are available. Instead, fill fs_quota_stat
>    only with gquota information.
> ----
> 
> Start using pquotino and define a macro to check if the
> superblock has pquotino.
> 
> Keep backward compatibilty by alowing mount of older superblock
> with no separate pquota inode.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

Looks good!

Reviewed-by: Ben Myers <bpm@sgi.com>

Applied.  As much as I'd like to send this in a pull request for -rc3, IMO this
is the sort of material that is most appropriate for a merge window.  I think
we'd better wait for 3.12-rc1 merge window to open.  Sorry about that.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
