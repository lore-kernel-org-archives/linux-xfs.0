Return-Path: <SRS0=0AGZ=6M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A9E2C83000
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 22:44:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F839206D9
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 22:44:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rNL7oHBz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgD1Wob (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 18:44:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48382 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbgD1Woa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Apr 2020 18:44:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SMdKtC046541;
        Tue, 28 Apr 2020 22:44:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=knj1Px3/HOdgRGqvMn+LXMIehroApqY9F25QlqiEfi4=;
 b=rNL7oHBz2OzWoMTn+ohsqWG1rDFCL7l2cFFyXqnDwwqFCuP03k3IYqgQ5w4mU8HQuaIv
 A8Oo0H4m6qZBhv0DR05WEm8zF9MuUBgwL/9uQkhSxFPW2U3IECKqqzpqY3/mmiegH9gA
 vzkozvDAggs0lCZycM3vNXS6VJ4UDHghC3DJq4GctRzlAvWuMamNDHpGu6bF7SPpfWRP
 vbM3VceIzPqkekGJdGQ2UVllsFoMZXipd3Tp3MuvVx38rt7tnvI3XQ9uj4rfxG38l+cy
 4xUyXEtZFD6acfnNyw2fMpMyIrPXfuQZN+Zh08OnTDIsrla3rRzfTvUPvfpYjxDr7oKm 4g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30nucg2r2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 22:44:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SMcnRZ177544;
        Tue, 28 Apr 2020 22:42:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30mxph6pxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 22:42:27 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03SMgQlg006416;
        Tue, 28 Apr 2020 22:42:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Apr 2020 15:42:26 -0700
Date:   Tue, 28 Apr 2020 15:42:25 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/19] xfs: refactor log recovery intent item dispatch
 for pass2 commit functions
Message-ID: <20200428224225.GQ6742@magnolia>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <158752120800.2140829.455621202654717367.stgit@magnolia>
 <20200425182417.GD16698@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200425182417.GD16698@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280175
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 25, 2020 at 11:24:17AM -0700, Christoph Hellwig wrote:
> On Tue, Apr 21, 2020 at 07:06:48PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Move the log intent item pass2 commit code into the per-item source code
> > files and use the dispatch function to call it.  We do these one at a
> > time because there's a lot of code to move.  No functional changes.
> 
> This commit log doesn't really match what is going on, as no move
> beween files happens.  And the changes themselves look pretty odd
> as well.

Yeah.  This patch will look very different once I get rid of
xlog_recover_intent_type.

(Fair warning: I was replying to these two threads in reverse order.)

--D
