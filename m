Return-Path: <SRS0=Xde3=3T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93938C2D0DB
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 18:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E40320658
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 18:33:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EqhmrcS4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbgA3Sd7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jan 2020 13:33:59 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51942 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727657AbgA3Sd6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jan 2020 13:33:58 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00UIDJtR094519;
        Thu, 30 Jan 2020 18:33:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=9/wzNPxWUYX5Q6VjudSG4qeXkojiW+SFhPn3SvItykA=;
 b=EqhmrcS4GtikkUQV+0iQCgg2so3eM8VMAzi2zilal7SNpAjXwEsUFFM1SQ0QS171PlYo
 POwQM6hDTjdI9v/oxoluvF+efFaallr0Kr0w3oAOrHXEX9R3/JNRjnaZiv5EYfKJeLbJ
 vcqYvobOwWQFXJwtNAan8In2m7miZ+cSVC6aUi7wcpW0rPjgcUTiEitRNwsWe8qW91nH
 j6lPB+LJ8Fc3TC39NCzuBEG4610ePNrfc7v+82v02uySo6Y9MRF+9Kp+kRqGCWHZ+XQ4
 5RHWv0+mF0cGN8WPf3FipzyEtozqGSdWs+EaHnEU7Nlia6lijldVDpu44Zcdu9+6vyi8 4A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xrdmqx220-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jan 2020 18:33:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00UIESHr105582;
        Thu, 30 Jan 2020 18:31:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2xuc30m4sp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jan 2020 18:31:41 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00UIVdGs022618;
        Thu, 30 Jan 2020 18:31:40 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Jan 2020 10:31:39 -0800
Date:   Thu, 30 Jan 2020 10:31:38 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/8] xfs_repair: don't corrupt a attr fork da3 node when
 clearing forw/back
Message-ID: <20200130183138.GA3447196@magnolia>
References: <157982499185.2765410.18206322669640988643.stgit@magnolia>
 <20200130181512.GZ3447196@magnolia>
 <20200130182230.GC27318@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200130182230.GC27318@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9516 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=988
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

On Thu, Jan 30, 2020 at 10:22:30AM -0800, Christoph Hellwig wrote:
> While this looks functionally correct, I think the structure in
> here is weird.  In libxfs we usually check that magic number first
> and then branch out into helper that deal with the leaf vs node
> format.  That is we don't do the xfs_attr3_leaf_hdr_from_disk call
> for node format attrs, and also check the forward/backward pointers
> based on the actual ichdr.  Maybe this code should follow that
> structure?

Yeah, I'll refactor the case blocks into two functions.

--D
