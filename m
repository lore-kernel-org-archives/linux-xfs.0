Return-Path: <SRS0=EAe2=4B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19209C352A4
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 01:55:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE4C520724
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 01:55:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f+pjcNoW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729333AbgBMBzp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Feb 2020 20:55:45 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:43452 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729313AbgBMBzp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Feb 2020 20:55:45 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01D1sCJl003529;
        Thu, 13 Feb 2020 01:55:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=eUEeIsVUV9pbqNdD+WQV5MyFdTJFE/Uh7Rf9Kkc8clY=;
 b=f+pjcNoWj4OCXOV3+Zv+zGD8cq/cZi8LApnB3IQqMJupg4FiM9YHt288vzg9YbMkObq4
 FSd5aX6yCXXCvOeXcXTefy83uzqbWi2sl242TS0x85z4ps+7aoTzFqbCAzWhW/Re8Zkn
 ZuS60YN2kHDPx9ossL6GYqxjZZYhbh1vsgVhWgauKi90tkPrX+SfVQYD3mywEXn8I8Ef
 ruwQoKLMBk2al+3SXm1e1o4XxQtnL1RRd3cQNAWgMPufeeINKwEurOJ9HSmbe6+ij8Pe
 P44F0Vdht2Mt0GN4Om9L4iIwXy7sJKcvb6G7fWtUX/RyGnkBEVvfIYPn6vt+FbQqAz/S hQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2y2p3spfd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 13 Feb 2020 01:55:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01D1rfuX165686;
        Thu, 13 Feb 2020 01:53:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2y4k33dupf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Feb 2020 01:53:41 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01D1rex6032333;
        Thu, 13 Feb 2020 01:53:40 GMT
Received: from localhost (/10.159.151.237)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Feb 2020 17:53:40 -0800
Date:   Wed, 12 Feb 2020 17:53:38 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/14] xfs: explicitly define inode timestamp range
Message-ID: <20200213015338.GA6870@magnolia>
References: <157784106066.1364230.569420432829402226.stgit@magnolia>
 <157784106702.1364230.14985571182679451055.stgit@magnolia>
 <639ba6e0-71b3-1d81-820e-ad49a56a032c@sandeen.net>
 <20200213012607.GW6870@magnolia>
 <7ae0af7b-bc7f-95ac-582c-1f5b2c11487f@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ae0af7b-bc7f-95ac-582c-1f5b2c11487f@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9529 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002130014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9529 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 impostorscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002130014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 12, 2020 at 07:50:02PM -0600, Eric Sandeen wrote:
> On 2/12/20 7:26 PM, Darrick J. Wong wrote:
> > On Wed, Feb 12, 2020 at 05:00:59PM -0600, Eric Sandeen wrote:
> >> On 12/31/19 7:11 PM, Darrick J. Wong wrote:
> >>> From: Darrick J. Wong <darrick.wong@oracle.com>
> >>>
> >>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ...
> 
> >>>  static inline void __init
> >>>  xfs_check_ondisk_structs(void)
> >>>  {
> >>> +	/* make sure timestamp limits are correct */
> >>> +	XFS_CHECK_VALUE(XFS_INO_TIME_MIN, 			-2147483648LL);
> >>> +	XFS_CHECK_VALUE(XFS_INO_TIME_MAX,			2147483647LL);
> >>
> >> IMHO this really shouldn't be in a function with this name, as it's not checking
> >> an ondisk struct.  And I'm not really sure what it's protecting against?
> >> Basically you put an integer in one #define and check it in another?
> > 
> > Admittedly /this/ part isn't so crucial, because S32_MAX is never going
> > to be redefined.  However, I added this for completeness; notice that
> > the patch that widens xfs_timestamp_t adds similar checks for the new
> > minimum and maximum timestamp, whose values are not so straightforward.
> > 
> > Also, I get that this isn't directly checking an ondisk structure, but
> > given that we use these constants, there ought to be a check against
> > incorrect computation *somewhere*.  The BUILD_BUG_ON macros don't
> > produce any real code (and this function is called at __init time) so
> > what's the harm?
> 
> OCD?  Maybe just make a xfs_check_time_vals() to go with
> xfs_check_ondisk_structs() or something.

Done.

--D

> -Eric
