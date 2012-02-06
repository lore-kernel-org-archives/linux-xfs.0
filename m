Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q16JtrJ0161341 for <xfs@oss.sgi.com>; Mon, 6 Feb 2012 13:55:53 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	jbi0PW28tAROkLhw (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 Feb 2012 11:55:50 -0800 (PST)
Date: Mon, 6 Feb 2012 14:55:47 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] filemap: don't call generic_write_sync for
	-EIOCBQUEUED
Message-ID: <20120206195546.GA22640@infradead.org>
References: <1327698949-12616-1-git-send-email-jmoyer@redhat.com>
	<1327698949-12616-4-git-send-email-jmoyer@redhat.com>
	<20120202175219.GB6640@quack.suse.cz>
	<x497gzzrkfa.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <x497gzzrkfa.fsf@segfault.boston.devel.redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Mon, Feb 06, 2012 at 11:33:29AM -0500, Jeff Moyer wrote:
> > code, right? Before that we'd drain the IO queue when cache flush is issued
> > and thus effectively wait for IO completion...
> 
> Right, though hch seems to think even then the problem existed.

I was wrong, using -o barrier it didn't.  That was however not something
people using O_SYNC heavy production loads would do, they'd use disabled
caches and nobarrier.

> > Also I was thinking whether we couldn't implement the fix in VFS. Basically
> > it would be the same like the fix for ext4. Like having a per-sb workqueue
> > and queue work calling generic_write_sync() from end_io handler when the
> > file is O_SYNC? That would solve the issue for all filesystems...
> 
> Well, that would require buy-in from the other file system developers.
> What do the XFS folks think?

I don't think using that code for XFS makes sene.  But just like
generic_write_sync there's no reason it can't be added to generic code,
just make sure only generic_file_aio_write/__generic_file_aio_write use
it, but generic_file_buffered_write and generic_file_direct_write stay
clear of it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
