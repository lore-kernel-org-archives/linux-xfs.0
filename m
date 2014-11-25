Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ADB777F3F
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 10:03:01 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7F1088F8064
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 08:02:58 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 4jU4cEJcRBXEIEUg (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2014 08:02:57 -0800 (PST)
Date: Tue, 25 Nov 2014 17:02:56 +0100
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH-v3 6/6] btrfs: add an is_readonly() so btrfs can use
	common code for update_time()
Message-ID: <20141125160256.GH26471@twin.jikos.cz>
References: <1416893674-419-1-git-send-email-tytso@mit.edu>
	<1416893674-419-7-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1416893674-419-7-git-send-email-tytso@mit.edu>
Reply-To: dsterba@suse.cz
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>

On Tue, Nov 25, 2014 at 12:34:34AM -0500, Theodore Ts'o wrote:
> The only reason btrfs cloned code from the VFS layer was so it could
> add a check to see if a subvolume is read-ony.  Instead of doing that,
> let's add a new inode operation which allows a file system to return
> an error if the inode is read-only, and use that in update_time().
> There may be other places where the VFS layer may want to know that
> btrfs would want to treat an inode is read-only.
> 
> With this commit, there are no remaining users of update_time() in the
> inode operations structure, so we can remove it and simply things
> further.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: linux-btrfs@vger.kernel.org

Reviewed-by: David Sterba <dsterba@suse.cz>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
