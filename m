Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05EF8C2D0A8
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 16:35:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AAFE206FB
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 16:35:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PA/ezKr3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgIWQfs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 12:35:48 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:56058 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIWQfs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 12:35:48 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NGZdwn006831;
        Wed, 23 Sep 2020 16:35:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=otw2C1NkO8nauoh+szRS3meDkrIRSttupJDsW4e1NaI=;
 b=PA/ezKr3wcTeCaTX8H6Mknegqzh+CYRfilgz2UOrs8bL7Vt6W+jmv4PJGB0jrycM3EY2
 6v0a3Uum7QeFIDtFMDQMLdYltcFGg/DDEESCXzZeo8Nbzazikkr46y71wUa7EbzpklP4
 09ZO+UyoPL6GThaqUjaQfY42baTr9F94hOS7HTQmvFk7i7MSFjKrY+JaYk851mvYryHe
 RMy+lJfSy9b0BOmOkPszD6wCxZ0AktdfGZ0UXkknjD83vhprx7rrD2qI7G5faOr9/GDC
 LUrgTNKcB99idORFEt7+hRTnCRch/27NoTyoUKjAoOIbmsMZxsBV3+h0+6UFDK2KZKYq zg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 33qcpu0gsb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Sep 2020 16:35:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NGZUUB135884;
        Wed, 23 Sep 2020 16:35:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33nux1d809-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 16:35:43 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08NGZgiw030497;
        Wed, 23 Sep 2020 16:35:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Sep 2020 09:35:42 -0700
