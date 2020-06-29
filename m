Return-Path: <SRS0=2z4t=AK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B09C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Jun 2020 21:24:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD7EA208B6
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Jun 2020 21:24:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cJNKQwGV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgF2VYM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Jun 2020 17:24:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58344 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729519AbgF2SuV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jun 2020 14:50:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05TGwAIO100949;
        Mon, 29 Jun 2020 17:00:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=A3mcy7RRQz5dd7odb0660diXq4Zw4Lv0BXx7wlpoS6k=;
 b=cJNKQwGVlH1+4CdgRAIOQL3WbCVjxkBHGaMMOzLmfQ4nvwcO6fpKafUKCS1AL2+yjpbZ
 vwijAisW9QWxOzqv6IMN7TXbMVIycGr2FWrdAwqJ92chLmeL/Rt3XpzVyICcaxQUTKS2
 EVy8dPlgsjpOeQ/jMTTqZHFFV7SMhI7jKzRocKPzVZYZZ+2TgHYw6b1CzI38rbEOhjmt
 l12bIclopkCBaS4FjMOjy9K+gPQFf9H1napu31vYRQRQjkv1kMkjdPq9Y82EtRkDLE6B
 5AfiTn8n8NJ7xooHqlUTLdrTgUpWHqtVNYjulM5qOR/D4fMH45jllkmNlEZNTgxVYW8G 7g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31xx1dmgjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 29 Jun 2020 17:00:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05TGwQO2093682;
        Mon, 29 Jun 2020 17:00:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 31y52gp388-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Jun 2020 17:00:50 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05TH0ntZ028805;
        Mon, 29 Jun 2020 17:00:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 29 Jun 2020 17:00:49 +0000
Date:   Mon, 29 Jun 2020 10:00:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: use MMAPLOCK around filemap_map_pages()
Message-ID: <20200629170048.GR7606@magnolia>
References: <20200623052059.1893966-1-david@fromorbit.com>
 <20200623211910.GG7606@magnolia>
 <20200623221431.GB2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623221431.GB2005@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 suspectscore=1 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006290109
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=1 mlxlogscore=999 cotscore=-2147483648 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006290109
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 24, 2020 at 08:14:31AM +1000, Dave Chinner wrote:
> On Tue, Jun 23, 2020 at 02:19:10PM -0700, Darrick J. Wong wrote:
> > On Tue, Jun 23, 2020 at 03:20:59PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > The page faultround path ->map_pages is implemented in XFS via
> > 
> > What does "faultround" mean?
> 
> Typo - fault-around.
> 
> i.e. when we take a read page fault, the do_read_fault() code first
> opportunistically tries to map a range of pages surrounding
> surrounding the faulted page into the PTEs, not just the faulted
> page. It uses ->map_pages() to do the page cache lookups for
> cached pages in the range of the fault around and then inserts them
> into the PTES is if finds any.
> 
> If the fault-around pass did not find the page fault page in cache
> (i.e. vmf->page remains null) then it calls into do_fault(), which
> ends up calling ->fault, which we then lock the MMAPLOCK and call
> into filemap_fault() to populate the page cache and read the data
> into it.
> 
> So, essentially, fault-around is a mechanism to reduce page faults
> in the situation where previous readahead has brought adjacent pages
> into the page cache by optimistically mapping up to
> fault_around_bytes into PTEs on any given read page fault.
> 
> > I'm pretty convinced that this is merely another round of whackamole wrt
> > taking the MMAPLOCK before relying on or doing anything to pages in the
> > page cache, I just can't tell if 'faultround' is jargon or typo.
> 
> Well, it's whack-a-mole in that this is the first time I've actually
> looked at what map_pages does. I knew there was fault-around in the
> page fault path, but I know that it had it's own method for
> page cache lookups and pte mapping, nor that it had it's own
> truncate race checks to ensure it didn't map pages invalidated by
> truncate into the PTEs.

<nod> Thanks for the explanation.

/me wonders if someone could please check all the *_ops that point to
generic helpers to see if we're missing obvious things like lock
taking.  Particularly someone who wants to learn about xfs' locking
strategy; I promise it won't let out a ton of bees.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D


> There's so much technical debt hidden in the kernel code base. The
> fact we're still finding places that assume only truncate can
> invalidate the page cache over a file range indicates just how deep
> this debt runs...
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
