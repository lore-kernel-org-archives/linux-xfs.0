Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DB02E7F54
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 11:56:08 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B0C788F8050
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 09:56:08 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HzivW8M66avrvmsZ for
	<xfs@oss.sgi.com>; Wed, 13 Nov 2013 09:56:04 -0800 (PST)
Message-ID: <5283BD1A.8000704@redhat.com>
Date: Wed, 13 Nov 2013 12:55:38 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 00/11] xfs: introduce the free inode btree
References: <1384353427-36205-1-git-send-email-bfoster@redhat.com>
	<20131113161711.GA14300@infradead.org>
In-Reply-To: <20131113161711.GA14300@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 11/13/2013 11:17 AM, Christoph Hellwig wrote:
> I have to admit that I haven't followed this series as closely as I
> should, but could you summarize the performance of it?  What workloads
> does it help most, what workloads does it hurt and how much?
> 

Hi Christoph,

Sure... this work is based on Dave's write up here:

http://oss.sgi.com/archives/xfs/2013-08/msg00344.html

... where he also explains the general idea, which is basically to
improve inode allocation performance on a large fs' that happens to be
sparsely populated with inode chunks with free inodes. We do this by
creating a second inode btree that only tracks inode chunks with at
least one free inode.

So far I've only really ad hoc tested the focused case: create millions
of inodes on an fs, strategically remove an inode towards the end of the
ag such that there is one existing inode chunk with a single free inode,
then go and create a file.

The current implementation hits the fallback search in xfs_dialloc_ag()
(the for loop prior to 'alloc_inode:') and degrades to a couple seconds
or so (on my crappy single spindle setup). Alternatively, the finobt in
this scenario contains a single record with the chunk with the free
inode, so the record lookup and allocation time is basically constant
(e.g., we eliminate the need to ever run the full ag scan).

Sorry I don't have more specific numbers at the moment. Most of my
testing so far has been the focused case and general reliability
testing. I'll need to find some hardware worthy of performance testing,
particularly to check for any potential negative effects of managing the
secondary tree. I suppose I wouldn't expect it to be much worse than the
overhead of managing two free space trees, but we'll see.
Thoughts/suggestions appreciated, thanks.

Brian


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
