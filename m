Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 209D57F3F
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 07:30:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E63D98F8049
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 05:30:34 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id P7ddl7BMZlHSfzMd (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 09 Jan 2015 05:30:23 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t09DULdH019038
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Fri, 9 Jan 2015 08:30:22 -0500
Received: from sh-el6.eng.rdu2.redhat.com (sh-el6.eng.rdu2.redhat.com
	[10.10.160.69])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t09DUJO1009781
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 9 Jan 2015 08:30:21 -0500
Date: Fri, 9 Jan 2015 08:30:19 -0500
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: beginners project: RENAME_WHITEOUT
Message-ID: <20150109133019.GD28570@sh-el6.eng.rdu2.redhat.com>
References: <20141107190959.GB21021@infradead.org>
	<20141108234232.GJ28565@dastard>
	<CAJfpegsvZtCxV-GSJ4ON7=JeNkZ7o2=+fmbOTrxDAfm==b1XBw@mail.gmail.com>
	<20141110135249.GR28565@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141110135249.GR28565@dastard>
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
To: xfs@oss.sgi.com

So, giving this conversation, should we implement WHITEOUTS in XFS
already, or is this isn't decided yet?

Cheers.

On Tue, Nov 11, 2014 at 12:52:49AM +1100, Dave Chinner wrote:
> On Mon, Nov 10, 2014 at 10:25:40AM +0100, Miklos Szeredi wrote:
> > On Sun, Nov 9, 2014 at 12:42 AM, Dave Chinner <david@fromorbit.com> wrote:
> > > On Fri, Nov 07, 2014 at 11:09:59AM -0800, Christoph Hellwig wrote:
> > >> The overlayfs merge introduces a new rename flag to create to whiteouts.
> > >> Should be a fairly easy to implement.
> > >>
> > >> Miklos, do you have any good documentation and/or test cases for this?
> > >
> > > So overlayfs uses some weird char dev hack to implement whiteout
> > > inodes in directories?  Why do we need a whiteout inode on disk?
> > > what information is actually stored in the whiteout inode that
> > > overlayfs actually needs?  Only readdir and lookup care about
> > > whiteouts, and AFAICT nothing of the inode is ever used except
> > > checking the chrdev/whiteoutdev hack via ovl_is_whiteout(dentry).
> > >
> > > Indeed, whatever happened to just storing the whiteout in the dirent
> > > via DT_WHT and using that information on lookup in the lower
> > > filesystem to mark the dentry returned appropriately without needing
> > > to lookup a real inode?
> > 
> > The filesystem is free to implement whiteouts a dirent without an actual inode.
> 
> Sure, but overlayfs won't make use of it, so we'd have
> have to hack around overlayfs's ignorance of DT_WHT in several
> different places to do this. e.g.
> 
> 	- in mknod to intercept creation of magical whiteout chardevs
> 	- in readdir so we can convert them to DT_CHR so overlayfs
> 	  can detect them,
> 	- in ->lookup so we can create magical chardev inodes in
> 	  memory rather than try to read them from disk.
> 	- in rename we have to detect the magical chardev inodes so
> 	  we know it's a whiteout we are dealing with
> 
> This is difficult because overlayfs hard codes the definition of a
> whiteout into the VFS interface implementation as well as it's
> internal directory implementation. This leaves almost no room for
> anyone to optimise the back end implementation because the
> translation layers are complex and fiddly....
> 
> > But we do need at least an inode in the VFS, since the whiteout needs
> > to be presented to userspace when not part of the overlay.
> 
> Sure, but that's a different problem.
> 
> > The DT_WHT
> > makes the typical mistake of trying to make the implementation nice,
> > while not caring about user interfaces.
> 
> You're implying the d_type field in a dirent is something that it is
> not. d_type has only one purpose in life - to allowing userspace
> applications to avoid a stat() call to find out the type of the
> object the dirent points to.
> 
> > This is usually a big mistake, user interfaces are much more important
> > than implementation details, and an already existing file type on
> > which all the usual operations work (stat, unlink) is much better in
> > this respect than a completely new object which is unknown and
> > unmanageable for the vast majority of applications.
> 
> Sure, but again that's not the issue I'm commenting on.  The dirent
> type has no effect on stat, unlink, etc that are done on the dirent
> after it is returned to userspace.
> 
> So why is overloading DT_CHR to mean 'either a char device or a
> whiteout entry' a sane user interface design decision?  d_type *was*
> a simple, obvious, effective and efficient user interface that
> allowed users to avoid extra syscalls. It's been used this way by
> userspace for, what, 15 years?
> 
> With the overlayfs "magic" we now have the situation where d_type is
> not sufficient to avoid a stat() call to determine the type the
> dirent points to.  IOWs, we've just fucked up a perfectly good
> interface that is widely used because somebody thought that using
> the DT_WHT value in the d_type field for whiteout dirents is a "bad
> interface".
> 
> > The special chardev was Linus' idea, but I agree with him completely
> > on this point.  Introducing DT_WHT on the userspace API would be much
> > more of a hack than reusing existing objects and operations.
> 
> Magical char dev for access, unlink, etc: no problems there.
> 
> DT_CHR for the whiteout dirent type: completely fucked up.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
