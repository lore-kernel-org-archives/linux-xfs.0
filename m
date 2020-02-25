Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7DB5C35E04
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 18:47:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AED372084E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 18:47:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BRQZKFDQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbgBYSrJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 13:47:09 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49036 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727983AbgBYSrJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 13:47:09 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PIhdMF067205;
        Tue, 25 Feb 2020 18:47:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=N3J97izCVdG3YGA5bo96YwtrlvHSchQweUI4gwUNZ7M=;
 b=BRQZKFDQ/xqHn4/U5OwFNo4LxXuVxkjm4xXaZirooZxhiBNSjPIk8VB/wLsrG/Zb8MgS
 nD6KaSNGbYbsLXMQPEComfTS2+RyRPndnqb+qOA3lIe0xqzCY1nzzz01Nj41V4D0mET3
 U+ouUlM15oOjSGLSwYnHyGLI/seSNqZDPLhvIjODh8cL8wqCg2qDZmeoiMtVT5z/mBZy
 DdqxChHhJt7n8543uJOuxyoB+xLEAYrRELUOqrZPkELaXA4I7IwRcEDH8KlcHrjSpkCY
 9G410sO9ZhE41CHXYRdHEd36K0XVAVD0BHrrHPH4N7kaMCx4lHssvQmRig3x6hqFbdkj Hw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2yd093khnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 18:47:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PIiGI4063281;
        Tue, 25 Feb 2020 18:47:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2yd09b7ser-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 18:47:04 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01PIl3qN019683;
        Tue, 25 Feb 2020 18:47:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Feb 2020 10:47:03 -0800
Date:   Tue, 25 Feb 2020 10:47:02 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/25] libxfs: move log functions for convenience
Message-ID: <20200225184702.GK6740@magnolia>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
 <158258957007.451378.6015938096424691137.stgit@magnolia>
 <20200225174712.GN20570@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225174712.GN20570@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 mlxlogscore=919
 spamscore=0 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 suspectscore=0 priorityscore=1501
 phishscore=0 clxscore=1015 mlxlogscore=968 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250132
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 09:47:12AM -0800, Christoph Hellwig wrote:
> On Mon, Feb 24, 2020 at 04:12:50PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Move libxfs_log_clear and libxfs_log_header to the bottom of the file so
> > that we avoid having to create advance declarations of static functions
> > in the next patch.  No functional changes.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> I'd be tempted to in fact just move them into a separate file, unless
> that would mean marking too many functions non-static as none of this
> is related to the normal read/write code.

<shrug> I wonder why not just move this whole thing to libxlog and
rewire it to do its own IOs (like the kernel xfs log does now) but this
series is already too long and that seems like its own neat cleanup...

--D
