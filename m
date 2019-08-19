Return-Path: <SRS0=Z/aa=WP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 590DCC3A5A0
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 16:42:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A9852070B
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 16:42:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ldnd8cYH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfHSQml (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Aug 2019 12:42:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47930 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfHSQml (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Aug 2019 12:42:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7JGSvqI095526;
        Mon, 19 Aug 2019 16:42:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=iSPNmixy66wm6ewt38gqC/LjtVqtd+RS0G5ywJWQzpA=;
 b=Ldnd8cYHVEjgqd7NJ7hU1/iRtKo91kykUZWUx8YAZ+Qf3SoSBIkPTljGobLNfkhuSwsX
 odVmwDvcL5rFujC1dETdAwtgm9KnnNj/1yjuJYM77ICplhxA/+S+gXjCKi07HH6URlqP
 z+yq5MC5oslwDYbOTNyc1O36obCHkPqTY/wySWI2CHr2usGMsQGGRzoBCqn0xlveVZZb
 SSRGNi8XwZLaOOaZgzJTCXUmF9MwYItryzEfwaeWgHCfKHV+AZVvJFyBUiGf42p2LWFB
 mAtyyMPDkuiaQN8h3xfYCTk7ewvwDPJgQjVxv8UgIiRsQwoh8cRrTeYs3KyV+Q3pcZ7A jw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2ue9hp8pk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Aug 2019 16:42:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7JGSQk8136288;
        Mon, 19 Aug 2019 16:42:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ue8wycd66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Aug 2019 16:42:22 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7JGgJcp019337;
        Mon, 19 Aug 2019 16:42:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 19 Aug 2019 09:42:19 -0700
Date:   Mon, 19 Aug 2019 09:42:18 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 2/2] xfs: compat_ioctl: use compat_ptr()
Message-ID: <20190819164218.GA1021238@magnolia>
References: <20190816063547.1592-1-hch@lst.de>
 <20190816063547.1592-3-hch@lst.de>
 <20190817014218.GD752159@magnolia>
 <20190818083553.GA13583@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190818083553.GA13583@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9354 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=690
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908190176
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9354 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=749 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908190176
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 18, 2019 at 01:35:53AM -0700, Christoph Hellwig wrote:
> On Fri, Aug 16, 2019 at 06:42:18PM -0700, Darrick J. Wong wrote:
> > On Fri, Aug 16, 2019 at 08:35:47AM +0200, Christoph Hellwig wrote:
> > > For 31-bit s390 user space, we have to pass pointer arguments through
> > > compat_ptr() in the compat_ioctl handler.
> > > 
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > Looks ok,
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> So, what is the plan?  Do you think they are worth including for 5.3,
> or do you want to pass them off to Arnd for his series that is targeted
> at 5.4?

I'll combine these two with the reflink/dedupe locking fixes and push
all four out this week.

--D
