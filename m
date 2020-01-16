Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39868C33CAF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 23:00:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0834E2072B
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 23:00:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Br/1Hkoe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388131AbgAPXA0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 18:00:26 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55714 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388771AbgAPXA0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 18:00:26 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00GMwTYB073785;
        Thu, 16 Jan 2020 23:00:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=/UikURw4RndXc8TTUXymrpNWoqtBmw+afdWOMn9jNX8=;
 b=Br/1HkoevLVrsPyiBXssyoPe2RNv8Z779xPxmKWCmjp6rjQWqqzfzmQak+o6IY2Ad64F
 IQvfKFO4Ls0h0yCFV2non3s5leZOAaGnyK0f2YHgmR5l0KXlq4669IXX/v+rIHjW/cSO
 YSOaMIA/nIUjAAQNWUu70z8lluKcWxSHY6xFmsYXiTZ8/xMFnjru4awRWKcbB5FpLu4B
 sBdFMw9459ssnK3RdEf1C68k6CUXQ/6CWjwubGwM+MBH6qje20mVdrVQxaIrE95kXLhW
 Li17NEpke3MfrqhxeW26EgwHKu5WOiQoUX0uTS+A++bUuBW5lj3dzmkgVpHhbBr8QCHw sg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xf73ywkj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 23:00:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00GMsJRa067063;
        Thu, 16 Jan 2020 23:00:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2xjxm7q8q0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 23:00:17 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00GN0Gjc019588;
        Thu, 16 Jan 2020 23:00:17 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jan 2020 15:00:16 -0800
Date:   Thu, 16 Jan 2020 15:00:14 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/2] xfs: fix stale disk exposure after crash
Message-ID: <20200116230014.GK8247@magnolia>
References: <157915534429.2406747.2688273938645013888.stgit@magnolia>
 <20200116164955.GC4593@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116164955.GC4593@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=926
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160183
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160184
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 16, 2020 at 08:49:55AM -0800, Christoph Hellwig wrote:
> Btw, what happened to:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?h=djwong-wtf&id=c931d4b2a6634b94cc11958706592944f55870d4

Originally I thought that it was enough to decrease *wbc->range_start to
the ondisk EOF since the _flush_unmap function triggers a writepages
call.  Maybe it's better to make that part explicit.

However, it's only necessary to extend writeback like that if you're
going to retain the delalloc -> written state change.  I don't consider
applying patch 2 to be a good idea though.

--D

> ?
