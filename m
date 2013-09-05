Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7EB4129DFB
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 21:38:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5F40B8F8035
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 19:38:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id g6FXA3LZFADs1bIl for
	<xfs@oss.sgi.com>; Wed, 04 Sep 2013 19:38:26 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r852cPaT015399
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 4 Sep 2013 22:38:26 -0400
Received: from gelk.kernelslacker.org (ovpn-113-166.phx2.redhat.com
	[10.3.113.166])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r852cJwh006496
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 4 Sep 2013 22:38:25 -0400
Received: from gelk.kernelslacker.org (localhost [127.0.0.1])
	by gelk.kernelslacker.org (8.14.7/8.14.7) with ESMTP id r852cJp0010975
	for <xfs@oss.sgi.com>; Wed, 4 Sep 2013 22:38:19 -0400
Received: (from davej@localhost)
	by gelk.kernelslacker.org (8.14.7/8.14.7/Submit) id r852cIKO010974
	for xfs@oss.sgi.com; Wed, 4 Sep 2013 22:38:18 -0400
Date: Wed, 4 Sep 2013 22:38:18 -0400
From: Dave Jones <davej@redhat.com>
Subject: potential argument order bug in
	fs/xfs/xfs_dir2_node.c:xfs_dir2_leafn_unbalance
Message-ID: <20130905023818.GA10694@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

I'm picking through some of the bugs in coverity's database,
and I came across this one, which I'm unsure of..

In xfs_dir2_leafn_unbalance we have this code..

1583         if (xfs_dir2_leafn_order(save_blk->bp, drop_blk->bp))
1584                 xfs_dir3_leafn_moveents(args, drop_blk->bp, &drophdr, dents, 0,
1585                                         save_blk->bp, &savehdr, sents, 0,
1586                                         drophdr.count);
1587         else
1588                 xfs_dir3_leafn_moveents(args, drop_blk->bp, &drophdr, dents, 0,
1589                                         save_blk->bp, &savehdr, sents,
1590                                         savehdr.count, drophdr.count);

The issue that coverity picked up in both cases, is that 'sents' and 'dents' are in
a different order to how the xfs_dir3_leafn_moveents function expects them.

Is this intentional ? If so I'll mark it as such in their db.

thanks,

	Dave


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
