Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 927897F3F
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2014 18:44:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8903A304051
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2014 16:44:58 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	BVJJPHd94AzsQ1cZ for <xfs@oss.sgi.com>;
	Mon, 07 Jul 2014 16:44:56 -0700 (PDT)
Date: Tue, 8 Jul 2014 09:44:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] xfs: remove efi from AIL in log recovery
Message-ID: <20140707234453.GC4453@dastard>
References: <20140702143206.438456679@sgi.com>
	<20140702144139.620473576@sgi.com>
	<20140707143016.GA4123@laptop.bfoster> <53BABCBE.5050602@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53BABCBE.5050602@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Mon, Jul 07, 2014 at 10:29:02AM -0500, Mark Tinguely wrote:
> On 07/07/14 09:30, Brian Foster wrote:
> >On Wed, Jul 02, 2014 at 09:32:07AM -0500, Mark Tinguely wrote:
> >>  		    (extp->ext_len == 0) ||
> >>  		    (startblock_fsb>= mp->m_sb.sb_dblocks) ||
> >>  		    (extp->ext_len>= mp->m_sb.sb_agblocks)) {
> >>-			/*
> >>-			 * This will pull the EFI from the AIL and
> >>-			 * free the memory associated with it.
> >>-			 */
> >>-			set_bit(XFS_EFI_RECOVERED,&efip->efi_flags);
> >>-			xfs_efi_release(efip, efip->efi_format.efi_nextents);
> >>-			return XFS_ERROR(EIO);
> >>+			error = XFS_ERROR(EIO);
> >>+			goto return_free;
> >
> >This bit doesn't apply to for-next. I get similar problems with less
> >trivial hunks on the subsequent patch as well. Looks like you might need
> >to rebase the series onto the recent error negation patches..?
> 
> 
> WTF? Why are the changes not in the dev tree? Why do people have to
> do development to the for-next tree?

You don't. Brian just asked you to rebase against it because of
merge conflicts against the current for-next tree he tried to apply
it to. It's obvious to me that you didn't read the discussions about
the plans for this dev cycle that went on a month ago:

"[DISCUSS] Planning for new dev cycle (3.17)"

http://oss.sgi.com/pipermail/xfs/2014-June/036739.html

Fact is, this major restructure has been discussed several times
over the past couple of months, both on the mailing list and on IRC,
and there's been plenty of warning and requests for comments about
it.

As to being asked to rebase the patch set on the for-next tree,
I normally do the merges without anybody having to care about the
mismatches due to patch merge order, but we don't normally have a
massive set of changes queued up. Most conflicts are trivial, but
because of the massive change already queued up, the changes this
time are not trivial and so rather than have everyone who wants to
review your code have to mangle them to test with the for-next code,
he's asked you rebase the patchset against for-next.

There's nothing wrong with that - this is a pretty normal thing to
have to do when working with topic branches in the upstream repo.  I
was just about to send an email to ask you rebase - lucky I read
this first. ;)

FWIW, you should be doing all your testing against for-next, not
against the master branch. i.e.

$ git checkout -b dev-branch master
<hack hackity hack>
$ git commit
<build, test>
$ git checkout -b testing for-next
$ git merge dev-branch
<build, test, test, test>

Otherwise you aren't testing your changes with all the other changes
that have been committed in the current dev cycle....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
