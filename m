Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 77AC17FB8
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 21:12:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6047A304064
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 19:12:49 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ZQ44OZzLZrD79DnQ for <xfs@oss.sgi.com>;
	Thu, 14 Mar 2013 19:12:47 -0700 (PDT)
Date: Fri, 15 Mar 2013 13:12:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/18] xfstests: Remove obsolete remake script
Message-ID: <20130315021234.GF21651@dastard>
References: <20130314130611.405A853DEAEF@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130314130611.405A853DEAEF@polaris-admin.engr.sgi.com>
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
To: Philip White <pwhite@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 14, 2013 at 06:06:11AM -0700, Philip White wrote:
> From: Phil White <pwhite@sgi.com>
> 
> 
> This is a rebasing & resubmit of a dchinner patch.  His comments on the
> original:
> -----------------
> We don't ever do wholesale rebuilds of the output files anymore, so
> kill the script that does it to reduce the dependency on common and
> common.rc.
> -----------------
> 
> Signed-off-by: Phil White <pwhite@sgi.com>

Hi Phil - it's great that you've picked this up, but it would have
been really nice to know that you were doing this. Just a short
email on the list with me CC'd or even just a private message on
IRC. Last I heard from anyone at SGI was that SGI still didn't want
to remove the old bench scripts. Now I find out that you've picked
up the patchset that removes it and forward ported it....

If you let me know you were doing this, I could have let you know
that my local version has several more patches in it and bug fixes
that I haven't posted out. Indeed, I coul dhave taken an hour to
apply all the changes to the most recent additions to xfstests and
posted an up-to-date version, because I've been maintaining the
patchset locally.

Indeed, one of my test VMs runs this version of xfstests all the
time:

$ sudo MKFS_OPTIONS="-b size=512" ./check -g auto
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 test-1 3.9.0-rc2-dgc+
MKFS_OPTIONS  -- -f -b size=512 /dev/vdb
MOUNT_OPTIONS -- /dev/vdb /mnt/scratch

generic/001      2s
generic/002      0s
generic/005      0s
....

So I could have saved you a lot of work if you'd simply told us that
SGI had decided that "dropping bench is OK". If you make a decision
like this, then please tell us when you make it - sometimes it will
save you a lot of unnecessary time and effort....

/me knows what his afternoon is going to be spent doing: updating
all the recent tests added to xfstests and posting a current patch
set....

----

For future reference for everyone, a few technical guidelines for
reposting patch sets written by other people.  This is important to
get right, as we all know that the correct attribution of the
original of the code has legal significance.

- when you are reposting a mostly unmodified patch written by
  someone else, you should not claim it as your own, nor strip off
  the original s-o-b lines. i.e. reposted patches should have a
  description that looks like:

From: Dave Chinner <dchinner@redhat.com>

<unmodified original patch description>

<[pwhite] modifications added (if any) during rebasing>

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Phil White <pwhite@sgi.com>

  See the way I have done this in the CRC patchset attributing
  various patches in the series to Christoph and how I've modified
  them from Christoph's original versions. e.g:

  http://oss.sgi.com/pipermail/xfs/2013-March/024766.html

  This is especially important if the patches contain copyright
  title updates - they can only be made by the author of the code in
  question. Hence if the patch is listed as "from X" and the
  copyright statement says "(c) Y." then that is a big problem...

- comments like "this is a rebasing and resubmit" don't belong in
  commit messages, they belong in the patch 0 description.  Patch 0
  should also contain a high level description of the patch set and
  outline the changes you've made to the original code.

- large patch series need to be correctly threaded with a patch 0
  describing the series. git-send-email should be able to do this
  for you automatically.

- rebasing a patch set to a current tree means you need to apply all
  the changes to new files that have been added since this patch set
  was originally written. Part of rebasing is "making new stuff
  work"... ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
