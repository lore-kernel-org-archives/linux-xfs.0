Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E52DC3F2D1
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 03:43:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E76AD214D8
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 03:43:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zNcADeV8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387640AbgCDDnB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 22:43:01 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55942 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387397AbgCDDnB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 22:43:01 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0243guvT008005;
        Wed, 4 Mar 2020 03:42:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=0MAc0jvnddIucp9galUyXzNH4oR7Qv7rwGiVxsGmCB4=;
 b=zNcADeV8X9mvw9eIN1c5xiPLWx0FmsveeJY7djSwJ/ZpbPuxWKY7FJaBR2YNwQ6SWFVX
 1UdIEKKue9e1SBAJR3P5gjcSrowEmGyEBFIHme7I+lXOoP6BsfJxq+LDg2/jZytu5MBb
 xOJ24XjNfpUPIeXbQE2tN3v1U0BwJSSY6sDNKDCRsD9ss+1NfDXvVNr4bN9f0XTw8erk
 gPbd68hwXw4OsSPhi8bUhRC/t/kpzqQCoqbVnQbZgo69ZRByGfbmBTpDY6aTFaIt0dUM
 oq7wUU1q5Sd1B3nP6b85s3dP9Uf8rGyeG329QFPDWFYvV+PN/Hx3PdKcaMAmsxbfOsxH rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2yghn37gd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Mar 2020 03:42:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0243grBf132864;
        Wed, 4 Mar 2020 03:42:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2yg1rpaxay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Mar 2020 03:42:53 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0243gqbh010267;
        Wed, 4 Mar 2020 03:42:52 GMT
Received: from localhost (/10.159.225.108)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Mar 2020 19:42:52 -0800
Date:   Tue, 3 Mar 2020 19:42:51 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH v3 0/9] xfs_repair: use btree bulk loading
Message-ID: <20200304034251.GJ8045@magnolia>
References: <158329254501.2424103.11001979654106437662.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158329254501.2424103.11001979654106437662.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 adultscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003040024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 spamscore=0
 impostorscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003040024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hey,

Just a brief note about the sending of this series -- last week I asked
Brian if he might have time to take a look at the btree bulk loading
patches.  I decided that it might be a good idea to be able to show a
few examples of how to use the btree bulk loading functions, so I sent
along the xfs_repair conversion series instead of the online repair code
since it's probably a more familiar starting point for everyone.

The online repair code of course uses bulk loading too, but there's a
dozen or so cleanups that have to happen ahead of that, and I'm trying
to reduce flooding on the mailing list.

TLDR: This series is /not/ for immediate merging to xfsprogs.

--D

On Tue, Mar 03, 2020 at 07:29:05PM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> Refactor xfs_repair to use the btree bulk loading code instead of the
> open-coded versions in phase5.c.  This isn't a full submission; it's
> merely a demonstration of how the kernel patches can be used in
> userspace.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-bulk-load
