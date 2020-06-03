Return-Path: <SRS0=rMVI=7Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7739EC433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 16:54:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5255A20738
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 16:54:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rGECPAFz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbgFCQyE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Jun 2020 12:54:04 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48378 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgFCQyE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jun 2020 12:54:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 053Gq7TI073570;
        Wed, 3 Jun 2020 16:54:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=BO4MBDNDnfKmD8Pk416xJWijIj2+Achkl0+2yqqTpXA=;
 b=rGECPAFzDf7UuRPXSA3kPg0oS8tA6zAZNHWbNMc41d0J1HW57OTPBRPSzssUAfnierkU
 HBZcfRvg9+n2d+PGBUTtu1ccmAnklgL5l1TW1qpIq0Nel2qJjpTR98ft6MVTXSG0Woep
 LmILuXa4sUAiW1Auuh00MBrGsarc0hOpOzeE5BAAYVnQcGdFGT2Y2LB/IA6807xlhCvM
 WZmOaHMNZh/mR3nLbMNcSO7p/Hsav8Ik0jydyj4fYwglWd7dxn3lp9s4OjsCJPU0inZZ
 IYWjYulLFWh+fl1kkyXp1YEKez/Odm9teQ6nDMJlr7G1lOtzxTyUpibgqKxzU0f4pA8i ew== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31ef1ng7xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 03 Jun 2020 16:54:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 053GhTJU068011;
        Wed, 3 Jun 2020 16:52:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 31c12r5gjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jun 2020 16:52:01 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 053Gq1bk017309;
        Wed, 3 Jun 2020 16:52:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 03 Jun 2020 09:52:01 -0700
Date:   Wed, 3 Jun 2020 09:52:00 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [XFS SUMMIT] Ugh, Rebasing Sucks!
Message-ID: <20200603165200.GM2162697@magnolia>
References: <20200527184858.GM8230@magnolia>
 <20200528000351.GA2040@dread.disaster.area>
 <20200528024410.GM252930@magnolia>
 <20200528223932.GB2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528223932.GB2040@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9641 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=1 spamscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006030131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9641 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 clxscore=1015
 malwarescore=0 priorityscore=1501 impostorscore=0 spamscore=0
 suspectscore=1 bulkscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 mlxscore=0 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006030132
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 29, 2020 at 08:39:32AM +1000, Dave Chinner wrote:
> On Wed, May 27, 2020 at 07:44:10PM -0700, Darrick J. Wong wrote:
> > On Thu, May 28, 2020 at 10:03:51AM +1000, Dave Chinner wrote:
> > > From my perspective, an update from for-next after the -rc6 update
> > > gets me all the stuff that will be in the next release. That's the
> > > major rebase for my work, and everything pulled in from for-next
> > > starts getting test coverage a couple of weeks out from the merge
> > > window.  Once the merge window closes, another local update to the
> > > -rc1 kernel (which should be a no-op for all XFS work) then gets
> > > test coverage for the next release. -rc1 to -rc4 is when
> > > review/rework for whatever I want merged in -rc4/-rc6 would get
> > > posted to the list....
> > 
> > <nod>
> > 
> > My workflow is rather different -- I rebase my dev tree off the latest
> > rc every week, and when a series is ready I port it to a branch off of
> > for-next.
> 
> I do actually update the base kernel quite frequently - usually
> every monday after a -rc is released. This is easy, and rarely
> causes rebase issues because all the XFS changes in the base tree
> have already been in the for-next tree. i.e. my typical weekly
> "rebase" is:
> 
> git remote update
> for each git branch:
> 	guilt pop -a
> 	git reset --hard origin/master # latest Linus tree
> 	git merge linux-xfs/for-next
> 	<merge any dependencies>
> 	loop {
> 		guilt push -a
> 		<fix patch that doesn't apply>
> 	} until all patches applied
> 
> If there's no significant change in for-next, then this is all easy
> and is done in a few minutes. But if there's substantial change to
> for-next, then the problems occur when pushing the patches back
> onto the stack...
> 
> I've always based my dev work on the for-next branch (or equivalent
> dev tree tip) because that way I'm always testing the latest dev
> code from everyone else and I know my code works with it.

<nod>

> > Occasionally I'll port a refactoring from for-next into my
> > dev tree to keep the code bases similar. 
> 
> Yup, that's the "<merge any dependencies>" in the process above.
> i.e. someone has posted a cleanup patchset that's going to be merged
> into for-next before the work I'm doing. That's where all the recent
> problems have been coming from - the pain either occurs at the next
> for-next update, or I take it when it's clear it's going to be
> merged soon...

<nod> I guess the difference is that I don't generally merge for-next
wholesale into my dev tree, so that's probably why I didn't see quite as
much for-next-churn troubles. :/

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
