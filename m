Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24EC9C5DF60
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:49:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9C8121848
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:49:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LdNyoJK/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbfKHHtO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 02:49:14 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36126 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfKHHtO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 02:49:14 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA87nBH3090432;
        Fri, 8 Nov 2019 07:49:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=FGLuacyOSWWJUuZlCuDmNXxl4FVyeKF5ErCj9wdsbJg=;
 b=LdNyoJK/BkzvlSXlLbRoCtMp7asL36md8M3wEeRpsLAEdPmQtGJw7om6bbYFwAbRrGpw
 TyY5yI9IuJ8No9uqzBWH0O/UkPPzVYbGoFsBti1nt+stzsEJs2dCZmb3QeJ1w93W/HPv
 fVCkJL+nqBVEGFFi0rRe/ihJ1+XRX74ndxymWUkpgWgmxb+EKBXUiyEUfOMTI0l4DN04
 55p0p8vU8SX9VAKNhaTRYcOd8ar4atw+pm7cg6GKpI3Vl6SFxZNWzStn2KGn/zH2sVqe
 G2xR6OWy3OXT4DImLuC4sA4f2m6TR7S0UfnfucMt3C2jlF6JfhN6uEWrPUjBEs+M9lDN pQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2w41w13he1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 07:49:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA87mpkZ084190;
        Fri, 8 Nov 2019 07:49:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2w41wh376v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 07:49:10 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA87n8ZN012889;
        Fri, 8 Nov 2019 07:49:08 GMT
Received: from localhost (/10.159.236.44)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 23:49:08 -0800
Date:   Thu, 7 Nov 2019 23:49:07 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove XFS_IOC_FSSETDM and XFS_IOC_FSSETDM_BY_HANDLE
Message-ID: <20191108074907.GS6219@magnolia>
References: <20191108052303.15052-1-hch@lst.de>
 <20191108064801.GM6219@magnolia>
 <20191108065032.GA30861@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108065032.GA30861@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080077
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080077
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 08, 2019 at 07:50:32AM +0100, Christoph Hellwig wrote:
> On Thu, Nov 07, 2019 at 10:48:01PM -0800, Darrick J. Wong wrote:
> > On Fri, Nov 08, 2019 at 06:23:03AM +0100, Christoph Hellwig wrote:
> > > Thes ioctls set DMAPI specific flags in the on-disk inode, but there is
> > > no way to actually ever query those flags.  The only known user is
> > > xfsrestore with the -D option, which is documented to be only useful
> > > inside a DMAPI enviroment, which isn't supported by upstream XFS.
> > 
> > Hmm, shouldn't we deprecate this at least for one or two releases?
> > 
> > Even if it's functionally pointless...
> 
> It sets a value we can't even retreive.  Not sure what the deprecation
> would help with.

Dotting i's and crossing t's.  IOWs, not getting ourselves yelled at for
killing something without any warning / bureaucracy. :/

--D
