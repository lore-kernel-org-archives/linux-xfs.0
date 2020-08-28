Return-Path: <SRS0=eyVf=CG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C92F2C433E2
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Aug 2020 04:08:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6E5C20936
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Aug 2020 04:08:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AFYbk3/z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725536AbgH1EIm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Aug 2020 00:08:42 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35782 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgH1EIl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Aug 2020 00:08:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07S43J7a026435;
        Fri, 28 Aug 2020 04:08:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Sy5urEmQ2RYvZhNHkbU3ntdOtc8RcpaST88JaSE0as4=;
 b=AFYbk3/zaDxUmabu/1fSlBYnAD62yVRZXRdXh1MVIMqOXyUMhFUdgNMfLOq615wsz8/m
 6scfknw9wWMPhP8PGPtA9amPMZYuHPmYtxbbcbPWmbE01h4pIVmEp0DOxGUr26xPVOnm
 SKPhgKqxnis2HcWdafdFCVDlvX3PqD1G12qQshfN+6PTxEGyhEcAMba9nxWus4jOg6yV
 nlKOHQbXV0QcEOsyIyNatRzo6S2rR34F6zOK6dIn0XkiY67pgGRAoPfuXwzJzrRia3q7
 IToi6tvolYlLRb4xEVXxvJ31TaHkAQKt+fLQAw+xP6e5HsKRCJqXSKLdW6YJifI7UrM/ 8g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 333w6u8ch6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 28 Aug 2020 04:08:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07S40L0i157106;
        Fri, 28 Aug 2020 04:08:35 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 333ruere2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Aug 2020 04:08:35 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07S48Y3m027598;
        Fri, 28 Aug 2020 04:08:34 GMT
Received: from [192.168.1.226] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Aug 2020 21:08:34 -0700
Subject: Re: [PATCH 05/11] xfs: move xfs_log_dinode_to_disk to the log
 recovery code
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, david@fromorbit.com,
        hch@infradead.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com, sandeen@sandeen.net
References: <159847949739.2601708.16579235017313836378.stgit@magnolia>
 <159847953041.2601708.2391074537438610709.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <b728f9fd-22fa-8c72-1748-f6590a48d78c@oracle.com>
