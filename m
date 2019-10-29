Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF541CA9EAE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 20:22:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7446F2086A
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 20:22:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZKsdOLbU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbfJ2UWq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 16:22:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40810 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfJ2UWp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 16:22:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TKIUdX067261;
        Tue, 29 Oct 2019 20:22:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Zm+1B6uqgsdI2/PrO+o1WkYWJEmFIwKz9PwQxlN4eZw=;
 b=ZKsdOLbUZGG0lJIuIH9khNFLzVYk1veWX1YaGqkaQ6/wsYEvX4GKC+yTMz970wchVe0g
 auAm1JKkDGeoJli8DXe1LRRLWBy6n5bALLaU5XkiivgpfgMlGevo9nMYs3dIjkeVqCBo
 Eta8C8F1aMGRloBYmMvWUkfHhceOFjdYvmlXLyUYZUImzXlkkaCcewn+kUHk8h5DKWXd
 iUNdrxoTpbcXwXR5uGlsmYitHhgo1Aut+YXEt/srR5/zq+TU4hBGfDqwHl/wSlSP3zqx
 U0Q57VOCA9k/gNvsqlbRsXZlqJLaMT2sy2mtDlrd0Re3bHHCH3t4jfZ7awSfzHCxD9xe 0g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2vvumfgkws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 20:22:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TKHwxf115816;
        Tue, 29 Oct 2019 20:22:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vxpenw4c9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 20:22:30 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9TKMTx2007306;
        Tue, 29 Oct 2019 20:22:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Oct 2019 13:22:29 -0700
Date:   Tue, 29 Oct 2019 13:22:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: properly serialise fallocate against AIO+DIO
Message-ID: <20191029202228.GE15222@magnolia>
References: <20191029034850.8212-1-david@fromorbit.com>
 <20191029041908.GB15222@magnolia>
 <20191029044133.GN4614@dread.disaster.area>
 <20191029100342.GA41131@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029100342.GA41131@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910290176
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910290176
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 29, 2019 at 06:03:42AM -0400, Brian Foster wrote:
> On Tue, Oct 29, 2019 at 03:41:33PM +1100, Dave Chinner wrote:
> > On Mon, Oct 28, 2019 at 09:19:08PM -0700, Darrick J. Wong wrote:
> > > On Tue, Oct 29, 2019 at 02:48:50PM +1100, Dave Chinner wrote:
> ...
> > > > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > > > index 525b29b99116..865543e41fb4 100644
> > > > --- a/fs/xfs/xfs_file.c
> > > > +++ b/fs/xfs/xfs_file.c
> > > > @@ -817,6 +817,36 @@ xfs_file_fallocate(
> > > >  	if (error)
> > > >  		goto out_unlock;
> > > >  
> ...
> > > > +	/*
> > > > +	 * Now AIO and DIO has drained we flush and (if necessary) invalidate
> > > > +	 * the cached range over the first operation we are about to run.
> > > > +	 *
> > > > +	 * We care about zero and collapse here because they both run a hole
> > > > +	 * punch over the range first. Because that can zero data, and the range
> > > > +	 * of invalidation for the shift operations is much larger, we still do
> > > > +	 * the required flush for collapse in xfs_prepare_shift().
> > > > +	 *
> > > > +	 * Insert has the same range requirements as collapse, and we extend the
> > > > +	 * file first which can zero data. Hence insert has the same
> > > > +	 * flush/invalidate requirements as collapse and so they are both
> > > > +	 * handled at the right time by xfs_prepare_shift().
> > > > +	 */
> > > > +	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE |
> > > > +		    FALLOC_FL_COLLAPSE_RANGE)) {
> > > 
> > > Er... "Insert has the same requirements as collapse", but we don't test
> > > for that here?  Also ... xfs_prepare_shift handles flushing for both
> > > collapse and insert range, but we still have to flush here for collapse?
> > >
> > > <confused but suspecting this has something to do with the fact that we
> > > only do insert range after updating the isize?>
> > 
> > Yes, exactly.
> > 
> > The flush for collapse here is for the hole punch part of collapse,
> > before we start shifting extents. insert does not hole punch, so it
> > doesn't need flushing here but it still needs flush/inval before
> > shifting. i.e.:
> > 
> > collapse				insert
> > 
> > flush_unmap(off, len)
> > punch hole(off, len)			extends EOF
> >   writes zeros around (off,len)		  writes zeros around EOF
> > collapse(off, len)			insert(off, len)
> >   flush_unmap(off, EOF)			  flush_unmap(off, EOF)
> >   shift extents down			  shift extents up
> > 
> > So once we start the actual extent shift operation (up or down)
> > the flush/unmap requirements are identical.
> > 
> > > I think the third paragraph of the comment is just confusing me more.
> > > Does the following describe what's going on?
> > > 
> > > "Insert range has the same range [should this be "page cache flushing"?]
> > > requirements as collapse.  Because we can zero data as part of extending
> > > the file size, we skip the flush here and let the flush in
> > > xfs_prepare_shift take care of invalidating the page cache." ?
> > 
> > It's a bit better - that's kinda what I was trying to describe - but
> > I'll try to reword it more clearly after I've let it settle in my
> > head for a little while....
> > 
> 
> I agree the comment is a little confusing because to me, it's just
> describing a bit too much for its context. I.e., I read the comment and
> have to go look at other code to make sure I grok the comment rather
> than the comment helping me grok the code it's associated with.
> 
> FWIW, I find something like the following a bit more clear/concise on
> the whole:
> 
>         /*
> +        * Once AIO and DIO has drained we flush and (if necessary) invalidate
> +        * the cached range over the first operation we are about to run. We
> +        * include zero and collapse here because they both start with a hole
> +        * punch over the target range. Insert and collapse both invalidate the
> +        * broader range affected by the shift in xfs_prepare_shift().
>          */
> 
> ... because it points out why we special case collapse here, and that
> otherwise the prepare shift code is responsible for the rest. Just my
> .02 and otherwise the patch looks good to me.

I like that version better too.

--D

> Brian
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> 
