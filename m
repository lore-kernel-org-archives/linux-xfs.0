Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38760 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935851AbdEWMLx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 May 2017 08:11:53 -0400
Date: Tue, 23 May 2017 14:11:48 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Shutdown filesystem when a thin pool become full
Message-ID: <20170523121148.jbcl2pb5himtaun5@eorzea.usersys.redhat.com>
References: <c25a8ccc-f143-989d-3d49-3fe8753aa6f7@assyoma.it>
 <20170522230946.s3sdg4gd73oj7r5u@eorzea.usersys.redhat.com>
 <940c3b13-dea2-1887-d4ae-89555d1c2a4f@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <940c3b13-dea2-1887-d4ae-89555d1c2a4f@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-xfs@vger.kernel.org

Hi,

> > Although, I should say this is a bad idea. A full thin pool will return an
> > ENOSPC error to the filesystem, and, the filesystem should act accordingly.
> > 
> > Would you want the filesystem to shut down because it hit an ENOSPC, or report
> > to the user and let him/her to take the appropriate action, like freeing space
> > or increasing the dm-thin pool size?
> 
> Does a full thin pool *really* report a ENOSPC? On all my tests, I simply
> see "buffer i/o error on dev" on dmesg output (see below). How can I see if
> a ENOSPC was returned?

Yes, it does, unless you are using an old version of dm-thin module:

commit c3667cc6190469d2c7196c2d4dc75fcb33a0814f
Author: Mike Snitzer <snitzer@redhat.com>
Date:   Thu Mar 10 11:31:35 2016 -0500

    dm thin: consistently return -ENOSPC if pool has run out of data space


It used to return EIO, then we decided it should return ENOSPC instead of EIO.

See my comments in your next e-mail

> > The behavior really depends on several configurations, including how dm-thin
> > will deal with ENOSPC situations, dm-thin can be configured to queue new
> > incoming IOs, fail the IO, etc, but, even in a full disk situation, you can
> > still rewrite data, so this behavior doesn't change much from what would happen
> > if you fill up a regular block device, XFS will try to allocate a new block, the
> > block device returns an ENOSPC and XFS acts accordingly.
> 
> I am testing with "errorwhenfull=y" when thin pool fills.
> 

Ok, so it should return -ENOSPC


> > What exactly do you mean by failed data update? As long as you don't need to
> > allocate any new block either for data of metadata, you should be able to rewrite
> > data normally if the device is full.
> 
> I refer to update for which the metadata write completes successfully (ie:
> they are writen to already-allocated space), but the data writeout does
> *not* (ie: new data require a new allocation, which it fails).
> 

Yup, will make XFS complain about metadata errors, once it can't writeback data
queued in AIL.

> Can you link to the bug?
> 

https://www.spinics.net/lists/linux-xfs/msg06986.html


> Thanks a lot.
> 
> -- 
> Danti Gionatan
> Supporto Tecnico
> Assyoma S.r.l. - www.assyoma.it
> email: g.danti@assyoma.it - info@assyoma.it
> GPG public key ID: FF5F32A8
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
