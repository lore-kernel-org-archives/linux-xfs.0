Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 595D57F4E
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 16:13:58 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EB4DCAC009
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 14:13:54 -0800 (PST)
Received: from fieldses.org (fieldses.org [174.143.236.118]) by cuda.sgi.com
	with ESMTP id M4h0i0Ji4zONsUqg (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Nov 2014 14:11:47 -0800 (PST)
Date: Mon, 24 Nov 2014 17:11:45 -0500
Subject: Re: [PATCH-v2 0/5] add support for a lazytime mount option
Message-ID: <20141124221145.GB24003@fieldses.org>
References: <1416675267-2191-1-git-send-email-tytso@mit.edu>
	<20141124090755.GA28534@infradead.org>
	<20141124115727.GA19918@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141124115727.GA19918@thunk.org>
From: "J. Bruce Fields" <bfields@fieldses.org>
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Nov 24, 2014 at 06:57:27AM -0500, Theodore Ts'o wrote:
> If we want to be paranoid, we handle i_version updates non-lazily; I
> can see arguments in favor of that.
> 
> Ext4 only enables MS_I_VERSION if the user asks for it explicitly, so
> it wouldn't cause me any problems.  However, xfs and btrfs enables it
> by default, so that means xfs and btrfs wouldn't see the benefits of
> lazytime (if you're going to have to push I_VERSION to disk, you might
> as well update the [acm]time while you're at it).  I've always thought
> that we *should* do is to only enable it if nfsv4 is serving the file
> system, and not otherwise, though, which would also give us
> consistency across all the file systems.

I guess you need to worry about the case where you shutdown nfsd, modify
a file, then restart nfsd--you don't want a client to miss the
modification in that case.

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
