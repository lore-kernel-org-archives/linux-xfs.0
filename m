Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 423B0C35656
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 15:55:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16BDB24673
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 15:55:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vwdT4VjT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbgBUPzb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 10:55:31 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:35192 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728512AbgBUPzb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 10:55:31 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LFt3NP118319;
        Fri, 21 Feb 2020 15:55:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=3SU/ob7Ckwgc5KZ7BG9qyZo5fDm84yxetXkuaQo5JQo=;
 b=vwdT4VjTemhb57TpWVQLw2eIt5kmvAyJx5g9rNuhpvOhzj125F6vJIrJ2IbZ+x5HLchQ
 qtB0KXBAsxhJMEKdv0pVLFhsYqLoDqrXKwsvBj4b6IkAFyf3zsKNqOuoMSJ+RKVfQS3u
 8eky/B/KhQmtcsGD4eLClIJVnhAK0ra6cDlgrqM+DYbMCtn36ijC3ZLLvX+L1K/LMkZx
 HCEYCKrZcTB4YJBT8NUwfU+lCQR23NAhox6BpRsH6qkjvAgWeC6zqb3ABSRWKK0b9OQx
 ltsBzs2SsYy5yn1R3ammUfKeCI81FCqU+mWAU8wVJYTulUeFaJm93zwBcEDpUi9vKuuI gg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2y8uddhc7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 15:55:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LFqP1W152360;
        Fri, 21 Feb 2020 15:55:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2y8udfdhrq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 15:55:26 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01LFtPFS009522;
        Fri, 21 Feb 2020 15:55:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Feb 2020 07:55:25 -0800
Date:   Fri, 21 Feb 2020 07:55:22 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/18] libxfs: clean up readbuf flags
Message-ID: <20200221155522.GU9506@magnolia>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
 <158216296035.602314.7876331402312462299.stgit@magnolia>
 <20200221144247.GA15358@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221144247.GA15358@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9538 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=860 malwarescore=0 bulkscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002210119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9538 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 mlxlogscore=918 malwarescore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002210119
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 21, 2020 at 06:42:47AM -0800, Christoph Hellwig wrote:
> On Wed, Feb 19, 2020 at 05:42:40PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create a separate namespace for libxfs_readbuf() flags so that it's a
> > little more obvious when we're trying to use the "read or die" logic.
> 
> Can we just kill this damn flag instead?  Life would be much simpler
> if the exit simply moved to the caller.  It also kills the exit call
> in a library anti-pattern (although of course due to being conditional
> it isn't as bad as the real antipattern from the X11 libraries..)

Heh.  It was only now that I realized that there are ~8 callers of the
"fail on ioerror" flag.  Yes, let's get rid of them both.

--D
