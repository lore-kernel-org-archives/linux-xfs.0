Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E15737F3F
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 10:00:20 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C06BE8F8065
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 08:00:20 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id R2NiMT4uvMYLK5zw (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2014 08:00:19 -0800 (PST)
Date: Tue, 25 Nov 2014 17:00:18 +0100
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH-v3 1/6] fs: split update_time() into update_time() and
	write_time()
Message-ID: <20141125160018.GG26471@twin.jikos.cz>
References: <1416893674-419-1-git-send-email-tytso@mit.edu>
	<1416893674-419-2-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1416893674-419-2-git-send-email-tytso@mit.edu>
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

On Tue, Nov 25, 2014 at 12:34:29AM -0500, Theodore Ts'o wrote:
> In preparation for adding support for the lazytime mount option, we
> need to be able to separate out the update_time() and write_time()
> inode operations.  Currently, only btrfs and xfs uses update_time().
> 
> We needed to preserve update_time() because btrfs wants to have a
> special btrfs_root_readonly() check; otherwise we could drop the
> update_time() inode operation entirely.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: xfs@oss.sgi.com
> Cc: linux-btrfs@vger.kernel.org

For the btrfs changes

Acked-by: David Sterba <dsterba@suse.cz>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
