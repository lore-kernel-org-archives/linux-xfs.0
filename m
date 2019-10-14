Return-Path: <SRS0=3dSt=YH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E1DC4CECE
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 19:06:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96915206A3
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 19:06:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nUKh70Jd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733231AbfJNTGA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Oct 2019 15:06:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49652 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733149AbfJNTF7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Oct 2019 15:05:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9EJ4BYD148155;
        Mon, 14 Oct 2019 19:05:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=blDrIQgZJsGufQOaKp9RS+O9ljRPRBS2RsY8yHio/xQ=;
 b=nUKh70JdDfpb6yTAW65oosjIFnzO/W64glePSfKXaJUcXwA755b4tDgGT/iy3DhXBEXB
 tuTJOpIoqsfcPguksyu5DOLpqO/cIecelD2C83OOUYFxPvNriQRvu43Dcw8XQCVbGtw7
 IoNUL0rMbn9A0irPHe4O73rDp6JOalkmgN3RUInzsS7sc6LcuDLiYUiPXd86wrDQoojn
 iWUAcjhQWXkhj9Y3UYGdvb7HAvllOATjgmo5YBQcG9VQ3/HcgJ3MWRm3MjhKlCugsIiD
 VauPW2a/liYO9BJGwS7mXCvtoN+tr9D5G/xEkvrk7Tn9uryeZvSDeBhG5eUWfO5v5wTH Wg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2vk68ub008-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Oct 2019 19:05:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9EJ2gYf049521;
        Mon, 14 Oct 2019 19:05:55 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2vkr9xjsb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Oct 2019 19:05:55 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9EJ5s3T008812;
        Mon, 14 Oct 2019 19:05:54 GMT
Received: from localhost (/10.159.144.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Oct 2019 19:05:54 +0000
Date:   Mon, 14 Oct 2019 12:05:53 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs: remove the XLOG_STATE_DO_CALLBACK state
Message-ID: <20191014190553.GH26541@magnolia>
References: <20191009142748.18005-1-hch@lst.de>
 <20191009142748.18005-9-hch@lst.de>
 <20191012004145.GP13108@magnolia>
 <20191014072224.GF10081@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014072224.GF10081@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910140155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910140156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 14, 2019 at 09:22:24AM +0200, Christoph Hellwig wrote:
> On Fri, Oct 11, 2019 at 05:41:45PM -0700, Darrick J. Wong wrote:
> > > -#else
> > > -#define xlog_state_callback_check_state(l)	((void)0)
> > > -#endif
> > 
> > So, uh... does this debugging functionality just disappear?  Is it
> > unnecessary?  It's not clear (to me anyway) why it's ok for the extra
> > checking to go away.
> 
> Lets ask the counter question:  What kind of bug do you think this
> check would catch?

Dunno, that's why I'm asking /you/ :)

I think the answer is that DO_CALLBACK is pretty pointless since we
already have a CALLBACK state, and the removed debugging function checks
among all the iclogs for a state that shouldn't be possible (getting
ready to be doing callbacks when there are other iclogs further along in
the list that are still syncing or ioerror'd)?  Particularly since we
probably end up moving the iclog to the actual CALLBACK state pretty
quickly anyway?

--D
