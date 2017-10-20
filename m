Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:20248 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752334AbdJTWmB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2017 18:42:01 -0400
Date: Sat, 21 Oct 2017 09:41:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/17] Parent Pointers V3
Message-ID: <20171020224157.GS3666@dastard>
References: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
 <CAOQ4uxhzZT=5O6PM4Gp=uSwYPFdrO5X9D8UF54f3jEmM2LxK1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhzZT=5O6PM4Gp=uSwYPFdrO5X9D8UF54f3jEmM2LxK1Q@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Oct 19, 2017 at 07:11:50AM +0300, Amir Goldstein wrote:
> On Thu, Oct 19, 2017 at 1:55 AM, Allison Henderson
> <allison.henderson@oracle.com> wrote:
> > Hi all,
> >
> > This is the third version of parent pointer attributes for xfs.
> > I've integrated the suggestions made since v2, mostly moving the
> > attr buffers in the xfs_attr_log_item to pointers that point to
> > xfs_attr_item. I've also implementing the recovery routines for
> > the xfs_attr_log_format.  If I missed anything please point it
> > out.  As always, comments and feedback are appreciated.  Thank
> > you!
> >
> 
> A minor comment about the cover letter.
> All designated reviewers must know exactly what "parent pointers" are for,
> but it could be useful to add some context in the cover letter about the purpose
> of this work for the sake of other readers on the list. Useful to refer to the
> upcoming scrub support patches.
> 
> BTW, not sure if this was mentioned in the previous lifetime of those
> patches, but parent pointers can be used to implement exportfs operation
> xfs_fs_fh_to_parent() for "non-connectable" file handles (FILEID_INO32_GEN)
> and to implement xfs_fs_get_name(), which would make reconnect_path()
> *much* more efficient.

However, XFS only uses FILEID_INO32_GEN for directories
because they have known parents. For them, we implement ->get_parent()
and that means reconnect_path just does ->lookup("..") to find the
parents and doesn't need anything special.

We use FILEID_INO32_GEN_PARENT for all other types of files to
encode the ino # + generation of the parent inode into the handle.
That means for any non-dir file handle, our implemention of
->fh_to_parent  will get us the parent info as efficiently as
possible.

IOWs, parent pointers won't actually speed up filehandle ->
dentry reconnection on XFS at all because we already encode parent
pointers into the filehandles that need them....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
