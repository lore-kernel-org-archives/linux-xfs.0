Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18489 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752014AbdK2USg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Nov 2017 15:18:36 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vATKIZZn003036
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 20:18:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vATKIZB7029518
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 20:18:35 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vATKIZ3W017406
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 20:18:35 GMT
Date: Wed, 29 Nov 2017 12:18:34 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 11/17] Add the extra space requirements for parent
 pointer attributes when calculating the minimum log size during mkfs
Message-ID: <20171129201834.GH21412@magnolia>
References: <1510942905-12897-1-git-send-email-allison.henderson@oracle.com>
 <1510942905-12897-12-git-send-email-allison.henderson@oracle.com>
 <20171128185152.GN21412@magnolia>
 <0dcd4f0c-bd35-58fa-a924-32c2a356942d@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0dcd4f0c-bd35-58fa-a924-32c2a356942d@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Nov 29, 2017 at 11:47:27AM -0700, Allison Henderson wrote:
> On 11/28/2017 11:51 AM, Darrick J. Wong wrote:
> 
> >On Fri, Nov 17, 2017 at 11:21:39AM -0700, Allison Henderson wrote:
> >>Signed-off-by: Allison Henderson<allison.henderson@oracle.com>
> >>---
> >>  fs/xfs/libxfs/xfs_log_rlimit.c | 34 ++++++++++++++++++++++++++++++++++
> >>  1 file changed, 34 insertions(+)
> >>
> >>diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
> >>index c105979..beec9bf 100644
> >>--- a/fs/xfs/libxfs/xfs_log_rlimit.c
> >>+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
> >>@@ -39,6 +39,40 @@ xfs_log_calc_max_attrsetm_res(
> >>  {
> >>  	int			size;
> >>  	int			nblks;
> >>+	struct xfs_trans_resv   *resp = M_RES(mp);
> >>+
> >>+	/* Calculate extra space needed for parent pointer attributes */
> >>+	if (!xfs_sb_version_hasparent(&mp->m_sb)) {
> >if (xfs_sb_version_hasparent()) ?
> >
> >--D
> yeah I think you're right.   This means there's something wrong with the
> check then, because it appears to succeed.  I will debug that, it's probably
> the command line flag i added to mkfs.xfs to exercise it.

Keep in mind that the log reservation calculations represent worst case
space requirements, so if we screw this up we won't always immediately
see things blow up... until some time later when a heavily fragmented fs
actually needs the worst case space, overruns, and bombs. :(

Also mkfs probably formats a larger log than the minimum requirements,
unless you have a bunch of 500M disks lying around for testing.

--D

> >>+
> >>+		/* rename can add/remove/modify 2 parent attributes */
> >>+		resp->tr_rename.tr_logres +=
> >>+			2 * max(resp->tr_attrsetm.tr_logres,
> >>+				resp->tr_attrrm.tr_logres);
> >>+		resp->tr_rename.tr_logcount +=
> >>+			2 * max(resp->tr_attrsetm.tr_logcount,
> >>+				resp->tr_attrrm.tr_logcount);
> >>+
> >>+		/* create will add 1 parent attribute */
> >>+		resp->tr_create.tr_logres += resp->tr_attrsetm.tr_logres;
> >>+		resp->tr_create.tr_logcount += resp->tr_attrsetm.tr_logcount;
> >>+
> >>+		/* mkdir will add 1 parent attribute */
> >>+		resp->tr_mkdir.tr_logres += resp->tr_attrsetm.tr_logres;
> >>+		resp->tr_mkdir.tr_logcount += resp->tr_attrsetm.tr_logcount;
> >>+
> >>+		/* link will add 1 parent attribute */
> >>+		resp->tr_link.tr_logres += resp->tr_attrsetm.tr_logres;
> >>+		resp->tr_link.tr_logcount += resp->tr_attrsetm.tr_logcount;
> >>+
> >>+		/* symlink will add 1 parent attribute */
> >>+		resp->tr_symlink.tr_logres += resp->tr_attrsetm.tr_logres;
> >>+		resp->tr_symlink.tr_logcount += resp->tr_attrsetm.tr_logcount;
> >>+
> >>+		/* remove will remove 1 parent attribute */
> >>+		resp->tr_remove.tr_logres += resp->tr_attrrm.tr_logres;
> >>+		resp->tr_remove.tr_logcount = resp->tr_attrrm.tr_logcount;
> >>+	}
> >>+
> >>  	size = xfs_attr_leaf_entsize_local_max(mp->m_attr_geo->blksize) -
> >>  	       MAXNAMELEN - 1;
> >>-- 
> >>2.7.4
> >>
> >>--
> >>To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> >>the body of a message tomajordomo@vger.kernel.org
> >>More majordomo info athttp://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
