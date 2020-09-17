Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8589C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 16:07:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E4D922583
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 16:07:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nNXjLofA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgIQQC0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 12:02:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43590 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728274AbgIQQBo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 12:01:44 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HFibLP039696;
        Thu, 17 Sep 2020 15:54:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=vpziPoGoR+m4nOxghzrKWLdl/ZBQuEliVb5bX+RP+Aw=;
 b=nNXjLofASs/4ICuV5Kxr6CYOsiD7OhWd3ghtFL34G/OI1YDaGuB1gq3UuncYKXbphXYS
 0B5EWZWOHW80DMgoH1tXWGEfgauE1jII4+AvH59B857mHOSDH+dJvElT8HWQJDUQkQkU
 SiEPl5YXEDEgCL32Vk0jh8e1E/Z4CTlDqg9NlwnlbXPaHkHgo1KnzgD5YSXNQfkk+per
 G/ElZsjNg4FDIX6ofZbp9zSAuWTwdnzPqnmfXv/5NAqHEpbdWLpkyjdNBA5kq4VWf4wW
 kpiAQM4QY7yfCfuQ5aYRlgSjvl5ND/uCye/TgU3Chv6E2Dd+EO2U0niHmVvzoNdt7VLg yg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33j91duub1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 15:54:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HFjn4f048496;
        Thu, 17 Sep 2020 15:54:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33h88br2xp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 15:54:43 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08HFsfQe019925;
        Thu, 17 Sep 2020 15:54:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 15:54:41 +0000
Date:   Thu, 17 Sep 2020 08:54:39 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Xiao Yang <yangx.jy@cn.fujitsu.com>, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 03/24] generic/607: don't break on filesystems that don't
 support FSGETXATTR on dirs
Message-ID: <20200917155439.GY7955@magnolia>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013419510.2923511.4577521065964693699.stgit@magnolia>
 <5F62BEAD.3090602@cn.fujitsu.com>
 <20200917032730.GQ7955@magnolia>
 <5F62DB4E.9040506@cn.fujitsu.com>
 <20200917035620.GR7955@magnolia>
 <20200917075245.GC26262@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917075245.GC26262@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=1 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=1 mlxlogscore=999
 clxscore=1011 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170120
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 08:52:45AM +0100, Christoph Hellwig wrote:
> On Wed, Sep 16, 2020 at 08:56:20PM -0700, Darrick J. Wong wrote:
> > Oops, sorry, I was reading the wrong VM report.  It's overlayfs (atop
> > xfs though I don't think that matters) that doesn't support FSGETXATTR
> > on directories.
> 
> I think we should overlayfs to support FSGETXATTR on all files that
> can be opened instead.

Heh, yes, that would be a better option. :)

Even if they do add it, though, I still think we need to be able to
_notrun this test to avoid failures on unpatched kernels?

This also makes me wonder, we lose all the FSGETXATTR state on copy-up,
don't we?  Since the VFS doesn't have a primitive for cloning all the
metadata?

--D
