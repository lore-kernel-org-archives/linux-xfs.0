Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC351C4CEC4
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 18:21:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EA3921920
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 18:21:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AamNa0H8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388337AbfIRSVx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 14:21:53 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49514 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388324AbfIRSVw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Sep 2019 14:21:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IIJLLI081685;
        Wed, 18 Sep 2019 18:21:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=CEAU4fjk3a3oB6LQZhQFp/TSG6DxNiVhGIOabSkx1pY=;
 b=AamNa0H8IQyl0irKsBDyVLLj0bzhamNy+pY9Si87h1yTrd5/Uch+d6/8YfFhJOceAeMc
 noguOLuwr17F5sQURt8bTkF5qXDgg1v3VAHnYdJetb/a+DqfJxGgtR8tqK/JUFh6TXhI
 SZ+s5UsGUOzFIqixlfORjFgu8T2K9t00kKaWpFRhQcEhHVG4h/Jr08xcO7qf/8Qg+cM0
 5AZyZivur4CkpAQRX7YUnEOjCg7UrOot/1jQ6FmnwCKb4q3B+MvOhPYBdt86bSF8594s
 nPd0RI29+8l947V2zD8qisv6XckjqFqwBc4nRlfDuNp7xEXrmb3RrBfSqVxUDIZTJ4rm vQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2v385e5q9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 18:21:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IIIZot153903;
        Wed, 18 Sep 2019 18:21:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2v37mb0qjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 18:21:39 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8IILb7m023935;
        Wed, 18 Sep 2019 18:21:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Sep 2019 11:21:37 -0700
Date:   Wed, 18 Sep 2019 11:21:35 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: remove xfs_release
Message-ID: <20190918182135.GO2229799@magnolia>
References: <20190916122041.24636-1-hch@lst.de>
 <20190916122041.24636-2-hch@lst.de>
 <20190916125311.GB41978@bfoster>
 <20190918164938.GA19316@lst.de>
 <20190918181204.GG29377@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918181204.GG29377@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909180162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909180162
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 18, 2019 at 02:12:04PM -0400, Brian Foster wrote:
> On Wed, Sep 18, 2019 at 06:49:38PM +0200, Christoph Hellwig wrote:
> > On Mon, Sep 16, 2019 at 08:53:11AM -0400, Brian Foster wrote:
> > > The caller might not care if this call generates errors, but shouldn't
> > > we care if something fails? IOW, perhaps we should have an exit path
> > > with a WARN_ON_ONCE() or some such to indicate that an unhandled error
> > > has occurred..?
> > 
> > Not sure there is much of a point.  Basically all errors are either
> > due to a forced shutdown or cause a forced shutdown anyway, so we'll
> > already get warnings.
> 
> Well, what's the point of this change in the first place? I see various
> error paths that aren't directly related to shutdown. A writeback
> submission error for instance looks like it will warn, but not
> necessarily shut down (and the filemap_flush() call is already within a
> !XFS_FORCED_SHUTDOWN() check). So not all errors are associated with or
> cause shutdown. I suppose you could audit the various error paths that
> lead back into this function and document that further if you really
> wanted to go that route...

I agree with Brian, there ought to be some kind of warning that some
error happened with inode XXX even if we do end up shutting down
immediately afterwards.

> Also, you snipped the rest of my feedback... how does the fact that the
> caller doesn't care about errors have anything to do with the fact that
> the existing logic within this function does? I'm not convinced the
> changes here are quite correct, but at the very least the commit log
> description is lacking/misleading.

I was wondering that too -- if filemap_flush, we'd stop immediately, but
now we keep going.  That certainly seems like a behavior change that
ought to be a separate patch from combining the two release functions?

--D

> Brian
