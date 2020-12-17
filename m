Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BC42C4361B
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Dec 2020 00:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E0EB23D1C
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Dec 2020 00:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbgLQA7q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Dec 2020 19:59:46 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44486 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbgLQA7q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Dec 2020 19:59:46 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH0sJZW114836;
        Thu, 17 Dec 2020 00:58:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=d/jWUewRA4FR6A076hhgFrAeTsTCrFy6w4RPbVOmsdQ=;
 b=hXdV85auWLolM1zwQEA1DuJH+VOYjyEzLUsybW3xcmnKTBWnzxOvHjEMdwxbXPj3u3WH
 Run3xrKPvq6PoV8R5GsrajKnqjqz9UFkxTzij2Pb2j/rwB63scqVfegZRcRJMiSpqJvl
 74VBG4ArZxw4fT6HYExSenZNLmbR+iX//MmF4rW2R/exDZsTke1qAep6AHYtb4PzQkW9
 kjphKAiekJJc+RYDqsKpjfXuKdUDuagnBSAcctV7PMMT+LGA/Joxk929PSw86cT+V4LU
 XhC3tuOr6d7jyqc2WSG5d4hr+P428oM2Xsy2VHeV32UT7GOeuZzZzqP2PO10+p32HYKk Mw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 35cn9rk45a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Dec 2020 00:58:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH0tAL5031575;
        Thu, 17 Dec 2020 00:58:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 35e6esmuae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 00:58:54 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BH0wn6C030701;
        Thu, 17 Dec 2020 00:58:49 GMT
Received: from localhost (/10.159.128.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Dec 2020 16:58:49 -0800
Date:   Wed, 16 Dec 2020 16:58:48 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Thomas Deutschmann <whissi@gentoo.org>
Subject: Re: [PATCH V2] xfsdump: don't try to generate .ltdep in inventory/
Message-ID: <20201217005848.GE6918@magnolia>
References: <15af018c-caf7-71e7-c353-96775d7173ba@redhat.com>
 <ad5ad420-1c4d-7f53-a2a6-51480836ea09@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad5ad420-1c4d-7f53-a2a6-51480836ea09@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012170003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 clxscore=1011 spamscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012170003
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 16, 2020 at 04:32:07PM -0600, Eric Sandeen wrote:
> .ltdep gets generated from CFILES, and there are none in inventory/
> so trying to generate it in that dir leads to a non-fatal error when
> the include invokes the rule to build the .ltdep file:
> 
> Building inventory
>     [LTDEP]
> gcc: fatal error: no input files
> compilation terminated.
> 
> inventory/ - like common/ - has files that get linked into other dirs,
> and .ltdep is generated in those other dirs, not in inventory/.
> 
> So, simply remove the .ltdep include/generation from the inventory/
> dir, because there is no reason or ability to generate the file here.
> 
> Reported-by: Thomas Deutschmann <whissi@gentoo.org>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

/me has long wondered why the source files in inventory and common are
built separately for dump and restore instead of being dumped into a
shared .a file and linked from both tools.  There's probably some
reason, though whether or not I really want to go digging into Yet
Another Pile is questionable...

For shutting up the warning,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> V2: more comprehensive problem description
> 
> diff --git a/inventory/Makefile b/inventory/Makefile
> index cda145e..6624fba 100644
> --- a/inventory/Makefile
> +++ b/inventory/Makefile
> @@ -12,5 +12,3 @@ LSRCFILES = inv_api.c inv_core.c inv_fstab.c inv_idx.c inv_mgr.c \
>  default install install-dev:
>  
>  include $(BUILDRULES)
> -
> --include .ltdep
> 
