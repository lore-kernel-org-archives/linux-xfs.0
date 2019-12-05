Return-Path: <SRS0=6LQP=Z3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E389CC43603
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Dec 2019 17:18:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B69E820801
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Dec 2019 17:18:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VbSE0YH8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729430AbfLERSP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Dec 2019 12:18:15 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46878 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729396AbfLERSP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Dec 2019 12:18:15 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB5HE4rJ185659;
        Thu, 5 Dec 2019 17:17:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=We7FFT52e+w7qubvoBOunnMVUcWvtvuprqhEIBuZLec=;
 b=VbSE0YH8tIG/EdO2b90mllIJATGNjYUh04GRZITvjzmd3FV+oGJh8MPVQOw+9y/gPl5i
 /upJBTN9ji/iU2y2a8RvvIM1JzkaROnnmObMGg5MJ8LcRFonO8Dq3eX/Rh58IoFhuEZf
 29kjtdjqv8SG8IC9QmVMxEzsity0fTdI/RAh8EbJiuS7SfhINTQVYe2NEdqDf0C+VNX7
 F1IQq4ZkX1dnGpli3P0EuokogRYNb0eBDYkBhB/GPXByv1RbJWbIlMpd/9fVZKJrgJjf
 tOiNkcIOg+O6rqjspKH8asAGe4M+5Xmd/ErM4nkGsbB3zUTUqA6AfDHOcKjLYOjKny53 IA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2wkgcqpjhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Dec 2019 17:17:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB5HECvo131642;
        Thu, 5 Dec 2019 17:15:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2wpp8j7hef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Dec 2019 17:15:32 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB5HFRg9023362;
        Thu, 5 Dec 2019 17:15:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Dec 2019 09:15:27 -0800
Date:   Thu, 5 Dec 2019 09:15:25 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Jan Kara <jack@suse.cz>, mbobrowski@mbobrowski.org,
        riteshh@linux.ibm.com
Subject: [ANNOUNCE] xfs-linux: iomap-5.5-merge updated to c275779ff2dd
Message-ID: <20191205171525.GA13249@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9462 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=984
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912050145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9462 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912050145
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The iomap-5.5-merge branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the iomap-5.5-merge branch is commit:

c275779ff2dd iomap: stop using ioend after it's been freed in iomap_finish_ioend()

New Commits:

Christoph Hellwig (1):
      [1cea335d1db1] iomap: fix sub-page uptodate handling

Zorro Lang (1):
      [c275779ff2dd] iomap: stop using ioend after it's been freed in iomap_finish_ioend()


Code Diffstat:

 fs/iomap/buffered-io.c | 40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)
