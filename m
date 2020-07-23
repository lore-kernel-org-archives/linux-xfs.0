Return-Path: <SRS0=I6cU=BC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83222C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jul 2020 17:23:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C4CE20714
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jul 2020 17:23:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H8oNolli"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgGWRX0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jul 2020 13:23:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58190 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgGWRX0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jul 2020 13:23:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06NHDo66092169;
        Thu, 23 Jul 2020 17:23:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=2QYAgo6ace5xREaapH2qZ0/To4GsJtMU8CTj+KAHWIQ=;
 b=H8oNolliHklmw9XKtMyNizrxWDNsGm4d9C4B/6lMcm1ZKyctOT4BizFp3G5o/QDU3puA
 t8dsf16oMqt2USoob8jeriDKMhQNMkeYM8DfGrohbbmVxkmL31C9Fp1Oqp3GiWDwTFho
 nbg08yvCVGGJsLDmrK2DDgUZeDRvZUWtVYMPN2DPbeWZ7O3+361WQ3sz1NOLVJvJmuPf
 6AEP7+LuCC3HCX3HPjC3TcAO5xFNYQs61Kq4LdzwnW2qPF+Rpj6XgfxlmbN7GJC9Oxpw
 5wGwTJuJw2iU6mJH535C/P8iYbJ2KcVzNHGUaKbDheYmY/UySNWkHDcXgUSDMxmgTLGj dg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 32bs1mtrfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 23 Jul 2020 17:23:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06NHJ8Ai097744;
        Thu, 23 Jul 2020 17:21:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 32fe67at0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jul 2020 17:21:15 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06NHLEuK026505;
        Thu, 23 Jul 2020 17:21:14 GMT
Received: from localhost (/10.159.238.162)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jul 2020 17:21:14 +0000
Date:   Thu, 23 Jul 2020 10:21:13 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Allison Collins <allison.henderson@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Need to slow things down for a few days...
Message-ID: <20200723172113.GP3151642@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9691 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=1 malwarescore=0 spamscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007230126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9691 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 spamscore=0 mlxscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007230126
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi everyone,

I wrenched my back last night (blah blah too much internal process
stress and sitting) and need a few days rest.  I still intend to make a
post-rc6 for-next push, though I've noticed that fstests runtime has
slipped by about 30%.

I can't tell if it's the result of iomap directio falling back to
buffered writes, or Carlos' kmem conversion, or even Allison's delayed
attrs series, but I'll know in a few hours.  I added all three a few
days ago to see what would happen. :P

In the meantime, I'll be hobbling along in the slow lane because sitting
down is not a good idea and I can only standing-desk it for so long. :(

--D
