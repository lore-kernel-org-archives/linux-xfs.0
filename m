Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FBD7C55199
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 17:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEC752078C
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 17:24:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CticwcS/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgD0RYq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 13:24:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35314 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbgD0RYq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 13:24:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RHMkLx090460;
        Mon, 27 Apr 2020 17:24:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=KkYooEp0SA2M8mKfNaCgrUWY4EVeyI0P1O+mKHqrTE0=;
 b=CticwcS/Q4WgMMNWFDck5qXbTAHOQuNGOuD5dqglf7+85tkkbXJkA1SjU9WNTQ3NgyiJ
 rXNZcHtonYVtvY0XNgHlflzlsV7hlY51Vzqym1bUqYrHii3Dg1uUUMKYi7OamTfS0xwQ
 7yeXzeZCh0XIxPFQMb7HY49Il7ivqnvKjxv/pCqm2T1hk+MuLFc+ynegNq5oajbabSQR
 g8egAinOjSB01h9P3QV0xYJ9XWNHO4PYGwc/usNAyXb+4OJOlr2iZsk9SaIoY/qjh/QG
 H7mZKL5Ly4ZvlVI4sQ0h++L8NQ9hvEDabEP2R5FjvA0Iw+AsuqkEgWKXLPu9yim+9Zy+ qg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30nucfu016-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 17:24:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RHLpCN043595;
        Mon, 27 Apr 2020 17:24:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 30mxwwmj1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 17:24:42 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03RHOfDo016762;
        Mon, 27 Apr 2020 17:24:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 10:24:41 -0700
Date:   Mon, 27 Apr 2020 10:24:40 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Bill O'Donnell" <billodo@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [XFS SUMMIT] xfs and gcc
Message-ID: <20200427172440.GS6742@magnolia>
References: <20200423150306.GA345064@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423150306.GA345064@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270142
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 23, 2020 at 10:03:06AM -0500, Bill O'Donnell wrote:
> Hello -
> 
> I'd be interested in having some discussion about the forward momentum
> of gcc, and xfs staying in reasonable sync with it. I'm sure you've noticed
> the warnings stacking up as xfs and xfsprogs is built.

Not really, because I'm still running gcc 8.4.  At least until I sort
through the remaining grub brain damage and actually upgrade every
system. :D

> With gcc-10 coming
> about in distros, the inevitable warnings and errors will become more than
> annoying.
> 
> How best to approach modifications to xfs to alleviate these build issues?

No idea. :(

Admittedly it would be nice to ask the kernel robot or something like it
if it's willing to take on building some of the core userspace packages.
They're a little spammy (we recently had a cppcheck episode) but more
often than not, it does catch minor problems.

--D

> Thanks-
> Bill
> 