Date:   Thu, 27 Aug 2020 21:08:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <159847953041.2601708.2391074537438610709.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008280032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008280032
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 8/26/20 3:05 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move this function to xfs_inode_item_recover.c since there's only one
> caller of it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Looks fine
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/libxfs/xfs_inode_buf.c   |   52 ---------------------------------------
>   fs/xfs/libxfs/xfs_inode_buf.h   |    2 --
>   fs/xfs/xfs_inode_item_recover.c |   52 +++++++++++++++++++++++++++++++++++++++
>   3 files changed, 52 insertions(+), 54 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 8d5dd08eab75..fa83591ca89b 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -310,58 +310,6 @@ xfs_inode_to_disk(
>   	}
>   }
>   
> -void
> -xfs_log_dinode_to_disk(
> -	struct xfs_log_dinode	*from,
> -	struct xfs_dinode	*to)
> -{
> -	to->di_magic = cpu_to_be16(from->di_magic);
> -	to->di_mode = cpu_to_be16(from->di_mode);
> -	to->di_version = from->di_version;
> -	to->di_format = from->di_format;
> -	to->di_onlink = 0;
> -	to->di_uid = cpu_to_be32(from->di_uid);
> -	to->di_gid = cpu_to_be32(from->di_gid);
> -	to->di_nlink = cpu_to_be32(from->di_nlink);
> -	to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
> -	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
> -	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
> -
> -	to->di_atime.t_sec = cpu_to_be32(from->di_atime.t_sec);
> -	to->di_atime.t_nsec = cpu_to_be32(from->di_atime.t_nsec);
> -	to->di_mtime.t_sec = cpu_to_be32(from->di_mtime.t_sec);
> -	to->di_mtime.t_nsec = cpu_to_be32(from->di_mtime.t_nsec);
> -	to->di_ctime.t_sec = cpu_to_be32(from->di_ctime.t_sec);
> -	to->di_ctime.t_nsec = cpu_to_be32(from->di_ctime.t_nsec);
> -
> -	to->di_size = cpu_to_be64(from->di_size);
> -	to->di_nblocks = cpu_to_be64(from->di_nblocks);
> -	to->di_extsize = cpu_to_be32(from->di_extsize);
> -	to->di_nextents = cpu_to_be32(from->di_nextents);
> -	to->di_anextents = cpu_to_be16(from->di_anextents);
> -	to->di_forkoff = from->di_forkoff;
> -	to->di_aformat = from->di_aformat;
> -	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
> -	to->di_dmstate = cpu_to_be16(from->di_dmstate);
> -	to->di_flags = cpu_to_be16(from->di_flags);
> -	to->di_gen = cpu_to_be32(from->di_gen);
> -
> -	if (from->di_version == 3) {
> -		to->di_changecount = cpu_to_be64(from->di_changecount);
> -		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
> -		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
> -		to->di_flags2 = cpu_to_be64(from->di_flags2);
> -		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
> -		to->di_ino = cpu_to_be64(from->di_ino);
> -		to->di_lsn = cpu_to_be64(from->di_lsn);
> -		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
> -		uuid_copy(&to->di_uuid, &from->di_uuid);
> -		to->di_flushiter = 0;
> -	} else {
> -		to->di_flushiter = cpu_to_be16(from->di_flushiter);
> -	}
> -}
> -
>   static xfs_failaddr_t
>   xfs_dinode_verify_fork(
>   	struct xfs_dinode	*dip,
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 6b08b9d060c2..89f7bea8efd6 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -49,8 +49,6 @@ void	xfs_dinode_calc_crc(struct xfs_mount *, struct xfs_dinode *);
>   void	xfs_inode_to_disk(struct xfs_inode *ip, struct xfs_dinode *to,
>   			  xfs_lsn_t lsn);
>   int	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
> -void	xfs_log_dinode_to_disk(struct xfs_log_dinode *from,
> -			       struct xfs_dinode *to);
>   
>   xfs_failaddr_t xfs_dinode_verify(struct xfs_mount *mp, xfs_ino_t ino,
>   			   struct xfs_dinode *dip);
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> index 5e0d291835b3..1e417ace2912 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -115,6 +115,58 @@ xfs_recover_inode_owner_change(
>   	return error;
>   }
>   
> +STATIC void
> +xfs_log_dinode_to_disk(
> +	struct xfs_log_dinode	*from,
> +	struct xfs_dinode	*to)
> +{
> +	to->di_magic = cpu_to_be16(from->di_magic);
> +	to->di_mode = cpu_to_be16(from->di_mode);
> +	to->di_version = from->di_version;
> +	to->di_format = from->di_format;
> +	to->di_onlink = 0;
> +	to->di_uid = cpu_to_be32(from->di_uid);
> +	to->di_gid = cpu_to_be32(from->di_gid);
> +	to->di_nlink = cpu_to_be32(from->di_nlink);
> +	to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
> +	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
> +	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
> +
> +	to->di_atime.t_sec = cpu_to_be32(from->di_atime.t_sec);
> +	to->di_atime.t_nsec = cpu_to_be32(from->di_atime.t_nsec);
> +	to->di_mtime.t_sec = cpu_to_be32(from->di_mtime.t_sec);
> +	to->di_mtime.t_nsec = cpu_to_be32(from->di_mtime.t_nsec);
> +	to->di_ctime.t_sec = cpu_to_be32(from->di_ctime.t_sec);
> +	to->di_ctime.t_nsec = cpu_to_be32(from->di_ctime.t_nsec);
> +
> +	to->di_size = cpu_to_be64(from->di_size);
> +	to->di_nblocks = cpu_to_be64(from->di_nblocks);
> +	to->di_extsize = cpu_to_be32(from->di_extsize);
> +	to->di_nextents = cpu_to_be32(from->di_nextents);
> +	to->di_anextents = cpu_to_be16(from->di_anextents);
> +	to->di_forkoff = from->di_forkoff;
> +	to->di_aformat = from->di_aformat;
> +	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
> +	to->di_dmstate = cpu_to_be16(from->di_dmstate);
> +	to->di_flags = cpu_to_be16(from->di_flags);
> +	to->di_gen = cpu_to_be32(from->di_gen);
> +
> +	if (from->di_version == 3) {
> +		to->di_changecount = cpu_to_be64(from->di_changecount);
> +		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
> +		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
> +		to->di_flags2 = cpu_to_be64(from->di_flags2);
> +		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
> +		to->di_ino = cpu_to_be64(from->di_ino);
> +		to->di_lsn = cpu_to_be64(from->di_lsn);
> +		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
> +		uuid_copy(&to->di_uuid, &from->di_uuid);
> +		to->di_flushiter = 0;
> +	} else {
> +		to->di_flushiter = cpu_to_be16(from->di_flushiter);
> +	}
> +}
> +
>   STATIC int
>   xlog_recover_inode_commit_pass2(
>   	struct xlog			*log,
> 
