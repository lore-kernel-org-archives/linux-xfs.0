Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from namei.org ([65.99.196.166]:34604 "EHLO namei.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbeJBCrt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Oct 2018 22:47:49 -0400
Date: Tue, 2 Oct 2018 06:08:16 +1000 (AEST)
From: James Morris <jmorris@namei.org>
Subject: Re: Leaking Path in XFS's ioctl interface(missing LSM check)
In-Reply-To: <20181001154459.GB5872@magnolia>
Message-ID: <alpine.LRH.2.21.1810020608090.14406@namei.org>
References: <5EF0D46A-C098-4B51-AD13-225FFCA35D4C@vt.edu> <20180926013329.GD31060@dastard> <20180926192426.472360ea@alans-desktop> <20180927013812.GF31060@dastard> <20180930151652.6975610c@alans-desktop> <20181001002521.GM31060@dastard>
 <20181001160442.47c798bc@alans-desktop> <20181001154459.GB5872@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Dave Chinner <david@fromorbit.com>, TongZhang <ztong@vt.edu>, linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, Wenbo Shen <shenwenbosmile@gmail.com>

On Mon, 1 Oct 2018, Darrick J. Wong wrote:

> If we /did/ replace CAP_SYS_ADMIN checking with a pile of LSM hooks,

Not sure we'd need a pile of hooks, what about just "read" and "write" 
storage admin?

Or even two new capabilities along these lines, which we convert existing 
CAP_SYS_ADMIN etc. to?

> how do we make sure that we (XFS) avoid breaking existing XFS tools?  I 
> guess the default compatibility handler for all of those new hooks would 
> be "return capable(CAP_SYS_ADMIN) ? 0 : -EPERM;" and then other LSMs 
> could restrict that further if so configured.
> 
> Seriously, I don't know that much about how LSMs actually perform
> security checks -- it looks like a number of them can be active
> simultaneously, and we just call each of them in a chain until one of
> them denies permission or we run out of LSMs and allow it?
> 

Correct.

> FWIW I didn't have a particular security or threat model in mind when I
> made the above list; all I did was break up the existing CAP_SYS_ADMIN
> into rough functional areas.  Maybe it makes sense, but maybe I'm
> rambling. :)
> 
> --D
> 
> > You can build that model where for example only an administrative
> > login from a trusted console may launch processes to do that
> > management.
> > 
> > Or you could - if things were not going around the LSM hooks.
> > 
> > Alan
> 

-- 
James Morris
<jmorris@namei.org>
