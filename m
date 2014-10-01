Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0347F7F81
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 04:45:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C638A30406B
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 02:45:46 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id hWYuAog7beMPKxIc (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Oct 2014 02:45:41 -0700 (PDT)
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 5A4C7AC39
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 09:45:39 +0000 (UTC)
Date: Wed, 1 Oct 2014 11:45:39 +0200
From: Jan Kara <jack@suse.cz>
Subject: xfstests test xfs/030 failure
Message-ID: <20141001094539.GD17405@quack.suse.cz>
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

  Hello,

  I'm getting failure for text xfs/030 like:
xfs/030 9s ... - output mismatch (see /var/lib/xfstests/results//xfs/030.out.bad)
    --- tests/xfs/030.out       2014-09-30 19:36:53.000000000 +0200
    +++ /var/lib/xfstests/results//xfs/030.out.bad      2014-09-30 22:11:38.000000000 +0200
    @@ -39,8 +39,8 @@
             - traversal finished ...
             - moving disconnected inodes to lost+found ...
     Phase 7 - verify and correct link counts...
    -Note - stripe unit (0) and width (0) fields have been reset.
    -Please set with mount -o sunit=<value>,swidth=<value>
    +Note - stripe unit (0) and width (0) were copied from a backup superblock.
    +Please reset with mount -o sunit=<value>,swidth=<value> if necessary
    ...
    (Run 'diff -u tests/xfs/030.out /var/lib/xfstests/results//xfs/030.out.bad'  to see the entire diff)

  Now obviously this is because I run xfsprogs 3.2.1 but xfstests have
message from older version of xfsprogs. What is a standard solution for
this? If I just replace the messages, then people with older xfsprogs will
see failures. So some kind of a filter?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
