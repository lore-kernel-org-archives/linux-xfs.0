Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ECDAA7F47
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 16:55:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CD1BB8F8033
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 14:55:53 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	IWKbdoaywNqYaEDP for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 14:55:51 -0700 (PDT)
Date: Tue, 18 Aug 2015 07:55:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/11] xfsprogs: Partial OS X support
Message-ID: <20150817215549.GD714@dastard>
References: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: hch@infradead.org, xfs@oss.sgi.com

On Mon, Aug 17, 2015 at 06:23:15PM +0200, Jan Tulak wrote:
> This is a third iteration of OS X support patches. Notes with information about
> changes in every patch since the last bulk submittation (or at least the last
> iteration of that patch) follows.

What version of the patches are these? I see some patches in
previous thread with "v4" on them, so I don't know whether they are
more recent than these or not. 

FWIW, I'm not picking on you; I'm trying to explain what I see and
why it makes it difficult for me to work out what is going on so you
understand why I might be asking for specific information. Nobody
explains this stuff to new developers; you pick it up through trial
an error, and emails like this :/

What I'm seeing in my inbox is threads like this:

patch 0 v1
  ->patch 1
  ->patch 2
  ->patch 3

patch 0 v2
  ->patch 1 V2
  ->patch 2 V2
    ->patch 2 V3
      -> patch 2 V4
  ->patch 3 V2

patch 0 v3
  ->patch 1 v3
  ->patch 2 v3
    ->patch 2 V4
  ->patch 3 v3

And so you can see how confusing "patch 2 V3" or "patch 2 v4" gets
when they are versioned this way. I don't know which one is most
recent just by looking at the patch subject.

I try to avoid this problem by putting a version on the patchset
itself (i.e. on the patch 0 letter) and then the individual patches
do not have a version. If I update a patch within a series, it gets
a v2, v3, etc on each repost within that overall patch series. When
I repost the entire patch series as a new version, however, I send
the latest version of the patch without a version. i.e. the threads
look like:


patch 0 v1
  ->patch 1
  ->patch 2
  ->patch 3

patch 0 v2 (w/ changelog for v2)
  ->patch 1
  ->patch 2
    ->patch 2 V2 (w/ changelog)
      -> patch 2 V3 (w/ changelog)
  ->patch 3

patch 0 v3 (w/ changelog for v3)
  ->patch 1
  ->patch 2
    ->patch 2 V2 (w/ changelog)
  ->patch 3

And so the lastest patches are always in the latest thread the
patch series has been posted.

> BTW: for the patches which already got "Reviewed-by", I added the line
> to these patches. If this is not a good thing and I should let the reviewer
> to submit his reviewed-by email again, tell me. :-)

No, that's the rigth thing to do, and you don't need to mention it
in the changelog. Seeing the tag in the commit message tells both
the reviewer and the maintainer that the patchhas already been
reviewed and does not need to be rescrutinised.

Of course, that means if you change the patch you need to remove the
reviewed-by tag to tell reviewers it needs to be looked at again
and the change documented in the change log...

Speaking of change logs:

> undefined variable fix
> - better explanation in commit
> 
> Add ifdef dirent checks where it was missing
> - added approximation of d_reclen
> - text width fix
> 
> Change OS X-specific CFLAGS/LDFLAGS
> - Nothing, already reviewed
> 
> Add includes required for OS X builds
> - updated for libdisk gone
> 
> missing and dummy calls for OS X support
> - new patch (no review yet)
> 
> Add mntent.h check into autoconf
> - new patch
> - autoconf change
> 
> Add fls check into autoconf
> - new patch
> - autoconf change
>
> replace obsolete memalign with posix_memalign
> - new patch
> - remove strange code formatted
> 
> prevent LIST_ macros conflicts
> - already reviewed
> - new patch
> 
> Update doc for OS X
> - new patch (no review yet)
> 
> Add a way to compile without blkid
> - new patch
> - changed default behaviour if BLKID is disabled such that mkfs -f is required

Better is this:

Version 3:
- better commit messages (patch 1)
- formatting fixes (patch 2, 8)
- autoconf updates (patch 6, 7)
- changed default behaviour if BLKID is disabled such that mkfs -f
  is required (patch 11)

Version 2:
- added approximation of d_reclen (patch 2)
- updated for libdisk removal (patch 4)
- OS X documentation update (new patch 10)

So we have some idea of what changed between two reposts of the
patch series, and we have some context of the changes that have
previously been asked for during review without having to go back to
the previous threads.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
