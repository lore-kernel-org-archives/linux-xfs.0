Return-Path: <SRS0=yyqk=36=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8245C352A3
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Feb 2020 13:56:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BE6D206ED
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Feb 2020 13:56:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbgBJN45 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Feb 2020 08:56:57 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38652 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727918AbgBJN45 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Feb 2020 08:56:57 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01ADsObb057430
        for <linux-xfs@vger.kernel.org>; Mon, 10 Feb 2020 08:56:56 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y1tp190nt-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 10 Feb 2020 08:56:55 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Mon, 10 Feb 2020 13:56:54 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 10 Feb 2020 13:56:52 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01ADupoE59965672
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Feb 2020 13:56:51 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 563954203F;
        Mon, 10 Feb 2020 13:56:51 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77EA842041;
        Mon, 10 Feb 2020 13:56:50 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.94.7])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 Feb 2020 13:56:50 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 29/30] xfs: remove XFS_DA_OP_INCOMPLETE
Date:   Mon, 10 Feb 2020 19:29:37 +0530
Organization: IBM
In-Reply-To: <20200129170310.51370-30-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de> <20200129170310.51370-30-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20021013-0020-0000-0000-000003A8D0CD
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021013-0021-0000-0000-00002200ABA2
Message-Id: <2409782.K6jDtV8EAe@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-10_04:2020-02-10,2020-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 spamscore=0 clxscore=1015 bulkscore=0 phishscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=1 adultscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002100110
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, January 29, 2020 10:33 PM Christoph Hellwig wrote: 
> Now that we use the on-disk flags field also for the interface to the
> lower level attr routines we can use the XFS_ATTR_INCOMPLETE definition
> from the on-disk format directly instead.
>

The combination of args->attr_namespace and XFS_ATTR_INCOMPLETE correctly
replaces that of args->op_flags and XFS_DA_OP_INCOMPLETE.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_attr.c      |  2 +-
>  fs/xfs/libxfs/xfs_attr_leaf.c | 15 ++++++---------
>  fs/xfs/libxfs/xfs_types.h     |  6 ++----
>  3 files changed, 9 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index d5c112b6dcdd..23e0d8ce39f8 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -898,7 +898,7 @@ xfs_attr_node_addname(
>  		 * The INCOMPLETE flag means that we will find the "old"
>  		 * attr, not the "new" one.
>  		 */
> -		args->op_flags |= XFS_DA_OP_INCOMPLETE;
> +		args->attr_namespace |= XFS_ATTR_INCOMPLETE;
>  		state = xfs_da_state_alloc();
>  		state->args = args;
>  		state->mp = mp;
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 9081ba7af90a..fae322105457 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -456,7 +456,12 @@ xfs_attr_match(
>  		return false;
>  	if (memcmp(args->name, name, namelen) != 0)
>  		return false;
> -	if (args->attr_namespace != (flags & XFS_ATTR_NSP_ONDISK_MASK))
> +	/*
> +	 * If we are looking for incomplete entries, show only those, else only
> +	 * show complete entries.
> +	 */
> +	if (args->attr_namespace !=
> +	    (flags & (XFS_ATTR_NSP_ONDISK_MASK | XFS_ATTR_INCOMPLETE)))
>  		return false;
>  	return true;
>  }
> @@ -2387,14 +2392,6 @@ xfs_attr3_leaf_lookup_int(
>  /*
>   * GROT: Add code to remove incomplete entries.
>   */
> -		/*
> -		 * If we are looking for INCOMPLETE entries, show only those.
> -		 * If we are looking for complete entries, show only those.
> -		 */
> -		if (!!(args->op_flags & XFS_DA_OP_INCOMPLETE) !=
> -		    !!(entry->flags & XFS_ATTR_INCOMPLETE)) {
> -			continue;
> -		}
>  		if (entry->flags & XFS_ATTR_LOCAL) {
>  			name_loc = xfs_attr3_leaf_name_local(leaf, probe);
>  			if (!xfs_attr_match(args, name_loc->namelen,
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 2b02f854ebaf..a2005e2d3baa 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -194,7 +194,7 @@ typedef struct xfs_da_args {
>  	uint8_t		filetype;	/* filetype of inode for directories */
>  	void		*value;		/* set of bytes (maybe contain NULLs) */
>  	int		valuelen;	/* length of value */
> -	unsigned int	attr_namespace;	/* XFS_ATTR_{ROOT,SECURE} */
> +	unsigned int	attr_namespace;	/* XFS_ATTR_{ROOT,SECURE,INCOMPLETE} */
>  	unsigned int	attr_flags;	/* XATTR_{CREATE,REPLACE} */
>  	xfs_dahash_t	hashval;	/* hash value of name */
>  	xfs_ino_t	inumber;	/* input/output inode number */
> @@ -225,7 +225,6 @@ typedef struct xfs_da_args {
>  #define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
>  #define XFS_DA_OP_CILOOKUP	0x0010	/* lookup to return CI name if found */
>  #define XFS_DA_OP_NOTIME	0x0020	/* don't update inode timestamps */
> -#define XFS_DA_OP_INCOMPLETE	0x0040	/* lookup INCOMPLETE attr keys */
> 
>  #define XFS_DA_OP_FLAGS \
>  	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
> @@ -233,8 +232,7 @@ typedef struct xfs_da_args {
>  	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
>  	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
>  	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
> -	{ XFS_DA_OP_NOTIME,	"NOTIME" }, \
> -	{ XFS_DA_OP_INCOMPLETE,	"INCOMPLETE" }
> +	{ XFS_DA_OP_NOTIME,	"NOTIME" }
> 
>  /*
>   * Type verifier functions
> 


-- 
chandan



