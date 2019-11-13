Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DFDEC432C3
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 16:27:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 408AA24079
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 16:27:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XaEmzHT9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbfKMQ1Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 11:27:16 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42160 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727196AbfKMQ1Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 11:27:16 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADGOIgD005215;
        Wed, 13 Nov 2019 16:27:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=fNsEVpcVL4Sagl4jhHnluI14mtALInzEbVQCLzmmqEk=;
 b=XaEmzHT9D2MOdGloJYHWIN9qWwsI6JVGemxq3O+y9Rp7U5/MVinZV0S1HVyEyFFmZB26
 WREcHD4tPXh5Sa4zLODOG5d2bl+AudsiZKJJ5Va8s2oTP0sz05UWzHlR5FeFqaXdb83x
 pHvWs5Xzq0sHJXrLB4/dxJYSJNXsSwqTDWQcMUaZMWikQGyaW6fO/FLn/OYptkd28Ibr
 1o/6vaPxONDy/Be8wRLZHmgKAKoGBP7Fv2b+HPAs3FiZ8DufGj2TPLX1AYWtldbxYoOM
 e8v7oS6AweJXRy9Rp/L1nxVYx3r3oeYsJBBQaH8efVv/JwNuEGoOxg03Hbq289FsTEPM Og== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2w5ndqdn2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 16:27:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADGQZFt186057;
        Wed, 13 Nov 2019 16:27:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2w7vpphtdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 16:27:10 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xADGR8lb009954;
        Wed, 13 Nov 2019 16:27:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 Nov 2019 08:27:08 -0800
Date:   Wed, 13 Nov 2019 08:27:06 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: devirtualize ->m_dirnameops
Message-ID: <20191113162706.GV6219@magnolia>
References: <20191111180415.22975-1-hch@lst.de>
 <20191113042247.GH6219@magnolia>
 <20191113065918.GA2606@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113065918.GA2606@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9440 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=977
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911130146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9440 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911130146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 13, 2019 at 07:59:18AM +0100, Christoph Hellwig wrote:
> On Tue, Nov 12, 2019 at 08:22:47PM -0800, Darrick J. Wong wrote:
> > > @@ -718,7 +718,7 @@ xfs_dir2_block_lookup_int(
> > >  		 * and buffer. If it's the first case-insensitive match, store
> > >  		 * the index and buffer and continue looking for an exact match.
> > >  		 */
> > > -		cmp = mp->m_dirnameops->compname(args, dep->name, dep->namelen);
> > > +		cmp = xfs_dir2_compname(args, dep->name, dep->namelen);
> > 
> > gcc complains about the unused @mp variable here.  With that fixed the
> > rest looks ok, so:
> 
> What gcc version do you use?  I see a consistent pattern lately that
> yours (correctly) find initialized but unused variable, but neither my
> local one nor the build bot does..

$ gcc --version
gcc (Ubuntu 8.3.0-6ubuntu1~18.04.1) 8.3.0

AHA, I remember now that I kludged up the xfs and iomap makefiles to
include the following, which turns on more warnings and debuginfo:

	ccflags-$(CONFIG_KASAN) += -Wno-error
	ccflags-y += -g \
	-Werror \
	-femit-struct-debug-detailed=any \
	-Wunused-but-set-variable \
	-Wuninitialized \
	-Wno-pointer-sign \
	-Wall \
	-Wextra \
	-Wno-unused-parameter \
	-fstack-usage \
	-Wno-sign-compare \
	-Wno-ignored-qualifiers \
	-Wno-error=unused-but-set-variable \
	-Wno-error=format=

	UBSAN_SANITIZE := y

At this point I suspect -Wall -Wextra cover a lot of these.

--D
