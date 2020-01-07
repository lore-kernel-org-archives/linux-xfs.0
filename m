Return-Path: <SRS0=eQYP=24=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D223C282DD
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 19:37:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 753FA214D8
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 19:37:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l6yOEPVe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbgAGThs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jan 2020 14:37:48 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45010 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728454AbgAGThs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jan 2020 14:37:48 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 007JYCYQ070361;
        Tue, 7 Jan 2020 19:37:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=PbtPKlMGf7rQeYXu72gjdbZ5tS7/+7P93T+3RQZmVzs=;
 b=l6yOEPVeyJBFoHLjm9aLjb5n9H/H/Dr08uVrGlFYi0/v/GsZvFEiaBoDB+yjBJj5prM5
 u0gxhRCQVourmtrdczy8Kn/7X/89bOSRpMevF4Rn/GsFHk53sF7CWD1mfrd2TZXsL0C8
 nlj5W+XLw6Sn/sfP9assxdgogbXqO9lPCqkuX/AzWW/hFf40awHzihufA1pkDvflb+Nm
 Z79ggDXsfii4/BlKW6zIJI5ib06VN/OzWSXZLyYtP8lefRHcx3vpIjAHBLxQmT5pmgS1
 grm4j1SNB+JONEDfgncJXrZYFVnPv0GOgPW2x9LZsob59XjSArBxaYfBvt5nEkcvGLGe kQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2xaj4tyu3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jan 2020 19:37:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 007JXW4i168584;
        Tue, 7 Jan 2020 19:35:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2xcjvdu992-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jan 2020 19:35:39 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 007JZcHb005569;
        Tue, 7 Jan 2020 19:35:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jan 2020 11:35:38 -0800
Date:   Tue, 7 Jan 2020 11:35:37 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] misc: support building flatpak images
Message-ID: <20200107193537.GD917713@magnolia>
References: <157784176039.1372453.10128269126585047352.stgit@magnolia>
 <157784176718.1372453.6932244685934321782.stgit@magnolia>
 <20200107142035.GA17614@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107142035.GA17614@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001070154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001070154
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 07, 2020 at 06:20:35AM -0800, Christoph Hellwig wrote:
> On Tue, Dec 31, 2019 at 05:22:47PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Poke the system until it supports building flatpaks.  Maybe.
> 
> Why would we want to support such a fucked up package delivery
> mechanism?

In theory we could use it as a means to distribute uptodate xfs_repair
so that anyone with a problem that their distro's copy of xfs_repair
can't or won't fix can try upstream without having to build xfsprogs
themselves.

Though I wonder how many people in that situation are running some
colorful linux distribution but are too stingy to pay for a support
contract.... :)

Also, can you elaborate on 'fucked up package delivery mechanism'?

Admittedly I'm /not/ volunteering to maintain a xfs_repair flatpak, so
perhaps I should just drop this whole thing.

--D
