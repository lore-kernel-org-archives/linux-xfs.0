Return-Path: <SRS0=0AGZ=6M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16674C83000
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 22:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7AA420731
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 22:40:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ilOdx3co"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgD1Wk2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 18:40:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45320 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgD1Wk2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Apr 2020 18:40:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SMdJVk046534;
        Tue, 28 Apr 2020 22:40:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=tG2HONkOiAW+lxjzrrhsfJaZuoo5GDqinthGWMR2wQk=;
 b=ilOdx3coxrM7FXKWeAMDXBxNSOIFfGoKC1BDiAzbKlScPQtA+uRno4iVIZOGeW8Y56Ii
 4pzXfw+YamGDtSSBeULn8XKHn23Cn3inwPCpLK1Myyjt/qMYsUez4dBVUw1BCL3f04y0
 ye/3Bv6WsD+NIwOp9571FnzSzCD6AOxxdPPeeXoKo0Zzx4rmzb+BmKp/aU/3ukNpQVhA
 D7QLbGSi4Xu/H3LFAu4L6+maMBoKn0TosIevHkGOZ3x/smp25kfI4RwqRBnD5n0I81Km
 k9xIHseCeN/5v8k8E44Ujs+5ygkqeEyGcyI72/uhlAZPxIUE01PAfztbeynUtB2zz53j gQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30nucg2qks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 22:40:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SMcC8t160176;
        Tue, 28 Apr 2020 22:40:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 30mxrtm7tm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 22:40:25 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03SMeOWE011255;
        Tue, 28 Apr 2020 22:40:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Apr 2020 15:40:23 -0700
Date:   Tue, 28 Apr 2020 15:40:23 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/19] xfs: refactor RUI log item recovery dispatch
Message-ID: <20200428224023.GO6742@magnolia>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <158752123963.2140829.11785185891630195018.stgit@magnolia>
 <20200425182854.GF16698@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200425182854.GF16698@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004280175
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

On Sat, Apr 25, 2020 at 11:28:54AM -0700, Christoph Hellwig wrote:
> On Tue, Apr 21, 2020 at 07:07:19PM -0700, Darrick J. Wong wrote:
> > +const struct xlog_recover_intent_type xlog_recover_rmap_type = {
> > +	.recover_intent		= xlog_recover_rui,
> > +	.recover_done		= xlog_recover_rud,
> > +	.process_intent		= xlog_recover_process_rui,
> > +	.cancel_intent		= xlog_recover_cancel_rui,
> 
> Can you make sure your method instance names are always
> someprefix_actual_method_name?  That makes life so much easier when
> looking for all instances.

Will do.

--D

