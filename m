Return-Path: <SRS0=O+9a=AA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 588FCC433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Jun 2020 21:31:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2216E21941
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Jun 2020 21:31:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ay4yp3W2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726056AbgFSVb5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Jun 2020 17:31:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47482 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbgFSVb5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Jun 2020 17:31:57 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05JLRZdW195505;
        Fri, 19 Jun 2020 21:31:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=w1ukZGn+GBWxfmWdhnHFcLm9cN8hh5sK36A0Ze0uyAs=;
 b=Ay4yp3W2Csr3f55ZBEh6ZRMW/waZ0487vIsr9Lf08NuYX/9tyu7k58QRBDer8rDyFttr
 GZvcQ9w4U+DPLZM0gRcubqwbG+2yd6CmiXovmkqqDlYlkNA3q+HRscTMLR1gwxAnXp/Q
 FlIJnJIwcucBzLD5I5K2Brqb1xGQ+uhhv84TDjAxMInDMm5ngrIMlHZRKE8ywoeRbug6
 LeDZIwdWK7P7W6KB4lccNWntQtyQJFvPsKZ7glg3JtzISk/BMLSnDNG03H8/SE/888qh
 fx1Ti2Y9rUSHnUnam0TdQiTSHGHt/TY8Je2ETPCXJwQYSJlA3ekNnm+c/rd5lq9TB0dE 0A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31qecm7cw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 19 Jun 2020 21:31:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05JLSq07124086;
        Fri, 19 Jun 2020 21:31:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 31q66dkqgp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Jun 2020 21:31:42 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05JLVe1f024900;
        Fri, 19 Jun 2020 21:31:40 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 19 Jun 2020 14:31:40 -0700
Date:   Fri, 19 Jun 2020 14:31:38 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Subject: Re: [PATCH 2/7] xfs: Check for per-inode extent count overflow
Message-ID: <20200619213138.GC11245@magnolia>
References: <20200606082745.15174-1-chandanrlinux@gmail.com>
 <20200606082745.15174-3-chandanrlinux@gmail.com>
 <20200608162425.GC1334206@magnolia>
 <1885585.BIgNe5D0sC@garuda>
 <20200609171003.GB11245@magnolia>
 <20200619143608.GB29528@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619143608.GB29528@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9657 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 suspectscore=1 bulkscore=0 adultscore=0 mlxlogscore=718 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006190151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9657 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 cotscore=-2147483648 malwarescore=0
 clxscore=1015 adultscore=0 suspectscore=1 spamscore=0 lowpriorityscore=0
 mlxlogscore=753 priorityscore=1501 bulkscore=0 phishscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006190151
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 19, 2020 at 07:36:08AM -0700, Christoph Hellwig wrote:
> I'm lost in 4 layers of full quotes.  Can someone summarize the
> discussion without hundreds of lines of irrelevant quotes?

Naming issues with helper functions, and pointing out that any code path
that thinks it could add $nr extents to a file needs to check for
overflows in (ifp->if_nextents + $nr) after we take the ILOCK but before
we dirty the transaction.

--D
