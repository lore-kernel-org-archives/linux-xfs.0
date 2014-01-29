Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E0C647F7C
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 16:31:16 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7F563AC007
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 14:31:13 -0800 (PST)
Received: from mail-ob0-f172.google.com (mail-ob0-f172.google.com
	[209.85.214.172]) by cuda.sgi.com with ESMTP id
	ifJJXJFo761pkZMK (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Jan 2014 14:31:09 -0800 (PST)
Received: by mail-ob0-f172.google.com with SMTP id vb8so2693683obc.17
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 14:31:08 -0800 (PST)
Message-ID: <52E98124.5060808@gmail.com>
Date: Wed, 29 Jan 2014 17:31:00 -0500
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [NOISE] merge window blues, XFS broken
References: <52E56386.5040802@gmail.com> <20140127015614.GD2212@dastard>
	<52E62ADA.2040800@gmail.com> <20140127233039.GF2212@dastard>
	<52E768CF.5040908@gmail.com> <20140128095559.GJ2212@dastard>
In-Reply-To: <20140128095559.GJ2212@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 01/28/2014 04:55 AM, Dave Chinner wrote:
> Ok, so xfs_inode_item_format+0x4a is inside the very first call to
> preapre the ilf structure. That tells us that the initial
> xfs_log_vec/xfs_log_iovec array are resulting in an unaligned
> buffer.
> 
> Can you try the patch below, Michael?
> 
> Cheers,
> 
> Dave.

To the best of my knowledge, it works fine.  It was subjected to some
of the xfstests xfs/* and generic/* series along with some of the
"log" group.  In addition, it was run through fs_mark and a homebrew
benchmark idea of running a ( make clean; make ) loop for the kernel
while two fsx processes were running.  This was for default (4k, 
internal logdev) v5-superblock XFS filesystems. v4-superblock XFS 
went through similar testing, to a lesser degree.

I did not know about a message like "log buf needs to be larger than
stripe size" on tests that require v2 logs.  [xfs/087 might be one of
those tests.]  This was also the case for the test-patch that padded
the structs directly, and this might be an old message.

At the very least, I'm keeping this patch.  Your approach to the
solution looks cool.  Basically, you're stating that you can have
either xfs_log_vec or xfs_log_iovec in there, and no matter what
their size, they get aligned in the log, correct?

Thanks!

Michael


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
