Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 63E5F7F55
	for <xfs@oss.sgi.com>; Sat,  6 Apr 2013 16:50:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4570D304039
	for <xfs@oss.sgi.com>; Sat,  6 Apr 2013 14:50:55 -0700 (PDT)
Date: Sat, 6 Apr 2013 22:50:33 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 2/4] fsfreeze: manage kill signal when sb_start_write is
	called
Message-ID: <20130406215033.GM4068@ZenIV.linux.org.uk>
References: <515FF344.8040705@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <515FF344.8040705@gmail.com>
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
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Chris Mason <chris.mason@fusionio.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alasdair G Kergon <agk@redhat.com>, linux-cifs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-ext4@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, fuse-devel@lists.sourceforge.net, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Joel Becker <jlbec@evilplan.org>, Anton Altaparmakov <anton@tuxera.com>, Alex Elder <elder@kernel.org>, Theodore Ts'o <tytso@mit.edu>, linux-ntfs-dev@lists.sourceforge.net, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>, ocfs2-devel@oss.oracle.com, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-btrfs@vger.kernel.org

On Sat, Apr 06, 2013 at 12:04:52PM +0200, Marco Stornelli wrote:
> In every place where sb_start_write was called now we must manage
> the error code and return -EINTR.

Now go and look for callers of mnt_want_write() ;-/  The really
painful one is in do_last(), but kern_path_create() is not much
better; mq_open() would be bad too, had it not been about something
you are not going to freeze anyway...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
