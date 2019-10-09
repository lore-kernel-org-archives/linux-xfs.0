Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52469ECE58D
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 18:02:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2075B21924
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 18:02:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QozqrOJm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731155AbfJISCn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 14:02:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46088 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731144AbfJISCn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 14:02:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99HmpPi079651;
        Wed, 9 Oct 2019 18:02:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=XusFcFbrKewDIzs5kRKarefEHohZAVXlh1Vbmtl2OtY=;
 b=QozqrOJmaf9/z7G+8wkLFD0a9d5XMgyf6//9JkSn4KpSWWUba2h68Z4sRe1SkL4Wjl/m
 MWqM2GfZFVeuQTKSKkPnJGRs1ELmC2CmFtDNxCB1u3MjFJvhW2BjPaTSkZ/lCgBSKvcM
 TG0QwxrDXsGPODv+JaJquIVel92DXhdLoAMf+joXUQglDthrvFlaw/YeItF4RzlXrhPr
 /QY8VGpvpHO420rci2Fba1NMcqeuLN8JpTbr75ysr4txZX8ADB6iZIbqfNRIcs8c21Ri
 a9ubO30KPL9gRCmPr6PIDuhQ7UKGNQNmqJim4yZiABhsmD7O8kxo/YOY+5vIcDHx6WJ2 Pg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2vektrp5af-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Oct 2019 18:02:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99HmGjP116592;
        Wed, 9 Oct 2019 18:02:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2vh8k17ymb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Oct 2019 18:02:36 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x99I2YnV025303;
        Wed, 9 Oct 2019 18:02:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Oct 2019 11:02:34 -0700
Date:   Wed, 9 Oct 2019 11:02:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 4/4] populate: punch files after writing to fragment free
 space properly
Message-ID: <20191009180232.GF13097@magnolia>
References: <157049658503.2397321.13914737091290093511.stgit@magnolia>
 <157049660991.2397321.6295105033631507023.stgit@magnolia>
 <20191009070353.GB24658@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009070353.GB24658@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910090150
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910090150
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 12:03:53AM -0700, Christoph Hellwig wrote:
> On Mon, Oct 07, 2019 at 06:03:29PM -0700, Darrick J. Wong wrote:
> > To fix this, we need to force the filesystem to allocate all blocks
> > before freeing any blocks.  Split the creation of swiss-cheese files
> > into two parts: (a) writing data to the file to force allocation, and
> > (b) punching the holes to fragment free space.  It's a little hokey for
> > helpers to be modifying variables in the caller's scope, but there's not
> > really a better way to do that in bash.
> 
> Why can't we just split the operations into creating a large contigous
> file and then fragment them?
> 
> 
> create_large_file foo
> create_large_file bar
> create_large_file baz
> 
> fragment_large_file foo
> fragment_large_file bar
> fragment_large_file baz


Yeah, that would also work, and without the clumsy side effects.  I'll
do that instead.

--D
