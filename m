Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:5828 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S947110AbcJaVZq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Oct 2016 17:25:46 -0400
Date: Tue, 1 Nov 2016 08:25:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Fwd: mounting a xfs file system gives the message: "failure code
 -3003" and "structure needs cleaning"
Message-ID: <20161031212542.GO22126@dastard>
References: <CAPvv1vytjK-n7Z3=Zi+vScuV-ej3CagQ5rFc9ppVC8JEihZPkQ@mail.gmail.com>
 <8bd7b65f-d85d-2958-dd7d-ba97c91ac9ea@telefonica.net>
 <CAPvv1vx-Juge8e=36bq4AFvGxs8Kf7-V_v0j+a9LGWYdDo5h+w@mail.gmail.com>
 <20161031194212.GU14023@dastard>
 <CAPvv1vzDQO9iMNhXByGfXrbLEtMt=F1xFd1Ybr63AAuPfvA6iw@mail.gmail.com>
 <20161031203715.GV14023@dastard>
 <CAPvv1vyGXNHP3pFAB6DAGPWfrwqpV22bS35JUXwwCwRJ-xE8Fg@mail.gmail.com>
 <20161031205810.GW14023@dastard>
 <CAPvv1vxt2MDwf8rXW9HCPprWyg-=h8YFxqhSya9WrKAhMo9kqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPvv1vxt2MDwf8rXW9HCPprWyg-=h8YFxqhSya9WrKAhMo9kqg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Steffen D." <sdumke@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 31, 2016 at 10:09:09PM +0100, Steffen D. wrote:
> 2016-10-31 21:58 GMT+01:00 Dave Chinner <david@fromorbit.com>:
> > On Mon, Oct 31, 2016 at 09:53:49PM +0100, Steffen D. wrote:
> >> Hi Dave
> >>
> >> 2016-10-31 21:37 GMT+01:00 Dave Chinner <david@fromorbit.com>:
> >>
> >> > What kernel version? 32 bit or 64 bit?
> >>
> >> booth kernels where 64 bit
> >
> > What kernel versions? Both old and new versions are important.
> 
> old kernel: 3.16
> new kernel: 4.1
> 
> sorry, I have not more detailed informations

Do youhave the minor numbers for the kernel versions? major numbers
are insufficient to tell me what I need to know, because the commit
I quoted got backported to various stable kernels....

(uname -a output is usually best when someone asks for kernel
versions).

> > Also
> > how long ago you did you upgrade?
> 
> The upgrade was just 2 days ago

Ok, so the first iteration across the AGFLs could trigger this,
depending on what version of 4.1 is being run...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
