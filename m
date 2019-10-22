Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D781CA9EAF
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 01:51:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E2BD207FC
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 01:51:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dEyih4Da"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbfJVBvB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Oct 2019 21:51:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50954 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbfJVBvB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Oct 2019 21:51:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9M1haqa004800;
        Tue, 22 Oct 2019 01:45:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=e6n5ZFfi2T01b//f4W948xwScbtAlpoo4PfACf0vsQg=;
 b=dEyih4DapLS/MMDQFq9TDZ2LsH+I1W2z3NQKpgljU9MUNFKwR/k39baqFc0odFeRVT3c
 1Z6S9VZ6GYLrTa3zc3602zXkJL+KPh4yR/hc1+tcvJ4iEWqHLmj86GKuBNoDEQvQWlvZ
 d/JylGDs9jLYd6Kjl0adc3WkMuGoYo/XxYC4PIURcXFa+a9SdRy8U6CzjaEEL2prmssO
 irZhrjcfdgazkt0FsUvNPoro/5EDjcyTW7HKdp4Tu/38Y4jtMbH22yFZbA6hwCRCZC3K
 VYDOROeuLhY6g0ngIOdfkz0wU8oy9U+l9+2QXM1igLSFf+hTe5ukbg4LNIeVc7Q9sUAR iw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2vqu4qk5t6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 01:45:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9M1cEoZ097530;
        Tue, 22 Oct 2019 01:45:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2vrc00tfvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 01:45:11 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9M1jBNP003098;
        Tue, 22 Oct 2019 01:45:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Oct 2019 18:45:10 -0700
Date:   Mon, 21 Oct 2019 18:45:09 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Goldwyn Rodrigues <rgoldwyn@suse.com>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: xfs COW cleanups v3
Message-ID: <20191022014509.GJ913374@magnolia>
References: <20191019144448.21483-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191019144448.21483-1-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=806
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=884 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220015
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 19, 2019 at 04:44:36PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> Changes since v2:
>  - rebased on the latest iomap-for-next and dropped patches already
>    merged
> 
> Changes since v1:
>  - renumber IOMAP_HOLE to 0 and avoid the reserved 0 value
>  - fix minor typos and update comments

Merged, thanks.

--D
