Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 235237F6F
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 21:06:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C1A34AC001
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 19:06:25 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id aPIDD8NLGOOhxVBy (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Oct 2014 19:06:23 -0700 (PDT)
Date: Wed, 1 Oct 2014 22:06:19 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] vfs: Fix data corruption when blocksize < pagesize
	for mmaped data
Message-ID: <20141002020619.GA16766@thunk.org>
References: <1411648916-16773-1-git-send-email-jack@suse.cz>
	<1411648916-16773-2-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1411648916-16773-2-git-send-email-jack@suse.cz>
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

On Thu, Sep 25, 2014 at 02:41:55PM +0200, Jan Kara wrote:
> ->page_mkwrite() is used by filesystems to allocate blocks under a page
> which is becoming writeably mmapped in some process' address space. This
> allows a filesystem to return a page fault if there is not enough space
> available, user exceeds quota or similar problem happens, rather than
> silently discarding data later when writepage is called.
> 
> However VFS fails to call ->page_mkwrite() in all the cases where
> filesystems need it when blocksize < pagesize. For example when
> blocksize = 1024, pagesize = 4096 the following is problematic:
>   ftruncate(fd, 0);
>   pwrite(fd, buf, 1024, 0);
>   map = mmap(NULL, 1024, PROT_WRITE, MAP_SHARED, fd, 0);
>   map[0] = 'a';       ----> page_mkwrite() for index 0 is called
>   ftruncate(fd, 10000); /* or even pwrite(fd, buf, 1, 10000) */
>   mremap(map, 1024, 10000, 0);
>   map[4095] = 'a';    ----> no page_mkwrite() called
> 
> At the moment ->page_mkwrite() is called, filesystem can allocate only
> one block for the page because i_size == 1024. Otherwise it would create
> blocks beyond i_size which is generally undesirable. But later at
> ->writepage() time, we also need to store data at offset 4095 but we
> don't have block allocated for it.
> 
> This patch introduces a helper function filesystems can use to have
> ->page_mkwrite() called at all the necessary moments.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied to the ext4 tree, thanks.

					- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
