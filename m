Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E70AC35E01
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 18:53:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2638220CC7
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 18:53:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i56Y2iat"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbgBYSxB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 13:53:01 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57014 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730776AbgBYSxB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 13:53:01 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PIhwo5084283;
        Tue, 25 Feb 2020 18:52:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=dVO5rSI4MMSdyLPF7eGJTRyi3ETkukiw9omcLhlApIM=;
 b=i56Y2iatzmIann6mQ0eyOMKn5x3AVI96D7BPyrWywk4ZVzRzfYV2n6NAFCKzAHQqv+59
 mBH/BCvn7PfC3hF12d1+SnSRcw1fBDnYirnSYAbM0qX3sV2UIMXGfRObPS+BwBPS7CTT
 6QM1a78BPTyAyZqRgvwo3OW1eFKcD6WXxIqxu47VC5113BI/n1L0jxYA0uYvKV6bKWB1
 ylblKbzQeAYh9vNvBM0EEWTz85z+4VEVUWa6JqsTYNMqAyY1D6Mn7H3oMDQYwthglfH2
 Xda15FDtb9M9YgWaDwdC9bHVrsPaec59k7ndgRh59gyMyqSnHIqZo9qi/G0LqFsDbIRd hA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2yd093kjjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 18:52:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PIqcuL173012;
        Tue, 25 Feb 2020 18:52:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2ybduxdjv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 18:52:58 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01PIqui7029833;
        Tue, 25 Feb 2020 18:52:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Feb 2020 10:52:56 -0800
Date:   Tue, 25 Feb 2020 10:52:55 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/25] libxfs: remove unused flags parameter to
 libxfs_buf_mark_dirty
Message-ID: <20200225185255.GN6740@magnolia>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
 <158258960303.451378.10926259135197727277.stgit@magnolia>
 <20200225175107.GR20570@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225175107.GR20570@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=863 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 suspectscore=0 priorityscore=1501
 phishscore=0 clxscore=1015 mlxlogscore=936 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250132
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 09:51:07AM -0800, Christoph Hellwig wrote:
> On Mon, Feb 24, 2020 at 04:13:23PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Nobody uses the flags parameter, so get rid of it.
> 
> Looks good, but wouldn't it make sense to fold this into the previous
> patch instead of modifying all callers twice?

I'll ask Eric if he prefers it this way or combined.  Or I guess you
could, if you run into him later today. ;)

--D

> Reviewed-by: Christoph Hellwig <hch@lst.de>
