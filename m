Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8528B7F3F
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 13:26:16 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 743828F8052
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 11:26:13 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id D7E1yUMpAjA8PRTZ (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2014 11:26:12 -0800 (PST)
Date: Tue, 25 Nov 2014 14:26:09 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/4] vfs: add support for a lazytime mount option
Message-ID: <20141125192609.GA28449@thunk.org>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
	<1416599964-21892-3-git-send-email-tytso@mit.edu>
	<20141125015239.GD27262@dastard> <20141125043335.GF31339@thunk.org>
	<20141125173040.GD3228@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141125173040.GD3228@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Nov 25, 2014 at 06:30:40PM +0100, Jan Kara wrote:
>   This would be possible and as Boaz says, it might be possible to reuse
> the same list_head in the inode for this. Getting rid of the full scan of
> all superblock inodes would be nice (as the scan gets really expensive for
> large numbers of inodes (think of i_sb_lock contention) and this makes it
> twice as bad) so I'd prefer to do this if possible.

Fair enough, I'll give this a try.  Personally, I've never been that
solicitous towards the efficiency of sync, since if you ever use it,
you tend to destroy performance just because of contention of the disk
drive head caused by the writeback, never mind the i_sb_lock
contention.  ("I am sync(2), the destroyer of tail latency SLO's...")

In fact there has sometimes been discussion about disabling sync(2)
from non-root users, because the opportunity for mischief when a
developer logs and types sync out of reflex is too high.  Of course,
if we ever did this, I'm sure such a patch would never be accepted
upstream, but that's OK, most people don't seem to care about tail
latency outside of Facebook and Google anyway....

					- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
