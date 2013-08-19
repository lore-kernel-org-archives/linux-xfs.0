Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 077BB7F5A
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 18:28:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C662B30406B
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 16:28:32 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 3o2EFQPXAeiExTKF for <xfs@oss.sgi.com>;
	Mon, 19 Aug 2013 16:28:31 -0700 (PDT)
Message-ID: <5212AA1D.3000809@sandeen.net>
Date: Mon, 19 Aug 2013 18:28:29 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 51/50] xfs: add xfs sb v4 support for dirent filetype field
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
	<20130819201940.516942026@sgi.com>
In-Reply-To: <20130819201940.516942026@sgi.com>
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
Cc: xfs@oss.sgi.com

On 8/19/13 3:19 PM, Mark Tinguely wrote:

<an attachment that doesn't show up on reply, moving d_type support to v4 superblocks ;) >

Thanks, Mark!

Has you been able to test this at all?

I do still owe a promised xfstest - but for that, we'll need at least mkfs
& xfs_repair support.

Did you patch up mkfs to do basic tests of your kernelspace patch?

Talking to Dave, he reminds me of a few things this needs, if it's
going to be complete & compatible on V4:

* mkfs.xfs commandline option support & manpage updates
* xfs_db support (including version friendly-text output)
* XFS_IOC_FSGEOM support so that xfs_info can report the difference
* xfs_repair needs to know that it's a valid feature on V4

Some of that may overlap w/ things still needed on V5, but some is unique
to allowing it on V4.

Mark, do you plan to do some of those unique-to-V4 parts, too?

As an aside: I would support getting this feature onto V4 superblocks,
after we have confidence that all the bits are done, tested, and robust.

I still would really like to see it go forward in parallel on V5, and
not be blocked by the extra work needed for proper V4 integration.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
