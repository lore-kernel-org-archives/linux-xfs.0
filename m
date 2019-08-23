Return-Path: <SRS0=lWMA=WT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9647C3A5A2
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 14:37:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD4452054F
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 14:37:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R/pnpxcm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390896AbfHWOhE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Aug 2019 10:37:04 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45788 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389397AbfHWOhE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Aug 2019 10:37:04 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7NEYUam123236;
        Fri, 23 Aug 2019 14:36:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=mCmlq0J5LHSJPNRvvnm2neJRgUpuAfyrZ5lnHyhradY=;
 b=R/pnpxcmWf9H/bF/xaTGKEd408ITQ1foXqfBcaffWMDk17zlPcB91oo26FZ+dDuYdeqw
 vmt3nJiLEHCAMqs1AkNnefywJxhttAf9mQbLwQWCP0vBq2/1S/B6HjFOEzfXvUU4tn99
 8a7JlY172Djx9I0GaxWBArPUb7OsWYXjjvOrlgwgkrBr4aH8u8UvFnldQ3wo97IpPd6u
 Yk+k/p/J8EU8IPhP39x0/mvtVM/EVgGt3Un7P6fJlu/+A9/li1uozXCN26cVwzkqGWyx
 oxxpGeOkgr8G8eusYtnsiGlE+nJvm9zHzhWXl/5XLEtQ4CNFeK/LKCj86EKuWlzdMQJX 1w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2ue9hq526a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 14:36:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7NEY7TV080849;
        Fri, 23 Aug 2019 14:36:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2uj1y0jr8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 14:36:52 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7NEapOq013969;
        Fri, 23 Aug 2019 14:36:51 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 23 Aug 2019 07:36:51 -0700
Date:   Fri, 23 Aug 2019 07:36:50 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] t_stripealign: Fix fibmap error handling
Message-ID: <20190823143650.GI1037350@magnolia>
References: <20190823092530.11797-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823092530.11797-1-cmaiolino@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9358 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908230151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9358 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908230152
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 23, 2019 at 11:25:30AM +0200, Carlos Maiolino wrote:
> FIBMAP only returns a negative value when the underlying filesystem does
> not support FIBMAP or on permission error. For the remaining errors,
> i.e. those usually returned from the filesystem itself, zero will be
> returned.
> 
> We can not trust a zero return from the FIBMAP, and such behavior made
> generic/223 succeed when it should not.
> 
> Also, we can't use perror() only to print errors when FIBMAP failed, or
> it will simply print 'success' when a zero is returned.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  src/t_stripealign.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/src/t_stripealign.c b/src/t_stripealign.c
> index 5cdadaae..164831f8 100644
> --- a/src/t_stripealign.c
> +++ b/src/t_stripealign.c
> @@ -76,8 +76,11 @@ int main(int argc, char ** argv)
>  		unsigned int	bmap = 0;
>  
>  		ret = ioctl(fd, FIBMAP, &bmap);
> -		if (ret < 0) {
> -			perror("fibmap");
> +		if (ret <= 0) {
> +			if (ret < 0)
> +				perror("fibmap");
> +			else
> +				fprintf(stderr, "fibmap error\n");

"fibmap returned no result"?

--D

>  			free(fie);
>  			close(fd);
>  			return 1;
> -- 
> 2.20.1
> 
