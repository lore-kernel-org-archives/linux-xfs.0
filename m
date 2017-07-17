Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32582 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751388AbdGQWxu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jul 2017 18:53:50 -0400
Date: Mon, 17 Jul 2017 15:53:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Parent pointers
Message-ID: <20170717225341.GG4224@magnolia>
References: <59680165.9020201@oracle.com>
 <20170714085016.4j2yeyihezmb6nkp@eorzea.usersys.redhat.com>
 <817aafad-6b64-3700-6752-c63d7e5cdde7@sandeen.net>
 <59690307.9090407@oracle.com>
 <5d8fa5a7-110a-520f-9b13-b10627950bd3@sandeen.net>
 <20170714190740.GA43494@bfoster.bfoster>
 <20170714224658.GB4224@magnolia>
 <AT5PR84MB0163E6FA1BF71A12136E94EAE2A20@AT5PR84MB0163.NAMPRD84.PROD.OUTLOOK.COM>
 <20170717144946.GB56739@bfoster.bfoster>
 <cd120f6c-2b7b-8452-fbd6-6565db574e21@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd120f6c-2b7b-8452-fbd6-6565db574e21@hpe.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mark Tinguely <mark.tinguely@hpe.com>
Cc: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, Allison Henderson <allison.henderson@oracle.com>, "cmaiolino@redhat.com" <cmaiolino@redhat.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Mon, Jul 17, 2017 at 10:33:12AM -0500, Mark Tinguely wrote:
> On 07/17/2017 09:49 AM, Brian Foster wrote:
> >On Sat, Jul 15, 2017 at 04:36:27PM +0000, Tinguely, Mark wrote:
> >>-----Original Message-----
> >>From: linux-xfs-owner@vger.kernel.org [mailto:linux-xfs-owner@vger.kernel.org] On Behalf Of Darrick J. Wong
> >>Sent: Friday, July 14, 2017 5:47 PM
> >>To: Brian Foster <bfoster@redhat.com>
> >>Cc: Eric Sandeen <sandeen@sandeen.net>; Allison Henderson <allison.henderson@oracle.com>; cmaiolino@redhat.com; linux-xfs@vger.kernel.org
> >>Subject: Re: Parent pointers
> >>
> >>On Fri, Jul 14, 2017 at 03:07:41PM -0400, Brian Foster wrote:
> >>>On Fri, Jul 14, 2017 at 01:46:27PM -0500, Eric Sandeen wrote:
> >>>>On 07/14/2017 12:44 PM, Allison Henderson wrote:
> >>>>>On 7/14/2017 7:04 AM, Eric Sandeen wrote:
> >><parent inode pointers returneth messages deleted>
> >>
> >>>It's something to keep in mind, in any event. IIRC there were also
> >>>missing Signed-off-by's required for some of Mark's original patches.
> >>That's also a problem; unless someone can get Mark to supply them, we probably have to get someone to rewrite them.  At a bare minimum I think we explicitly have to pass back a xfs_dir2_dataptr_t, not a bare uint32_t.
> >>
> >>Me says:
> >>The community can do what they want.  If you want to start with that code, permission for S-O-B: me (snickers at the pun)
> >>
> >Thanks Mark. I guess we can add Mark's Signed-off-by to those patches he
> >originally authored and that solves that problem. :)
> >
> >>>IMO, the best next step might be to just finish off the implementation
> >>>as-is such that we could have a fairly functional RFC to put on the
> >>>list and hash out whether there are in fact any remaining design
> >>>hurdles, but others might have a different opinion on that. :)
> >>No one is asking me but I will add, IMO (definitely disclaiming the storage group and HPE):
> >>  the PIP costs outweigh the benefits.
> >>    Adding the redundant filename for recovery and an occasional output of the path pushes the cost to be *totally unreasonable*.
> >>     If I had a say, I don't and won't, I would NAK any implementation that included it.
> >>  Implementing with extended attributes is the wrong, wrong, wrong choice. It was done for hysterical :) reasons and even that appeasement bit me in the asterisk.
> >>
> >Could you elaborate on this a bit? I haven't gone through all of the old
> >discussions and it's been a while since I've even reviewed the recent
> >code, but on a quick look at the links Darrick posted, it appears the
> >old implementation incorporated the "first" parent pointer direct in the
> >inode with a fallback to xattrs for inodes with multiple parents whereas
> >the updated implementation uses xattrs outright (and as a result is able
> >to incorporate the dentry name in the xattr). Is that an accurate
> >summary?
> >
> >If so, is the performance concern really the use of xattrs or the fact
> >that the name is included (or some combination of both)? For example,
> >would you consider a situation where pp's are entirely isolated to
> >shortform xattrs much worse than the direct pp approach? It seems to me
> >that the inline approach could still be considered as an optimization
> >(i.e., maybe an incore cache) if performance does prove to be a problem.
> >Maybe we could also consider something where (somehow, handwaving again
> >;) some number of pp xattrs are always shortform and thus remain within
> >the inode.

I'd rather not do that, since a certain filesystem is, uh, extending its
ability to store extended attributes (with biases to keep inline data
and ACLs and such inside the inode).  Now they have two different places
where keys can hide and three places where values can get stuffed, and
it's ... a complicated mess.

Better just to leave the existing da btree structure that we understand,
unless we find that the cost is so outrageous that it becomes worth
breaking all our brains.  As it is, fixing the existing atomicity
problems w.r.t. xattrs will be invasive enough.

> I disagree with both saving the name and using xattrs.

FWIW I disagree with /not/ storing the name, because my vision for
parent pointers is to store backrefs that are rich enough that we can
(ideally) reconstruct the damaged parts of the directory tree or (worst
case) feed lost+found better names.

(Though, we have enough cooks now that I encourage everyone with
differing goals to speak up.)

> >IOW, I think performance is a valid concern, but this should probably
> >1.) follow correctness and 2.) be more dictated by testing (another
> >really good reason to try and finish off the current rfc IMO) where we
> >can consider various, potentially problematic situations. We're bound to
> >have workloads where pretty much every file is hardlinked more than once
> >(think glusterfs), for example.

Agree.

> >Brian
> >
> OMG! Sigh ...
> >>Good luck.
> x2

Thanks!

--D

> >>
> >>--Mark Tinguely
> >>   not representing anyone but myself.
> >>
> >>
> >>--
> >>To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> >>the body of a message to majordomo@vger.kernel.org
> >>More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
