Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 May 2008 02:28:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4D9S4Ru016296
	for <xfs@oss.sgi.com>; Tue, 13 May 2008 02:28:08 -0700
Date: Tue, 13 May 2008 05:28:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Jfs-discussion] Unneeded kernel threads (xfs, jfs, gfs2)
Message-ID: <20080513092851.GA19879@infradead.org>
References: <4828CAC6.3090402@unixsol.org> <48292742.8090409@sgi.com> <482951C3.60600@unixsol.org> <20080513090311.GZ155679365@sgi.com> <20080513092156.GA26736@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080513092156.GA26736@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Georgi Chorbadzhiyski <gf@unixsol.org>, cluster-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jfs-discussion@lists.sourceforge.net, Donald Douwsma <donaldd@sgi.com>, xfs@oss.sgi.com

On Tue, May 13, 2008 at 05:21:56AM -0400, Christoph Hellwig wrote:
> Well, we could refcount the number of active xfs instances and
> start/stop the global threads based on that.  Not really worth my
> time IHMO, but if someone comes up with a clean enough patch it should
> go in.

Actually doing it in the VFS might be even better.  Add ->init and
->exit methods to struct file_system_type and then the filesystems can
move most of module_init/exit into the new methods.
