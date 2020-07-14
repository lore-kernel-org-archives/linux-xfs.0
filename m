Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A569EC433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 01:43:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 758F120578
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 01:43:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dua65tAA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgGNBn2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 21:43:28 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44698 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgGNBn1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jul 2020 21:43:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E1gSwj120746;
        Tue, 14 Jul 2020 01:43:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=575hWvbabZVx1iancJZozKfM9fdi9/eXw6UF+xny7QU=;
 b=Dua65tAA9ZVfDqWPz/gtNEzpwfudxDSSbUU2mJ10eVQnEro3qDjBv/+iw2Z84I7F7IB+
 Nm60BuzpvuUJmFRpcjTOXgyYL1EVY1VAPlujoXyHFPH5w1v9jwypG9v/WyIGlhKF4uTu
 xQvg+0Q/Gu/yNcIEY8iKlhBTXJ8pdJqTtkZY0OJg0hhyh7RHCOVT5TY7cU7ETQQ54s7+
 vkVWgwf8EnGCWD0scoZfUrvHg8Zw4KBJItyGqNhaoJaYOgWmhQq25maz3dlE9fuTWKFf
 tz57nw2Tr/X7LE/7i0YvBW7buI5WWHiqREEZeMMgIZe0Wp8VA9cRuma42GgzdoVdvRgw yg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3274ur2frp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 01:43:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E1bWaL159625;
        Tue, 14 Jul 2020 01:43:19 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 327qb29ac9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 01:43:19 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06E1hIGB018916;
        Tue, 14 Jul 2020 01:43:18 GMT
Received: from localhost (/10.159.128.100)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 18:43:18 -0700
Date:   Mon, 13 Jul 2020 18:43:18 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 00/26] xfs: remove xfs_disk_quot from incore dquot
Message-ID: <20200714014318.GY7625@magnolia>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159469028734.2914673.17856142063205791176.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=1 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=1 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In case anyone was curious, the unreviewed patches in this series are:

4, 5, 6, 7, 8, 10, 24, and 25.

4-8 and 10 are the new ones that arrived because Christoph wanted more
refactoring of flags fields.

24 got comments in v1 and hasn't been looked at since.

25 bumps the warning counter when we go over the soft limit but haven't
gone over the hard limit or the soft warning limit.  I get it, that's
not refactoring per se, but I'm not sure if warnings not working is
deliberate, or merely a sign of how little anyone tests quota
enforcement?

--D
