Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8521B29E06
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 16:58:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 61CDC304059
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 14:58:43 -0700 (PDT)
Received: from exprod7og125.obsmtp.com (exprod7og125.obsmtp.com [64.18.2.28])
	by cuda.sgi.com with SMTP id 0lVhZ05bWlDF4hUB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 May 2013 14:58:41 -0700 (PDT)
Message-ID: <5194050B.7010401@genband.com>
Date: Wed, 15 May 2013 15:58:35 -0600
From: Chris Friesen <chris.friesen@genband.com>
MIME-Version: 1.0
Subject: any way to work backwards from xfs_inode_t to a filename?
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, xfs@oss.sgi.com


Hi all,

As I mentioned before I'm digging into some intermittent xfs corruption 
issues on an embedded system running a 2.6.27-based kernel.

In one case I've hit XFS_WANT_CORRUPTED_GOTO in xfs_free_ag_extent(). 
In this particular case the call chain was

xfs_free_ag_extent+0x55d/0x6e0
xfs_free_extent+0xac/0xd0
xfs_bmap_finish+0x156/0x1a0
xfs_itruncate_finish+0x137/0x340
xfs_inactive+0x386/0x4b0
xfs_fs_clear_inode+0xc6/0x120
clear_inode+0x58/0x110
generic_delete_inode+0xff/0x110
generic_drop_inode+0x16d/0x190
iput+0x5d/0x70
do_unlinkat+0x147/0x280
sys_unlinkat+0x1d/0x40

I have two questions:

1) do_unlinkat() has the filesystem path, but iput() returns void.  Is 
there any way for me to add instrumentation to xfs_inactive() to work 
backwards from the xfs_inode_t pointer to print out a path to the file 
being deleted?

2) If this sort of corruption happens again, what's my best bet for 
figuring out the source of the problem?  This is an embedded system, so 
I need to be able to automate any data gathering (after which we'll run 
xfs_repair so we can return to service--any manual analysis will need to 
happen later based on stored data).

Thanks,
Chris



-- 

Chris Friesen
Software Designer
www.genband.com
office:+1.343.883.2717

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
