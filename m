Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC46AC5DF61
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 06:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E187218AE
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 06:44:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KZsXsO0P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbfKGGoS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 01:44:18 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:59676 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbfKGGoS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 01:44:18 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA76hurQ192453;
        Thu, 7 Nov 2019 06:44:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=0rpg1HEjwlssesUt/BwllmUuPcZcgM6B4yGQ7s6Gc3U=;
 b=KZsXsO0P9TNx2Zr63cEODUxYO2XDKxi3Ss32yNKlEYh6DEPWDtj/S/KD5boEYCo3i0CW
 YYPmldxYKl21iwi7I2xIOsg3JlDZzubtSb6nh7Mb5vdCymDva9beeKWGCwpGBXoskP0m
 ACcHsr0vPvtxpMXvbHZpIwTn5etoHTnXquE6aVR0uKovykPTqMoYGyqchHKh9XgkjD1y
 AUhdVnPnjV28WgeYZIfwvRQ/D9Dp8AMiklwTS5J847hXa1Tu3XTL6blAbIZx+aLmZJ+W
 Of142e4lNM/Y8/4uDDaj0Bw0mgdDMC5965YI+2oN7cY7/Z02upbPrrpxkXfKM4/bDETx /g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2w41w0uvgk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 06:44:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA76hqWk191719;
        Thu, 7 Nov 2019 06:44:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2w41wgd3kn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 06:44:13 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA76iBWE000681;
        Thu, 7 Nov 2019 06:44:12 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 22:44:11 -0800
Date:   Thu, 7 Nov 2019 09:44:04 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Colin Ian King <colin.king@canonical.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] xfs: remove redundant assignment to variable error
Message-ID: <20191107064404.GL10409@kadam>
References: <20191106155248.266489-1-colin.king@canonical.com>
 <20191106155631.GJ4153244@magnolia>
 <cbb99652-c6b2-c81c-128d-6d85be04fddc@canonical.com>
 <a77fff95-0591-bcca-2541-3fd68c0da908@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a77fff95-0591-bcca-2541-3fd68c0da908@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070068
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070068
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 10:19:18AM -0600, Eric Sandeen wrote:
> 
> 
> On 11/6/19 9:59 AM, Colin Ian King wrote:
> > On 06/11/2019 15:56, Darrick J. Wong wrote:
> >> On Wed, Nov 06, 2019 at 03:52:48PM +0000, Colin King wrote:
> >>> From: Colin Ian King <colin.king@canonical.com>
> >>>
> >>> Variable error is being initialized with a value that is never read
> >>> and is being re-assigned a couple of statements later on. The
> >>> assignment is redundant and hence can be removed.
> >>>
> >>> Addresses-Coverity: ("Unused value")
> >>
> >> Er... is there a coverity id that goes with this?
> > 
> > Unfortunately it is a private one, so it does not make sense to use it.
> 
> If it's not in the upstream coverity scan (and AFAICT it's not),
> it makes no sense to reference coverity in the commit log.
> It's not useful to anyone IMHO.
> 

It's sort of useful if want to see how the bug was found or if you want
to count how many bugs coverity finds...  I'm pretty sure I remember
someone complaining that it wasn't mentioned in the commit.

regards,
dan carpenter
