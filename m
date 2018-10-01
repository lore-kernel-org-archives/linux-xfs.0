Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36736 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729439AbeJAWDx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Oct 2018 18:03:53 -0400
Date: Mon, 1 Oct 2018 11:25:29 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: Leaking Path in XFS's ioctl interface(missing LSM check)
Message-ID: <20181001152529.GA2549@thunk.org>
References: <5EF0D46A-C098-4B51-AD13-225FFCA35D4C@vt.edu>
 <20180926013329.GD31060@dastard>
 <20180926192426.472360ea@alans-desktop>
 <20180927013812.GF31060@dastard>
 <20180930151652.6975610c@alans-desktop>
 <20181001002521.GM31060@dastard>
 <20181001160442.47c798bc@alans-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181001160442.47c798bc@alans-desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, TongZhang <ztong@vt.edu>, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, Wenbo Shen <shenwenbosmile@gmail.com>

On Mon, Oct 01, 2018 at 04:04:42PM +0100, Alan Cox wrote:
> > Systems restricted by LSMs to the point where CAP_SYS_ADMIN is not
> > trusted have exactly the same issues. i.e. there's nobody trusted by
> > the kernel to administer the storage stack, and nobody has defined a
> > workable security model that can prevent untrusted users from
> > violating the existing storage trust model....
> 
> With a proper set of LSM checks you can lock the filesystem management
> and enforcement to a particular set of objects. You can build that model
> where for example only an administrative login from a trusted console may
> launch processes to do that management.
> 
> Or you could - if things were not going around the LSM hooks.

It would be useful if anyone actually *wants* to do this thing to
define a formal security model, and detail *everything* that would
need to be changed in order to accomplish it.  Just as we don't
speculatively add code "just in case" someone might want to use it
someday, I don't think we should be adding random LSM hooks just
becausre someone *might* want do something.

Let's see the use case, and let's see how horrible the changes would
need to be, and how credible we think it is that someone will actually
want to *use* it.  I suspect the chagnes will be a really huge number
of places, and not just in XFS....

					- Ted
