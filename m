Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B27FA372C
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:46:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00F6721848
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:46:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IZuP4vSx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbfKHHqm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 02:46:42 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33234 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbfKHHqm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 02:46:42 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA87k4id088200;
        Fri, 8 Nov 2019 07:46:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=gLLhpuBUo6mTzkWfXVtb1PFJHoDBTpZOidD5G+vM4X8=;
 b=IZuP4vSxzfb6D26ONhIDMehB6fQvRcEt5RrWNCRXjWOW1AT5MZiv9rLsQZ6pcEtgDNro
 JUuCaPn55CR5jgVXHC/uP2pu3Ja3My992BJNtfWNKIOYWT/NAoqcxKK9SNBHL9IhSW2b
 SY11PaEwS4qTgLHQJZd0Vk8dFgZY8wuVBuor5o9u5e1T64pXGP/7KoNb4MEzHzO77bDR
 xYJW8XtBzkhnAo8i6sNpvxzTHyvPHgmOQRMeIKLtP7W/yv8Wpnpvaoiy0002OPIHJKk5
 dkispKhWvQ/4YmCWMZ0iv/DUcacLPrWK5UbiqAS6ctikMcVKOHbvtEFPyeaep29Cwx0u cA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2w41w13h5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 07:46:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA87iosV152769;
        Fri, 8 Nov 2019 07:46:36 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2w4k30py8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 07:46:36 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA87kZit004283;
        Fri, 8 Nov 2019 07:46:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 23:46:35 -0800
Date:   Thu, 7 Nov 2019 23:46:34 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: actually check xfs_btree_check_block return in
 xfs_btree_islastblock
Message-ID: <20191108074634.GQ6219@magnolia>
References: <157319668531.834585.6920821852974178.stgit@magnolia>
 <157319670439.834585.6578359830660435523.stgit@magnolia>
 <20191108071441.GB31526@infradead.org>
 <20191108072951.GP6219@magnolia>
 <20191108073306.GA2539@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108073306.GA2539@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=920
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080076
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080076
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 11:33:06PM -0800, Christoph Hellwig wrote:
> On Thu, Nov 07, 2019 at 11:29:51PM -0800, Darrick J. Wong wrote:
> > That said, "Is this cursor pointing to the last block on $level?" only
> > makes sense if you've already performed a lookup (or seek) operation.
> > If you've done that, you've already checked the block, right?  So I
> > think we could just get rid of the _check_block call on the grounds that
> > we already did that as part of the lookup (or turn it into an ASSERT),
> > and then this becomes a short enough function to try to make it a four
> > line static inline predicate.
> > 
> > Same result, but slightly better encapsulation.
> > 
> > (Yeah yeah, it's C, we're all one big happy family of bits...)
> 
> Sounds ok.

Ok, I'll push out a (lightly tested) patch.

--D
