Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2ICcb5i237296 for <xfs@oss.sgi.com>; Wed, 18 Mar 2009 07:38:58 -0500
Received: from smtp120.mail.mud.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 9821D1C4EEE1
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2009 05:37:56 -0700 (PDT)
Received: from smtp120.mail.mud.yahoo.com (smtp120.mail.mud.yahoo.com
	[209.191.84.77]) by cuda.sgi.com with SMTP id e5PEJnA0WgIp5L3n
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2009 05:37:56 -0700 (PDT)
From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: fput under mmap_sem
Date: Wed, 18 Mar 2009 23:37:48 +1100
References: <200903151459.01320.denys@visp.net.lb>
	<20090315221921.GY26138@disturbed>
	<20090318071313.GA30011@infradead.org>
In-Reply-To: <20090318071313.GA30011@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903182337.48789.nickpiggin@yahoo.com.au>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-mm@kvack.org, xfs@oss.sgi.com

On Wednesday 18 March 2009 18:13:13 Christoph Hellwig wrote:
> On Mon, Mar 16, 2009 at 09:19:21AM +1100, Dave Chinner wrote:
> > This is a VM problem where it calls fput() with the mmap_sem() held
> > in remove_vma(). It makes the incorrect assumption that filesystems
> > will never use the same lock in the IO path and the inode release path.
> >
> > This can deadlock if you are really unlucky.
>
> I really wonder why other filesystems haven't hit this yet.  Any chance
> we can get the fput moved out of mmap_sem to get rid of this class of
> problems?

Yes I don't think there is any reason against holding the file refcount
a little longer, but it can be pretty nasty to do in practice because
of deep call chains and sometimes multiple fputs within a given lock
section.

Possibly the easiest and quickest way will be to move aio's deferred
__fput into a usable API and try that. If there are any performance
problems, then we can try to move those fputs out from the mmap_sem
one at a time (eg. I don't expect fput for vma replacement/merging to
often cause the refcount to reach 0, and this is one of the harder
places; wheras fput for a simple munmap might be more often causing
refcount to reach 0 but it should be simpler to move out of mmap_sem
if it is a problem).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
