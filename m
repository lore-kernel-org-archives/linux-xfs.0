Return-Path: <SRS0=yyqk=36=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14D7EC352A3
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Feb 2020 15:54:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA64320714
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Feb 2020 15:54:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BpU28/m2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbgBJPyY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Feb 2020 10:54:24 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55870 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727143AbgBJPyY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Feb 2020 10:54:24 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01AFsGFm018753;
        Mon, 10 Feb 2020 15:54:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=+tjCQQZAMseq09FLYQdZ6dxurwoGDIXMEWBw7hAS+8M=;
 b=BpU28/m23XBkd5dV9NTt4xvUdJU4Vj6rhFITUhWLC3j9El7efb3JwiuogyinYkSYSboa
 rXqn8h12NU0SzTQT1teCrtUMt2ur+RJ6enA3by3/lku1djlK+ph3Y/3mvuv/mQBPU7g3
 uebaL+vyaIMAaHTekY+y8tf+q5Qsy7KSQ7lXNrQ3D8DsVC22D2p0/2KGR1Sicp3GPB8/
 Xcfq/ttOnplB9B4+yI9+BhD80hKg173tFgWYXcICVkERA62AOs9sFx9yvRBKq3uGrbbp
 BH+HIWxF66rCa/ko0jDLXBhFDD2n7GgYQJpfgecnzRFgcqFWocXptDBvm5KJWYGchyQi CA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2y2jx5wn4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Feb 2020 15:54:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01AFq7wg020264;
        Mon, 10 Feb 2020 15:54:16 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2y26ht7aqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Feb 2020 15:54:16 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01AFsFx7000781;
        Mon, 10 Feb 2020 15:54:15 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 10 Feb 2020 07:54:14 -0800
Date:   Mon, 10 Feb 2020 07:54:13 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>, John Jore <john@jore.no>
Subject: Re: [PATCH] xfs_repair: fix bad next_unlinked field
Message-ID: <20200210155413.GJ6870@magnolia>
References: <f5b8a2a9-e691-3bf5-c2c7-f4986a933454@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5b8a2a9-e691-3bf5-c2c7-f4986a933454@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9527 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=2 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002100120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9527 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 priorityscore=1501 adultscore=0 phishscore=0 impostorscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=2 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002100120
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 10, 2020 at 09:42:28AM -0600, Eric Sandeen wrote:
> As of xfsprogs-4.17 we started testing whether the di_next_unlinked field
> on an inode is valid in the inode verifiers. However, this field is never
> tested or repaired during inode processing.
> 
> So if, for example, we had a completely zeroed-out inode, we'd detect and
> fix the broken magic and version, but the invalid di_next_unlinked field
> would not be touched, fail the write verifier, and prevent the inode from
> being properly repaired or even written out.
> 
> Fix this by checking the di_next_unlinked inode field for validity and
> clearing it if it is invalid.
> 
> Reported-by: John Jore <john@jore.no>
> Fixes: 2949b4677 ("xfs: don't accept inode buffers with suspicious unlinked chains")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Seems reasonable,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 8af2cb25..c5d2f350 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -2272,6 +2272,7 @@ process_dinode_int(xfs_mount_t *mp,
>  	const int		is_free = 0;
>  	const int		is_used = 1;
>  	blkmap_t		*dblkmap = NULL;
> +	xfs_agino_t		unlinked_ino;
>  
>  	*dirty = *isa_dir = 0;
>  	*used = is_used;
> @@ -2351,6 +2352,23 @@ process_dinode_int(xfs_mount_t *mp,
>  		}
>  	}
>  
> +	unlinked_ino = be32_to_cpu(dino->di_next_unlinked);
> +	if (!xfs_verify_agino_or_null(mp, agno, unlinked_ino)) {
> +		retval = 1;
> +		if (!uncertain)
> +			do_warn(_("bad next_unlinked 0x%x on inode %" PRIu64 "%c"),
> +				(__s32)dino->di_next_unlinked, lino,
> +				verify_mode ? '\n' : ',');
> +		if (!verify_mode) {
> +			if (!no_modify) {
> +				do_warn(_(" resetting next_unlinked\n"));
> +				clear_dinode_unlinked(mp, dino);
> +				*dirty = 1;
> +			} else
> +				do_warn(_(" would reset next_unlinked\n"));
> +		}
> +	}
> +
>  	/*
>  	 * We don't bother checking the CRC here - we cannot guarantee that when
>  	 * we are called here that the inode has not already been modified in
> 
