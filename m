Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B72D57F4E
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2014 13:26:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A4553304062
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2014 11:26:58 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id bOC9ZLMT9HTtq9Bu for <xfs@oss.sgi.com>;
	Wed, 26 Nov 2014 11:26:56 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 5842F6565094
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2014 13:26:56 -0600 (CST)
Message-ID: <5476297F.8080304@sandeen.net>
Date: Wed, 26 Nov 2014 13:26:55 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: no quota output if no usage?
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

This seems a bit weird:

# xfs_quota -x -c 'quota -p project1' /mnt/test
#

Huh, did it work?

# xfs_quota -x -c 'quota -pv project1' /mnt/test
Disk quotas for Project project1 (1)
Filesystem              Blocks      Quota      Limit  Warn/Time      Mounted on
/dev/sdc2                    0    1024000    1228800   00 [--------] /mnt/test
#

Oh, ok!

I don't know why reporting limits should depend on the verbose flag, but it
has been that way since 2005 in quota_mount() :

        if (!(flags & VERBOSE_FLAG)) {
                count = 0;
                if ((form & XFS_BLOCK_QUOTA) && d.d_bcount)
                        count++;
                if ((form & XFS_INODE_QUOTA) && d.d_icount)
                        count++;
                if ((form & XFS_RTBLOCK_QUOTA) && d.d_rtbcount)
                        count++;
                if (!count)
                        return 0;
        }

I'm inclined to change it, but is it OK to change the output of this - might old
scripts be relying on this (odd) silent behavior?  I think it can certainly cause
confusion (as evidenced by at least one bug I'm looking at ...)

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
