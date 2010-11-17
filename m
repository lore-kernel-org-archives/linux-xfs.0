Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAH6UmHP196229 for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 00:30:49 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 40C2A13C7AA0
	for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 22:32:21 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dEP3C2bSdefWVqLv for
	<xfs@oss.sgi.com>; Tue, 16 Nov 2010 22:32:21 -0800 (PST)
Date: Wed, 17 Nov 2010 01:31:26 -0500
From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 4/6] Ext4: fail if we try to use hole punch
Message-ID: <20101117063125.GE5618@dhcp231-156.rdu.redhat.com>
References: <1289840723-3056-1-git-send-email-josef@redhat.com>
	<1289840723-3056-5-git-send-email-josef@redhat.com>
	<4CE2783F.1020004@redhat.com>
	<20101116125016.GA31957@dhcp231-156.rdu.redhat.com>
	<4CE28211.6060204@redhat.com> <20101117030640.GD3290@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101117030640.GD3290@thunk.org>
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
To: Ted Ts'o <tytso@mit.edu>, Avi Kivity <avi@redhat.com>, Josef Bacik <josef@redhat.com>, david@fromorbit.com, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com

On Tue, Nov 16, 2010 at 10:06:40PM -0500, Ted Ts'o wrote:
> > >There is no simple way to test if a filesystem supports hole punching or not so
> > >the check has to be done per fs.  Thanks,
> > 
> > Could put a flag word in superblock_operations.  Filesystems which
> > support punching (or other features) can enable it there.
> 
> No, it couldn't be in super_operations.  It may vary on a per-inode
> basis for some file systems, such as ext4 (depending on whether the
> inode is extent-mapped or indirect-block mapped).
> 
> So at least for ext4 we'd need to call into fallocate() function
> anyway, once we add support.  I suppose if other file systems really
> want it, we could add a flag to the super block ops structure, so they
> don't have do the "do we support the punch" operation.  I can go
> either way on that; although if we think the majority of file systems
> are going support punch in the long-term, then it might not be worth
> it to add such a flag.
>

Yeah thats alot of extra code just for one part of fallocate.  Calling into
->fallocate is perfectly reasonable, especially since ext4 works the way it
does, I'm going to leave things as they are.  Thanks,

Josef 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
