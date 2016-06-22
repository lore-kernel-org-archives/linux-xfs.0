Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 50EF37CA3
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2016 20:43:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AC85BAC002
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2016 18:42:59 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	b8pKdXImHb0UmRol for <xfs@oss.sgi.com>;
	Tue, 21 Jun 2016 18:42:56 -0700 (PDT)
Date: Wed, 22 Jun 2016 11:42:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: crash in xfs in current
Message-ID: <20160622014253.GS12670@dastard>
References: <48817b4c-26f4-5eb6-8a97-d8fa34fe7f6a@monom.org>
	<20160607134442.GA1803@infradead.org>
	<CAAA5faFWyPDienm2NbHkafZh-RvbjJp6f_zDq62z6rC1d1Vzyw@mail.gmail.com>
	<CAAA5faGXHJZPWkkxDM-kvHqh--hPhnD1Y8RuaaSmuzgiz=_LDg@mail.gmail.com>
	<CAAA5faEDdR_L6y9ShhUcermgvjtmzNCzwoYeENjx+8RUEMdwaA@mail.gmail.com>
	<20160609022238.GY26977@dastard>
	<CAAA5faGL_Nyu=jW2Vrgr_m7crhnB9BriWWzMAPODbiQATFhS=Q@mail.gmail.com>
	<00bbe658-a891-3771-ca1d-5661a8b6ab61@sandeen.net>
	<CAAA5faH7RA=_WByj6uh4yVCLgwxkLh88CkrtTOa-qJqdyEDT-A@mail.gmail.com>
	<CAAA5faGTL4i3YS_oLxoeetpsEt+q59dmc2L7Kc-b5khzoV0GvA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAA5faGTL4i3YS_oLxoeetpsEt+q59dmc2L7Kc-b5khzoV0GvA@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Reinoud Koornstra <reinoudkoornstra@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Daniel Wagner <wagi@monom.org>, Eric Sandeen <sandeen@sandeen.net>, viro@zeniv.linux.org.uk, xfs@oss.sgi.com

On Tue, Jun 14, 2016 at 11:40:23PM -0600, Reinoud Koornstra wrote:
> On Wed, Jun 8, 2016 at 9:42 PM, Reinoud Koornstra
> <reinoudkoornstra@gmail.com> wrote:
> > On Wed, Jun 8, 2016 at 8:56 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> >> On 6/8/16 9:53 PM, Reinoud Koornstra wrote:
> >>
> >>>> In your Linus git tree:
> >>>>
> >>>> $ git remote add xfsdev git://git.kernel.org/git/dgc/linux-xfs.git
> >>>> $ git remote update
> >>>> $ git checkout -b xfsdev-merge v4.6
> >>>> $ git merge xfsdev/xfs-for-linus-4.7-rc1
> >>>
> >>> Tried to do this:
> >>>
> >>> reinoud@router-dev:~/Downloads/kernel_current$  git remote add xfsdev
> >>> git://git.kernel.org/git/dgc/linux-xfs.git
> >>
> >> I think that should be:
> >>
> >> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git
> >
> > Ok That worked better indeed. :)
> 
> I've tested the way you and Dave described.
> Indeed, I do not see the issues appearing in that xfsdev tree.
> So it works good there.
> For verification, I tried when I was upon this state (so this is a good state):

Ok, that's good to hear. Now for some more testing: Al Viro just
pushed some fixes to the parallel lookup code that may fix this
problem. Al asked this question:

| Can that be triggered on 4e82901 + cherry-pick of e7d6ef979?
| Same for 9f541801 + e7d6ef979?

Those commits are all in the current Linus tree - would you be
able to test them? (i.e. check out tree to 4e82901, then just
cherry pick the single commit (e7d6ef979) on top of that).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
