Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 889ADC4724C
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 18:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AA2920836
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 18:43:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="t/qw/r8i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgD3SnP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 14:43:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41474 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgD3SnO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 14:43:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UIfO27057262;
        Thu, 30 Apr 2020 18:43:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Kc2yrRczBz+dymmYvYlmdnXIBMuqMi4dy+Pw8THnXHg=;
 b=t/qw/r8il2DSjepR9P3uDwACNoCyA6IP3TZAbfyonmw3Z+dH6+Msx7gtUQuJjPCCq3gv
 Iv8NF2fE8gc5B4Av4gIjE/AO5B3p3/xwiH6Ew7CPHOtuOMUE5MPQXbb82IXzZxUdLTjK
 IHo0udfa//nvf9s9uurbbKeUGgImfnjBeDPN1peEE0euapQTFnYeP0n+qLeHxXEY5bwn
 sGPBe5HHiD4cN4uUqvQ7d1kgK/WPvE89Fj1/X+Sf4PsnPe6RHhI917BJukx41JR2sefA
 QkNYIoZovqok0V57rYbqTeO1mnIZvCPN8J/BRhT1/I4Q77pmdMYTHIf6TUgEIzBMk+24 Xg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30p2p0jp3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 18:43:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UIZ2bY071146;
        Thu, 30 Apr 2020 18:41:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30qtf87da7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 18:41:10 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03UIf9K7023216;
        Thu, 30 Apr 2020 18:41:09 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 11:41:09 -0700
Date:   Thu, 30 Apr 2020 11:41:07 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 05/17] xfs: reset buffer write failure state on
 successful completion
Message-ID: <20200430184107.GF6742@magnolia>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-6-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429172153.41680-6-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300144
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1015
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300144
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 01:21:41PM -0400, Brian Foster wrote:
> The buffer write failure flag is intended to control the internal
> write retry that XFS has historically implemented to help mitigate
> the severity of transient I/O errors. The flag is set when a buffer
> is resubmitted from the I/O completion path due to a previous
> failure. It is checked on subsequent I/O completions to skip the
> internal retry and fall through to the higher level configurable
> error handling mechanism. The flag is cleared in the synchronous and
> delwri submission paths and also checked in various places to log
> write failure messages.
> 
> There are a couple minor problems with the current usage of this
> flag. One is that we issue an internal retry after every submission
> from xfsaild due to how delwri submission clears the flag. This
> results in double the expected or configured number of write
> attempts when under sustained failures. Another more subtle issue is
> that the flag is never cleared on successful I/O completion. This
> can cause xfs_wait_buftarg() to suggest that dirty buffers are being
> thrown away due to the existence of the flag, when the reality is
> that the flag might still be set because the write succeeded on the
> retry.
> 
> Clear the write failure flag on successful I/O completion to address
> both of these problems. This means that the internal retry attempt
> occurs once since the last time a buffer write failed and that
> various other contexts only see the flag set when the immediately
> previous write attempt has failed.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Makes sense, and probably explains why the ioerr retry timeouts
sometimes took longer than I was expecting them to...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_buf.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index d5d6a68bb1e6..fd76a84cefdd 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1197,8 +1197,10 @@ xfs_buf_ioend(
>  		bp->b_ops->verify_read(bp);
>  	}
>  
> -	if (!bp->b_error)
> +	if (!bp->b_error) {
> +		bp->b_flags &= ~XBF_WRITE_FAIL;
>  		bp->b_flags |= XBF_DONE;
> +	}
>  
>  	if (bp->b_iodone)
>  		(*(bp->b_iodone))(bp);
> @@ -1274,7 +1276,7 @@ xfs_bwrite(
>  
>  	bp->b_flags |= XBF_WRITE;
>  	bp->b_flags &= ~(XBF_ASYNC | XBF_READ | _XBF_DELWRI_Q |
> -			 XBF_WRITE_FAIL | XBF_DONE);
> +			 XBF_DONE);
>  
>  	error = xfs_buf_submit(bp);
>  	if (error)
> @@ -1996,7 +1998,7 @@ xfs_buf_delwri_submit_buffers(
>  		 * synchronously. Otherwise, drop the buffer from the delwri
>  		 * queue and submit async.
>  		 */
> -		bp->b_flags &= ~(_XBF_DELWRI_Q | XBF_WRITE_FAIL);
> +		bp->b_flags &= ~_XBF_DELWRI_Q;
>  		bp->b_flags |= XBF_WRITE;
>  		if (wait_list) {
>  			bp->b_flags &= ~XBF_ASYNC;
> -- 
> 2.21.1
> 
