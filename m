Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D8CCE7CA2
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2016 20:34:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 56301AC001
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2016 18:34:26 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	mB8GOAQIMamOW6rE for <xfs@oss.sgi.com>;
	Tue, 13 Sep 2016 18:34:23 -0700 (PDT)
Date: Wed, 14 Sep 2016 11:34:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs_repair: update the manual content about
	xfs_repair exit status
Message-ID: <20160914013421.GL30497@dastard>
References: <1473782076-9137-1-git-send-email-zlang@redhat.com>
	<20160913163226.GE9314@birch.djwong.org>
	<5b36e20b-9238-0694-f919-31e33cd9ecbb@sandeen.net>
	<20160913214801.GJ30497@dastard>
	<28a1500b-c3cb-9718-696d-e35f7fa99a75@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <28a1500b-c3cb-9718-696d-e35f7fa99a75@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Tue, Sep 13, 2016 at 04:52:32PM -0500, Eric Sandeen wrote:
> 
> 
> On 9/13/16 4:48 PM, Dave Chinner wrote:
> > On Tue, Sep 13, 2016 at 11:57:59AM -0500, Eric Sandeen wrote:
> >> On 9/13/16 11:32 AM, Darrick J. Wong wrote:
> 
> ...
> 
> >>> So... I'd rather the documentation about the return code reflect the
> >>> status of the filesystem -- 2 means "unclean log, replay it or zap it",
> >>> 1 means "errors encountered, fs may not be correct", and 0 /should/ mean
> >>> "fs is correct".
> >>>
> >>> OTOH I don't know for sure that xfs_repair always cleans up the fs on
> >>> the first try.
> >>
> >> That's certainly the intent; I can't imagine a manpage documenting
> >> return codes qualified with "... unless bugs happen." :)
> > 
> > Right - if we hit bugs, all bets are off. But otherwise, the fs
> > should be repaired and clean after a single pass.
> > 
> >>>  ISTR
> >>> asking Dave about this, and I think he said that the FS should be clean
> >>> if repair returns 0.  But I'll let him reiterate that if it's true;
> >>> don't trust my crummy memory, that's why I have filesystems. ;)
> >>
> >> Did you have an alternate wording in mind?
> > 
> > Yup, 0 = " fs is clean", 1 = "fs is still b0rken",
> > 2 = "couldn't run for whatever reason given"
> 
> Technically, 1 = "may or may not be broken" - we really don't know.
> We could get an exit of 1 for a consistent filesystem, for example
> if some allocation failed... all we know is something bonked out in
> the middle.
> 
> Maybe "1 == xfs_repair did not run to completion?"

Well, if it fails part way through phase 5, then the filesystem is
most definitely broken, even if it was clean to begin with. i.e.
repair, even when the filesystem is clean, will rebuild parts of the
filesystem from scratch.

And repair nulls out directory entries in phase 4 and doesn't
rebuild those directories till phase 6, so between those points the
filesystem is actually in a corrupt state that requires repair.
hence there is a large scope where a failure in repair really does
mean that we need to run repair again. Hence I think it's simply
safer to explicitly document it as:

	"1 == fs may be even more broken than before repair started,
	so repair needs to be run again"

because "did not run to completion" does not really tell the user
what to do when it occurs.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
