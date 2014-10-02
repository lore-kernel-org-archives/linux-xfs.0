Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6ABE27F76
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 21:06:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 150E6AC003
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 19:06:36 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id GhGhyUoz929rOW8q (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Oct 2014 19:06:35 -0700 (PDT)
Date: Wed, 1 Oct 2014 22:06:33 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Fix mmap data corruption when blocksize <
	pagesize
Message-ID: <20141002020633.GB16766@thunk.org>
References: <1411648916-16773-1-git-send-email-jack@suse.cz>
	<1411648916-16773-3-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1411648916-16773-3-git-send-email-jack@suse.cz>
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
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Thu, Sep 25, 2014 at 02:41:56PM +0200, Jan Kara wrote:
> Use truncate_isize_extended() when hole is being created in a file so that
> ->page_mkwrite() will get called for the partial tail page if it is
> mmaped (see the first patch in the series for details).
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied to the ext4 tree, thanks.

					- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
