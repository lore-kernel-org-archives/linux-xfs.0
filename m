Return-Path: <SRS0=mG4f=AP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFAB8C433DF
	for <linux-xfs@archiver.kernel.org>; Sat,  4 Jul 2020 03:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CF0C20658
	for <linux-xfs@archiver.kernel.org>; Sat,  4 Jul 2020 03:39:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L0cdwUUd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgGDDjh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Jul 2020 23:39:37 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41690 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbgGDDjg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Jul 2020 23:39:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0643WW9U132863;
        Sat, 4 Jul 2020 03:39:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=HgXvRTdcwpCw3IeQeqr02AL51/acD5HKESvrVUUrhuw=;
 b=L0cdwUUdll4mQTNREHVcs2XVMlLCQMCBGERLaQFpZ9Xokk7pUTrFbMAs7D0gL5b7llAH
 dKnYEUnRWKytjSmhfb7O8JICAMksfQL/8Z0G1TStks1ekGWKpeNvkODWiVkAHkcDMHdV
 nKF8gJ9A6Z/e8LOx4mvSb+8prvm6CGIJk16j9LfZLBq7z92E+/AsBRx23Lwwm2USvpKU
 +aSjouVVNJ8y0qCe872TzAK1RVVjdDEdLqCm6pX2fJCSFlXnUnougQ2DKvBHR0gO3KbB
 ikLHB2fimjxoLmDzQUeJt9tm09uyTULLrgTA9W9uMP4psQZNzACBTdAzFzwwY7CZ1WZH GQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31wxrnqk15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 04 Jul 2020 03:39:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0643Xv3b071376;
        Sat, 4 Jul 2020 03:39:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 322evqns6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 04 Jul 2020 03:39:32 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0643dVwa010215;
        Sat, 4 Jul 2020 03:39:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 04 Jul 2020 03:39:30 +0000
Date:   Fri, 3 Jul 2020 20:39:30 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH v2 06/12] xfs_repair: create a new class of btree rebuild
 cursors
Message-ID: <20200704033930.GV7625@magnolia>
References: <159107201290.315004.4447998785149331259.stgit@magnolia>
 <159107205193.315004.2458726856192120217.stgit@magnolia>
 <20200702151801.GB7606@magnolia>
 <c5969f81-3921-e2fd-ddcf-818ca3e59324@sandeen.net>
 <20200703202620.GT7625@magnolia>
 <929bdc40-027d-b942-d7b5-6e26bc5be3a5@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <929bdc40-027d-b942-d7b5-6e26bc5be3a5@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9671 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007040024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9671 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007040024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 03, 2020 at 04:51:10PM -0500, Eric Sandeen wrote:
> On 7/3/20 3:26 PM, Darrick J. Wong wrote:
> > On Thu, Jul 02, 2020 at 10:24:30PM -0500, Eric Sandeen wrote:
> >> On 7/2/20 10:18 AM, Darrick J. Wong wrote:
> >>> From: Darrick J. Wong <darrick.wong@oracle.com>
> >>>
> >>> Create some new support structures and functions to assist phase5 in
> >>> using the btree bulk loader to reconstruct metadata btrees.  This is the
> >>> first step in removing the open-coded AG btree rebuilding code.
> >>>
> >>> Note: The code in this patch will not be used anywhere until the next
> >>> patch, so warnings about unused symbols are expected.
> >>>
> >>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> >>> ---
> >>> v2: set the "nearly out of space" slack value to 2 so that we don't
> >>> start out with tons of btree splitting right after mount
> >>
> >> This also took out the changes to phase5_func() I think, but there is no
> >> V2 of 07/12 to add them back?
> > 
> > Doh.  Do you want me just to resend the entire pile that I have?  I've
> > forgotten which patches have been updated because tracking dozens of
> > small changes individually via email chains is awful save for the
> > automatic archiving.
> 
> I think I have it all good to go but if you want to point me at a branch to
> compare against that might be good.

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-quotacheck_2020-07-02

--D

> 
> Thanks,
> -Eric
