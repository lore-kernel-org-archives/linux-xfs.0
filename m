Return-Path: <SRS0=TABv=4U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 759EFC3F2CD
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 05:00:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 423DD21739
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 05:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgCCFAx convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 00:00:53 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42854 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725830AbgCCFAx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 00:00:53 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0234xWT0023157
        for <linux-xfs@vger.kernel.org>; Tue, 3 Mar 2020 00:00:52 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yfk5mmj1e-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 03 Mar 2020 00:00:52 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Tue, 3 Mar 2020 05:00:50 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 3 Mar 2020 05:00:48 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02350lfj33685880
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Mar 2020 05:00:47 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A784A4C04E;
        Tue,  3 Mar 2020 05:00:47 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A8144C046;
        Tue,  3 Mar 2020 05:00:47 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.124.35.74])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  3 Mar 2020 05:00:46 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 13/19] xfs: Add delay ready attr remove routines
Date:   Tue, 03 Mar 2020 10:33:43 +0530
Organization: IBM
In-Reply-To: <20200223020611.1802-14-allison.henderson@oracle.com>
References: <20200223020611.1802-1-allison.henderson@oracle.com> <20200223020611.1802-14-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-TM-AS-GCONF: 00
x-cbid: 20030305-0012-0000-0000-0000038C8C72
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030305-0013-0000-0000-000021C94179
Message-Id: <5805763.2Ij3A3caSj@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-02_09:2020-03-02,2020-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 mlxlogscore=999 clxscore=1015 impostorscore=0 spamscore=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 adultscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030038
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sunday, February 23, 2020 7:36 AM Allison Collins wrote: 
> This patch modifies the attr remove routines to be delay ready. This means they no
> longer roll or commit transactions, but instead return -EAGAIN to have the calling
> routine roll and refresh the transaction. In this series, xfs_attr_remove_args has
> become xfs_attr_remove_iter, which uses a sort of state machine like switch to keep
> track of where it was when EAGAIN was returned. xfs_attr_node_removename has also
> been modified to use the switch, and a  new version of xfs_attr_remove_args
> consists of a simple loop to refresh the transaction until the operation is
> completed.
> 
> This patch also adds a new struct xfs_delattr_context, which we will use to keep
> track of the current state of an attribute operation. The new xfs_delattr_state
> enum is used to track various operations that are in progress so that we know not
> to repeat them, and resume where we left off before EAGAIN was returned to cycle
> out the transaction. Other members take the place of local variables that need
> to retain their values across multiple function recalls.
> 
> Below is a state machine diagram for attr remove operations. The XFS_DAS_* states
> indicate places where the function would return -EAGAIN, and then immediately
> resume from after being recalled by the calling function.  States marked as a
> "subroutine state" indicate that they belong to a subroutine, and so the calling
> function needs to pass them back to that subroutine to allow it to finish where
> it left off. But they otherwise do not have a role in the calling function other
> than just passing through.
> 
>  xfs_attr_remove_iter()
>          XFS_DAS_RM_SHRINK     ─┐
>          (subroutine state)     │
>                                 │
>          XFS_DAS_RMTVAL_REMOVE ─┤
>          (subroutine state)     │
>                                 └─>xfs_attr_node_removename()
>                                                  │
>                                                  v
>                                          need to remove
>                                    ┌─n──  rmt blocks?
>                                    │             │
>                                    │             y
>                                    │             │
>                                    │             v
>                                    │  ┌─>XFS_DAS_RMTVAL_REMOVE
>                                    │  │          │
>                                    │  │          v
>                                    │  └──y── more blks
>                                    │         to remove?
>                                    │             │
>                                    │             n
>                                    │             │
>                                    │             v
>                                    │         need to
>                                    └─────> shrink tree? ─n─┐
>                                                  │         │
>                                                  y         │
>                                                  │         │
>                                                  v         │
>                                          XFS_DAS_RM_SHRINK │
>                                                  │         │
>                                                  v         │
>                                                 done <─────┘
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c     | 114 +++++++++++++++++++++++++++++++++++++------
>  fs/xfs/libxfs/xfs_attr.h     |   1 +
>  fs/xfs/libxfs/xfs_da_btree.h |  30 ++++++++++++
>  fs/xfs/scrub/common.c        |   2 +
>  fs/xfs/xfs_acl.c             |   2 +
>  fs/xfs/xfs_attr_list.c       |   1 +
>  fs/xfs/xfs_ioctl.c           |   2 +
>  fs/xfs/xfs_ioctl32.c         |   2 +
>  fs/xfs/xfs_iops.c            |   2 +
>  fs/xfs/xfs_xattr.c           |   1 +
>  10 files changed, 141 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 5d73bdf..cd3a3f7 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -368,11 +368,60 @@ xfs_has_attr(
>   */
>  int
>  xfs_attr_remove_args(
> +	struct xfs_da_args	*args)
> +{
> +	int			error = 0;
> +	int			err2 = 0;
> +
> +	do {
> +		error = xfs_attr_remove_iter(args);
> +		if (error && error != -EAGAIN)
> +			goto out;
> +
> +		if (args->dac.flags & XFS_DAC_FINISH_TRANS) {
> +			args->dac.flags &= ~XFS_DAC_FINISH_TRANS;
> +
> +			err2 = xfs_defer_finish(&args->trans);
> +			if (err2) {
> +				error = err2;
> +				goto out;
> +			}
> +		}
> +
> +		err2 = xfs_trans_roll_inode(&args->trans, args->dp);
> +		if (err2) {
> +			error = err2;
> +			goto out;
> +		}
> +
> +	} while (error == -EAGAIN);
> +out:
> +	return error;
> +}
> +
> +/*
> + * Remove the attribute specified in @args.
> + *
> + * This function may return -EAGAIN to signal that the transaction needs to be
> + * rolled.  Callers should continue calling this function until they receive a
> + * return value other than -EAGAIN.
> + */
> +int
> +xfs_attr_remove_iter(
>  	struct xfs_da_args      *args)
>  {
>  	struct xfs_inode	*dp = args->dp;
>  	int			error;
>  
> +	/* State machine switch */
> +	switch (args->dac.dela_state) {
> +	case XFS_DAS_RM_SHRINK:
> +	case XFS_DAS_RMTVAL_REMOVE:
> +		goto node;
> +	default:
> +		break;
> +	}
> +

On the very first invocation of xfs_attr_remote_iter() from
xfs_attr_remove_args() (via a call from xfs_attr_remove()),
args->dac.dela_state is set to a value of 0. This happens because
xfs_attr_args_init() invokes memset() on args. A value of 0 for
args->dac.dela_state maps to XFS_DAS_RM_SHRINK.

If the xattr was stored in say local or leaf format we end up incorrectly
invoking xfs_attr_node_removename() right?

-- 
chandan



