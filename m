Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08DF0C433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 20:38:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B09B221E8
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 20:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgLCUir (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 15:38:47 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:39462 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLCUir (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 15:38:47 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3KPgec190378;
        Thu, 3 Dec 2020 20:38:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=0AEd0dfiMxMQ7S/8kMIB8Xdf/93lJ/CIQoBXuNFS9qE=;
 b=W4r7jmXOIyiSHQGXIwD6UXHToDHSvqMVWMElIPMeQrpwv0u37qjds5EHeNVVEcR8DZ34
 xds9rLQ9RlRX9aYv4QZ//f0wGaVKqV2SA1aH8DK9gsgF9mON/w9zy3eg3WT0LIIFBC2r
 /VaR5PvWZM9i1Dh91NA2aNGvbJY9FCfMKImgV/wk12/MCEDOuiMLtpSkaHsUbYOG+UWc
 5b5US+MsMzEtGPWugFSvRlwY/CDCKJfqWpGBO0ezXwn5jj+vd+qDF1epHGKjQaylM2xg
 rNu+/wPOx5H4PDJQ7AOsXsl1mP7fpg0xPLg1HZZ9drz7pEESnCs3lKVjT0bnxNcO1ScE 1A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 353c2b879r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Dec 2020 20:38:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3KaOKU151509;
        Thu, 3 Dec 2020 20:38:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3540awt28b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Dec 2020 20:38:02 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B3Kc1xO025526;
        Thu, 3 Dec 2020 20:38:01 GMT
Received: from localhost (/10.159.242.140)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 12:38:01 -0800
Date:   Thu, 3 Dec 2020 12:38:00 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/3] xfs_quota: document how the default quota is stored
Message-ID: <20201203203800.GM106272@magnolia>
References: <44dcd8f3-0585-e463-499f-44256d8bad8d@redhat.com>
 <2e9b1d0f-7ad8-b42a-ac2b-b1fdd9a9fb45@redhat.com>
 <20201203200753.GJ106272@magnolia>
 <8e0e818a-4e39-6a9b-fe89-19d786b82f12@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e0e818a-4e39-6a9b-fe89-19d786b82f12@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=1
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030119
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 03, 2020 at 02:12:58PM -0600, Eric Sandeen wrote:
> On 12/3/20 2:07 PM, Darrick J. Wong wrote:
> > On Thu, Dec 03, 2020 at 02:00:01PM -0600, Eric Sandeen wrote:
> >> Nowhere in the man page is the default quota described; what it
> >> does or where it is stored.  Add some brief information about this.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>  man/man8/xfs_quota.8 | 5 +++++
> >>  1 file changed, 5 insertions(+)
> >>
> >> diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
> >> index dd0479cd..b3c4108e 100644
> >> --- a/man/man8/xfs_quota.8
> >> +++ b/man/man8/xfs_quota.8
> >> @@ -178,6 +178,11 @@ to a file on
> >>  where the user's quota has not been exceeded.
> >>  Then after rectifying the quota situation, the file can be moved back to the
> >>  filesystem it belongs on.
> >> +.SS Default Quotas
> >> +The XFS quota subsystem allows a default quota to be enforced for any user which
> > 
> > "user"?  Does this not apply to group or project quotas? ;)
> 
> I thought about that, but the overview section already refers to "users" as a
> generic idea, i.e. "Quotas can be set for each individual user on any/all of the
> local filesystems."
> 
> I mean, I guess I could s/user/ID/ to be more clear or rewrite the whole overview...

<shrug> "The XFS quota subsystem allows a default quota to be enforced
for any user, group or project which does not have a quota limit
explicitly set."

> >> +does not have a quota limit explicitly set. These limits are stored in and

"These limits are stored in and displayed as ID 0's limits."

since id==0 doesn't necessarily map to "root" unless
/etc/{passwd,group,projid} explicitly defines that.

--D

> > 
> > Usual complaint about starting sentences in column zero in manpage
> > source. :)
> 
> grumble grumble random nonobvious rules grumble ok
> 
> -Eric
> 
> > --D
> > 
> >> +displayed as the "root" user's limits, although they do not actually limit the
> >> +root user.
> >>  .SH USER COMMANDS
> >>  .TP
> >>  .B print
> >> -- 
> >> 2.17.0
> >>
> >>
> > 
> 