Date:   Wed, 23 Sep 2020 09:35:40 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 1/2] xfs: avoid LR buffer overrun due to crafted h_len
Message-ID: <20200923163540.GU7955@magnolia>
References: <20200917051341.9811-1-hsiangkao@redhat.com>
 <20200917051341.9811-2-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917051341.9811-2-hsiangkao@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 spamscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230129
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 01:13:40PM +0800, Gao Xiang wrote:
> Currently, crafted h_len has been blocked for the log
> header of the tail block in commit a70f9fe52daa ("xfs:
> detect and handle invalid iclog size set by mkfs").
> 
> However, each log record could still have crafted h_len
> and cause log record buffer overrun. So let's check
> h_len vs buffer size for each log record as well.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

/me squints real hard and thinks he understands what this patch does.

Tighten up xlog_valid_rec_header, and add a new callsite in the middle
of xlog_do_recovery_pass instead of the insufficient length checking.
Assuming that's right,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> v3: https://lore.kernel.org/r/20200904082516.31205-2-hsiangkao@redhat.com
> 
> changes since v3:
>  - drop exception comment to avoid confusion (Brian);
>  - check rhead->hlen vs buffer size to address
>    the harmful overflow (Brian);
> 
> And as Brian requested previously, "Also, please test the workaround
> case to make sure it still works as expected (if you haven't already)."
> 
> So I tested the vanilla/after upstream kernels with compiled xfsprogs-v4.3.0,
> which was before mkfs fix 20fbd4593ff2 ("libxfs: format the log with
> valid log record headers") got merged, and I generated a questionable
> image followed by the instruction described in the related commit
> messages with "mkfs.xfs -dsunit=512,swidth=4096 -f test.img" and
> logprint says
> 
> cycle: 1        version: 2              lsn: 1,0        tail_lsn: 1,0
> length of Log Record: 261632    prev offset: -1         num ops: 1
> uuid: 7b84cd80-7855-4dc8-91ce-542c7d65ba99   format: little endian linux
> h_size: 32768
> 
> so "length of Log Record" is overrun obviously, but I cannot reproduce
> the described workaround case for vanilla/after kernels anymore.
> 
> I think the reason is due to commit 7f6aff3a29b0 ("xfs: only run torn
> log write detection on dirty logs"), which changes the behavior
> described in commit a70f9fe52daa8 ("xfs: detect and handle invalid
> iclog size set by mkfs") from "all records at the head of the log
> are verified for CRC errors" to "we can only run CRC verification
> when the log is dirty because there's no guarantee that the log
> data behind an unmount record is compatible with the current
> architecture).", more details see codediff of a70f9fe52daa8.
> 
> The timeline seems to be:
>  https://lore.kernel.org/r/1447342648-40012-1-git-send-email-bfoster@redhat.com
>  a70f9fe52daa [PATCH v2 1/8] xfs: detect and handle invalid iclog size set by mkfs
>  7088c4136fa1 [PATCH v2 7/8] xfs: detect and trim torn writes during log recovery
>  https://lore.kernel.org/r/1457008798-58734-5-git-send-email-bfoster@redhat.com
>  7f6aff3a29b0 [PATCH 4/4] xfs: only run torn log write detection on dirty logs
> 
> so IMHO, the workaround a70f9fe52daa would only be useful between
> 7088c4136fa1 ~ 7f6aff3a29b0.
> 
> Yeah, it relates to several old kernel commits/versions, my technical
> analysis is as above. This patch doesn't actually change the real
> original workaround logic. Even if the workground can be removed now,
> that should be addressed with another patch and that is quite another
> story.
> 
> Kindly correct me if I'm wrong :-)
> 
> Thanks,
> Gao Xiang
> 
>  fs/xfs/xfs_log_recover.c | 39 +++++++++++++++++++--------------------
>  1 file changed, 19 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index a17d788921d6..782ec3eeab4d 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2878,7 +2878,8 @@ STATIC int
>  xlog_valid_rec_header(
>  	struct xlog		*log,
>  	struct xlog_rec_header	*rhead,
> -	xfs_daddr_t		blkno)
> +	xfs_daddr_t		blkno,
> +	int			bufsize)
>  {
>  	int			hlen;
>  
> @@ -2894,10 +2895,14 @@ xlog_valid_rec_header(
>  		return -EFSCORRUPTED;
>  	}
>  
> -	/* LR body must have data or it wouldn't have been written */
> +	/*
> +	 * LR body must have data (or it wouldn't have been written)
> +	 * and h_len must not be greater than LR buffer size.
> +	 */
>  	hlen = be32_to_cpu(rhead->h_len);
> -	if (XFS_IS_CORRUPT(log->l_mp, hlen <= 0 || hlen > INT_MAX))
> +	if (XFS_IS_CORRUPT(log->l_mp, hlen <= 0 || hlen > bufsize))
>  		return -EFSCORRUPTED;
> +
>  	if (XFS_IS_CORRUPT(log->l_mp,
>  			   blkno > log->l_logBBsize || blkno > INT_MAX))
>  		return -EFSCORRUPTED;
> @@ -2958,9 +2963,6 @@ xlog_do_recovery_pass(
>  			goto bread_err1;
>  
>  		rhead = (xlog_rec_header_t *)offset;
> -		error = xlog_valid_rec_header(log, rhead, tail_blk);
> -		if (error)
> -			goto bread_err1;
>  
>  		/*
>  		 * xfsprogs has a bug where record length is based on lsunit but
> @@ -2975,21 +2977,18 @@ xlog_do_recovery_pass(
>  		 */
>  		h_size = be32_to_cpu(rhead->h_size);
>  		h_len = be32_to_cpu(rhead->h_len);
> -		if (h_len > h_size) {
> -			if (h_len <= log->l_mp->m_logbsize &&
> -			    be32_to_cpu(rhead->h_num_logops) == 1) {
> -				xfs_warn(log->l_mp,
> +		if (h_len > h_size && h_len <= log->l_mp->m_logbsize &&
> +		    rhead->h_num_logops == cpu_to_be32(1)) {
> +			xfs_warn(log->l_mp,
>  		"invalid iclog size (%d bytes), using lsunit (%d bytes)",
> -					 h_size, log->l_mp->m_logbsize);
> -				h_size = log->l_mp->m_logbsize;
> -			} else {
> -				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> -						log->l_mp);
> -				error = -EFSCORRUPTED;
> -				goto bread_err1;
> -			}
> +				 h_size, log->l_mp->m_logbsize);
> +			h_size = log->l_mp->m_logbsize;
>  		}
>  
> +		error = xlog_valid_rec_header(log, rhead, tail_blk, h_size);
> +		if (error)
> +			goto bread_err1;
> +
>  		if ((be32_to_cpu(rhead->h_version) & XLOG_VERSION_2) &&
>  		    (h_size > XLOG_HEADER_CYCLE_SIZE)) {
>  			hblks = h_size / XLOG_HEADER_CYCLE_SIZE;
> @@ -3070,7 +3069,7 @@ xlog_do_recovery_pass(
>  			}
>  			rhead = (xlog_rec_header_t *)offset;
>  			error = xlog_valid_rec_header(log, rhead,
> -						split_hblks ? blk_no : 0);
> +					split_hblks ? blk_no : 0, h_size);
>  			if (error)
>  				goto bread_err2;
>  
> @@ -3151,7 +3150,7 @@ xlog_do_recovery_pass(
>  			goto bread_err2;
>  
>  		rhead = (xlog_rec_header_t *)offset;
> -		error = xlog_valid_rec_header(log, rhead, blk_no);
> +		error = xlog_valid_rec_header(log, rhead, blk_no, h_size);
>  		if (error)
>  			goto bread_err2;
>  
> -- 
> 2.18.1
> 
