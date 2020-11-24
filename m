Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14DE3C63697
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 00:35:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4B9A20758
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 00:35:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JfH5rbzU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbgKXAfK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Nov 2020 19:35:10 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:35026 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728339AbgKXAfJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Nov 2020 19:35:09 -0500
X-Greylist: delayed 631 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Nov 2020 19:35:08 EST
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO0FOn3059161;
        Tue, 24 Nov 2020 00:25:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=iVBq0hiyY4s1Y9vKkB54kExkXAnt6i5Se5UGScodWr4=;
 b=JfH5rbzUTGT28JsltbSl7Qt69wkn1R0CHeLYWSoHifgXNHxC5I1w4AS9QxgkVYd4I3zj
 URUqZoQQwkFSJB4DZuT2JPJUoIZRiORMMA/aLQ1kwUgKiIrVY0YbXPwC+X16qFHwQIhr
 3yI6kq9Pqf4sIDEekIWfprX/RxnTH3Y4rcCJDkyRGMYtFxDTWkNgheS8tgHNFa3UhcFB
 YiqSoPazxfFdV40GWv6+gsRHD9g9VrEPUijS8Du/VER1rVrx9EevjzSILq8xTxmTBslZ
 aD7OlpnYn0ngyIGhuiDwfSVT/+ehfTOCY3HOm7Ayf92G3TrJ0sR1x87bVwO0R/5ELQhI Tg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 34xtaqkj0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Nov 2020 00:25:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO0G2gG059968;
        Tue, 24 Nov 2020 00:25:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34ycfmk00r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 00:25:28 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AO0PSR3011536;
        Tue, 24 Nov 2020 00:25:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Nov 2020 16:25:27 -0800
Date:   Mon, 23 Nov 2020 16:25:27 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/26] xfs_logprint: refactor timestamp printing
Message-ID: <20201124002527.GE7880@magnolia>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
 <160375529676.881414.3983778876306819986.stgit@magnolia>
 <3922d9ed-4ced-a92f-1b0c-749b44d79c1f@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3922d9ed-4ced-a92f-1b0c-749b44d79c1f@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 suspectscore=1 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 clxscore=1015 suspectscore=1 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 23, 2020 at 02:14:27PM -0600, Eric Sandeen wrote:
> On 10/26/20 6:34 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Introduce type-specific printing functions to xfs_logprint to print an
> > xfs_timestamp instead of open-coding the timestamp decoding.  This is
> > needed to stay ahead of changes that we're going to make to
> > xfs_timestamp_t in the following patches.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  logprint/log_misc.c      |   18 ++++++++++++++++--
> >  logprint/log_print_all.c |    3 +--
> >  logprint/logprint.h      |    2 ++
> >  3 files changed, 19 insertions(+), 4 deletions(-)
> > 
> 
> Just for the record, I decided to not take this one; the helper function
> with the somewhat vague "compact" arg at the callers doesnt' really seem
> worth it, I just open-coded this at the 2 callsites when I did the merge.

<nod> it was kind of questionable from the start :)

--D

> Thanks,
> -Eric
