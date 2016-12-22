Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36930 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755644AbcLVJ2Y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Dec 2016 04:28:24 -0500
Date: Thu, 22 Dec 2016 10:28:20 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: XFS_IOC_FSEMAP requirements
Message-ID: <20161222092820.7odq2uzrflsxegy3@eorzea.usersys.redhat.com>
References: <20161220102935.ppt7ixjoh53uhu2e@eorzea.usersys.redhat.com>
 <20161221014816.GC5487@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161221014816.GC5487@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Dec 20, 2016 at 05:48:16PM -0800, Darrick J. Wong wrote:
> On Tue, Dec 20, 2016 at 11:29:35AM +0100, Carlos Maiolino wrote:
> > Hi folks,
> > 
> > I've been working on the implementation of FSEMAP ioctl as we've been
> > discussed previously, and, the first discussion about this, was about
> > using the same fiemap structures to retrieve free extents from the
> > btrees.
> > 
> > By our last chat about it (it's been a while, I know, I got busy with
> > more important stuff :), Dave suggested another uses for FSEMAP that
> > were not in my mind, so, I think it deserves its own implementation,
> > independent of fiemap from where the same idea came from.
> > 
> > So, I'd like to know, what else might FSEMAP be used for, beyond
> > iterating free space extents, so I can think of a new struct to be
> > exchanged between user<-> kernel. FSEMAP is supposed to complement
> > GETFSMAPX, discussed in LSF this year, but I don't know if is there
> > any plan to keep with GETFSMAPX or not, or even if FSEMAP is still a
> > valuable idea :)
> > 
> > Any comments, suggestions about to what direction should FSEMAP go?
> 
> GETFSMAP reports free space extents along with the other space mappings.
> If there is no rmapbt, the ioctl reports free space extents from the
> bnobt and reports the non-free space as being owned by "unknown".
> I was planning to send out the whole GETFSMAP + online scrub series for
> review (for 4.11) after the 4.10 merge window closes.  Internally, the
> online scrub kernel code cross-references space metadata against the
> rmapbt if it's available.
> 
> For xfsprogs 4.11, the userspace online scrub tool uses the fsmap data
> to figure out where to do media read testing after having the kernel
> perform online checking of the metadata.  I also forward-ported spaceman
> to current xfsprogs and getfsmap, so I'll be sending that out for review
> for the 4.11 release too.
> 

ah, ok, I'll switch back to my work still undone with our behavior working
together with dm-thin then =]

> As for project ideas, I can think of a handful of them -- reworking the
> in-core extent tree not to require large contiguous memory allocations,
> sorting out reflink+dax, and stomping out the rest of the buffer head
> usage, and all the rest of the ongoing cleanups and fix branches.
> There's probably more, but let's see if Dave will chime in. :)
> 
> (I intend to track all this via google spreadsheet or something to keep
> my head on straight.)
> 
> --D
> 
> > 
> > Cheers
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
