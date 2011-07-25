Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6PEl3CT006327 for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 09:47:03 -0500
Subject: Re: [PATCH v3] xfs_repair: Check if agno is inside the filesystem
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <alpine.LFD.2.00.1107251604580.9742@dhcp-27-109.brq.redhat.com>
References: <1309271164-29794-1-git-send-email-lczerner@redhat.com>
	<1310742423.2921.17.camel@doink>
	<alpine.LFD.2.00.1107251604580.9742@dhcp-27-109.brq.redhat.com>
Date: Mon, 25 Jul 2011 09:45:47 -0500
Message-ID: <1311605147.2914.10.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, 2011-07-25 at 16:06 +0200, Lukas Czerner wrote:
> On Fri, 15 Jul 2011, Alex Elder wrote:
> 
> > On Tue, 2011-06-28 at 16:26 +0200, Lukas Czerner wrote:
> > > When getting an inode tree pointer from an array inode_tree_ptrs, we
> > > should check if agno, which is used as a pointer to the array, lives
> > > within the file system, because if it is not, we can end up touching
> > > uninitialized memory. This may happen if we have corrupted directory
> > > entry.
> > > 
> > > This commit fixes it by passing xfs_mount to affected functions and
> > > checking if agno really is inside the file system.
> > > 
> > > This solves Red Hat bug #694706
> > > 
> > > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > 
> > OK, it looks like there are basically four changes
> > here--adding the mount point argument to four functions
> > and using it to verify (or assert the validity of) the
> > an AG number.  The rest of the changes are simply the
> > rippling-back effect of adding the mount point.
> > 
> > The change looks good to me.  If nobody else objects to
> > the change I will commit this for you.
> > 
> > Reviewed-by: Alex Elder <aelder@sgi.com>
> 
> Thanks Alex!
> 
> I still can not see it in the git though, so what is the status of this
> patch ?

Sorry about that, I missed this one when I committed some
things last week.  I'll get it in this week, likely today.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
