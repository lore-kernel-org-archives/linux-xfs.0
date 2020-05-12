Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC041CA90AF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 17:12:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8272C206B8
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 17:12:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eZDKrhWR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgELRM4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 13:12:56 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46652 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbgELRMz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 13:12:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CHCI7g121539
        for <linux-xfs@vger.kernel.org>; Tue, 12 May 2020 17:12:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=keFPTh8ikDtJ+OZtb+3pKg72jSh2Ud4o9QBDLYKImVY=;
 b=eZDKrhWRz+3WTKv70qRozhqW8W1IGFImEIh0iS5oQNwyTPnqFe25zUlvGg5E4Znu17Ry
 xbOPJhN6iToLVFtfgO7HXaBl5P/qpnwY5lGt56gOpIBcVtuWwWgauiz7GkO3ueuKA7eZ
 jYZAPRqtdGnFqr2DERveTUewMiN7kLxTN7iWlxKiD3CRAfbzWOmJNydpGa0CcToz+azL
 9dBGm7uC/lZif5ifSYI77yeFbpEq7933dYTU3JSaDlgD0Td47h8LU3WnqbezEPe9Iakb
 Hzl5VxLEWKPBig1rGculiQCHgvx3wwu+MGNBjqsVGxvoJc0vo3herBj+TXdzWAZbyYuy rA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30x3gmmbd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 12 May 2020 17:12:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CH7wWP150171
        for <linux-xfs@vger.kernel.org>; Tue, 12 May 2020 17:12:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30ydsqvuwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 12 May 2020 17:12:54 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04CHCrDa008540
        for <linux-xfs@vger.kernel.org>; Tue, 12 May 2020 17:12:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 May 2020 10:12:53 -0700
Date:   Tue, 12 May 2020 10:12:52 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-documentation: master updated to 443df98
Message-ID: <20200512171252.GH6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=2 mlxscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 clxscore=1015 spamscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 suspectscore=2
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120132
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The master branch of the xfs-documentation repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-documentation.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the master branch is commit:

443df98 xfsdocs: capture some information about dirs vs. attrs and how they use dabtrees

New Commits:

Darrick J. Wong (1):
      [443df98] xfsdocs: capture some information about dirs vs. attrs and how they use dabtrees


Code Diffstat:

 .../extended_attributes.asciidoc                   | 59 ++++++++++++++++++++++
 1 file changed, 59 insertions(+)
