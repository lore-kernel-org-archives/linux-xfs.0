Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D1BE47F4E
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2014 09:25:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B12288F8049
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2014 07:25:07 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 2wg4NWhe4I50FKgT (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 27 Nov 2014 07:25:06 -0800 (PST)
Date: Thu, 27 Nov 2014 07:25:04 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH-v4 1/7] vfs: split update_time() into update_time() and
	write_time()
Message-ID: <20141127152504.GA15839@infradead.org>
References: <1416997437-26092-1-git-send-email-tytso@mit.edu>
	<1416997437-26092-2-git-send-email-tytso@mit.edu>
	<20141126192328.GA20436@infradead.org>
	<20141127123429.GD30152@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141127123429.GD30152@quack.suse.cz>
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
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>

On Thu, Nov 27, 2014 at 01:34:29PM +0100, Jan Kara wrote:
>   But Ted changed XFS to copy timestamps to on-disk structure from the
> in-memory inode fields after VFS updated the timestamps. So the stamps
> should be coherent AFAICT, shouldn't they?

Not coherent enough.  We need the XFS ilock to synchronize reading from
and writing to the time stamps.  update_time() only has i_mutex, which
we can't take for the transaction commit path.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
