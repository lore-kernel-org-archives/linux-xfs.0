Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:54690 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751642AbdHPNfG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Aug 2017 09:35:06 -0400
Date: Wed, 16 Aug 2017 23:35:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: preserve i_mode if __xfs_set_acl() fails
Message-ID: <20170816133502.GN21024@dastard>
References: <20170814081806.GA3924@debian.home>
 <20170815020018.GF21024@dastard>
 <20170815061857.GA2803@debian.home>
 <20170815084430.GK21024@dastard>
 <20170815192938.GA1247@debian.home>
 <20170816002511.GM21024@dastard>
 <20170816071649.GA4143@debian.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170816071649.GA4143@debian.home>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ernesto =?iso-8859-1?Q?A=2E_Fern=E1ndez?= <ernesto.mnd.fernandez@gmail.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Zorro Lang <zlang@redhat.com>

On Wed, Aug 16, 2017 at 04:16:53AM -0300, Ernesto A. Fernández wrote:
> On Wed, Aug 16, 2017 at 10:25:11AM +1000, Dave Chinner wrote:
> > On Tue, Aug 15, 2017 at 04:29:39PM -0300, Ernesto A. Fernández wrote:
> > > On Tue, Aug 15, 2017 at 06:44:30PM +1000, Dave Chinner wrote:
> > > > On Tue, Aug 15, 2017 at 03:18:58AM -0300, Ernesto A. Fernández wrote:
> > > > But I have to ask - why do we even need to modify the mode first?
> > > > Why not change the ACL first, then modify the mode+timestamp? If
> > > > setting the ACL fails, then we don't have anything to undo and all
> > > > is good....
> > > 
> > > I intended for the mode to be committed as part of the same transaction
> > > that sets or removes the ACL. In my mind making the changes later, as part
> > > of a separate transaction, would have meant that a crash between the two
> > > left the filesystem in an inconsistent state,
> > 
> > No, it will not leave the fileystem in an inconsistent state. It
> > will leave the inode permissions in an /unwanted/ state, but there
> > is no filesystem metadata inconsistency. 
> > 
> > > with a new ACL but without
> > > the corresponding mode bits.
> > 
> > Yup, but that's no different from right now, where a crash after
> > setting the mode bits could be applied but the ACL update is
> > missing.
> > 
> > Either way is even rarely than "crash at the wrong time" implies,
> > because we've also got to have a complete journal checkpoint occur
> > between the two operations and then crash between the checkpoint and
> > the second operation. Yes, it's possible, but in the entire time
> > I've been working on XFS (almost 15 years now) I can count on one
> > hand the number of times such a problem has occurred and been
> > reported...
> > 
> > So, it's a rare problem, and one that will get solved in time
> > because there's much more to solving the problem than just this
> > case. e.g. I worte this in 2008:
> > 
> > http://xfs.org/index.php/Improving_Metadata_Performance_By_Reducing_Journal_Overhead#Atomic_Multi-Transaction_Operations
> > 
> > And we've really only got the infrastructure we could use to
> > implement this in a widespread manner with the rmap/reflink
> > functionality. But implementing it will require a large amount of
> > re-organisation of filesystem operations, so it's something that
> > will take time to roll out.
> 
> Alright, thanks for the explanation.
>  
> > With that in mind, here's waht I suggested above: set the mode after
> > the xattr. I haven't tested it - can you check it solves the problem
> > case you are testing?
> 
> It does. Of course the test still fails, as I said before, now claiming that
> the filesystem is inconsistent. But that's a separate issue.

It shouldn't be - what's the error that is being reported?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
