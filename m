Return-Path: <SRS0=maQ1=AO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F983C433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jul 2020 20:26:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F73120890
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jul 2020 20:26:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G+WrCJIH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgGCU02 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Jul 2020 16:26:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58866 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgGCU02 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Jul 2020 16:26:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 063KGQZf026961;
        Fri, 3 Jul 2020 20:26:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=0n6HEZ7sx+dFrCQTwRi3ywoXfh1qxFf3RQBtz+7JDSA=;
 b=G+WrCJIHQpLDOT9roTNVeBZfKsaMV8g6L7d7wrnSp93zBm1EDvb3bV0Q7DJDiJfBVzZn
 SAPBQnskCW5XBWJEs97M9wDNNw2/sLPqtB0BsNUcz63XsUxstwlc4H9MtQHhSjoa7MPE
 ObL/7jIcEtvepyoiPQC4AwSXUoKBVOTgqyH3d5t1Zx4kUZx5bagIE9R0zppy1hN0j3mL
 v9JRZmirLUL/XF0zH8jBu0D8EUhCihg+X5cPaQwhKyhFzIwchmcgxhnkokQw42oDIPnR
 7bAeRf5gtK5RXUMxqe5MAVuWbHDrC6cKmoEo6xAxiW2rcKF+IdmUPynyAlfMvKKMiNYs SQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31wxrnq0ye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 03 Jul 2020 20:26:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 063KIs4K119788;
        Fri, 3 Jul 2020 20:26:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 31xg1dadud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jul 2020 20:26:23 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 063KQLp1005455;
        Fri, 3 Jul 2020 20:26:22 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jul 2020 20:26:21 +0000
Date:   Fri, 3 Jul 2020 13:26:20 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH v2 06/12] xfs_repair: create a new class of btree rebuild
 cursors
Message-ID: <20200703202620.GT7625@magnolia>
References: <159107201290.315004.4447998785149331259.stgit@magnolia>
 <159107205193.315004.2458726856192120217.stgit@magnolia>
 <20200702151801.GB7606@magnolia>
 <c5969f81-3921-e2fd-ddcf-818ca3e59324@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5969f81-3921-e2fd-ddcf-818ca3e59324@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9671 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=1 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007030138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9671 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=1 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007030138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 02, 2020 at 10:24:30PM -0500, Eric Sandeen wrote:
> On 7/2/20 10:18 AM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create some new support structures and functions to assist phase5 in
> > using the btree bulk loader to reconstruct metadata btrees.  This is the
> > first step in removing the open-coded AG btree rebuilding code.
> > 
> > Note: The code in this patch will not be used anywhere until the next
> > patch, so warnings about unused symbols are expected.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v2: set the "nearly out of space" slack value to 2 so that we don't
> > start out with tons of btree splitting right after mount
> 
> This also took out the changes to phase5_func() I think, but there is no
> V2 of 07/12 to add them back?

Doh.  Do you want me just to resend the entire pile that I have?  I've
forgotten which patches have been updated because tracking dozens of
small changes individually via email chains is awful save for the
automatic archiving.

--D

> -Eric
