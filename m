Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86287C4361A
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 19:36:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 207B8221EC
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 19:36:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgLCTfx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 14:35:53 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49866 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgLCTfw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 14:35:52 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3JXsEk066148;
        Thu, 3 Dec 2020 19:35:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ktpsBuOrDbTehcj8AiyFyNd3/5AhoSR2vgj/AXFV16c=;
 b=Ijr/5s0UzLE96lUPncF6lS2Djvaem5ox4uFw640kLI42LVrQ2rrP8o731npxfZwykmhe
 bJ/i45hfIP0ieHyfWLXZIHiD/GRRYNzOWMcVNtkM7i1B+dGa2XutrhOkWYpd+cJHDJAX
 ugEC6rBErDV0PnRGKh1JtyQPMb5f7Qcvk12I7R6urOOml6b8c5NLg/IJaZrI8ABobAok
 JL9d1pgwkq6qSlvf83SOOXOgr7mAW4q3Kj0L9QbTJftXT/WESTSIbVZlbVosl1QhXVsU
 IEBHBZhF0Ev4dTjoxMQVRxZKhmSVzreQje+0AuU7faxNuduIDBaVoh8mJCNqPMqTngro 4w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 353dyqywva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Dec 2020 19:35:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3JQPge157064;
        Thu, 3 Dec 2020 19:35:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 3540awpy2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Dec 2020 19:35:09 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B3JZ84U004638;
        Thu, 3 Dec 2020 19:35:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 11:35:08 -0800
Date:   Thu, 3 Dec 2020 11:35:07 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dan Melnic <dmm@fb.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: xfsprogs and libintl
Message-ID: <20201203193507.GI106272@magnolia>
References: <B8D4A2D8-01A0-40D6-AB89-887BD0B1F4B4@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B8D4A2D8-01A0-40D6-AB89-887BD0B1F4B4@fb.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=922 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1011 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=933
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030113
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 03, 2020 at 07:15:39PM +0000, Dan Melnic wrote:
> Hi,
> 
> If we compile some code both with libintl.h and libxfs/xfsprogs, we can end up, based on the include order, with the 
> # define textdomain(d) do { } while (0) 
> before: 
> extern char *textdomain (const char *__domainname) __THROW;
> 
> This will cause a compile error.
> I think the ENABLE_GETTEXT check should not leak into any public headers.

What public header file?

$ grep textdomain /usr/include/xfs/
$ grep ENABLE_GETTEXT /usr/include/xfs/
$

> /* Define if you want gettext (I18N) support */
> #undef ENABLE_GETTEXT
> #ifdef ENABLE_GETTEXT
> # include <libintl.h>
> # define _(x)                   gettext(x)
> # define N_(x)  x
> #else
> # define _(x)                   (x)
> # define N_(x)  x
> # define textdomain(d)          do { } while (0)
> # define bindtextdomain(d,dir)  do { } while (0)
> #endif
> 
> https://github.com/osandov/xfsprogs/blob/master/include/platform_defs.h.in#L48

platform_defs.h is private to the xfsprogs code base; what are you
doing?

Confused,

--D

> 
> Thanks,
> 
> Dan
> 
> 
