Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8QD9aAh238827 for <xfs@oss.sgi.com>; Sat, 26 Sep 2009 08:09:38 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7FAF9B81CCA
	for <xfs@oss.sgi.com>; Sat, 26 Sep 2009 06:10:55 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 6JFcsrOItn3ZWiq7 for
	<xfs@oss.sgi.com>; Sat, 26 Sep 2009 06:10:55 -0700 (PDT)
Date: Sat, 26 Sep 2009 09:10:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: mmap vs mtime in 2.6.26 and up
Message-ID: <20090926131043.GA25204@infradead.org>
References: <20090518114305.GA6303@infradead.org>
	<87vdj742dt.fsf@tac.ki.iif.hu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87vdj742dt.fsf@tac.ki.iif.hu>
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
To: Ferenc Wagner <wferi@niif.hu>
Cc: Peter Staubach <staubach@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>, Ray Lee <ray-lk@madrabbit.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>

On Fri, Sep 25, 2009 at 02:47:42PM +0200, Ferenc Wagner wrote:
> I added some fresh test results to
> http://bugzilla.kernel.org/show_bug.cgi?id=2645.  In short, under
> 2.6.30-rc8 the test program reports full failure on XFS and RAMFS,
> full success on EXT3, VFAT and ReiserFS, and mixed results on TMPFS:

There's a patch queued up for inclusion in 2.6.32 to work around this
issue in XFS.  The lack of a proper callout from the VFS still makes
this a much less than ideal solution.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
