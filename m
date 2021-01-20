Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B79C7C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 20:01:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AF0823441
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 20:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392771AbhATUA3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jan 2021 15:00:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:37740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392728AbhATUAW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Jan 2021 15:00:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3396C23619;
        Wed, 20 Jan 2021 19:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611172722;
        bh=j8JpqhwtoTOZTpgoop1v0PZroNRy10eomIoOhcs0mj8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AkMi5TdzkhGGJ/NISs1HpUAhtC0lSwtFQZCDrVcJD4hYq899F2powWWCXFJ+yLHC5
         9DSpd2wDw/Mq88ftFMtzlDvxKQVoTBqA2QD9/TJemRVfv7L3qxluv+SQMLiNN0CIDo
         13kcSQlAnbguVvwE23LaCgvRvF7JeYuyeSUbxsvtOoRVvUEVFF5jkJ3l5QeCyhH83h
         Hdip8gcKA6QLHwSJPEp0+ypk+6VFN/4a4m06YbAy6IKe1Hb1jvdpgNfCodm1WKo6cX
         hJzut+qjE6B9HV8ZoIXlx6EgTuSeBcYNn0u/qRC/CDRjyIEMQPD8LgmP2EZ3Ruxvqh
         xQZwmFs8a4ETw==
Date:   Wed, 20 Jan 2021 11:58:42 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        avi@scylladb.com, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 11/11] xfs: reduce exclusive locking on unaligned dio
Message-ID: <20210120195842.GR3134581@magnolia>
References: <20210118193516.2915706-1-hch@lst.de>
 <20210118193516.2915706-12-hch@lst.de>
 <20210120184056.GC3133414@magnolia>
 <20210120184400.GA29173@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120184400.GA29173@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 20, 2021 at 07:44:00PM +0100, Christoph Hellwig wrote:
> [another full quote removed, guys please send properly formatted email]
> 
> On Wed, Jan 20, 2021 at 10:40:56AM -0800, Darrick J. Wong wrote:
> > > +	if (!(flags & IOMAP_DIO_UNALIGNED))
> > > +		inode_dio_wait(VFS_I(ip));
> > 
> > Er... this really confused me when I read it -- my first thought was
> > "How can we be in the unaligned direct write function but DIO_UNALIGNED
> > isn't set?  Wouldn't we be in some other function if we're doing an
> > aligned direct write?"
> > 
> > Then I looked upthread to where Christph said he'd renamed it
> > IOMAP_DIO_SUBBLOCK, but I didn't think that was sufficiently better:
> > 
> > 	if (!(flags & IOMAP_DIO_SUBBLOCK))
> > 		iomap_dio_wait(...);
> > 
> > This flag doesn't have a 1:1 relationship with the iocb asking for an
> > (fsblock-)unaligned write or the iocb saying that the write involves
> > sub-block io -- this flag really means "I require a stable written
> > mapping, no post-processing (of the disk block) allowed".
> 
> Would:
> 
> 	if (flags & IOMAP_DIO_FORCE_WAIT)
> 		inode_dio_wait(VFS_I(ip));
> 
> look any better to you?  Behavior would be the same.

Looks fine to me.

--D
