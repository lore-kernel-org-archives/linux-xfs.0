Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6161C35E0D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 18:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2B672084E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 18:40:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zda+3AcH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731636AbgBYSke (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 13:40:34 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:38146 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731647AbgBYSke (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 13:40:34 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PIcdoL061964;
        Tue, 25 Feb 2020 18:40:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=bB1RwkXmCY6PqY3VjK6H1sVOQQahxe6L3erYroQF0ms=;
 b=zda+3AcHb0oCVcSAiRCep+fD8uQlSNu83qkVIZp2GaxEGnqDFCnO2u2Cj2NyGBpZhCto
 TMwkm6y2368CBLtzn58uP9mqWLcm5sDbTKWMUIwmgqG1Hpr4f6jLG8Fd8D6WxB81XUBv
 gBjI/Vto6npRZLH9bfWlak7aQZnV8xkXKfd8KTnKkGMx9UpiXPHAQDqN5WujUimGiNJP
 UPLCUDIYQXoeJF3MvR/N+9ywE6NoUdYfAKq8EWGv7NUnuX2o5r7puILOWge2rqiOPW0O
 l7e3PKVMxs4BUDRUb8b6tNoZUr1iThgGL6nN8/4NmzVyyQAX6Yknm+bbVkIWrz/6Y7js ww== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2yd0m1uc54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 18:40:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PIcEht043017;
        Tue, 25 Feb 2020 18:40:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2yd09b7bt6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 18:40:25 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01PIeOqv014625;
        Tue, 25 Feb 2020 18:40:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Feb 2020 10:40:24 -0800
Date:   Tue, 25 Feb 2020 10:40:23 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/25] libxfs: open-code "exit on buffer read failure" in
 upper level callers
Message-ID: <20200225184023.GJ6740@magnolia>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
 <158258949476.451378.9569854305232356529.stgit@magnolia>
 <20200225174252.GG20570@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225174252.GG20570@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 mlxlogscore=597
 spamscore=0 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 impostorscore=0 spamscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 malwarescore=0
 mlxlogscore=657 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250131
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 09:42:52AM -0800, Christoph Hellwig wrote:
> On Mon, Feb 24, 2020 at 04:11:34PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Make all functions that use LIBXFS_EXIT_ON_FAILURE to abort on buffer
> > read errors implement that logic themselves.  This also removes places
> > where libxfs can abort the program with no warning.
> 
> How are the libxfs_mount changes related to this commit message?
> 
> All the other bits looks fine, but those changes seem to have slipt in
> without a good reason.

Prior to this patch, the "!(flags & DEBUGGER)" expressions in the call
sites evaluate to 0 or 1, and this effectively results in libxfs_mount
passing EXIT_ON_FAILURE to the buffer read functions as the flag value.
The flag value is passed all the way down to __read_buf, and when it
sees an IO failure, it exits.

After this patch, libxfs_mount passes flags==0, which means that we get
a buffer back, possibly with b_error set.  If b_error is set, we log a
warning about the screwed up filesystem and return a null mount if the
libxfs_mount caller didn't indicate that it is a debugger.  Presumably
the libxfs_mount caller will exit with error if we return a null mount.

IOWs, I'm doing exactly what the commit message says, but in a rather
subtle way.  I'll clarify that, if you'd like.

--D
