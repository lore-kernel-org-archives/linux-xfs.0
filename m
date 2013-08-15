Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 80FF97CBE
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 14:06:16 -0500 (CDT)
Date: Thu, 15 Aug 2013 14:06:13 -0500
From: Geoffrey Wehrman <gwehrman@sgi.com>
Subject: Re: [PATCH 48/49] xfs: Add read-only support for dirent filetype field
Message-ID: <20130815190612.GJ3783@sgi.com>
References: <51F80FA8.4060304@sgi.com> <20130812005905.GK12779@dastard>
	<5208E243.9080403@sgi.com> <20130813005024.GS12779@dastard>
	<520A53E8.6030604@sgi.com> <20130814075042.GE6023@dastard>
	<20130814184729.GA4604@sgi.com> <520D06C0.3040207@sandeen.net>
	<20130815183205.GG3783@sgi.com> <520D20CB.4080907@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <520D20CB.4080907@sandeen.net>
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
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Thu, Aug 15, 2013 at 01:41:15PM -0500, Eric Sandeen wrote:
| 
| You brought this topic up on an xfs community call months ago,
| as I recall.  I thought we had put it to rest, because we didn't hear
| from you again until now.
| 
| Am I misremembering?

The issue I brought up before was with one of two aspects of v5
superblock filesystems.
  - The fact that CRCs cannot be disabled in a v5 superblock filesystem.
    I capitulated on this issue on the grounds that v5 superblock
    filesystems are experimental only, and I have the opportunity to
    provide the code myself to disable CRCs in a v5 superblock filesystem.
  - v5 superblock filesystem minimum inode size is 512 bytes.  Dave
    pointed out in a followup e-mail that v5 superblock inodes have
    bloated so that they no longer fit in 256 bytes.
    http://oss.sgi.com/archives/xfs/2013-06/msg00726.html

Yes, I have had recent issues with how Dave is implementing some of
his features.  My recent complaint is unrelated to the previous two.
The dirent filetype feature is not dependent neither on v5 superblock
nor on v3 directory block for technical reasons, only by preference.
I do no sit around looking for excuses to throw barriers in Dave's way.
My only motivation is to speak up when I feel a decision has been made
which is not beneficial to the XFS community.


-- 
Geoffrey Wehrman  651-683-5496  gwehrman@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
