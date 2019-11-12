Return-Path: <SRS0=Awhw=ZE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A022BC43331
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 23:08:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78F2021925
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 23:08:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aD2Bi9aD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbfKLXIS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 18:08:18 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45950 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727200AbfKLXIR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 18:08:17 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xACN4iM3104249;
        Tue, 12 Nov 2019 23:08:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=T2fnG6Hb2pr+1ENmkGZTphTB38Rls0niggevjdB5oIs=;
 b=aD2Bi9aDtqJbckI6d+wqHmOLVSvHlrd3mLwBamm90jKVaC2y5Iafz9nJ9Nyr/6ZwZooN
 VdUVVZesw8zhFMkRLgl1CNQVwXtVTSA/SxbT7x/kz9L3CeYVGMX+A71ntCpD2TvvgFv9
 8WUkw883LngI5zXli+ZW0vF41CR+4Kzr1C9RAsvizFwK6Obw+Kf7svBfmxRqA+XxJLsS
 MF/DgOUTgr8iL5HdamClXUe8hvxxBuloIwHc69IRaseCAA7ly8iiLG1otdQMlSw5GfI6
 Pkx+VqynvaPKTqgO/oCDF1DKBNAsHox7+RoFl3w05r0eTKNiyrlMsv87BxZMQwIKaBZT Ow== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2w5ndq8642-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Nov 2019 23:08:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xACN4NVC029603;
        Tue, 12 Nov 2019 23:08:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2w7vbbqrrq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Nov 2019 23:08:09 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xACN88Zt004944;
        Tue, 12 Nov 2019 23:08:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Nov 2019 15:08:08 -0800
Date:   Tue, 12 Nov 2019 15:08:06 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.org
Subject: Re: [PATCH 2/3] xfs: kill the XFS_WANT_CORRUPT_* macros
Message-ID: <20191112230806.GB6219@magnolia>
References: <157343507145.1945685.2940312466469213044.stgit@magnolia>
 <157343508488.1945685.9867882880040545380.stgit@magnolia>
 <20191111085117.GA5729@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111085117.GA5729@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=960
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911120199
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911120199
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 11, 2019 at 12:51:17AM -0800, Christoph Hellwig wrote:
> I have to say I really hate the macro that includes the actual
> if statement. 

Agreed, especially because it breaks coccinelle and other tools that
don't deal well with random identifiers that "inexplicably" have
statement blocks coming after them.

> On Sun, Nov 10, 2019 at 05:18:05PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The XFS_WANT_CORRUPT_* macros conceal subtle side effects such as the
> > creation of local variables and redirections of the code flow.  This is
> > pretty ugly, so replace them with explicit if_xfs_meta_bad() tests that
> > remove both of those ugly points.  First we use Cocinelle to expand the
> > macros into an if test and braces with the following coccinelle script:
> 
> Also all this seems to be out of date.

Yeah.

--D
