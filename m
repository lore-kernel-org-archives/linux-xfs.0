Return-Path: <SRS0=CRyL=CU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEFE2C433E2
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Sep 2020 02:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74C43207FB
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Sep 2020 02:59:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NcKL7Poo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725497AbgIKC7x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Sep 2020 22:59:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46272 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbgIKC7w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Sep 2020 22:59:52 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08B2xovi010673;
        Fri, 11 Sep 2020 02:59:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=bUbt5MGmUHat+AQGOW/RicA8UPsr7DCCfBgbpSs8sYw=;
 b=NcKL7PooTOz8OdKsmkOy19qMqJJvRsxNJxpmY8EqE2MF3gQJG5pEGA+F1mL6eyTEzUcJ
 5IDfIJ0lI1cC7tPdqH11wTJMOJvfckAy+kAabshEVT5Va2XR1E9B1VZ8vza61zA+CjE9
 y76wg5wy9NAVaXv8yS2ZCb0kxcH1Fpx2KMQfj2bt3jf6zmdw3Ud624eZbbHlJdTnOsgD
 KsijMQcZKV8WEw+M/L82/QwZsYFUXChX996XgpdQfA1IE9HICI15Ihd13d1zj6WcX+WC
 YgGEM/lFQqggwQ2CuVycTSvdIqi1vY0cgYg/bXMkVNYaxnm/3splkVQFhxKQz1dNzGLX PA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 33c23rbn6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 11 Sep 2020 02:59:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08B2taQS041577;
        Fri, 11 Sep 2020 02:57:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 33cmew98rq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Sep 2020 02:57:50 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08B2vk9U019429;
        Fri, 11 Sep 2020 02:57:49 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 10 Sep 2020 19:57:46 -0700
Subject: Re: [PATCH 1/4] man: install all manpages that redirect to another
 manpage
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
References: <159950108982.567664.1544351129609122663.stgit@magnolia>
 <159950109644.567664.3395622067779955144.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <94fde0c5-043a-560d-80b1-52f777453ff6@oracle.com>
Date:   Thu, 10 Sep 2020 19:57:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <159950109644.567664.3395622067779955144.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9740 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009110022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9740 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=0 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009110023
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 9/7/20 10:51 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Some of the ioctl manpages do not contain any information other than a
> pointer to a different manpage.  These aren't picked up by the install
> scripts, so fix them so that they do.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Ok, makes sense
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   include/buildmacros |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/include/buildmacros b/include/buildmacros
> index f8d54200382a..6f34d7c528fa 100644
> --- a/include/buildmacros
> +++ b/include/buildmacros
> @@ -95,9 +95,10 @@ INSTALL_MAN = \
>   	@for d in $(MAN_PAGES); do \
>   		first=true; \
>   		for m in `$(AWK) \
> -			'/^\.S[h|H] NAME/ {ok=1; next} ok {print; exit}' $$d \
> +			'/^\.S[h|H] NAME/ {ok=1; next} /^\.so/ {printf("so %s\n", FILENAME); exit} ok {print; exit}' $$d \
>   			| $(SED) \
>   				-e 's/^\.Nm //' -e 's/,/ /g' -e 's/\\-.*//' \
> +				-e 's/^so \([_a-zA-Z]*\)\.[0-9]/\1/g' \
>   				-e 's/\\\f[0-9]//g' -e 's/  / /g;q'`; \
>   		do \
>   			[ -z "$$m" -o "$$m" = "\\" ] && continue; \
> 
