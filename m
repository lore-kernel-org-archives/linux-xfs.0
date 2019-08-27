Return-Path: <SRS0=DGLX=WX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5849CC3A5A3
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 15:19:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29107217F5
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 15:19:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ptpJ6xil"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfH0PTN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 11:19:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60660 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbfH0PTN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Aug 2019 11:19:13 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7RFBuxa113026;
        Tue, 27 Aug 2019 15:19:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=i8K8iXvu+F4S3TlmhSzrwn8hrY0Eo6XBhihlcXSGjvQ=;
 b=ptpJ6xilt/e/zCialTzBimxGhpL6V2Vg+9TuIYrz4lEKk/KmgmLRmYFo5gcmQPs7tiqJ
 Ar9+GaJ4phbgJ62A/vvFaO2PvZZXzIA4Au9sYFiV+GzJ37nfCNdkauXpuOvsWfwfr/BZ
 zt+T/TR9u3mryUaXsTkWk4pXDLUL3+T5vRwGdknLSqsH6V+2qzh0F9oH/f56gjI1LVn+
 JtxYqrH4RqiYHXygBG8m1bE41huQCDM8ZqshQOEK7wM+/E22Ya8ZNshnEGYwNhsEZk0T
 nVm36l+z6SBaDu6QhEMf/Md7zz7g7O1qSuoBDi01o48WuAFFJjKHKwU9B3fmloUE+cWW aw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2un6x1r258-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Aug 2019 15:19:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7RFIXUd127774;
        Tue, 27 Aug 2019 15:19:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2un5rjm32t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Aug 2019 15:19:04 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7RFJ3PM029098;
        Tue, 27 Aug 2019 15:19:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Aug 2019 08:19:02 -0700
Date:   Tue, 27 Aug 2019 08:19:01 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com
Subject: Re: [PATCH 4/4] xfs: fix sign handling problem in
 xfs_bmbt_diff_two_keys
Message-ID: <20190827151901.GB1037350@magnolia>
References: <156685612356.2853532.10960947509015722027.stgit@magnolia>
 <156685614992.2853532.4191470495720238021.stgit@magnolia>
 <20190826231555.GP1119@dread.disaster.area>
 <4f959cf2-4381-ffa0-ad58-9e12a40534f1@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f959cf2-4381-ffa0-ad58-9e12a40534f1@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9362 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908270156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9362 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908270155
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 27, 2019 at 08:01:16AM -0500, Eric Sandeen wrote:
> On 8/26/19 6:15 PM, Dave Chinner wrote:
> > On Mon, Aug 26, 2019 at 02:49:09PM -0700, Darrick J. Wong wrote:
> >> From: Darrick J. Wong <darrick.wong@oracle.com>
> >>
> >> In xfs_bmbt_diff_two_keys, we perform a signed int64_t subtraction with
> >> two unsigned 64-bit quantities.  If the second quantity is actually the
> >> "maximum" key (all ones) as used in _query_all, the subtraction
> >> effectively becomes addition of two positive numbers and the function
> >> returns incorrect results.  Fix this with explicit comparisons of the
> >> unsigned values.  Nobody needs this now, but the online repair patches
> >> will need this to work properly.
> >>
> >> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> >> ---
> >>  fs/xfs/libxfs/xfs_bmap_btree.c |   16 ++++++++++++++--
> >>  1 file changed, 14 insertions(+), 2 deletions(-)
> >>
> >>
> >> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> >> index fbb18ba5d905..3c1a805b3775 100644
> >> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> >> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> >> @@ -400,8 +400,20 @@ xfs_bmbt_diff_two_keys(
> >>  	union xfs_btree_key	*k1,
> >>  	union xfs_btree_key	*k2)
> >>  {
> >> -	return (int64_t)be64_to_cpu(k1->bmbt.br_startoff) -
> >> -			  be64_to_cpu(k2->bmbt.br_startoff);
> >> +	uint64_t		a = be64_to_cpu(k1->bmbt.br_startoff);
> >> +	uint64_t		b = be64_to_cpu(k2->bmbt.br_startoff);
> >> +
> >> +	/*
> >> +	 * Note: This routine previously casted a and b to int64 and subtracted
> >> +	 * them to generate a result.  This lead to problems if b was the
> >> +	 * "maximum" key value (all ones) being signed incorrectly, hence this
> >> +	 * somewhat less efficient version.
> >> +	 */
> >> +	if (a > b)
> >> +		return 1;
> >> +	else if (b > a)
> >> +		return -1;
> > 
> > No need for an else here, but otherwise OK.
> > 
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> In fact having the else means the a == b case isn't handled, even if it
> should never happen, so might a static checker eventually complain about
> reaching the end of a non-void function?

Hmm?  There's a return 0 after that which Dave's reply clipped.

--D

> -Eric
> 
