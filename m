Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7008DC54FCB
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 23:03:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AF082076E
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 23:03:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F7E+1qvI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgDVXDL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 19:03:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43416 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgDVXDL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Apr 2020 19:03:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03MMwjL9182126;
        Wed, 22 Apr 2020 23:03:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=B4VbNM67BU1B5kLZuRiBfg3Binzb9YJ5OWvs0TEndf0=;
 b=F7E+1qvI5FBdErpsTM/odh+LE5GmP1HlT2RzhBoBzwa7YMOHrfA9cMWBrSqkUHi6GYog
 QCXejZfJdazPCWgkpXwKTw9ZPTuO11FL6a/Qg5VIS7u+bqKfKmLAtx7bCR2etvPsgHqM
 UxoIp/lP3w7R6qUoRtvXiV9P6vT9u71jWFwIYNYqdHKHrMyCKXRRftmVGU3i5H+9WGIe
 K5RnQCxxajLSQocLTGgyXzFPMRsL+M1uSxhkiEtXwAoz3ma/w7WlNWFW2xjIS5xzlP41
 2602mNHYFlxo+4EeSdzQrN0HfoTRV+r4rg/g/VXoq0oGheWEPqxL+QxuWlM8AvF/dVyg oA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30jhyc4f28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 23:03:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03MMvdM1093654;
        Wed, 22 Apr 2020 23:03:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30gb3umexp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 23:03:08 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03MN38a1028760;
        Wed, 22 Apr 2020 23:03:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Apr 2020 16:03:07 -0700
Date:   Wed, 22 Apr 2020 16:03:07 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     amir73il@gmail.com
Subject: [XFS SUMMIT] 64bit timestamps
Message-ID: <20200422230307.GH6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9599 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=891 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9599 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=952 spamscore=0 mlxscore=0
 clxscore=1015 suspectscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's a thread to talk about the remainder of 64-bit timestamp support
on XFS.  I have a series[1] that redefines the inode timestamps to be
64-bit nanosecond counters and decreases the accuracy of the ondisk
quota timers to 4s so that both will last until 2446.

--D

[1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=bigtime
