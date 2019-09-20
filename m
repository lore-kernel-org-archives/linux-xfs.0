Return-Path: <SRS0=+mcJ=XP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF7EFC49ED7
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 04:20:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFE3D207E0
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 04:20:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Uv5k6NBF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437158AbfITEUV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Sep 2019 00:20:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36126 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437157AbfITEUV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Sep 2019 00:20:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8K4J1AQ148810
        for <linux-xfs@vger.kernel.org>; Fri, 20 Sep 2019 04:20:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=sy3e1Jom1+Gmwc4blxpUk942Ue+OBVEGxTFHRURaZHM=;
 b=Uv5k6NBF2C1+h0jOdi7yLptaKRYrZ0oa0eAnkFv4KOdgxeY4uxp6uqgmkbi5OfjQRB1w
 ig5FdsGopyKgNPiXOZa9/vl90xgj/rHfqTyk0qH0eOAafWbsXY0x+eHr2RPoMZiwvtNt
 gnT5fSPNhWa4fpvRMsqmDpXK1ltNE2L63Sm6Npv4O/W85gVKDqMHjv+u4NkY44U1VPVK
 E5DNKH/4kZS2svPv3qOq4r+3pzLrpg+YolH9hfyIMmoLmdGuEF0GsH+RtbAfrAM7ymG/
 PWa0fy977NmyjTf3PZatqoo1cmo1FHn6C3azWFarnwMwYsidu3gYXkWXYTbE7Brucy68 lQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2v3vb4yx4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 Sep 2019 04:20:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8K4ItVa130271
        for <linux-xfs@vger.kernel.org>; Fri, 20 Sep 2019 04:20:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2v3vbhe8a2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 Sep 2019 04:20:18 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8K4KHqs014927
        for <linux-xfs@vger.kernel.org>; Fri, 20 Sep 2019 04:20:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Sep 2019 21:20:17 -0700
Date:   Thu, 19 Sep 2019 21:20:15 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: current 5.4 status
Message-ID: <20190920042015.GP2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9385 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=659
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909200048
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9385 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=736 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909200048
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi everyone,

FYI, the vfs and xfs pull requests for 5.4 have landed; and the iomap
branch keeps getting whittled further and further down, so things ought
to be mostly sorted now.  I'll send the two remaining iomap patches (the
directio api changes) to Linus next week, having dropped the rest.

I don't know how many of you plan to join Friday's climate strike (or
already have), but I certain am.  Enjoy your maintainer-free day! :)

--Darrick
