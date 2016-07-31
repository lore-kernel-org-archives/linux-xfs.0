Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 063D57CA0
	for <xfs@oss.sgi.com>; Sat, 30 Jul 2016 19:34:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CB8208F8035
	for <xfs@oss.sgi.com>; Sat, 30 Jul 2016 17:34:39 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	hJNkI99uzb31k95q for <xfs@oss.sgi.com>;
	Sat, 30 Jul 2016 17:34:34 -0700 (PDT)
Date: Sun, 31 Jul 2016 10:34:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Any better way to interact with xfs?
Message-ID: <20160731003431.GF16044@dastard>
References: <SYXPR01MB044863A851C967C37649BE3FF8000@SYXPR01MB0448.ausprd01.prod.outlook.com>
	<CAOQ4uxiOavjc+wrRQHW8U16EDocNRRGnM24a7d6dhO8tzV0a1w@mail.gmail.com>
	<20160729022552.GA16044@dastard>
	<CAOQ4uxiJ9yNyJhyEoTPrqJ0F-HcJz6hagio1K_pxVPPQiDC=KQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiJ9yNyJhyEoTPrqJ0F-HcJz6hagio1K_pxVPPQiDC=KQ@mail.gmail.com>
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
To: Amir Goldstein <amir73il@gmail.com>
Cc: Ryan Lindsay <rlindsay@unimelb.edu.au>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sat, Jul 30, 2016 at 05:26:03PM +0300, Amir Goldstein wrote:
> On Fri, Jul 29, 2016 at 5:25 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, Jul 28, 2016 at 09:48:07AM +0300, Amir Goldstein wrote:
> >> Hi Ryan,
> >>
> >> You could use the XFS_IOC_FSINUMBERS/XFS_IOC_FSBULKSTAT API to iterate
> >> over all inodes in the fs.
> >
> > That's a read-only API - you can't use it to change the inodes
> > on disk.
> >
> >> not having to readdir and recourse the directory tree should safe you
> >> some time (much less i/o).
> >> Also, the interface can be used to make your conversion work parallel
> >> by working on different inode ranges.
> >
> > It cannot be used to make coherent, atomic changes to the inode
> > state.
> >
> 
> I'm curios: In theory, one can construct a file_handle from bulkstat
> info. correct?
> and one could use that handle to open_by_handle_at() and fchown(). right?
> I realize that both APIs were not intended for this use case, but I wonder:
> 1. can it be done?

Yes. See xfs_fsr.

> 2. what are the possible consequences?

You can modify the data any file in the filesystem without leaving a
trace. Files opened this way do not get their c/mtime changed when
modified by syscalls, and only on CRC enabled filesystem is it
possible to tell if the inode metadata was changed this way. You
still can't tell if file data was changed.

> 3. what do you mean by "coherent, atomic changes to the inode state"?
> does it not play well with the dentry/inode cache?

The inode can change between bulkstat time (i.e. the info the kernel
returned about the inode) and the time you have an open fd and
make the change you want to make. It could have been renamed,
it could have been truncated, it's permissions could have been
changed, etc. None of these sorts of checks are run when opening by
filehandle.

i.e. it's all the same coherency issues that we have with multiple
NFS clients modifying the same file concurrently. They don't know
what each other are doing, and so modifications are going to get
lost or be overwritten incorrectly....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
