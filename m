Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4O5Ijou051792 for <xfs@oss.sgi.com>; Tue, 24 May 2011 00:18:45 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 94B9E477BC5
	for <xfs@oss.sgi.com>; Mon, 23 May 2011 22:18:43 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	HBCxDRuYuUKfBDI3 for <xfs@oss.sgi.com>;
	Mon, 23 May 2011 22:18:43 -0700 (PDT)
Date: Tue, 24 May 2011 15:18:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] xfstests:Make 225 compare map and fiemap at each block.
Message-ID: <20110524051827.GF32466@dastard>
References: <1306134423-10028-1-git-send-email-xiaoqiangnk@gmail.com>
	<20110524015105.GE32466@dastard>
	<BANLkTikWgG2E1EYcm+B2zxBCY=KH-Rb0Dw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTikWgG2E1EYcm+B2zxBCY=KH-Rb0Dw@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Cc: sandeen@redhat.com, linux-ext4@vger.kernel.org, josef@redhat.com, xfs@oss.sgi.com

On Tue, May 24, 2011 at 10:42:23AM +0800, Yongqiang Yang wrote:
> Thank you for your review.
> On Tue, May 24, 2011 at 9:51 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Mon, May 23, 2011 at 03:07:03PM +0800, Yongqiang Yang wrote:
> >> Due to my carelessness, =A0I induced a ugly patch to ext4's fiemap, as=
 a result
> >> delayed-extents that did not start at the head block of a page was ign=
ored
> >> in ext4 with 1K block, but 225 could not find it.
> >
> > When ext4 is using 1k block sizes, fiemap-tester does not find
> > problems that may exist on ext4 with delayed allocation extents on
> > the first block of a page.
> >
> >> So I looked into the 225
> >> and could not figure out logic in compare_map_and_fiemap(), which seem=
ed to
> >> mix extents with blocks.
> >
> > Once again, "I don't understand it" is not a reason for a whoelsale
> > rewrite.
> >
> >> Then I made 225 compare map and fiemap at each block,
> >> the new 225 can find the bug I induced and another bug in ext4 with 1k=
 block,
> >> which ignored delayed-extents after a hole, which did not start at the=
 head
> >> block of a page.
> >
> > Which means that the first paragraph should read:
> >
> > "When ext4 is using 1k block sizes, fiemap-tester does not find
> > problems that may exist on ext4 with delayed allocation extents on
> > the first block of a page or directly after a hole."
> >
> > That's a concise description of the overall problem you are fixing
> > in this patch. Next you need to describe the different changes being
> > made in the patch and the bugs they are fixing. =A0There appear to be:
> >
> > =A0 =A0 =A0 =A0- an off-by one in map array allocation
> > =A0 =A0 =A0 =A0- zeroing the end block in the map array
> > =A0 =A0 =A0 =A0- making check_weird_fs_hole() verify bytes read by prea=
d()
> > =A0 =A0 =A0 =A0- moving truncate/seek of the test file around
> > =A0 =A0 =A0 =A0- changing the way map/fiemap are compared
> Yes, thank you.

I'm not asking you to ACK the list of changes in the bug - I'm
asking you to describe the symptoms of the problems those fixes
apparently address - how you've found them , what the test failures
looked like, etc, so there's some meaningful record of why those
changes were made.

> > Also, you haven't addressed any of the comments I made in my
> > original review:
> >
> > =A0 =A0 =A0 =A0- removing the changelog from the header comment
> The change is large, so I think  it's convenient for others to leave
> an e-mail in the file in case that they have some questions.

That's what git log/git blame is for. Details of who made what
change has no place in the code itself - recording that information
ina queriable format is precisely the reason we use a VCS.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
