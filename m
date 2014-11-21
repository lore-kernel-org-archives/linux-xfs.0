Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0BB0D7F3F
	for <xfs@oss.sgi.com>; Fri, 21 Nov 2014 15:37:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EDFDB304051
	for <xfs@oss.sgi.com>; Fri, 21 Nov 2014 13:37:01 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id bVkkGCCPJW2AM4FT (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 21 Nov 2014 13:36:57 -0800 (PST)
Date: Fri, 21 Nov 2014 16:36:51 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/4] vfs: don't let the dirty time inodes get more than a
	day stale
Message-ID: <20141121213651.GF7112@thunk.org>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
	<1416599964-21892-4-git-send-email-tytso@mit.edu>
	<B1759DB3-7D86-499B-BE09-34D9927C75C8@dilger.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <B1759DB3-7D86-499B-BE09-34D9927C75C8@dilger.ca>
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
To: Andreas Dilger <adilger@dilger.ca>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, Nov 21, 2014 at 02:19:07PM -0600, Andreas Dilger wrote:
> > -	if (inode->i_sb->s_flags & MS_LAZYTIME) {
> > +	if ((inode->i_sb->s_flags & MS_LAZYTIME) &&
> > +	    (!inode->i_ts_dirty_day ||
> > +	     inode->i_ts_dirty_day == days_since_boot)) {
> > 		spin_lock(&inode->i_lock);
> > 		inode->i_state |= I_DIRTY_TIME;
> > 		spin_unlock(&inode->i_lock);
> > +		inode->i_ts_dirty_day = days_since_boot;
> 
> It isn't clear if this is correct.  It looks like the condition will
> only be entered if i_ts_dirty_day == days_since_boot, but that is only
> set inside the condition?

If i_ts_dirty_day is zero, the timestamps don't have to written to
disk.  This is either because the inode has been written to disk, or
the system has been up for less than a day, such that when we last a
lazy mtime update (i.e., we skipped the call to mark_inode_dirty)
since jiffies / (HZ * 86400) was zero.

If it is non-zero, then the timestamps were updated but were not sent
to disk N days since the system was booted.  So long as it remains N
days since the system was booted, we can skip calling
mark_inode_dirty().  But once it becomes N+1 days since the system was
booted, then we will call mark_inode_dirty() and set i_ts_dirty_day to
zero.

I'll add a comment so it's a bit more obvious what we're doing here,
but I'm pretty sure we currently have is in fact correct.

> and "days_since_boot" should be declared unsigned short so it wraps
> in the same way as i_ts_dirty_day

Good point, thanks.  This will only be an issue after the system has
been up for almost 90 years, but we might as well get it right,

     	    	      	     	    	  - Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
