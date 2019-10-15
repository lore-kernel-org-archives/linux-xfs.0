Return-Path: <SRS0=TKSY=YI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 174ACC10F14
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 16:04:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DED922086A
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 16:04:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Lgwjey3z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbfJOQEo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 12:04:44 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41718 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731631AbfJOQEo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Oct 2019 12:04:44 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9FG4904190383;
        Tue, 15 Oct 2019 16:04:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=5atIgHlU1eMGFNM9+eEbj5qmq1OyO184XswcrfykqTA=;
 b=Lgwjey3zoPfJMRIF/bTQR8gTnY8rzY3npTaFR53RMaPaBLpgrfTxSJDCoK0dFYSic/Nj
 BGo9RTY67tS84uokAdQ4Gu+uaHq05CnyzBlVUtez+8EPFY9Xk/5ZQlf/+RqbcvKqe0uI
 yMKJeLFFlpDMCwvUBQoDDDVndZX19EQ/LTtXQyaw6GtoJQH8S/pjn9j39uL6hxW8Wx+9
 8bSCESBrzjdWWj7C6YVt8X8XyhqzuIJKvhExZggBvtdFDU6w2WDT01LpNwyYkyQ4nk48
 EPnF5LjecihLqdyZDg7PbFD/sO+SJdtyufgeUZMmavoiOtrTEZ0Dh76NBvR+EnrM9HNO tA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2vk7fr90b7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 16:04:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9FFlab4147983;
        Tue, 15 Oct 2019 16:04:27 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2vn718jm7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 16:04:27 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9FG4Pvt003632;
        Tue, 15 Oct 2019 16:04:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Oct 2019 16:04:24 +0000
Date:   Tue, 15 Oct 2019 09:04:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] xfs: change the seconds fields in xfs_bulkstat to signed
Message-ID: <20191015160422.GD13108@magnolia>
References: <20191014171211.GG26541@magnolia>
 <20191015080230.GD3055@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015080230.GD3055@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9411 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910150139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9411 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910150140
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 15, 2019 at 01:02:30AM -0700, Christoph Hellwig wrote:
> On Mon, Oct 14, 2019 at 10:12:11AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > 64-bit time is a signed quantity in the kernel, so the bulkstat
> > structure should reflect that.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Strictly speaking this is a break of the userspace API, but I can't see
> how it causes problems in practice, so:

Yeah, I think I'll add a note to the changelog:

"Note that the structure size stays the same and that we have not yet
published userspace headers for this new ioctl so there are no users to
break."

> Reviewed-by: Christoph Hellwig <hch@lst.de>
