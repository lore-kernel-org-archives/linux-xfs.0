Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B7E887F54
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 16:12:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3CB2CAC001
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 14:12:19 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Ws961ie1kOLzmoDb for <xfs@oss.sgi.com>;
	Tue, 24 Mar 2015 14:12:17 -0700 (PDT)
Message-ID: <5511D331.5030106@sandeen.net>
Date: Tue, 24 Mar 2015 16:12:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 0/5 V2] xfs: RENAME_WHITEOUT support
References: <1427194771-3105-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1427194771-3105-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 3/24/15 5:59 AM, Dave Chinner wrote:
> Hi folks,
> 
> This is the second version of the RENAME_WHITEOUT patchset that I
> originally posted here:
> 
> http://oss.sgi.com/pipermail/xfs/2015-February/040378.html
> 
> This is mainly the breakup and restructuring of the patchset I
> mention that needed to be done, as well as addressing the comments
> that were made at the time (e.g. wino -> wip).
> 
> The patchset has been split into 5 patches, the first four are
> really cleanup and factoring patches to make the rename and inode
> locking code a bit simpler and easier to understand. The last patch
> then introduces the RENAME_WHITEOUT functionality, which ends up
> being surprisingly little code....
> 
> The changes pass xfstests, but I have not run them on overlayfs at
> all yet, so I don't know if that's going to result in smoke and
> tears yet. Still, getting the patch set out for review now is more
> important that waiting for testing because there is relatively
> little time left before the 4.1 merge window opens up....
> 
> So, comments, thoughts and flames are more than welcome.

I mentioned little editorial nits on patches 3 and 5, otherwise looks fine;
fix them or not, you can add:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
