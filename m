Return-Path: <SRS0=chL6=C7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC646C4363D
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 16:05:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2D5B22206
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 16:05:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WQCkUfgn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgIVQFf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Sep 2020 12:05:35 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:55374 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgIVQFf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Sep 2020 12:05:35 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MFnlkD041814;
        Tue, 22 Sep 2020 16:05:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=i6QAce4Uu6vZmqwevnE6oFbtEwPSGJyaKBFmh5esjSo=;
 b=WQCkUfgnUml59kj0vo1iMaExTXoA3AakTtbJi9MSX1aDbd7TJw8P81hLLwT7AAI4xB++
 QDDqkr1Ore647FLbNgH2I99Ep/1rFq7cKCeEsG4CeAldUfUiZ2Og0y+XjyDeQCtatgwx
 wSPF9K5WAbaQkZ3JXwiB/W9Irxqh+2W0tLgHIQ9OSxo5Ecr+0iCA1sZuCyoo2dXVywHF
 1PsybTrg8Gs3kyZfOeC0qqMIg6E+DFVT6oTTX0+iLS00uGbe0mWVPosI5ms9WxzstLT2
 cG/9g9ufgyuCPQk5enyYZuyPi2NxCiIY28Fxo0S28A9u7n5nabmTdopMhM/NjOM7QQpi sw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 33qcpttn3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 16:05:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MFntPn004987;
        Tue, 22 Sep 2020 16:03:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33nuw49qd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 16:03:30 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08MG3Tdf026657;
        Tue, 22 Sep 2020 16:03:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Sep 2020 09:03:28 -0700
Date:   Tue, 22 Sep 2020 09:03:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: drop the obsolete comment on filestream locking
Message-ID: <20200922160328.GG7955@magnolia>
References: <20200922034249.20549-1-hsiangkao.ref@aol.com>
 <20200922034249.20549-1-hsiangkao@aol.com>
 <20200922044428.GA4284@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922044428.GA4284@xiangao.remote.csb>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 suspectscore=1 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 adultscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 spamscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220122
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 22, 2020 at 12:44:28PM +0800, Gao Xiang wrote:
> On Tue, Sep 22, 2020 at 11:42:49AM +0800, Gao Xiang wrote:
> > From: Gao Xiang <hsiangkao@redhat.com>
> > 
> > Since commit 1c1c6ebcf52 ("xfs: Replace per-ag array with a radix
> > tree"), there is no m_peraglock anymore, so it's hard to understand
> > the described situation since per-ag is no longer an array and no
> > need to reallocate, call xfs_filestream_flush() in growfs.
> > 
> > In addition, the race condition for shrink feature is quite confusing
> > to me currently as well. Get rid of it instead.
> > 
> 
> (Add some words) I think I understand what the race condition could mean
> after shrink fs is landed then, but the main point for now is inconsistent
> between code and comment, and there is no infrastructure on shrinkfs so
> when shrink fs is landed, the locking rule on filestream should be refined
> or redesigned and xfs_filestream_flush() for shrinkfs which was once
> deleted by 1c1c6ebcf52 might be restored to drain out in-flight
> xfs_fstrm_item for these shrink AGs then.
> 
> From the current code logic, the comment has no use and has been outdated
> for years. Keep up with the code would be better IMO to save time.

Not being familiar with the filestream code at all, I wonder, what
replaced all that stuff?  Does that need a comment?  I can't really tell
at a quick glance what coordinates growfs with filestreams.

--D
