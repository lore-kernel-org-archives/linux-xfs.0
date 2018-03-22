Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39964 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751632AbeCVTuR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Mar 2018 15:50:17 -0400
Date: Thu, 22 Mar 2018 12:50:12 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: RFC: removing non-linux platform support from xfsprogs
Message-ID: <20180322195012.GC4818@magnolia>
References: <7d962368-5376-0fca-dbc6-3d3f6fdf50e8@sandeen.net>
 <CACj3i71pW6JxNFzfPMwJW1qz9U54pO2i94_ihhcsb_FwOn_3PQ@mail.gmail.com>
 <bd213985-c2b6-6b9f-3d43-88eb2cd73b48@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd213985-c2b6-6b9f-3d43-88eb2cd73b48@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Tulak <jtulak@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Sat, May 27, 2017 at 11:17:30AM -0500, Eric Sandeen wrote:
> 
> 
> On 5/27/17 2:41 AM, Jan Tulak wrote:
> > On Fri, May 26, 2017 at 11:47 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> >> There's a bunch of mucking about to try to build xfsprogs on non-linux
> >> platforms.  Is anyone using that, or care about it?  If not, I propose
> >> removing it all in a cruft-reducing effort.
> >>
> >> If I'm missing some good reason for it to be there, please educate me,
> >> and I'll leave it alone.
> >>
> >> In particular, Jan - I know you did a lot of this work - do you still
> >> use it?
> >>
> > 
> > I used the macos stuff at the beginning to get into the code with
> > little risk of breaking anything. Until it is possible to mount xfs in
> > the other systems, xfsprogs is useless there... So, I'm ok with the
> > removal of macos code. I don't know how it is with the other systems,
> > though.
> 
> Ok, thanks - honestly if you still use it, that's fine.  But if you're
> not ... and nobody else is ... let's nuke it.  ;)

Ten months and nobody else has said anything, let's nuke non-linux
support.

--D

> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
