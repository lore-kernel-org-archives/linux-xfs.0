Return-Path: <SRS0=QPje=ZI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FA57C432C3
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Nov 2019 19:42:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65AB5206E1
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Nov 2019 19:42:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R0Ko9wiJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbfKPTm3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 Nov 2019 14:42:29 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44634 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbfKPTm3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Nov 2019 14:42:29 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAGJe4q2057189;
        Sat, 16 Nov 2019 19:40:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=RXxepOO7hf3VaigVk3BMBYt/CM7kLe2CkkOptDCOVM8=;
 b=R0Ko9wiJYPMQHIFydqKwDBt1WmCYNWutNq13EnirUlM39phZ13Gpr2ZYT5AccpVxr/sQ
 8YUKGkZLwJsWRRL3NCGJpdI8rDXgNkrUik+4E9Q3rSnTrGFtHMrP9Kr8XiI5yDS1XNbV
 LcpX5+/nSJEhmHrkwltp9fCUdBbZZX6xpioryaVoGTt0nwHNAqFbTFff9MCuIRxwfGN8
 PXI4C6j5F8CvnQ3u1EcH9kANVTRtaat684WGTKQW4oaL5qdNFa6GjQz1sYu1gkNiDMcW
 E9c71r0L5oXlqTYmFw/KPzAD0D8bU6es/EUQNi5c45/MqIk8wpDFBUmoGloj/CXoQSB0 CQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2wa8ht9req-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 Nov 2019 19:40:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAGJcwYp126659;
        Sat, 16 Nov 2019 19:40:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2wa8xk1c2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 Nov 2019 19:40:14 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAGJeDgN004283;
        Sat, 16 Nov 2019 19:40:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 16 Nov 2019 11:40:13 -0800
Date:   Sat, 16 Nov 2019 11:40:12 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to f368b29ba917
Message-ID: <20191116194012.GR6219@magnolia>
References: <20191114181654.GG6211@magnolia>
 <20191116070236.GA30357@infradead.org>
 <20191116181505.GA15462@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191116181505.GA15462@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9443 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=914
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911160183
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9443 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911160183
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Nov 16, 2019 at 10:15:05AM -0800, Christoph Hellwig wrote:
> On Fri, Nov 15, 2019 at 11:02:36PM -0800, Christoph Hellwig wrote:
> > FYI, this crash for me in xfs/348 with unfortunately a completely
> > garbled dmesg.  The xfs-5.5-merge-11 is fine.
> 
> git-bisect points to:
> 
> xfs: convert open coded corruption check to use XFS_IS_CORRUPT

Hmm, got a kconfig for me to try out?

--D
