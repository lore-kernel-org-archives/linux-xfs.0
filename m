Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CAFDC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 15:09:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A857206B5
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 15:09:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rsRCzv+o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725781AbgHXPJH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 11:09:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34966 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727036AbgHXPIp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Aug 2020 11:08:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07OF8Sxp005862;
        Mon, 24 Aug 2020 15:08:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=WIEAunfvpebQwdMMGaTdQskRvyWBPd2/e+fiMwWEOVw=;
 b=rsRCzv+oms5y90ywKDeD6C4B5FBfEPPBhwuh66s522bqxpAwgCW/Xebx58muTnxzi2E5
 omtmGaIPUsJAA+OSdkiR+Jfvjo9/XRAlYjwhFZ3z7DWJvJqllxwjXwC9AHoGrTsvBc6F
 j/4dfE+nUsBRC0WgBOYM5ZrHjTHcC9FdlxnHgIKZfcj7PtfI97h4hQGLdG+Dt+9chkM0
 n7tVGyV+fUiyA/NExI0VHq0hjkzkjplVYGu6WmhXMUdp/viKUpuLU23aACrspWQF0aCs
 RRZFu4mFCnYDlrQxHMcqfJT2FfH+k4D0HT4D+FJ33BGlPnOG/oNR8Y0EyJiHsToEibiv Hg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 333cshw5sh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 24 Aug 2020 15:08:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07OF0Ce9193965;
        Mon, 24 Aug 2020 15:08:35 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 333ru51wkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Aug 2020 15:08:35 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07OF8Xs1021101;
        Mon, 24 Aug 2020 15:08:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Aug 2020 08:08:33 -0700
Date:   Mon, 24 Aug 2020 08:08:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH] xfs: use log_incompat feature instead of speculate
 matching
Message-ID: <20200824150832.GV6096@magnolia>
References: <20200823172421.GA16579@xiangao.remote.csb>
 <20200824081900.27573-1-hsiangkao@aol.com>
 <20200824083402.GB16579@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824083402.GB16579@xiangao.remote.csb>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9722 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=1 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008240121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9722 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 lowpriorityscore=0 suspectscore=1 mlxlogscore=999 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008240122
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 24, 2020 at 04:34:02PM +0800, Gao Xiang wrote:
> On Mon, Aug 24, 2020 at 04:19:00PM +0800, Gao Xiang wrote:
> > From: Gao Xiang <hsiangkao@redhat.com>
> > 
> > Use a log_incompat feature just to be safe.
> > If the current mount is in RO state, it will defer
> > to next RW remount.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> > 
> > After some careful thinking, I think it's probably not working for
> > supported V4 XFS filesystem. So, I think we'd probably insist on the
> > previous way (correct me if I'm wrong)...
> > 
> > (since xfs_sb_to_disk() refuses to set up any feature bits for non V5
> >  fses. That is another awkward setting here (doesn't write out/check
> >  feature bits for V4 even though using V4 sb reserved fields) and
> >  unless let V4 completely RO since this commit. )
> > 
> > Just send out as a RFC patch. Not fully tested after I thought as above.
> 
> Unless we also use sb_features2 for V4 filesystem to entirely
> refuse to mount such V4 filesystem...
> Some more opinions on this?

Frankly, V4 is pretty old, so I wouldn't bother.  We only build new
features for V5 format.

--D

> Thanks,
> Gao Xiang
> 
