Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64B42C4BA01
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 22:07:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3527F20838
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 22:07:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PZ00HG4u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgBYWHf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 17:07:35 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:53438 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgBYWHf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 17:07:35 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PLx7eg003863;
        Tue, 25 Feb 2020 22:07:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=B0GGCh2XIGmqORJyjBDP7KACUGN3IAIqTyDSvWyLwz8=;
 b=PZ00HG4uYdKF4uNrW3hYCu4XCxxu+toXWHsgYoYxFDHwmbZlR6XDGv7tFPqh65lQ3sF8
 XEX356yjIlvMH63SCNztuvi1DAhZz5nZfUSZ3IWm1zEoaScC/OOzB/9LfY88BuHKDl/1
 dJfQWrq79j8RmqQO0cd7YtGDC2ep74xC5nB6hOcu3xIb22HTMiu3PvnvJITI8EvL2PpW
 53mFk4Xn2yTiVMOyc9j7N6YV4jLK/3NH0kgcXL4NTSJcY0OR3/fe3UMPzUJDrWHdewss
 LA41vgGBHwNUsXuBbGv4Ycf02MxZVmJljCAbNd3te9YOrR86e+Jl635EBpNzeUa+smkZ yw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2yd0m1vd4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 22:07:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PLwdZ0035660;
        Tue, 25 Feb 2020 22:05:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2yd09bmf2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 22:05:29 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01PM5S0X006632;
        Tue, 25 Feb 2020 22:05:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Feb 2020 14:05:28 -0800
Date:   Tue, 25 Feb 2020 14:05:27 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Qian Cai <cai@lca.pw>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix an undefined behaviour in _da3_path_shift
Message-ID: <20200225220527.GX6740@magnolia>
References: <20200225214045.GA14399@infradead.org>
 <F151ED18-55CF-482E-98BE-45A5A4D9A565@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F151ED18-55CF-482E-98BE-45A5A4D9A565@lca.pw>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 mlxlogscore=843
 spamscore=0 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=31
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 suspectscore=31 bulkscore=0 adultscore=0 impostorscore=0 spamscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 malwarescore=0
 mlxlogscore=892 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250152
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 04:55:56PM -0500, Qian Cai wrote:
> 
> 
> > On Feb 25, 2020, at 4:40 PM, Christoph Hellwig <hch@infradead.org> wrote:
> > 
> > In xfs_da3_path_shift() blk can be assigned to state->path.blk[-1] if
> > state->path.active is 1 (which is a valid state) when it tries to add an
> > entry > to a single dir leaf block and then to shift forward to see if
> > there's a sibling block that would be a better place to put the new
> > entry.  This causes a KASAN warning given
> 
> s/KASAN/UBSAN/
> 
> > negative array indices are
> > undefined behavior in C.  In practice the warning is entirely harmless
> > given that blk is never dereference in this case, but it is still better
> > to fix up the warning and slightly improve the code.
> 
> Agree. This is better.
> 
> Darrick, do you need me to send a v3 for it or you could squash this in?

Please send a v3.  The code in v2 looked fine to me.

--D
