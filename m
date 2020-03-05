Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CDC7C3F2D2
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 17:46:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EED8C20870
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 17:46:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gThBhBPY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgCERqI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Mar 2020 12:46:08 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:35014 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgCERqI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Mar 2020 12:46:08 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 025HT5RR026652;
        Thu, 5 Mar 2020 17:46:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=GWHUmie2v3J9JTQXCjQNEhkH31WbI2Lm8ycc3V/GhBk=;
 b=gThBhBPYwX09r1nC53GZdtBdDjhRpbbTNi1XK7C/SP2vdtu45lrLVEU3VfSEhz63YbsC
 NuY+gDqbiS997n/DyN1d1aKKt8s8InaCPB4dhPawqA05I3muKdSDEvOx8aMzeG6VNuZB
 pNy+ExGf3oiojfhbZaJTPLusCducjUyy9pvOjAFWjD3/DxgAEQcvILPYoyp9a92DcJuu
 Iq0762G5ldt026UzXPIikuMMfhGi9s4shLqUCPTCuIx3AyYA7rVnkc5dWF0f47zyxh2e
 0YllSONDyP8q+0a0yIo6/wWtxSVc2agUMV61Vsm/1IqM5o4sbx7QRPJgmdKkKdaAwreb 5Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2yghn3jgjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Mar 2020 17:46:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 025Hh1kd162477;
        Thu, 5 Mar 2020 17:46:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2yjuf1js91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Mar 2020 17:46:01 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 025HjtF4030278;
        Thu, 5 Mar 2020 17:46:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Mar 2020 09:45:55 -0800
Date:   Thu, 5 Mar 2020 09:45:54 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: fix buffer state when we reject a corrupt dir
 free block
Message-ID: <20200305174554.GS8045@magnolia>
References: <158294091582.1729975.287494493433729349.stgit@magnolia>
 <158294092192.1729975.12710230360219661807.stgit@magnolia>
 <e38b8334-6b64-71ed-62d6-527f0fe57f09@sandeen.net>
 <20200303163853.GA8045@magnolia>
 <20200303234533.GY10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303234533.GY10776@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9551 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=2 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003050108
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9551 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 spamscore=0
 impostorscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003050108
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 10:45:33AM +1100, Dave Chinner wrote:
> On Tue, Mar 03, 2020 at 08:38:53AM -0800, Darrick J. Wong wrote:
> > On Mon, Mar 02, 2020 at 05:54:07PM -0600, Eric Sandeen wrote:
> > > On 2/28/20 5:48 PM, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Fix two problems in the dir3 free block read routine when we want to
> > > > reject a corrupt free block.  First, buffers should never have DONE set
> > > > at the same time that b_error is EFSCORRUPTED.  Second, don't leak a
> > > > pointer back to the caller.
> > > 
> > > For both of these things I'm left wondering; why does this particular
> > > location need to have XBF_DONE cleared after the verifier error?  Most
> > > other locations that mark errors don't do this.
> > 
> > Read verifier functions don't need to clear XBF_DONE because
> > xfs_buf_reverify will notice b_error being set, and clear XBF_DONE for
> > us.
> > 
> > __xfs_dir3_free_read calls _read_buf.  If the buffer read succeeds,
> > _free_read then has xfs_dir3_free_header_check do some more checking on
> > the buffer that we can't do in read verifiers.  This is *outside* the
> > regular read verifier (because we can't pass the owner into _read_buf)
> > so if we're going to use xfs_verifier_error() to set b_error then we
> > also have to clear XBF_DONE so that when we release the buffer a few
> > lines later the buffer will be in a state that the buffer code expects.
> 
> Actually, if the data in the buffer is bad after it has been
> successfully read and we want to make sure it never gets used, the
> buffer should be marked stale.
> 
> That will prevent the buffer from being placed on the LRU when it is
> released, and if a lookup finds it in cache it will clear /all/ the
> flags on it
> 
> xfs_da_read_buf() has read the buffer successfully, and set up it's
> state so that it is cached via insertion into the LRU on release. We
> want to make sure that nothing uses this buffer again without a
> complete re-initialisation, and that's effectively what
> xfs_buf_stale() does.
> 
> > This isn't theoretical, if the _header_check fails then we start
> > tripping the b_error assert the next time someone calls
> > xfs_buf_reverify.
> 
> We shouldn't be trying to re-use a corrupt buffer - it should cycle
> out of memory immediately. Clearing the XBF_DONE flag doesn't
> accomplish that; it works for buffer read verifier failures because
> that results in the buffer being released before they are configured
> to be cached on the LRU by the caller...
> 
> Indeed, xfs_buf_read_map() already stales the buffer on read and
> reverify failure....

I coded up making xfs_buf_corruption_error stale the buffer and it
didn't let out the magic smoke, so I'll add that to this series.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
