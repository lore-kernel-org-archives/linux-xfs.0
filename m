Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 765DDC35666
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 20:50:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 462E6207FD
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 20:50:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IYGsjTFB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgBUUuf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 15:50:35 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:50488 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgBUUuf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 15:50:35 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LKh0Nb122318;
        Fri, 21 Feb 2020 20:50:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ev77XhYygHKZ6EODp1APGW+8XSYTD0LeSc/Fq5cict4=;
 b=IYGsjTFBJSOVFrZd0iTObdlRXG/z/QmY67Ayt+dqskLef1pZvAHEOITMg0w32AuFS8er
 +SYkb0r+YYhtzEe25Df89kWhhDBxHnlpjOJ0W5e5SDl4lB/TL1rU2WfLHrAiKbPyKNhc
 9uWYR5AYdTYgZ2lPr444hx0iYU50xVAWXtEptcdrPVJx/iXgtGbpHdc/RWO9vflj5eCs
 Aq9OlkOmEy6nesPi3R1stxZt3tm+c8B3vqY9XiT+xtMH2/3JU70/oYJdyVSL9hHSJ2q1
 VjCV9Hml0OaymjBYKc7kuE8wnO41qU6Q902/WLTAC0S/6JxQeQqJwy+do/CHCibZiZ30 4A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2y8uddjuqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 20:50:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LKfvh7189487;
        Fri, 21 Feb 2020 20:50:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2y8udq8fkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 20:50:30 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01LKoTQJ026983;
        Fri, 21 Feb 2020 20:50:30 GMT
Received: from localhost (/10.145.179.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Feb 2020 12:50:29 -0800
Date:   Fri, 21 Feb 2020 12:50:28 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/18] libxfs: introduce libxfs_buf_read_uncached
Message-ID: <20200221205028.GA9506@magnolia>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
 <158216301746.602314.17789861786273491972.stgit@magnolia>
 <20200221144833.GH15358@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221144833.GH15358@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9538 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=975
 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002210157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9538 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002210157
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 21, 2020 at 06:48:33AM -0800, Christoph Hellwig wrote:
> On Wed, Feb 19, 2020 at 05:43:37PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Introduce an uncached read function so that userspace can handle them in
> > the same way as the kernel.  This also eliminates the need for some of
> > the libxfs_purgebuf calls (and two trips into the cache code).
> > 
> > Refactor the get/read uncached buffer functions to hide the details of
> > uncached buffer-ism in rdwr.c.
> 
> Split this into one patch adding the functionality to libxfs and
> one each to convert db and copy over with a good rationale for the
> switch in each case?

Both programs use the uncached read for the same purpose, which is to
read the superblock without polluting the buffer cache when we haven't
yet established the filesystem sector size.

The only reason why repair doesn't need patching is that reaches into
the buffer cache internals to call lseek and read by hand.  I guess that
should be fixed, separately.

--D
