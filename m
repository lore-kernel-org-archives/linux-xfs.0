Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69CBBC28CBC
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 16:57:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44608208CA
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 16:57:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jHTOD78l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730224AbgEFQ5T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 12:57:19 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48414 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729414AbgEFQ5T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 12:57:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046GsH4T017441;
        Wed, 6 May 2020 16:57:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Obz9P6SIhfWUX+E8NcDIbnChs5kSgfJHJS7N8iHF1JQ=;
 b=jHTOD78lzWsXXSf3bmFm/MiQIL5nw8LstgvfkKJp/q+Oe7bDFNKY10JN2tU+TgT4/nET
 grpRtsPoe/z6hCN+tOJAxDaZnksa4Idlq6UAv+A9M5JhgdA4UktlRDGM4Tq2c6Xd9aTN
 rSVUGFWY3kHesP+5C4Ste53mUUG9F3Syo1+QpwYGy1j9p64am3EPwcO2jExsY+iNTBex
 6qsl0RfLQK1NYZIBKtDuQUDtJYoBs+R+0wrj25XkpaFe7JAHNZ96C+RJR+ByNzrGG0Sd
 Ew3W915anNwmF4TjEyfVAoawkb8GZgvGn8ZtZRau8tbFzjFkfHTpqLr4Z+tvwneB1HAk 7Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30s09rbmfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 16:57:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046GqcP4130889;
        Wed, 6 May 2020 16:55:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 30us7n5but-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 16:55:14 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 046GtDeA009706;
        Wed, 6 May 2020 16:55:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 09:54:41 -0700
Date:   Wed, 6 May 2020 09:54:40 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/28] xfs: use parallel processing to clear unlinked
 metadata
Message-ID: <20200506165440.GX5703@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864121071.182683.2313546760215092713.stgit@magnolia>
 <20200506153632.GD27850@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506153632.GD27850@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=1
 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005060136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=1
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005060136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 06, 2020 at 08:36:32AM -0700, Christoph Hellwig wrote:
> On Mon, May 04, 2020 at 06:13:30PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Run all the unlinked metadata clearing work in parallel so that we can
> > take advantage of higher-performance storage devices.
> 
> Can you keep this out of the series (and maybe the whole iunlink move)?
> The series already is huge, no need to add performance work to the huge
> refactoring bucket.

Ok.  I'll make the unlinks clearing patches a separate series.

--D
