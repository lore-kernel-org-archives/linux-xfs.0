Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5MFO72N099148 for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 10:24:07 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9EEED24E30
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 08:24:06 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id TjEyhfK4Fg2MEyer for <xfs@oss.sgi.com>;
	Wed, 22 Jun 2011 08:24:06 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id F02BC4964600
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 10:24:02 -0500 (CDT)
Message-ID: <4E020912.9020106@sandeen.net>
Date: Wed, 22 Jun 2011 10:24:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: duplicate code in dir2
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

I was poking around with various code metrics, and found a fair bit of duplication in dir2 code (using "duplo").

Haven't really thought about how it might be factorable, but thought it might be interesting to share.

-Eric

/src/git/linux-2.6/fs/xfs/xfs_dir2_node.c(251)
/src/git/linux-2.6/fs/xfs/xfs_dir2_leaf.c(440)
                if (index < be16_to_cpu(leaf->hdr.count))
                        memmove(lep + 1, lep,
                                (be16_to_cpu(leaf->hdr.count) - index) * sizeof(*lep));
                lfloglow = index;
                lfloghigh = be16_to_cpu(leaf->hdr.count);
                be16_add_cpu(&leaf->hdr.count, 1);
        else {
                if (compact == 0) {
                        for (lowstale = index - 1;
                             lowstale >= 0 &&
                                be32_to_cpu(leaf->ents[lowstale].address) !=
                                XFS_DIR2_NULL_DATAPTR;
                             lowstale--)
                                continue;
                        for (highstale = index;
                             highstale < be16_to_cpu(leaf->hdr.count) &&
                                be32_to_cpu(leaf->ents[highstale].address) !=
                                XFS_DIR2_NULL_DATAPTR &&
                                (lowstale < 0 ||
                                 index - lowstale - 1 >= highstale - index);
                             highstale++)
                                continue;
                if (lowstale >= 0 &&
                    (highstale == be16_to_cpu(leaf->hdr.count) ||
                     index - lowstale - 1 < highstale - index)) {

/src/git/linux-2.6/fs/xfs/xfs_dir2_node.c(300)
/src/git/linux-2.6/fs/xfs/xfs_dir2_leaf.c(499)
                        if (index - lowstale - 1 > 0)
                                memmove(&leaf->ents[lowstale],
                                        &leaf->ents[lowstale + 1],
                                        (index - lowstale - 1) * sizeof(*lep));
                        lep = &leaf->ents[index - 1];
                        lfloglow = MIN(lowstale, lfloglow);
                        lfloghigh = MAX(index - 1, lfloghigh);
                else {

/src/git/linux-2.6/fs/xfs/xfs_dir2_node.c(316)
/src/git/linux-2.6/fs/xfs/xfs_dir2_leaf.c(518)
                        if (highstale - index > 0)
                                memmove(&leaf->ents[index + 1],
                                        &leaf->ents[index],
                                        (highstale - index) * sizeof(*lep));
                        lep = &leaf->ents[index];
                        lfloglow = MIN(index, lfloglow);
                        lfloghigh = MAX(highstale, lfloghigh);
                be16_add_cpu(&leaf->hdr.stale, -1);
        lep->hashval = cpu_to_be32(args->hashval);

/src/git/linux-2.6/fs/xfs/xfs_dir2_node.c(582)
/src/git/linux-2.6/fs/xfs/xfs_dir2_leaf.c(1349)
        for (lep = &leaf->ents[index]; index < be16_to_cpu(leaf->hdr.count) &&
                                be32_to_cpu(lep->hashval) == args->hashval;
                                lep++, index++) {
                if (be32_to_cpu(lep->address) == XFS_DIR2_NULL_DATAPTR)
                        continue;
                newdb = xfs_dir2_dataptr_to_db(mp, be32_to_cpu(lep->address));
                if (newdb != curdb) {

/src/git/linux-2.6/fs/xfs/xfs_dir2_node.c(442)
/src/git/linux-2.6/fs/xfs/xfs_dir2_leaf.c(1349)
        for (lep = &leaf->ents[index]; index < be16_to_cpu(leaf->hdr.count) &&
                                be32_to_cpu(lep->hashval) == args->hashval;
                                lep++, index++) {
                if (be32_to_cpu(lep->address) == XFS_DIR2_NULL_DATAPTR)
                        continue;
                newdb = xfs_dir2_dataptr_to_db(mp, be32_to_cpu(lep->address));
                if (newdb != curdb) {


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
