Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BADBCA9EAE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 16:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AF9920717
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 16:23:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q3JG8Z/e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389960AbfJ2QXh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 12:23:37 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35302 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389940AbfJ2QXh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 12:23:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TGK7qC081710;
        Tue, 29 Oct 2019 16:23:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=PeeD53/IjjeRMkomuOXiBoAaLUIf60XFu7NM8jMuIGo=;
 b=Q3JG8Z/eqOa5G+LOFXuboSgRMNa35X7SU1u841IJHeWbLis+dY9BDBvxEoYCBxqr07/k
 tyCkMQWT6DnUyGWz5Kka6m61u8+MjjEd+IO90auCpp50xBTx/0kCrbM+AzS2jHOeZnyb
 ELvuXPeSdZhE9cBDIUrLtPFLFcAAptNIwJHvwyFzjt7rHvudDd/xIEkO2J1/sDA8Pldk
 dZpMEawelq5dzdj6HGMvMFpJeLm02EmMBB9I9U0aSdUTYgDIR/vR7VWoLd4Ov/z9t9GQ
 MWZDSa5r1cuddinGkpM3H4Gu5OWJNZEYQaE0D5SWhpdJBIdEKkGMz4j+y0GJ4806rdwT Yw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2vvdjuak4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 16:23:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TGI9Bt109726;
        Tue, 29 Oct 2019 16:23:31 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2vxpgf85uh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 16:23:31 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9TGNUu1012897;
        Tue, 29 Oct 2019 16:23:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Oct 2019 09:23:30 -0700
Date:   Tue, 29 Oct 2019 09:23:30 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: namecheck directory entry names before listing
 them
Message-ID: <20191029162330.GD15222@magnolia>
References: <157198048552.2873445.18067788660614948888.stgit@magnolia>
 <157198050564.2873445.4054092614183428143.stgit@magnolia>
 <20191025125628.GD16251@infradead.org>
 <20191025160448.GI913374@magnolia>
 <20191029071615.GB31501@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029071615.GB31501@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910290146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910290146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 29, 2019 at 12:16:15AM -0700, Christoph Hellwig wrote:
> On Fri, Oct 25, 2019 at 09:04:48AM -0700, Darrick J. Wong wrote:
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > 
> > > Note that we can remove the check for '/' from xfs_dir2_namecheck for
> > > currentl mainline, given that verify_dirent_name in common code now has
> > > that check.
> > 
> > We can't, because this is the same function that xfs_repair uses to
> > decide if a directory entry is garbage.
> 
> So we'll at least need to document that for now.  And maybe find a way
> to not do the work twice eventually in a way that doesn't break repair.

What if we promote EFSCORRUPTED and EFSBADCRC to the vfs (since 5
filesystems use them now); change the VFS check function to return that;
and then we can just drop the xfs readdir calls to dir2_namecheck?

--D
