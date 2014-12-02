Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 123C97F54
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 11:55:57 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A2838AC004
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 09:55:53 -0800 (PST)
Received: from mail-qg0-f42.google.com (mail-qg0-f42.google.com
	[209.85.192.42]) by cuda.sgi.com with ESMTP id 7riVXvWaYEzq5bWG
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Dec 2014 09:55:51 -0800 (PST)
Received: by mail-qg0-f42.google.com with SMTP id z107so9867656qgd.29
	for <xfs@oss.sgi.com>; Tue, 02 Dec 2014 09:55:50 -0800 (PST)
Message-ID: <547DFD24.9070805@plexistor.com>
Date: Tue, 02 Dec 2014 19:55:48 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH-v5 1/5] vfs: add support for a lazytime mount option
References: <1417154411-5367-1-git-send-email-tytso@mit.edu>
	<1417154411-5367-2-git-send-email-tytso@mit.edu>
	<20141128172323.GD738@quack.suse.cz>
	<20141128181421.GA19461@google.com>
	<20141202125820.GE9092@quack.suse.cz>
In-Reply-To: <20141202125820.GE9092@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>, Ted Ts'o <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 12/02/2014 02:58 PM, Jan Kara wrote:
> On Fri 28-11-14 13:14:21, Ted Tso wrote:
>> On Fri, Nov 28, 2014 at 06:23:23PM +0100, Jan Kara wrote:
>>> Hum, when someone calls fsync() for an inode, you likely want to sync
>>> timestamps to disk even if everything else is clean. I think that doing
>>> what you did in last version:
>>> 	dirty = inode->i_state & I_DIRTY_INODE;
>>> 	inode->i_state &= ~I_DIRTY_INODE;
>>> 	spin_unlock(&inode->i_lock);
>>> 	if (dirty & I_DIRTY_TIME)
>>> 		mark_inode_dirty_sync(inode);
>>> looks better to me. IMO when someone calls __writeback_single_inode() we
>>> should write whatever we have...
>>
>> Yes, but we also have to distinguish between what happens on an
>> fsync() versus what happens on a periodic writeback if I_DIRTY_PAGES
>> (but not I_DIRTY_SYNC or I_DIRTY_DATASYNC) is set.  So there is a
>> check in the fsync() code path to handle the concern you raised above.
>   Ah, this is the thing you have been likely talking about but which I was
> constantly missing in my thoughts. You don't want to write times when inode
> has only dirty pages and timestamps - 

This I do not understand. I thought that I_DIRTY_TIME, and the all
lazytime mount option, is only for atime. So if there are dirty
pages then there are also m/ctime that changed and surly we want to
write these times to disk ASAP.

if we are lazytime also with m/ctime then I think I would like an
option for only atime lazy. because m/ctime is cardinal to some
operations even though I might want atime lazy.

Sorry for the slowness, I'm probably missing something
Thanks
Boaz

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
