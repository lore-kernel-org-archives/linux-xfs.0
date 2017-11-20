Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:34278 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751155AbdKTPDg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Nov 2017 10:03:36 -0500
Received: by mail-wm0-f49.google.com with SMTP id y82so6710816wmg.1
        for <linux-xfs@vger.kernel.org>; Mon, 20 Nov 2017 07:03:35 -0800 (PST)
Date: Mon, 20 Nov 2017 16:03:32 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [RFC PATCH] xfs: Properly retry failed dquot items in case of
 error during buffer writeback
Message-ID: <20171120150332.kimqrvgo66rqy32a@odin.localdomain>
References: <20170825120752.22553-1-cmaiolino@redhat.com>
 <20170825170400.GS4796@magnolia>
 <20170825215701.GT4796@magnolia>
 <20170828092030.l5z2hruccr7ctvl3@hades.localdomain>
 <20171013162114.GP7122@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171013162114.GP7122@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

> > Yup, you are right.
> > 
> > > (Does this compile at all?)
> > > 
> > 
> > Yes, it compiled the way it was :P
> > 
> > I'll wait for some extra comments here, before submitting a non-RFC patch, and
> > will think about how can I reproduce it on xfstests, maybe filling the
> > filesystem and then playing with quotas.
> 
> Has there been a rework of this patch?

I missed this e-mail somehow, I'll rework and submit the non-RFC patch

> 
> --D
> 
> > 
> > Thanks for the review Darrick.
> > 
> > Cheers.
> > 
> > -- 
> > Carlos
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
