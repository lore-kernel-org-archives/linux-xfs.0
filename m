Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEAB2C33CAF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 23:15:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CF8420684
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 23:15:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sGGATksh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388516AbgAPXPy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 18:15:54 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56646 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729336AbgAPXPy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 18:15:54 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00GND4pv067803;
        Thu, 16 Jan 2020 23:15:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=j8ZWMA/+8uAsmWg51ym0vw8AlE/VJtGtJB/x+BZV2xg=;
 b=sGGATkshGH3uSjHvho567zraP462+kmVuR3bJkE6MGDbFPqffwI7WjcoUeUYoWGGOj0y
 5dM6SvygWmDmC6PxRrCDW6iBQ9KJH15JJ4nJlAlBHFJMRwmWcQ98+iq3HJRAuND41Yra
 eS/FHlnUtxCGIs3OZL4d+heQMF7wc3AYKNF6DgJUbZbnoU0BLj+y9UulpMMZIYfz8Pmc
 bO3Lrobezhs5lr0c0rrW/tWjb49EPEmu7xjtmcQScm9dSLJCxDyfFllFCTi5PG4XJc0T
 nmrvbMJ+jz0crZjcWtKLHT6liZhaRwfpa6ECwpKk2lbihJjwBRRckh5aKN8KWnskOwun 2g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xf73u5j41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 23:15:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00GNFigE116855;
        Thu, 16 Jan 2020 23:15:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2xjxm7qw3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 23:15:44 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00GNFRiJ010201;
        Thu, 16 Jan 2020 23:15:27 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jan 2020 15:15:27 -0800
Date:   Thu, 16 Jan 2020 15:15:24 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: relax unwritten writeback overhead under some
 circumstances
Message-ID: <20200116231524.GL8247@magnolia>
References: <157915534429.2406747.2688273938645013888.stgit@magnolia>
 <157915535801.2406747.10502356876965505327.stgit@magnolia>
 <20200116164900.GB4593@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116164900.GB4593@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160185
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160185
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 16, 2020 at 08:49:00AM -0800, Christoph Hellwig wrote:
> On Wed, Jan 15, 2020 at 10:15:58PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In the previous patch, we solved a stale disk contents exposure problem
> > by forcing the delalloc write path to create unwritten extents, write
> > the data, and convert the extents to written after writeback completes.
> > 
> > This is a pretty huge hammer to use, so we'll relax the delalloc write
> > strategy to go straight to written extents (as we once did) if someone
> > tells us to write the entire file to disk.  This reopens the exposure
> > window slightly, but we'll only be affected if writeback completes out
> > of order and the system crashes during writeback.
> > 
> > Because once again we can map written extents past EOF, we also
> > enlarge the writepages window downward if the window is beyond the
> > on-disk size and there are written extents after the EOF block.  This
> > ensures that speculative post-EOF preallocations are not left uncovered.
> 
> This does sound really sketchy.  Do you have any performance numbers
> justifying something this nasty?

Nope! :D

IIRC Dave also expressed interested in performance impacts the last time
I sent this series, albeit more from the perspective of quantifying how
much pain we'd incur from forcing all writes to perform an unwritten
extent conversion at the end.

FWIW after months of running this on my internal systems, I haven't been
able to quantify any significant difference before and after, even with
rmap enabled.  There's slightly more log traffic from the extra
bmbt/rmapbt/inode core updates, but even then the log is fairly good at
deduping repeated updates.  Both transactions usually commit before the
log checkpoints.

Frankly I wouldn't apply this patch (or 'xfs: extend the range of
flush_unmap ranges') on the grounds that re-opening potential disclosure
flaws is never worth the risk.  I'm also pretty sure that being careful
to convert delalloc data fork extents to unwritten extents fixes the
stale disclosure flaw that Ritesh wrote about in ('iomap: direct-io:
Move inode_dio_begin before filemap_write_and_wait_range').

(As far as ext4 goes, I talked to Jan and Ted this morning and they
seemed to think that they could solve the race on their end by retaining
the unwritten state in the incore extent cache because ext4 apparently
doesn't commit the extent map update transaction until after writeback
completes.)

--D
