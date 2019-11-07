Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84AC1C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 22:03:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50D0C20679
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 22:03:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ej7SL0ls"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbfKGWDO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 17:03:14 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39482 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfKGWDN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 17:03:13 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA7LxNT7041181;
        Thu, 7 Nov 2019 22:03:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=caBQ4APPq5Vt6s+rJlcvYq6uLfVJB6rOPPKIIaRtFS4=;
 b=Ej7SL0ls1IlqCtSlouxb1VrEFfZRHDLNKbFBPFY8dB4BMhxmSeENZTnCtKf7+pENnKdC
 dPdCsH7wpyASnHWBQFO/PFb2ytyQhdM09lrkd8rEb+cgrKfXEAqnlddTcTXqlA1YLQby
 DqBLpj5IIXlwCsXvLxcAC3MwCV73d+N3zxgeuXqZ6hOFpJJ48p8QqfToPUFHgZH334XL
 EgNOP9wJgmxzliUm8V6ctSuA516sqjkVkwL29Ku8ejKceu3hNxc2vgq9x9xUY96Du7qP
 T/JiwIkMpQdR1ZJL7gElXFrssawnp4yoQBcaGsZu5rOcRsgPsP5lAfOR1wKDEqk53P4S eQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2w41w11ast-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 22:03:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA7LxR4F132371;
        Thu, 7 Nov 2019 22:03:09 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2w41wjaa5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 22:03:09 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA7M38Bg027285;
        Thu, 7 Nov 2019 22:03:08 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 14:03:07 -0800
Date:   Thu, 7 Nov 2019 14:03:06 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Joe Perches <joe@perches.com>
Cc:     linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: Correct comment tyops -> typos
Message-ID: <20191107220306.GI6219@magnolia>
References: <0ceb6a89da4424a4500789610fae4d05ba45ba86.camel@perches.com>
 <20191107212541.GF6219@magnolia>
 <e8187485a6ee7fffef738f90cddfa052ccdb927c.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8187485a6ee7fffef738f90cddfa052ccdb927c.camel@perches.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070203
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070203
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 01:56:13PM -0800, Joe Perches wrote:
> On Thu, 2019-11-07 at 13:25 -0800, Darrick J. Wong wrote:
> > On Wed, Nov 06, 2019 at 10:01:15PM -0800, Joe Perches wrote:
> > > Just fix the typos checkpatch notices...
> > > 
> > > Signed-off-by: Joe Perches <joe@perches.com>
> > 
> > Looks ok,
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Darrick?  You are the listed maintainer here.
> Are you applying this or just reviewing it?

Applying it, though there's another 50+ patches to go...

--D

> 
> 
