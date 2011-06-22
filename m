Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5MFPiX1099428 for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 10:25:45 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6843BDFB3D8
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 08:25:44 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id mG8QFH6STAmcNZhk for <xfs@oss.sgi.com>;
	Wed, 22 Jun 2011 08:25:44 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 737524964601
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 10:25:43 -0500 (CDT)
Message-ID: <4E020977.9080000@sandeen.net>
Date: Wed, 22 Jun 2011 10:25:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: duplicate code in dir2
References: <4E020912.9020106@sandeen.net>
In-Reply-To: <4E020912.9020106@sandeen.net>
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

Another interesting chunk elsewhere:

/src/git/linux-2.6/fs/xfs/xfs_da_btree.c(782)
/src/git/linux-2.6/fs/xfs/xfs_attr_leaf.c(1542)
                *action = 0;
                return(0);
        if (count == 0) {
                forward = (info->forw != 0);
                memcpy(&state->altpath, &state->path, sizeof(state->path));
                error = xfs_da_path_shift(state, &state->altpath, forward,
                                                 0, &retval);
                if (error)
                        return(error);
                if (retval) {
                        *action = 0;
                } else {
                        *action = 2;
                return(0);
        forward = (be32_to_cpu(info->forw) < be32_to_cpu(info->back));
        for (i = 0; i < 2; forward = !forward, i++) {
                if (forward)
                        blkno = be32_to_cpu(info->forw);
                else
                        blkno = be32_to_cpu(info->back);
                if (blkno == 0)
                        continue;
                error = xfs_da_read_buf(state->args->trans, state->args->dp,

/src/git/linux-2.6/fs/xfs/xfs_da_btree.c(842)
/src/git/linux-2.6/fs/xfs/xfs_attr_leaf.c(1605)
                        break;
        if (i >= 2) {
                *action = 0;
                return(0);
        memcpy(&state->altpath, &state->path, sizeof(state->path));
        if (blkno < blk->blkno) {
                error = xfs_da_path_shift(state, &state->altpath, forward,
                                                 0, &retval);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
