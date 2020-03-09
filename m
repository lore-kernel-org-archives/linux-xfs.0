Return-Path: <SRS0=zudJ=42=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B82C10F25
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Mar 2020 22:30:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AD8024649
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Mar 2020 22:30:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0TFpbCsD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgCIWa3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Mar 2020 18:30:29 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49460 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726838AbgCIWa2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Mar 2020 18:30:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 029MT3dR088987;
        Mon, 9 Mar 2020 22:30:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=LkiaoyoSWku8YZ+2W3EROEjvc3IGrlg0Ep+rNmD9L4A=;
 b=0TFpbCsDDoFco2aYDlCLukT/3Glqso91cQ2df3m3IltwjT3Fkl6Y9sRAHzYTJtNcK3bb
 SygqTsHPMVnXyezMVxeI9QkkzKe/pU93q2YLO1xi7LX8Y9T1l5hgG45Xo6BruQke8OvC
 B07t+i9IiscsNkS51dBBxWb0OuczVPL/tgdKKYJB0wcvpIsu7qgubMnQkaAe2Kn4zycx
 ehIfDS6dDuS4FZWtPtNZ3iVWFlEb4+cwycFMQv8nzt25RTxreSR7d0s0zRymZQFxvEaB
 zzk/DTUsFAQ921WfzUad7XDEwRTvU1hYFnug1mZVum49ZMWHhXeOx9AjfCp+febo+0aP IQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ym31u9ybd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Mar 2020 22:30:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 029MQseH013416;
        Mon, 9 Mar 2020 22:30:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ymnb18380-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Mar 2020 22:30:15 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 029MUFdv005606;
        Mon, 9 Mar 2020 22:30:15 GMT
Received: from localhost (/10.159.248.213)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Mar 2020 15:30:14 -0700
Date:   Mon, 9 Mar 2020 15:30:15 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH][next] libxfs: xfs_format.h: Replace zero-length array
 with flexible-array member
Message-ID: <20200309223015.GN1752567@magnolia>
References: <20200309202842.GA9666@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309202842.GA9666@embeddedor>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9555 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003090135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9555 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003090135
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Please cc patches to the xfs mailing list.

On Mon, Mar 09, 2020 at 08:28:42PM +0000, Gustavo A. R. Silva wrote:
> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:
> 
> struct foo {
>         int stuff;
>         struct boo array[];
> };
> 
> By making use of the mechanism above, we will get a compiler warning
> in case the flexible array does not occur last in the structure, which
> will help us prevent some kind of undefined behavior bugs from being
> inadvertently introduced[3] to the codebase from now on.
> 
> Also, notice that, dynamic memory allocations won't be affected by
> this change:
> 
> "Flexible array members have incomplete type, and so the sizeof operator
> may not be applied. As a quirk of the original implementation of
> zero-length arrays, sizeof evaluates to zero."[1]

Are they subject to the same padding rules & quirks as zero-length
arrays?  I ask this mostly because we've had trouble with unaligned
flexible array members in struct xfs_agfl for years.  Though I guess
xfs_ondisk.h checks that now, so my question becomes: have you tracked
down the compilers that have gotten it wrong and made sure it's no more
broken than before? :)

--D

> This issue was found with the help of Coccinelle.
> 
> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> [2] https://github.com/KSPP/linux/issues/21
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  fs/xfs/libxfs/xfs_format.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 77e9fa385980..4b2748e669a7 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1673,7 +1673,7 @@ struct xfs_acl_entry {
>  
>  struct xfs_acl {
>  	__be32			acl_cnt;
> -	struct xfs_acl_entry	acl_entry[0];
> +	struct xfs_acl_entry	acl_entry[];
>  };
>  
>  /*
> -- 
> 2.25.0
> 
