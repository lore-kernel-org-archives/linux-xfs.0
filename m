Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC276C4361B
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:23:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9927B2311B
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:23:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgLFXWx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Dec 2020 18:22:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36224 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgLFXWw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Dec 2020 18:22:52 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6NJM09014216;
        Sun, 6 Dec 2020 23:22:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=huEqwuncr+1AWEM6vKViU+LV+AU45tZG4jcDYjSOvl4=;
 b=eY6AjBWmGE6LTi6Vpn/d6cvvWwPuu+ElgbOh/D9npCq3UadO+LG84av/VnYCVdrzziWw
 q5x2ydFqiXmwzkDmcdfbq74fi50liv52GOWXervg8y9albi301IxXl+NTqJdSre/NBG3
 f96nFcWb9NYfibngeBQrKScpL6pISrc/+5gHDb8s6Jv13AOaJkPY2d9SmL8cl3M+v8yb
 M14U5Nf0LDrg/KLYunAnl0fiAU3Zf/mSdYWt4nE4whefWdDfxb/NDuJsgDr+YWmkeRV7
 Jfc4w0pfvEWxwsRMyeixN2IdcFU/6W3jq/BTqXTABKHjpDmxGCweCafEGjyjHLBKSFCO MA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 35825ktutw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 06 Dec 2020 23:22:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6NKgRY190267;
        Sun, 6 Dec 2020 23:22:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 358kskgfa0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Dec 2020 23:22:01 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B6NLtBF025090;
        Sun, 6 Dec 2020 23:21:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 06 Dec 2020 15:21:55 -0800
Date:   Sun, 6 Dec 2020 15:21:54 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: use reflink to assist unaligned copy_file_range
 calls
Message-ID: <20201206232154.GK629293@magnolia>
References: <160679383048.447787.12488361211673312070.stgit@magnolia>
 <160679383664.447787.14224539520566294960.stgit@magnolia>
 <20201201100206.GA10262@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201100206.GA10262@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012060153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012060153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 01, 2020 at 10:02:06AM +0000, Christoph Hellwig wrote:
> On Mon, Nov 30, 2020 at 07:37:16PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add a copy_file_range handler to XFS so that we can accelerate file
> > copies with reflink when the source and destination ranges are not
> > block-aligned.  We'll use the generic pagecache copy to handle the
> > unaligned edges and attempt to reflink the middle.
> 
> Isn't this something we could better handle in the VFS (or a generic
> helper) so that all file systems that support reflink could benefit?

Maybe.  I don't know if it's universally true that all filesystems
should fall back to reflinking the middle range and pagecache copying
the unaligned start/end.

The other thing is that xfs can easily support reflink on rtextsize > 1,
but that adds the requirement that we set i_blocksize to a larger value
than we do now... or find some other way to convey allocation unit size
to a generic version of the fallback.  OTOH that's pretty easy to do
from xfs_copy_file_range.

--D
