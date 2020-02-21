Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDC86C35666
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 20:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9508424650
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 20:59:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KFaDdgPi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgBUU7N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 15:59:13 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:33530 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbgBUU7N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 15:59:13 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LKwx3U125524;
        Fri, 21 Feb 2020 20:59:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ughs9O0Qk7Bhl9ugaofqdlV9zP5qW3fqoWmD8mOlCUI=;
 b=KFaDdgPi5QR55ZyQIS3oPsaOJVxqc7+Tv+H2bv1E7ZHmfIGJQ9cjvFgh2biNJyG3wGBG
 Cw7bLnOugVYSBeHGkfEEpe6ZkL+v7INBdWZHuHT5b0kFsTgcbdk5K9Y7J8xCP1HM7slH
 K6ja/QkufgeviPcBJl58YqIuNwfWcZHmAV51uqOQ/fYDniJhc6D0xhwyys8TYtVkpImG
 C4l7KsQeMDerRPWKeC2WkGK7AAygtHnURaUc+/E7vUPyEYa4gFHZIwc7AaS9mB7Zcj2t
 HxMHSZEk6J8vixd7jSzrM533BZuW0FkUvrNVW3IpuJ9WMxRduB7GS7uFwPAgqTSW3ES8 Bg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2y8uddjvuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 20:59:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LKw81E072054;
        Fri, 21 Feb 2020 20:59:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2y8ud9nyq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 20:59:09 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01LKx85c005637;
        Fri, 21 Feb 2020 20:59:08 GMT
Received: from localhost (/10.145.179.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Feb 2020 12:59:08 -0800
Date:   Fri, 21 Feb 2020 12:59:07 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/18] libxfs: introduce libxfs_buf_read_uncached
Message-ID: <20200221205907.GB9506@magnolia>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
 <158216301746.602314.17789861786273491972.stgit@magnolia>
 <20200221144833.GH15358@infradead.org>
 <20200221205028.GA9506@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221205028.GA9506@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9538 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002210159
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9538 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002210159
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 21, 2020 at 12:50:28PM -0800, Darrick J. Wong wrote:
> On Fri, Feb 21, 2020 at 06:48:33AM -0800, Christoph Hellwig wrote:
> > On Wed, Feb 19, 2020 at 05:43:37PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Introduce an uncached read function so that userspace can handle them in
> > > the same way as the kernel.  This also eliminates the need for some of
> > > the libxfs_purgebuf calls (and two trips into the cache code).
> > > 
> > > Refactor the get/read uncached buffer functions to hide the details of
> > > uncached buffer-ism in rdwr.c.
> > 
> > Split this into one patch adding the functionality to libxfs and
> > one each to convert db and copy over with a good rationale for the
> > switch in each case?
> 
> Both programs use the uncached read for the same purpose, which is to
> read the superblock without polluting the buffer cache when we haven't
> yet established the filesystem sector size.

HAH nope, despite the very similiar code, they do it for different
reasons.  Separate patches it is.

--D

> The only reason why repair doesn't need patching is that reaches into
> the buffer cache internals to call lseek and read by hand.  I guess that
> should be fixed, separately.
> 
> --D
