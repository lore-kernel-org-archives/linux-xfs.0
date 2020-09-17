Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 611CBC43463
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 21:33:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2132A20771
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 21:33:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Wsu1CrpN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbgIQVd0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 17:33:26 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46824 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgIQVd0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 17:33:26 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HLTktu184295;
        Thu, 17 Sep 2020 21:33:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=yqQ3WmKDbBWmnu4TolrzXoVeaW+xc7/FA1Hu1sSodXM=;
 b=Wsu1CrpNP6KkuEc4XWwQKhzFCzKY8m9BAeMYM+fUTvk6fnrwaeow18tKsO4fSUIJOT2g
 kBD42QH2SNR+G31RyL2Vb3bgqewtjwFQ3eJxdJLb/PWuADG6f0MibLt6riQlxtBkUVln
 cBO6sKEHklxnMOgUD7UiTP3whkJu1rFn1+rzY110w/D6ix6UOooKxjAQZduLn+ZGhwS/
 v83nOiJvz+CKtPbyKljQ6MjmfNa5h/VRAXuyob2qhgUAlbQfQbK79/Hj7EiOESiryq2N
 iS42nKWo8reuaDCPpQKdDC4ZcYktuo0l5Whk92JYoz/CZAkQQkxsMlv1iFmoiDvhYXub xw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 33gnrrbye4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 21:33:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HLVYxU182545;
        Thu, 17 Sep 2020 21:33:16 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 33h88ch72v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 21:33:16 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08HLXEdA025950;
        Thu, 17 Sep 2020 21:33:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 21:33:14 +0000
Date:   Thu, 17 Sep 2020 14:33:12 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Anju T Sudhakar <anju@linux.vnet.ibm.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        minlei@redhat.com
Subject: Re: [PATCH] iomap: Fix the write_count in iomap_add_to_ioend().
Message-ID: <20200917213312.GF7954@magnolia>
References: <20200824150417.GA12258@infradead.org>
 <20200824154841.GB295033@bfoster>
 <20200825004203.GJ12131@dread.disaster.area>
 <20200825144917.GA321765@bfoster>
 <20200916001242.GE7955@magnolia>
 <20200916084510.GA30815@infradead.org>
 <20200916130714.GA1681377@bfoster>
 <20200917080455.GY26262@infradead.org>
 <20200917104219.GA1811187@bfoster>
 <20200917144804.GA31389@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917144804.GA31389@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=1 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170159
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=1
 clxscore=1015 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170159
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 03:48:04PM +0100, Christoph Hellwig wrote:
> On Thu, Sep 17, 2020 at 06:42:19AM -0400, Brian Foster wrote:
> > That wouldn't address the latency concern Dave brought up. That said, I
> > have no issue with this as a targeted solution for the softlockup issue.
> > iomap_finish_ioend[s]() is common code for both the workqueue and
> > ->bi_end_io() contexts so that would require either some kind of context
> > detection (and my understanding is in_atomic() is unreliable/frowned
> > upon) or a new "atomic" parameter through iomap_finish_ioend[s]() to
> > indicate whether it's safe to reschedule. Preference?
> 
> True, it would not help with latency.  But then again the latency
> should be controlled by the writeback code not doing giant writebacks
> to start with, shouldn't it?
> 
> Any XFS/iomap specific limit also would not help with the block layer
> merging bios.

/me hasn't totally been following this thread, but iomap will also
aggregate the ioend completions; do we need to cap that to keep
latencies down?  I was assuming that amortization was always favorable,
but maybe not?

--D
