Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CAC157F3F
	for <xfs@oss.sgi.com>; Fri, 21 Nov 2014 15:42:51 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A91778F8039
	for <xfs@oss.sgi.com>; Fri, 21 Nov 2014 13:42:48 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id PORx0I7jW83ch1Ql (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 21 Nov 2014 13:42:47 -0800 (PST)
Date: Fri, 21 Nov 2014 16:42:45 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] fs: split update_time() into update_time() and
	write_time()
Message-ID: <20141121214245.GG7112@thunk.org>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
	<1416599964-21892-2-git-send-email-tytso@mit.edu>
	<1416600528.24312.10@mail.thefacebook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1416600528.24312.10@mail.thefacebook.com>
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
To: Chris Mason <clm@fb.com>
Cc: linux-fsdevel@vger.kernel.org, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Out of curiosity, why does btrfs_update_time() need to call
btrfs_root_readonly()?  Why can't it just depend on the
__mnt_want_write() call in touch_atime()?

Surely if there are times when it's not OK to write into a btrfs file
system and mnt_is_readonly() returns false, the VFS is going to get
very confused abyway.

If the btrfs_update_time() is not necessary, then we could drop
btrfs_update_time() and update_time() from the inode operations
entirely, and depend on the VFS-level code in update_time().

	      	     	    	      	   - Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
