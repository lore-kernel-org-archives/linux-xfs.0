Return-Path: <SRS0=Xde3=3T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32C6FC33CB3
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 18:54:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BBF92082E
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 18:54:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Rev1/Dny"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729906AbgA3SkR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jan 2020 13:40:17 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57562 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729896AbgA3SkO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jan 2020 13:40:14 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00UIDJCt094526;
        Thu, 30 Jan 2020 18:40:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=lTHOu5vEZqviy/uZf+mEf6YR+JKvLgqdr4rZBOFV/AU=;
 b=Rev1/DnyizFPqxjflBgzbvXJ104D0InDcURF7gGApVKYNidcFq6m3R+HgzkeHMhcAd4M
 5f/ufl60u+0ez7AFEWx7WvJW0I5H6OJ2LocUVv5i/oYFJORObNd88suXdqVg3vNle7pk
 KjW09nbVUxy4O7BCaTM11sZNUA/ZxoL7lw+56EeVf2JhiWefOnE0rQOkGQPs0h7gfdkq
 RoOU46DbLwd8FUbPPkG03EKMyTENO8NKqbukZescIU/Dc1oMzpAB52m7v7tWGQffu5Iz
 g6fq/UPfMxOMHUyks8ZYZTZ8qZGhu5W9MDMjXfBuVmqiEjRRYKY+M2jVoMn9vFE3GYkl WQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xrdmqx32q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jan 2020 18:40:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00UIES6o012881;
        Thu, 30 Jan 2020 18:40:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xuherfdtu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jan 2020 18:40:09 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00UIe8jA007805;
        Thu, 30 Jan 2020 18:40:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Jan 2020 18:40:08 +0000
Date:   Thu, 30 Jan 2020 10:40:07 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/8] libxfs: remove duplicate attr function declarations
Message-ID: <20200130184007.GB3447196@magnolia>
References: <157982499185.2765410.18206322669640988643.stgit@magnolia>
 <20200130181330.GY3447196@magnolia>
 <55cb3628-9211-6ddb-6edf-24fffc684108@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55cb3628-9211-6ddb-6edf-24fffc684108@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9516 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001300127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9516 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001300127
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 30, 2020 at 12:28:43PM -0600, Eric Sandeen wrote:
> On 1/30/20 12:13 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Remove these function declarations since they're in libxfs/xfs_attr.h
> > and are therefore redundant.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Is it worth keeping this exporting hack around to make static checkers
> happy if it's just one more thing to keep up to date in userspace?

Probably?  It depends on how much you like culling known false positives
when you run smatch/sparse against xfsprogs.

(I for one don't mind not having to remember that stuff...)

--D

> -Eric
