Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 60ADB7F4E
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2014 04:20:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4F19530404E
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2014 02:20:25 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id lUKfD2ZxvMP3WwR9 (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Nov 2014 02:20:20 -0800 (PST)
Date: Wed, 26 Nov 2014 05:20:17 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/4] vfs: don't let the dirty time inodes get more than a
	day stale
Message-ID: <20141126102017.GJ28449@thunk.org>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
	<1416599964-21892-4-git-send-email-tytso@mit.edu>
	<20141125015332.GE27262@dastard> <20141125044508.GG31339@thunk.org>
	<20141125234851.GB9561@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141125234851.GB9561@dastard>
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
Cc: linux-fsdevel@vger.kernel.org, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, Nov 26, 2014 at 10:48:51AM +1100, Dave Chinner wrote:
> No abuse necessary at all. Just a different inode_dirtied_after()
> check is requires if the inode is on the time dirty list in
> move_expired_inodes().

I'm still not sure what you have in mind here.  When would this be
checked?  It sounds like you want to set a timeout such that when an
inode which had its timestamps updated lazily 24 hours earlier, the
inode would get written out.  Yes?  But that implies something is
going to have to scan the list of inodes on the dirty time list
periodically.  When are you proposing that this take place?

The various approaches that come to mind all seem more complex than
what I have in this patch 3 of 4, and I'm not sure it's worth the
complexity.

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
