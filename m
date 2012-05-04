Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q44Jn0s9080027 for <xfs@oss.sgi.com>; Fri, 4 May 2012 14:49:00 -0500
Date: Fri, 4 May 2012 14:52:24 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [RFC v5 PATCH 3/4] xfs: Add pquotaino to on-disk super block
Message-ID: <20120504195224.GU16881@sgi.com>
References: <20120314202623.17044.90045.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120314202641.17044.32835.sendpatchset@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120314202641.17044.32835.sendpatchset@chandra-lucid.austin.ibm.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Wed, Mar 14, 2012 at 03:26:42PM -0500, Chandra Seetharaman wrote:
> @@ -1055,19 +1057,22 @@ xfs_qm_qino_alloc(
>  		ASSERT((sbfields & (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
>  				   XFS_SB_GQUOTINO | XFS_SB_QFLAGS)) ==
>  		       (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
> -			XFS_SB_GQUOTINO | XFS_SB_QFLAGS));
> +			XFS_SB_GQUOTINO | XFS_SB_PQUOTINO | XFS_SB_QFLAGS));

I popped this assert in my testing.  I think it should look like this:

Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c
+++ xfs/fs/xfs/xfs_qm.c
@@ -838,7 +838,8 @@ xfs_qm_qino_alloc(
        if (flags & XFS_QMOPT_SBVERSION) {
                ASSERT(!xfs_sb_version_hasquota(&mp->m_sb));
                ASSERT((sbfields & (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
-                                  XFS_SB_GQUOTINO | XFS_SB_QFLAGS)) ==
+                                  XFS_SB_GQUOTINO | XFS_SB_PQUOTINO |
+                                  XFS_SB_QFLAGS)) ==
                       (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
                        XFS_SB_GQUOTINO | XFS_SB_PQUOTINO | XFS_SB_QFLAGS));

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
