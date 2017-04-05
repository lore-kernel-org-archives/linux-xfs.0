Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:35383 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755050AbdDEMPX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2017 08:15:23 -0400
Date: Wed, 5 Apr 2017 22:15:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [xfsprogs] Do we need so many data types for user input?
Message-ID: <20170405121519.GR17542@dastard>
References: <CACj3i738tUsYyRvQmr3NfPQ=P2FNruh2xsr1TAuLMJ69AV0a0w@mail.gmail.com>
 <20170404194825.GX28800@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170404194825.GX28800@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On Tue, Apr 04, 2017 at 09:48:25PM +0200, Luis R. Rodriguez wrote:
> On Tue, Apr 04, 2017 at 10:54:09AM +0200, Jan Tulak wrote:
> > Simply stated, signed values seem to be useless here. And at the end
> > of the day, we are converting all numbers into unsigned in one part of
> > the parsing anyway, so I don't see how such a change could change any
> > behaviour.
> > 
> > So what do you think, can I remove the other types in user-input part
> > of the code and save all numbers as uint64?
> 
> This seems reasonable to me, I could not find any valid use for negative values,
> yet we have int all over. No bueno.

Keep in mind you're looking at coding pattersn that were laid down
more than 20 years ago by people with different coding standards and
habits. e.g. lots of the values were originally ints because they
were set by calls to atoi() in command line parsing. the atoi()
calls are long gone, but the variables are still ints...

....

> FWIW since I had made the mkfs.xfs.conf RFCs I determined what the local variables
> of impact would be, they are (I added struct mkfs_xfs_opts to stuff them all on one
> data structure):
> 
> struct mkfs_xfs_opts {                                                          
>         int                     blocklog;                                       
>         int                     blflag;                                         
>         int                     bsflag;                                         

[....]

My intent when starting the table based config mods was that all
these intermediate values and flags would go away. i.e. they'd be
replace with a config table lookup for the option value because they
are redundant values and using the config table would remove the
confusion on what values should be used in the code.

And once everything is in the config option table, main() can be
more easily factored in sane, maintainable chunks....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
