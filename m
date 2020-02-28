Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21812C3F2D2
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 16:42:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8B36246AE
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 16:42:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R2/f+hJG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgB1Qmc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 11:42:32 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:47060 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgB1Qmc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 11:42:32 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SGSpOb083163;
        Fri, 28 Feb 2020 16:42:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=V7xnEnOnflsqxUNxVn5sn92luPkhOBPrDI+brc/QYNE=;
 b=R2/f+hJGdMxspg6s/YBdI2LHRV3US7mb24UEnEN104aQ8s4RsKp1fO403X6d1tt6wTFY
 UN7x6xtIdgFHc0FCza8m9QwTZ9EKyTnQZ9v4096H4Q8HlW9c46sdAmn2N1aWg/nHBh7u
 V/X8GMPVSdSoJNMkKcmsq9YQEY6oSYGCWD3J2fvDrxpv5zVG4Lda1CXuwT4S2Am9n02V
 xQuKFos3gO5uZBmBxUEKSLRbSSkNmv7qD1bGhlOr8rlgphBh/CarTWcDf358EbEwO9yB
 Gng5VitWxamW6Uucm2HUwYEA1kUMYO+Jn8VXnmAjwkH+J/CcaKX+MPgA8rBmhCSVTtj3 rA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2ydct3kyuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 16:42:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SGgQS0110403;
        Fri, 28 Feb 2020 16:42:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2ydcsex095-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 16:42:26 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01SGgGwD027760;
        Fri, 28 Feb 2020 16:42:17 GMT
Received: from localhost (/10.159.226.243)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 08:42:16 -0800
Date:   Fri, 28 Feb 2020 08:42:15 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [ANNOUNCE] xfsprogs for-next updated to fbbb184b
Message-ID: <20200228164215.GB8070@magnolia>
References: <adc5d23f-92d2-2dcc-5957-adb69f87cf4b@sandeen.net>
 <d923c538-f421-3716-0618-1516a5a4911a@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d923c538-f421-3716-0618-1516a5a4911a@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=876 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=931 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280131
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 27, 2020 at 08:46:18PM -0800, Eric Sandeen wrote:
> A note on this push; it breaks at least xfs/030, xfs/033, and xfs/178 due
> to some changes in expected output.  I'll work on that next, hopefully
> send a patch tonight.
> 
> Also: Darrick, help me out on what makes sense to merge next.... :D

For 5.5, I'll resend the relevant patchsets.  At this point, those are
(1) the patches to make userspace recognize and deal with write failures
("xfsprogs: actually check that writes succeeded"); and (2) the buffer
cache API cleanup ("xfsprogs: refactor buffer function names") that
removes most of the warts.

I think you're missing...

xfs_io/encrypt: support passing a keyring key to add_enckey

For 5.6 I'll send a libxfs-5.6-sync candidate, but that can wait until
after xfsprogs 5.5 is released.

--D

> and anyone else who got lost in the mega patch flurry of the past couple
> weeks, ping me if there's a patch I should pull in for 5.5.
> 
> Thanks,
> -Eric
> 



