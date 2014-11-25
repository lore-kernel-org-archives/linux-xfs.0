Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4847D7F3F
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 09:51:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 28DF98F8071
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 07:51:43 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id Y9PnCCmw9JSJqH03 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2014 07:51:42 -0800 (PST)
Date: Tue, 25 Nov 2014 16:51:41 +0100
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 1/4] fs: split update_time() into update_time() and
	write_time()
Message-ID: <20141125155141.GF26471@twin.jikos.cz>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
	<1416599964-21892-2-git-send-email-tytso@mit.edu>
	<20141124152101.GA12575@infradead.org>
	<20141124173430.GB26471@twin.jikos.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141124173430.GB26471@twin.jikos.cz>
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
To: dsterba@suse.cz, Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com, linux-btrfs@vger.kernel.org

On Mon, Nov 24, 2014 at 06:34:30PM +0100, David Sterba wrote:
> The btrfs_root_readonly checks in setxattr and removexattr are
> unnecessary because they're done through xattr_permisssion. I'll send a
> patch to remove them.

Does not work because the security.* and system.* namespaces do not call
the permission() hook, so no patch. However, if the proposed
inode_is_readonly callback is merged, we can replace the btrfs-specific
checks with is_readonly check in xattr_permission().

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
