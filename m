Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8743D7CBF
	for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 14:57:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 572CF8F804B
	for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 12:57:06 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 9QevQ4DKYReAONRj for <xfs@oss.sgi.com>;
	Tue, 27 Aug 2013 12:57:05 -0700 (PDT)
Received: from liberator.lan (h163.57.19.98.dynamic.ip.windstream.net
	[98.19.57.163])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 53C3963BEBC2
	for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 14:57:04 -0500 (CDT)
Message-ID: <521D048F.2040604@sandeen.net>
Date: Tue, 27 Aug 2013 14:57:03 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Anyone grok pf_batch_read() in xfs_repair?
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
To: xfs-oss <xfs@oss.sgi.com>

There's a pretty clear buffer overflow in pf_batch_read() but I'm having
a hard time wrapping my head around what it's supposed to be doing:

<snip>
                num = 0;
                if (which == PF_SECONDARY) {
                        bplist[0] = btree_find(args->io_queue, 0, &fsbno);
                        max_fsbno = MIN(fsbno + pf_max_fsbs,
                                                        args->last_bno_read);
                } else {
                        bplist[0] = btree_find(args->io_queue,
                                                args->last_bno_read, &fsbno);
                        max_fsbno = fsbno + pf_max_fsbs;
                }
                while (bplist[num] && num < MAX_BUFS && fsbno < max_fsbno) {
                        if (which != PF_META_ONLY ||
                            !B_IS_INODE(XFS_BUF_PRIORITY(bplist[num])))
                                num++;
                        bplist[num] = btree_lookup_next(args->io_queue, &fsbno);
                }
<snip>

That while loop is busted; we can increase num from (MAX_BUFS-1) to MAX_BUFS,
and then index the bplist array with MAX_BUFS, which is 1 past its end -
this corrupts memory.  Derp!

But I'm just not grokking what this is supposed to be doing.

If we come in w/ (which == PF_META_ONLY) we'll immediately overwrite
bplist[0] set in the if/else case above.  It all seems weird.
Anybody understand this offhand or should I just keep digging?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
