Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9D5B27F3F
	for <xfs@oss.sgi.com>; Fri, 19 Dec 2014 12:54:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8AFDE8F8059
	for <xfs@oss.sgi.com>; Fri, 19 Dec 2014 10:54:26 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id mx20Hc2rTHLJj8fB for <xfs@oss.sgi.com>;
	Fri, 19 Dec 2014 10:54:24 -0800 (PST)
Message-ID: <5494745E.60500@sandeen.net>
Date: Fri, 19 Dec 2014 12:54:22 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_repair: fix max block offset test
References: <5489DA3B.5050908@redhat.com>
	<20141218151835.GC13471@laptop.bfoster>
In-Reply-To: <20141218151835.GC13471@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@redhat.com>
Cc: Eryu Guan <eguan@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 12/18/14 9:18 AM, Brian Foster wrote:

hought this looked familiar:
> 
> http://oss.sgi.com/archives/xfs/2014-09/msg00524.html
> 
> Either one is fine with me. If we use the fix below, I think we should
> update the error message since it technically refers to the extent
> offset and we slightly tweak the meaning of the failure.
> 
> Brian

Ok, so here's what I wonder about with your patch.

+               if (irec.br_startoff > fs_max_file_offset)  {

What if the extent starting logical offset is *at* fs_max_file_offset
(which is sadly in blocks, not bytes, for extra confusion points),
but the extent is 1GB in length?

Isn't this a problem because we've now got files in the block which
are beyond fs_max_file_offset, and probably also beyond sb_maxbytes?

I'm not sure I follow why you feel the message needs to change with
my version:

+		/* Ensure this extent does not extend beyond the max offset */
+		if (irec.br_startoff + irec.br_blockcount - 1 >
+							fs_max_file_offset) {
                        do_warn(
_("inode %" PRIu64 " - extent offset too large - start %" PRIu64 ", "
  "count %" PRIu64 ", offset %" PRIu64 "\n"),
                                ino, irec.br_startblock, irec.br_blockcount,
                                irec.br_startoff);

If any (block) offset in the file is beyond the max, then we say the offset is
too large, and give it's physical block, its length, and its starting offset
(granted, the message is a bit *weird* - br_startblock really doesn't matter
here, but I don't think I've fundamentally changed the meaning of the test).

However, I've come to learn that you are almost always right about subtleties
like this, so perhaps you can explain again to me, using smaller words.  :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
