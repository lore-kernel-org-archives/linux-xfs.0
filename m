Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E537C7F6F
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 18:48:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C22EC8F8040
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 16:48:53 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	UF7ht0IW4CSzBtMQ for <xfs@oss.sgi.com>;
	Fri, 02 May 2014 16:48:51 -0700 (PDT)
Date: Sat, 3 May 2014 09:48:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/5] xfstests: fixes for the free inode btree
Message-ID: <20140502234831.GG26353@dastard>
References: <1399050842-19633-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1399050842-19633-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, May 02, 2014 at 01:13:57PM -0400, Brian Foster wrote:
> Hi all,
> 
> This series is a few xfstests fixes and addons for the finobt. Patch 1
> fixes xfs/030 to work correctly on finobt-enabled filesystems. Patches 2
> and 3 add support for finobt-oriented tests via require functions and
> repair filter updates. Patch 4 adds a new test for targeted repair of
> finobt filesystems. Patch 5 adds a stress test that creates/modifies a
> sparsely allocated set of inodes to effectively exercise the finobt in
> conjunction with an fsstress workload.
> 
> xfs/010 runs very quickly. xfs/013 runs for 5-10 minutes on my smallish
> VM running against a single spindle, so I've been back and forth on
> whether it should be part of the auto group. Thoughts, reviews, flames
> appreciated...

5-10 minutes is probably right at the edge for auto, but I think
that most people won't be testing this any time soon. Hence I'd
include it by default in the auto group, and if people complain
about the runtime when they start testing it, we can revist that
choice. FWIW, I'd also include it in the metadata group so that it
gets exercised when people run that group....

I had a quick eyeball of the changes, and nothing major stood out.
The only thing I noticed was a missing "wait" in the _cleanup
function of xfs/013 after killing all the fsstress processes. It
should probably using killall -9 as well. If we don't wait, then the
unmount will fail and if the fsstress processes don't die it will
affect every test after that...

I'll probably have more suggestions once I've run the tests ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
