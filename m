Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1E3877F54
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 18:14:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 054DF304053
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 16:14:24 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	BQpaYjyAqSucjA1z for <xfs@oss.sgi.com>;
	Wed, 16 Apr 2014 16:14:19 -0700 (PDT)
Date: Thu, 17 Apr 2014 09:13:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: btrfs, test send's ability to punch holes and
	prealloc extents
Message-ID: <20140416231333.GQ15995@dastard>
References: <1397580201-27475-1-git-send-email-fdmanana@gmail.com>
	<20140416002349.GV15995@dastard>
	<CAL3q7H75Da9uvLnE7HVam9ue-yayw=SgePbLszVWvnPbMwkd4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAL3q7H75Da9uvLnE7HVam9ue-yayw=SgePbLszVWvnPbMwkd4Q@mail.gmail.com>
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
To: Filipe David Manana <fdmanana@gmail.com>
Cc: Josef Bacik <jbacik@fb.com>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Apr 16, 2014 at 03:39:18PM +0100, Filipe David Manana wrote:
> On Wed, Apr 16, 2014 at 1:23 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Tue, Apr 15, 2014 at 05:43:21PM +0100, Filipe David Borba Manana wrote:
> >> This test verifies that after an incremental btrfs send the replicated file has
> >> the same exact hole and data structure as in the origin filesystem. This didn't
> >> use to be the case before the send stream version 2 - holes were sent as write
> >> operations of 0 valued bytes instead of punching holes with the fallocate system
> >> call, and pre-allocated extents were sent as well as write operations of 0 valued
> >> bytes instead of intructions for the receiver to use the fallocate system call.
> >> Also checks that prealloc extents that lie beyond the file's size are replicated
> >> by an incremental send.
> >
> > Can you wrap commit messages at 68 columns?
> >
> > ....
> >> +md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
> >> +# List all hole and data segments.
> >> +$XFS_IO_PROG -r -c "seek -r -a 0" $SCRATCH_MNT/mysnap2/foo
> >> +# List all extents, we're interested here in prealloc extents that lie beyond
> >> +# the file's size.
> >> +$XFS_IO_PROG -r -c "fiemap -l" $SCRATCH_MNT/mysnap2/foo | _filter_scratch
> >
> > That dumps raw block numbers into the golden output. _filter_fiemap
> > is probably needed here.
> 
> Hum, just tried it and uploaded a v2.
> However I'm now noticing it doesn't do everything I had in mind.
> _filter_fiemap is not showing the extents falloc -k created, only a
> collapsed range of holes.
> 
> So my intention is to verify not just holes, but also the extents
> created by 'falloc -k'. The following filter I just made locally gives
> me that:
> 
> _filter_all_fiemap()
> {
> awk --posix '
> $3 ~ /hole/ {
> print $1, $2, $3;
> next;
> }
> $3 ~ /[[:xdigit:]]*..[[:xdigit:]]/ {
> print $1, $2, "extent";
> next;
> }'
> }

Which is effectively _filter_hole_fiemap(), except it coalesces
adjacent extents into a single range.

I'd suggest moving the _filter_* functions from common/punch to
common/filter, and using _filter_hole_fiemap() as there's no
guarantee that you'll get individual extents for each falloc -k
range - they coul dbe allocated contiguously, and hence the number
of extents reported can change from run to run. That's the reason
why the filters coalesce adjacent file offsets of the same type - we
care whether the range of the file contains the correct extent type,
not how fragmented the range is....

> (nicely printed/indented at
> https://friendpaste.com/1JtG5bts2Sz0LWhUutCpzE, as e-mail is not good
> for code pasting)

Pasting code works fine for me ;)

> Which gives me:
> 
> 0: [0..191]: extent
> 1: [192..199]: extent
> 2: [200..231]: extent
> 3: [232..239]: extent
> 4: [240..287]: extent
> 5: [288..295]: extent
> 6: [296..487]: extent
> 7: [488..495]: extent
> 8: [496..519]: hole
> 9: [520..527]: extent
> 10: [528..583]: extent
> 11: [584..591]: extent
> 12: [592..2543]: extent
> 13: [2544..17575]: hole
> 14: [17576..21487]: extent

Also, you're trimming of the block count, so you can drop the "-l"
option to the fiemap command....

> Versus only (from _filter_fiemap):
> 
> 0: [496..17575]: hole

Maybe the "-l" option is confusing the filter, it should be giving:

0: [0..495]: data
1: [496..519]: hole
2: [520..2543]: data
3: [2544..17575]: hole
4: [17576..21487]: data

Though if there are unwritten extents, it will say "unwritten"
rather than "data". _filter_hole_fiemap should give:

0: [0..495]: extent
1: [496..519]: hole
2: [520..2543]: extent
3: [2544..17575]: hole
4: [17576..21487]: extent

Which tells you that everything you asked for was allocated...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
