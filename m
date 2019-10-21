Return-Path: <SRS0=IeGX=YO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 491BECA9EAF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 20:29:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AD6F2067B
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 20:29:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LMythNb0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387407AbfJUU3I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Oct 2019 16:29:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40930 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387406AbfJUU3I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Oct 2019 16:29:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9LKT2mV189554;
        Mon, 21 Oct 2019 20:29:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=q6i310SjUjRTtR3voSYYvcKHxyGQI5aGC4SM9R+BMNw=;
 b=LMythNb0L20sY2S+ghQ8REqUBa8uW4z6JDSZlUi5EX4wAl4czM1E3tF5sHyzm5yiUjX+
 cGZKlbAJxremHeYJjb6Neyjn0WkoTPvJIWy0bYLzICnnFyToySW59CVBM4XcVnrwJnaV
 aarN5eqFYIobfhgkRcITMScxWOStHyZ2Kd7oJHzIGBizJGiYOqnz9A6lff7jqMbATBuZ
 72PUKHY8jvuFpVB84yD0TKYHjkMHGYfW7zUFP2Ws6ceGNjhHz3SVnpCLWeNujVZ1ETRe
 N7tt3MmbS9ebQHxeOI7EMmlJsKD74nUe7zXNKn/5W9WChGdktMEQiPlVSzIy7ZJHUdf2 +A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2vqswtac5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Oct 2019 20:29:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9LKSHie076731;
        Mon, 21 Oct 2019 20:29:05 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2vrcnawa5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Oct 2019 20:29:04 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9LKT4QF023908;
        Mon, 21 Oct 2019 20:29:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Oct 2019 13:29:04 -0700
Date:   Mon, 21 Oct 2019 13:29:02 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/11] xfs_scrub: create a new category for unfixable
 errors
Message-ID: <20191021202902.GG913374@magnolia>
References: <156944736739.300131.5717633994765951730.stgit@magnolia>
 <156944743430.300131.9710870375452494499.stgit@magnolia>
 <9ad60a97-0931-f85b-d31d-bf503d4e514d@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ad60a97-0931-f85b-d31d-bf503d4e514d@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910210197
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910210197
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 21, 2019 at 02:45:17PM -0500, Eric Sandeen wrote:
> On 9/25/19 4:37 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > There's nothing that xfs_scrub (or XFS) can do about media errors for
> > data file blocks -- the data are gone.  Create a new category for these
> > unfixable errors so that we don't advise the user to take further action
> > that won't fix the problem.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> <bikeshed>
> What if unfixable_errors was a subcounter for total errors_found?
> Would that simplify all the places that need to check both?

Unfixable errors need to be tracked separately because we advise the
user on what xfs tool to run next if @errors_found (aka corruption
errors) or @runtime_errors are greater than zero.  There is no xfs
utility that you can run to fix things like file data loss.

(I mean, you can fix the unfixable by restoring from backups, maybe we
should say that?)

--D

> Or would that be confusing?
> 
> </bikeshed>
> 
