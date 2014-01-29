Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D34A67F7C
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 15:38:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B24F78F8052
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 13:38:50 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id pdGMqycZV7kL1VVu (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Jan 2014 13:38:48 -0800 (PST)
Date: Wed, 29 Jan 2014 16:38:38 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] xfstests: avoid ext4/306 failures caused by incompatible
	mount options
Message-ID: <20140129213838.GF30419@thunk.org>
References: <20140129204502.GC2165@wallace>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140129204502.GC2165@wallace>
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
To: Eric Whitney <enwlinux@gmail.com>
Cc: linux-ext4@vger.kernel.org, esandeen@redhat.com, xfs@oss.sgi.com

On Wed, Jan 29, 2014 at 03:45:02PM -0500, Eric Whitney wrote:
> ext4/306 will fail when mounting the ext3 file system it creates if an
> ext3-incompatible mount option is applied by _scratch_mount.  This can
> happen if EXT_MOUNT_OPTIONS is defined appropriately in the test
> environment.  For example, the block_validity option is commonly used
> to enhance ext4 testing, and it is not supported by ext3.  Fix this by
> not including any mount options defined by the test environment.

I'm not sure I understand why the test is insisting that the file
system be mounted using ext3.  If the file system is created without
the extents flag, all of the files will be created using indirect
blocks, and fundamentally what this test is getting at is that after
we grow the file system using resize2fs, the new blocks are available
to be allocated and attached to an indirect block file.

We can do this by using ext4; I'm not sure why this test is trying to
use ext3 to set up the test flie system.  It might be better to get
rid of the requirement to create the file system using ext3, since it
will make the test runnable even if the ext3 file system hasn't been
configured into the system and CONFIG_EXT23_AS_EXT4 is not enabled.

IIRC, Eric Sandeen wrote this test --- Eric, am I missing some reason
why it was necessary to use ext3 here?

					- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
