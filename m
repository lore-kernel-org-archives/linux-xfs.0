Return-Path: <SRS0=Jdfz=DX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCC48C43457
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Oct 2020 15:31:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F77120874
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Oct 2020 15:31:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bGv9NyFc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406032AbgJPPbN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Oct 2020 11:31:13 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:49316 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408025AbgJPPbN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Oct 2020 11:31:13 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09GFKmBC010764;
        Fri, 16 Oct 2020 15:31:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=3aRtliVHytT76HbNnzDs+qW3zumUqqaJs7dE7MNIQS8=;
 b=bGv9NyFc08qUFXDvb8YvzXx31SOGQpqDIGMEYUGV/D+OXSRpgswj4RNWzs328yIsgZw0
 l6lQj8YNn1gBCvgQZJGCiIrgwNRohWNuoFAG5rD/pG46bZl5hbkHr1GcE8/ZUYh7452/
 qalHQeLYH+AkF8Llue5mjoVIbY4sdhHsyfv7ayaHXFSPuIYcoHequP62KZAsp3VkuTvW
 h25XWs4CfZ/njmRH8Gd1GylO3+wqPNGkd6DKEnJfw/sJ+TlvNhorQs5KOWP8rVxnmmyi
 rmUDQBJMzrbgUEMTrV4szba9j1phK19hUh35CvwqnYXbtatn10ssVSocD9t0gD1AJel2 BQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 346g8gqhwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 16 Oct 2020 15:31:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09GFFOBM034959;
        Fri, 16 Oct 2020 15:29:03 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 343pv3cp4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Oct 2020 15:29:03 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09GFT1kc030811;
        Fri, 16 Oct 2020 15:29:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 16 Oct 2020 08:29:01 -0700
Date:   Fri, 16 Oct 2020 08:29:00 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        david@fromorbit.com
Subject: Re: [PATCH V6 08/11] xfs: Check for extent overflow when remapping
 an extent
Message-ID: <20201016152900.GD9832@magnolia>
References: <20201012092938.50946-1-chandanrlinux@gmail.com>
 <1680655.hsWa3aTUJI@garuda>
 <20201016070448.GA12318@infradead.org>
 <1899682.3A2Fs4cuYb@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1899682.3A2Fs4cuYb@garuda>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9776 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=1 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010160116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9776 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 suspectscore=1
 priorityscore=1501 phishscore=0 clxscore=1015 spamscore=0 adultscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010160117
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 16, 2020 at 04:58:53PM +0530, Chandan Babu R wrote:
> On Friday 16 October 2020 12:34:48 PM IST Christoph Hellwig wrote:
> > On Thu, Oct 15, 2020 at 03:31:26PM +0530, Chandan Babu R wrote:
> > > How about following the traits of XFS_IEXT_WRITE_UNWRITTEN_CNT (writing
> > > to unwritten extent) and XFS_IEXT_REFLINK_END_COW_CNT (moving an extent
> > > from cow fork to data fork) and setting XFS_IEXT_REFLINK_REMAP_CNT to a
> > > worst case value of 2? A write spanning the entirety of an unwritten extent
> > > does not change the extent count. Similarly, If there are no extents in the
> > > data fork spanning the file range mapped by an extent in the cow
> > > fork, moving the extent from cow fork to data fork increases the extent count
> > > by just 1 and not by the worst case count of 2.
> > 
> > No, I think the dynamic value is perfectly fine, as we have all the
> > information trivially available.  I just don't think having a separate
> > macro and the comment explaining it away from the actual functionality
> > is helpful.
> > 
> 
> Darrick, I think using the macros approach is more suitable. But I can go
> ahead and implement the approach decided by the community. Please let me know
> your opinion.

The macro only gets used in one place anyway, so I don't see as strong a
need for it as the other places.  I think this one could be open-coded
next to the places where we decide the values of smap_real and
dmap_written.  (i.e. what Christoph is suggesting)

--D

> -- 
> chandan
> 
> 
> 
