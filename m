Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E7E4C55185
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 22:25:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29C4421655
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 22:25:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ujYWlF+U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgDVWZl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 18:25:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39852 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgDVWZk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Apr 2020 18:25:40 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03MMNkmb133233
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 22:25:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=FX84oopRS31ky5mlFfonEw/DkgFVlSu7d38bVtiN66Y=;
 b=ujYWlF+UDdzTw1V18uLUrF0PDm8NRnxNtUp1ll9GcJPKN1EimalAFo9HYK06WXZMGn2o
 mHpUy0FCyB96JEBbcUO8OqntHCvj4moOOWNJGLrcorqEcUeSjxdky+JLLma6Kifo8ggB
 FP32yDD5PbVYJjJ3zEe4QN5o4swM0umity7KSgYkcm6UeR0vQU6MuFjGZoMa4Dueqa/3
 00Sz1LMoak4i/T/e9svsQoLA5BBJMHtf5nHzFF/BJJALUODq69FlCWMOOp/o5FSPUMjW
 hTshCSQOOwL8JA5XX16l7LUepeijMmtZXd68aD3fRImWmmn0oz80yJb+Pf8NusW42GKA 6g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30jhyc4bs9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 22:25:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03MMNYR9174602
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 22:25:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30gb93huct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 22:25:38 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03MMPbRH009922
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 22:25:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Apr 2020 15:25:37 -0700
Date:   Wed, 22 Apr 2020 15:25:36 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: Refactoring the Review Process
Message-ID: <20200422222536.GE6741@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9599 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9599 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 clxscore=1015 suspectscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220169
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi everyone,

Writing and reviewing code in isolation hasn't always served me well.  I
really enjoyed my experiences developing the reflink code (~2015) being
able to chat with Dave in the evenings about the design of particular
algorithms, or how certain XFS structures really worked, and to learn
the history behind this and that subsystem.

Returning to first principles, I perceive that the purpose of our review
processes is to make sure there aren't any obvious design flaws or
implementation errors in the code we put back to the git repo by
ensuring that at least one other XFS developer actually understands
what's going on.

In other words, I am interested in testing the pair programming
paradigm.  Given that we have zero physical locality, I suspect this
will work better with an interactive medium and between people who are
in nearby time zones.  I also suspect that this might be better used for
more focussed activities such as code walkthroughs and reviews.  Still,
I'm willing to entertain the possibility of using this as a second means
to get a patchset to a Reviewed-by.

I also speculate that this might be a good mentoring opportunity for us
to trade productivity tips and disseminate 'institutional' knowledge
between people.  I for one am happy to help others learn more about the
code base in exchange for learning more about the parts of XFS with
which I'm less familiar.  (I bet Allison knows more about how xattrs
work than I do at this point...)

--D
