Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17CB0C388F9
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Nov 2020 22:43:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92E422244C
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Nov 2020 22:43:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JpX1e30S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgKPWnl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Nov 2020 17:43:41 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57880 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgKPWnl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Nov 2020 17:43:41 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AGMe7EV051191;
        Mon, 16 Nov 2020 22:43:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=h50QLh1IuyYUjuLKxJsYNagcxaLG4NZZCT04Dn/Okks=;
 b=JpX1e30SKT5LM9jQ+OFOgI5Eka1WGJLvT0bImuDzojiPn3z9Yh22gNZLElH0/l1fHlVd
 UpONwyfydm63VRg5Ri9PZOhq9NE2h+D1LtRXdO9GmqDoSaj1EPx8zCdBnMS+ODI0n6F6
 f6ecjBccWUMp2Uwz6f1UKJ647XRjUt4iJmg9tbACKkd8sw2PvrPGZUhDo2E2K1WoTN6Q
 eFYyghhdf89tK3uQckvuLYIEbQREaG8F7SXvo0YZ4Gme9CbL1DlXhMkzvHaATC41fMOM
 fbOU01wv23fwHPpEBvUn82AN4pE1Lruhh0qaRoAPR5vyp64ciLLW6zkfdftHDVp6fiB3 VA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34t76kqpyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 16 Nov 2020 22:43:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AGMeUXu159835;
        Mon, 16 Nov 2020 22:41:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 34ts5v99xu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Nov 2020 22:41:38 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AGMfaEP029393;
        Mon, 16 Nov 2020 22:41:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Nov 2020 14:41:36 -0800
Date:   Mon, 16 Nov 2020 14:41:35 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/26] xfs_db: report bigtime format timestamps
Message-ID: <20201116224135.GV9695@magnolia>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
 <160375537615.881414.8162037930017365466.stgit@magnolia>
 <c0460761-65ba-0dbf-4b61-f262e19a16bb@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0460761-65ba-0dbf-4b61-f262e19a16bb@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011160136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011160136
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 16, 2020 at 03:16:17PM -0600, Eric Sandeen wrote:
> On 10/26/20 6:36 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Report the large format timestamps.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> hch had some concerns about this, but we didn't seem to reach a
> resolution... I'd like to get the bigtime stuff done this release
> and not navel-gaze too much about weird abis etc, so I'm inclined
> to just take this and we can fix it later in the release and/or
> when somebody hits that BUG_ON...
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

...and while I wasn't looking/these patches were all sitting in my dev
tree, this[1] happened.  So now that musl unconditionally defines time_t
to be an int64_t even on 32-bit platforms, I guess this is broken and
I'll try to go whip up a fix.

--D

[1] https://musl.libc.org/time64.html
