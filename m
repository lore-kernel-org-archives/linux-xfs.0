Return-Path: <SRS0=Mbmt=WN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5762FC3A59D
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Aug 2019 01:37:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 284992173E
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Aug 2019 01:37:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Hg3Gi9e0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbfHQBhQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Aug 2019 21:37:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48920 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbfHQBhQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Aug 2019 21:37:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7H1YFxO001228;
        Sat, 17 Aug 2019 01:37:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=vYMLF+om/faZP6qeCqFdTR2pqIO6wsJ3POwXOgamlAA=;
 b=Hg3Gi9e0JG1RoKPiAOhR3d0n2jYD3ZFL9DWSa9xLMSdn75twbv+MI5PhmB42CM/L38+A
 NUt8lVx/BvF3QE2ijGuv5201Ux98FPR1QeQkcoJm5NEIZ7NmjgK5+5Tf2XYD2k65ok+v
 88ZQrHBfNuUIRZgTa7gUbk1AYLirRMvFJ8anP5loB8ssFbQx8D7mNIAv4AmQZNKebVzz
 Zp4cvUJwet2jVLrn0f0Q5WRdISXI6XcwbsyfdN2L9d7wFAOvTpHUmBXjeDi1qOtDGH2+
 E9Qs4zw33c8SmL91Uo3vso9dd+dzuzFlzqBDbt34dJqeuyp/g5AH2x50H9srKwpqj8K+ 4Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2u9pjr35p3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 17 Aug 2019 01:37:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7H1XuFe086983;
        Sat, 17 Aug 2019 01:37:05 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2ue6qchxx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 17 Aug 2019 01:37:05 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7H1b4Sf032264;
        Sat, 17 Aug 2019 01:37:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 16 Aug 2019 18:37:04 -0700
Date:   Fri, 16 Aug 2019 18:37:03 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 3/4] xfs: randomly fall back to near mode lookup
 algorithm in debug mode
Message-ID: <20190817013703.GB752159@magnolia>
References: <20190815125538.49570-1-bfoster@redhat.com>
 <20190815125538.49570-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190815125538.49570-4-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9351 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908170014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9351 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908170014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 15, 2019 at 08:55:37AM -0400, Brian Foster wrote:
> The last block scan is the dominant near mode allocation algorithm
> for a newer filesystem with fewer, large free extents. Add debug
> mode logic to randomly fall back to lookup mode to improve
> regression test coverage.

How about just using an errortag since the new sysfs interface lets
testcases / admins control the frequency?

--D

> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 7753b61ba532..d550aa5597bf 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1266,6 +1266,7 @@ xfs_alloc_ag_vextent_near(
>  	int			i;
>  	xfs_agblock_t		bno;
>  	xfs_extlen_t		len;
> +	bool			lastblock;
>  
>  	/* handle unitialized agbno range so caller doesn't have to */
>  	if (!args->min_agbno && !args->max_agbno)
> @@ -1291,7 +1292,12 @@ xfs_alloc_ag_vextent_near(
>  	 * Otherwise run the optimized lookup search algorithm from the current
>  	 * location to the end of the tree.
>  	 */
> -	if (xfs_btree_islastblock(acur.cnt, 0)) {
> +	lastblock = xfs_btree_islastblock(acur.cnt, 0);
> +#ifdef DEBUG
> +	if (lastblock)
> +		lastblock = prandom_u32() & 1;
> +#endif
> +	if (lastblock) {
>  		int	j;
>  
>  		trace_xfs_alloc_cur_lastblock(args);
> -- 
> 2.20.1
> 
