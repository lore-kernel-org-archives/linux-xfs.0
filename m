Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1RNV0VL096768 for <xfs@oss.sgi.com>; Sun, 27 Feb 2011 17:31:00 -0600
Received: from test.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 242EE1314790
	for <xfs@oss.sgi.com>; Sun, 27 Feb 2011 15:33:47 -0800 (PST)
Received: from test.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id o2GxuScE6SSgA4fC for
	<xfs@oss.sgi.com>; Sun, 27 Feb 2011 15:33:47 -0800 (PST)
Date: Sun, 27 Feb 2011 17:49:40 -0500
From: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] Check for immutable flag in fallocate path
Message-ID: <20110227224940.GL2924@thunk.org>
References: <4D6221B8.9040303@gmail.com> <20110221124635.GA5525@infradead.org>
	<AANLkTi=bJBeR0m3xuGX_9YZPqRFuMY=bKoxZEWJt37=M@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTi=bJBeR0m3xuGX_9YZPqRFuMY=bKoxZEWJt37=M@mail.gmail.com>
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
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: cluster-devel@redhat.com, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Mon, Feb 21, 2011 at 05:50:21PM +0100, Marco Stornelli wrote:
> 2011/2/21 Christoph Hellwig <hch@infradead.org>:
> > On Mon, Feb 21, 2011 at 09:26:32AM +0100, Marco Stornelli wrote:
> >> From: Marco Stornelli <marco.stornelli@gmail.com>
> >>
> >> All fs must check for the immutable flag in their fallocate callback.
> >> It's possible to have a race condition in this scenario: an application
> >> open a file in read/write and it does something, meanwhile root set the
> >> immutable flag on the file, the application at that point can call
> >> fallocate with success. Only Ocfs2 check for the immutable flag at the
> >> moment.
> >
> > Please add the check in fs/open.c:do_fallocate() so that it covers all
> > filesystems.
> >
> >
> 
> The check should be done after the fs got the inode mutex lock.

Why?  None of the other places which check the IMMUTABLE flag do so
under the inode mutex lock.  Yes, it's true that we're not properly
doing proper locking when updating i_flags from the ioctl (this is
true for all file systems), but this has been true for quite some
time, and using a mutex to protect bit set/clear/test operations would
be like using a sledgehammer to kill a fly.

A proper fix if we want to be completely correct about updates to
i_flags would involve using test_bit, set_bit, and clear_bit, which is
guaranteed to be atomic.  This is how we update the
ext4_inode_info->i_flags (which is different from inode->i_flags) (see
the definition and use of EXT4_INODE_BIT_FNS in fs/ext4/ext4.h).

At some point, it would be good to fix how we set/get i_flags values,
but that's independent of the change that's being discussed here.

    	   	       	      	     	    	  - Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
