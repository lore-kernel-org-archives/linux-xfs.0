Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAOIb2dH143992 for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 12:37:02 -0600
Received: from mx2.isti.cnr.it (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DD7071A56BD
	for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 10:38:40 -0800 (PST)
Received: from mx2.isti.cnr.it (mx2.isti.cnr.it [194.119.192.4]) by
	cuda.sgi.com with ESMTP id g6X2QZeW8eG0uwBm for
	<xfs@oss.sgi.com>; Wed, 24 Nov 2010 10:38:40 -0800 (PST)
Received: from SCRIPT-SPFWL-DAEMON.mx.isti.cnr.it by mx.isti.cnr.it
	(PMDF V6.5 #31825) id <01NUN9UYWQO0LGZ9HO@mx.isti.cnr.it> for
	xfs@oss.sgi.com; Wed, 24 Nov 2010 19:37:50 +0100 (MET)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it (PMDF V6.5 #31825)
	id <01NUN9UYRRQ8LGZ4PF@mx.isti.cnr.it> for xfs@oss.sgi.com; Wed,
	24 Nov 2010 19:37:50 +0100 (MET)
Received: from [192.168.7.52] (firewall.itb.cnr.it [155.253.6.254])
	by mx.isti.cnr.it (PMDF V6.5 #31826)
	with ESMTPSA id <01NUN9UX2X2MLLWTQ8@mx.isti.cnr.it> for xfs@oss.sgi.com;
	Wed, 24 Nov 2010 19:37:49 +0100 (MET)
Date: Wed, 24 Nov 2010 19:39:56 +0100
From: Spelic <spelic@shiftmail.org>
Subject: Verify filesystem is aligned to stripes
Message-id: <4CED5BFC.8000906@shiftmail.org>
MIME-version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi there,
I thought there was a way to empirically check that the filesystem is 
correctly aligned to RAID stripes, but my attempts fail.
I don't mean by looking at sunit and swidth from xfs_info, because that 
would not detect if there is some LVM offset problem.

I am particularly interested for parity RAIDs in MD.

I was thinking at "iostat -x 1": if writes are aligned I shouldn't see 
any reads from the drives in a parity RAID...

unfortunately this does not work:
- a dd streaming write test has almost no reads even when I mount with 
"noalign", with sufficiently large stripe_cache_size such as 1024. If it 
is smaller, always reads, even if xfs is aligned.
- a kernel untar will show lots of reads at any stripe_cache_size even 
if I'm pretty sure I aligned the stripes correctly on my 1024k x 15 data 
disks and the .tar.bz2 file was in cache. I tried with both xfs stripes 
autodetection in 2.6.37-rc2 and by specifying su and sw values by hand, 
which turned out to be the same; I was without LVM so I'm pretty sure 
alignment was correct. Why are there still lots of reads in this case?

so I'm pretty clueless. Anyone has good suggestions?
Thank you

PS, OT: do you confirm it's not a good idea to have agsize multiple of 
stripe size like the mkfs warns you against? Today I offsetted it by +1 
stripe unit (chunk) so that every AG begins on a different drive but 
performances didn't improve noticeably. Wouldn't that cause more 
unfilled stripes when writing?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
