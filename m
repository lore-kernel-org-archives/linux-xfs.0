Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E992C43331
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 20:35:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBEB620735
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 20:35:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="llfUcARg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgCXUfG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 16:35:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49196 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbgCXUfG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 16:35:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OKSM21135992;
        Tue, 24 Mar 2020 20:35:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=FJDH++ZD9hjt0eFeghWfNAjmYIWBsPOOoRxIfPKqcus=;
 b=llfUcARgFTBneT+JxfgdgBC4n0BN2/X+FuPBnwg5N/0B64Wquwm0D2oj1LBRso81OuRF
 xX0y0duVKyHQj5jNbGnl9kZ8HvgyP4yx/Ou94hdcfb60+tDlD1JUC8mI4UBi3OXHixFT
 g0xcHUsZfDSk9nxmCZQcIgz9CN0LhxT2z6BF/qjGOxyG2YMvlRB5RZCq+FjwmqzGPg0F
 FafqGDEY7Gb07riZND00HtcWyYqgo03PukekwfTl8/jDdWIyDPdBRYYRU8cmYjVUQMZY
 ZCP8jZFOFrqkeAezGcIY+BkocO/btojLpw3wNvtCiJhhcpKa4+lH05gCZSc73Jj8GSja 9A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2yx8ac3h7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 20:35:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OKSNGN012070;
        Tue, 24 Mar 2020 20:35:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2yxw4q0fs1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 20:35:02 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02OKZ0Xh004706;
        Tue, 24 Mar 2020 20:35:00 GMT
Received: from localhost (/10.159.142.243)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 13:35:00 -0700
Date:   Tue, 24 Mar 2020 13:34:59 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: shutdown on failure to add page to log bio
Message-ID: <20200324203459.GG29339@magnolia>
References: <20200324165700.7575-1-bfoster@redhat.com>
 <20200324171859.GF29339@magnolia>
 <20200324172949.GB3148@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324172949.GB3148@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240102
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 mlxscore=0 adultscore=0 phishscore=0 impostorscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240102
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 24, 2020 at 01:29:49PM -0400, Brian Foster wrote:
> On Tue, Mar 24, 2020 at 10:18:59AM -0700, Darrick J. Wong wrote:
> > On Tue, Mar 24, 2020 at 12:57:00PM -0400, Brian Foster wrote:
> > > If the bio_add_page() call fails, we proceed to write out a
> > > partially constructed log buffer. This corrupts the physical log
> > > such that log recovery is not possible. Worse, persistent
> > > occurrences of this error eventually lead to a BUG_ON() failure in
> > > bio_split() as iclogs wrap the end of the physical log, which
> > > triggers log recovery on subsequent mount.
> > > 
> > > Rather than warn about writing out a corrupted log buffer, shutdown
> > > the fs as is done for any log I/O related error. This preserves the
> > > consistency of the physical log such that log recovery succeeds on a
> > > subsequent mount. Note that this was observed on a 64k page debug
> > > kernel without upstream commit 59bb47985c1d ("mm, sl[aou]b:
> > > guarantee natural alignment for kmalloc(power-of-two)"), which
> > > demonstrated frequent iclog bio overflows due to unaligned (slab
> > > allocated) iclog data buffers.
> > 
> > Fixes: tag?
> > 
> 
> I suppose you could argue it fixes commit 79b54d9bfcdcd ("xfs: use bios
> directly to write log buffers"), but I didn't include a tag because this
> is not really fixing a reproducible bug. It's fixing up the error
> handling based on a bad combination of patches in a distro kernel.
> Perhaps I'm just not clear on when we do or don't want a fixes tag..?

[Summarizing what I rambled about on IRC:]

From my perspective, this looks like you concluded that the WARN_ON_ONCE
wasn't sufficient to deal with the error (because the physical log got
corrupted), so you're adding branch code to shut down the log.

Granted, it should only happen if bio_add_page fails, but as that's not
part of xfs, we have to code defensively enough to avoid breaking the
filesystem.

Looks ok, will add fixes tag and send it to the testcloud...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> Brian
> 
> > Otherwise, looks ok to me.
> > 
> > --D
> > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/xfs_log.c | 14 ++++++++++----
> > >  1 file changed, 10 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > > index 2a90a483c2d6..ebb6a5c95332 100644
> > > --- a/fs/xfs/xfs_log.c
> > > +++ b/fs/xfs/xfs_log.c
> > > @@ -1705,16 +1705,22 @@ xlog_bio_end_io(
> > >  
> > >  static void
> > >  xlog_map_iclog_data(
> > > -	struct bio		*bio,
> > > -	void			*data,
> > > +	struct xlog_in_core	*iclog,
> > >  	size_t			count)
> > >  {
> > > +	struct xfs_mount	*mp = iclog->ic_log->l_mp;
> > > +	struct bio		*bio = &iclog->ic_bio;
> > > +	void			*data = iclog->ic_data;
> > > +
> > >  	do {
> > >  		struct page	*page = kmem_to_page(data);
> > >  		unsigned int	off = offset_in_page(data);
> > >  		size_t		len = min_t(size_t, count, PAGE_SIZE - off);
> > >  
> > > -		WARN_ON_ONCE(bio_add_page(bio, page, len, off) != len);
> > > +		if (bio_add_page(bio, page, len, off) != len) {
> > > +			xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
> > > +			break;
> > > +		}
> > >  
> > >  		data += len;
> > >  		count -= len;
> > > @@ -1762,7 +1768,7 @@ xlog_write_iclog(
> > >  	if (need_flush)
> > >  		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
> > >  
> > > -	xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count);
> > > +	xlog_map_iclog_data(iclog, count);
> > >  	if (is_vmalloc_addr(iclog->ic_data))
> > >  		flush_kernel_vmap_range(iclog->ic_data, count);
> > >  
> > > -- 
> > > 2.21.1
> > > 
> > 
> 
