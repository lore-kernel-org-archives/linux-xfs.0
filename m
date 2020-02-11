Return-Path: <SRS0=3qtu=37=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0C1EC3B186
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 15:43:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2ADD20656
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 15:43:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="opjtMpF9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbgBKPn3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Feb 2020 10:43:29 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:32972 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727962AbgBKPn2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Feb 2020 10:43:28 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01BFWQ6f133592;
        Tue, 11 Feb 2020 15:43:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=7QtCMIvL5EYIGOmL62BZ7gjTRBmCLqFKrYqR9vKMiig=;
 b=opjtMpF9sZ3zx9/cFFcrVLP2QWNtPlq8VPNO5SlzBb+SLKMPiP7cWEkkJxtUCaphdMLj
 Ch9h3sKWbqfQFYPG2P9ZBnO2VNTCsaAqzufvbSpcjn1oqOu3YX8Yvehr1rW1r+8lmW5h
 SPpN5v0Jp0e7qq2eunkfK0338xI6NRcFYF7iy9w7VypymBOqNQnYmN0XzZ9L+g2HZpWM
 qUqBUAA42gHTI/2is7WtxZngEqEkiiRs7Qbyw2lAhZeuEL1sIloNX984Yy+LAXkQmX/p
 WnB1MobV4CrnAj/IJ4lEwB39JNIi3wiblM8EVE75Ng32ZpVSyo8ok4s17eFEM9H62utr zg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2y2jx64ddk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 11 Feb 2020 15:43:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01BFgcNv075436;
        Tue, 11 Feb 2020 15:43:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2y26q1gccw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Feb 2020 15:43:24 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01BFhNRw003905;
        Tue, 11 Feb 2020 15:43:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 11 Feb 2020 07:43:23 -0800
Date:   Tue, 11 Feb 2020 07:43:22 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 0/4] xfs: enable per-type quota timers and warn limits
Message-ID: <20200211154322.GN6870@magnolia>
References: <333ea747-8b45-52ae-006e-a1804e14de32@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <333ea747-8b45-52ae-006e-a1804e14de32@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9527 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002110114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9527 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 priorityscore=1501 adultscore=0 phishscore=0 impostorscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002110113
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Feb 08, 2020 at 03:09:19PM -0600, Eric Sandeen wrote:
> Quota timers are currently a mess.  Right now, at mount time,
> we pick up the first enabled type and use that for the single
> timer in mp->m_quotainfo.
> 
> Interestingly, if we set a timer on a different type, /that/
> gets set into mp->m_quotainfo where it stays in effect until
> the next mount, when we pick the first enabled type again.
> 
> We actually write the timer values to each type of quota inode,
> but only one is ever in force, according to the interesting behavior
> described above.
> 
> This series allows quota timers & warn limits to be independently
> set and enforced for each quota type.

Is there a test case demonstrating this behavior?

Also, what do the other filesystems (well ok ext4) do?

--D

> All the action is in the last patch, the first 3 are cleanups to
> help.
> 
> -Eric
> 
