Return-Path: <SRS0=eqR3=AR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66CFAC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jul 2020 22:53:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E82B20723
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jul 2020 22:53:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dKfIiXom"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgGFWxw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jul 2020 18:53:52 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48714 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbgGFWxw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jul 2020 18:53:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 066Mr6Gj152591;
        Mon, 6 Jul 2020 22:53:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=qGTv/hofEApGb+qpfhVKGwUYz4UXOnHONvu+v/rFdy8=;
 b=dKfIiXomKZjnf5cCk5y2oTWLCK1eW5vuer5oWFJNGfXLdfYNGztfLOUlb7hwEsprLcA/
 vSo7mRndUX3rK9SlKxEdc0FvGFcdkOXttzldpxKJsDi6MrvV6jhq8+tkfu1dvrkLIzh2
 m2jAEPU+qU3vPQoDAm+z6mN/+yfizTFSFK5EAW/+TW2FnBtWpAvHLHuB8YdNQ0j0/0Jx
 X/2lD3Oy0KcHxmx0vidUODP+1DOrH3XhcBtbGbj4wKvtZfxsjm8xzi0BN4SRB1SecEAx
 r84PEdhJcaJHOir8Ko6xHN77uKpuwqvJEpquT3EdrHrfOY9NJfWW4t3Awvv6XrfGdKnl Og== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 323sxxnfqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 06 Jul 2020 22:53:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 066Mmv9F121832;
        Mon, 6 Jul 2020 22:53:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3243pdjdtm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Jul 2020 22:53:48 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 066MrkDi017092;
        Mon, 6 Jul 2020 22:53:46 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Jul 2020 15:53:46 -0700
Subject: Re: [PATCH 1/3] xfs_repair: complain about ag header crc errors
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <159370361029.3579756.1711322369086095823.stgit@magnolia>
 <159370361687.3579756.17807287829667417464.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <e9f71f07-9654-9bce-75c6-29d85245ae6a@oracle.com>
Date:   Mon, 6 Jul 2020 15:53:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <159370361687.3579756.17807287829667417464.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9674 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=2 spamscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007060157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9674 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 impostorscore=0 adultscore=0 cotscore=-2147483648 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 suspectscore=2 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007060157
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/2/20 8:26 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Repair doesn't complain about crc errors in the AG headers, and it
> should.  Otherwise, this gives the admin the wrong impression about the
> state of the filesystem after a nomodify check.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Looks fine
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   repair/scan.c |    6 ++++++
>   1 file changed, 6 insertions(+)
> 
> 
> diff --git a/repair/scan.c b/repair/scan.c
> index 505cfc53..42b299f7 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
> @@ -2441,6 +2441,8 @@ scan_ag(
>   		objname = _("root superblock");
>   		goto out_free_sb;
>   	}
> +	if (sbbuf->b_error == -EFSBADCRC)
> +		do_warn(_("superblock has bad CRC for ag %d\n"), agno);
>   	libxfs_sb_from_disk(sb, sbbuf->b_addr);
>   
>   	error = salvage_buffer(mp->m_dev,
> @@ -2450,6 +2452,8 @@ scan_ag(
>   		objname = _("agf block");
>   		goto out_free_sbbuf;
>   	}
> +	if (agfbuf->b_error == -EFSBADCRC)
> +		do_warn(_("agf has bad CRC for ag %d\n"), agno);
>   	agf = agfbuf->b_addr;
>   
>   	error = salvage_buffer(mp->m_dev,
> @@ -2459,6 +2463,8 @@ scan_ag(
>   		objname = _("agi block");
>   		goto out_free_agfbuf;
>   	}
> +	if (agibuf->b_error == -EFSBADCRC)
> +		do_warn(_("agi has bad CRC for ag %d\n"), agno);
>   	agi = agibuf->b_addr;
>   
>   	/* fix up bad ag headers */
> 
