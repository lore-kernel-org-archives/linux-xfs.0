Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9A0037F56
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 15:01:44 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8864A8F8033
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 13:01:41 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id B1AufriIj7XxMCxO (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Dec 2014 13:01:40 -0800 (PST)
Date: Tue, 2 Dec 2014 16:01:19 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH-v5 1/5] vfs: add support for a lazytime mount option
Message-ID: <20141202210119.GD13618@thunk.org>
References: <1417154411-5367-1-git-send-email-tytso@mit.edu>
	<1417154411-5367-2-git-send-email-tytso@mit.edu>
	<20141128172323.GD738@quack.suse.cz>
	<20141128181421.GA19461@google.com>
	<20141202125820.GE9092@quack.suse.cz>
	<547DFD24.9070805@plexistor.com> <20141202192337.GA13618@thunk.org>
	<0CAF91FD-F713-4E98-8967-9CA0390CA784@dilger.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0CAF91FD-F713-4E98-8967-9CA0390CA784@dilger.ca>
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
Cc: Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Tue, Dec 02, 2014 at 01:37:27PM -0700, Andreas Dilger wrote:
> 
> One thing that comes to mind is touch/utimes()/utimensat().  Those
> should definitely not result in timestamps being kept only in memory
> for 24h, since the whole point of those calls is to update the times.
> It makes sense for these APIs to dirty the inode for proper writeout.

Not a problem.  Touch/utimes* go through notify_change() and
->setattr, so they won't go through the I_DIRTY_TIME code path.

	      	   	    	    	- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
