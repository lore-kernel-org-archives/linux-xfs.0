Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E00C77F58
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 19:01:55 -0600 (CST)
From: Shaun Gosse <sgosse@sgi.com>
Subject: RE: Limits on agi->agi_level (and other btree depths?)
Date: Thu, 13 Feb 2014 01:01:50 +0000
Message-ID: <8D3FA7645C1CFC4E9E783D22B4C708644B09B9@P-EXMB2-DC21.corp.sgi.com>
References: <52FC09AB.3030209@sandeen.net>
In-Reply-To: <52FC09AB.3030209@sandeen.net>
Content-Language: en-US
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

>  (cue dchinner working out that 9 levels is 59 bazillion jillion items, and will never be hit?)

I don't know the XFS code and how it does B-trees. This is a very rough initial estimate that would apply to any sort of tree. Since we want to know when we're required to exceed a depth of 8, presume a full tree for simplicity. Say your branching factor for the whole tree is equal to the maximum depth. If it's higher, you have more room of course. But if it is equal, then you have 8**8 leaf nodes (calling the root node a depth of zero) before you have to add a depth 9 (or increase your branching factor; if there is a limit that might be hit, this would be the way to go to avoid more depth).

That gives you about 16 and three quarters million leaf nodes to work with. Of course if you're storing multiple entries per node, that gives you a constant factor on top.

In any event, sounds like it may be worth considering whether the limit could ever be reached and how to extend it if so. Given the discussion that's occurred about stack size, I could see where recursing on ever-deeper trees could be problematic, although perhaps it would be possible to use tail-recursion in anything which doesn't need to scan the full tree at least (if that's not already done).

Given that XFS has a theoretical maximum filesystem size of 18 Exabytes, for a hypothetical filesystem composed of 1k sized files (just to be maximally difficult; worst-case analysis), that's about 2 x 10**16 inodes to store. I'm sure this would make a lot of other things break first, but it would also blow past the number of leaves you can have in a tree of maximum height of 8, unless your branching factor goes above 50. And I doubt more than 100-1000 entries are being squeezed into a leaf, if that.

Sorry, I don't normally jump into the discussions on here, just follow along, since I'm not very familiar with the XFS code, but this seemed like an interesting question which could be partially addressed without any familiarity with the internals.

I will be curious to read what XFS is actually doing in this area in greater detail. And I look forward to the XFS test (and rig) that can manage to break it / exercise the limit...is there any known limit to the number of files? http://xfs.org/docs/xfsdocs-xml-dev/XFS_User_Guide/tmp/en-US/html/ch02s04.html just lists max file size and file system size. If nothing else, it would be worth determining the limit and documenting it.

Cheers,
-Shaun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
