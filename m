Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DA46E7CA0
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2016 19:24:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9B28B304048
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2016 17:24:21 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8ohmoMees9ujH0BL (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 22 Aug 2016 17:24:17 -0700 (PDT)
Date: Mon, 22 Aug 2016 19:24:13 -0500
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: [PATCH v2 1/3] xfs_quota: add capabilities for use on ext4
Message-ID: <20160823002413.GA21673@redhat.com>
References: <1471356998-2876-1-git-send-email-billodo@redhat.com>
	<1471356998-2876-2-git-send-email-billodo@redhat.com>
	<20160822014742.GQ19025@dastard> <20160822160207.GC2736@redhat.com>
	<20160823000916.GX19025@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160823000916.GX19025@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 23, 2016 at 10:09:16AM +1000, Dave Chinner wrote:
> On Mon, Aug 22, 2016 at 11:02:07AM -0500, Bill O'Donnell wrote:
> > On Mon, Aug 22, 2016 at 11:47:42AM +1000, Dave Chinner wrote:
> > > On Tue, Aug 16, 2016 at 09:16:36AM -0500, Bill O'Donnell wrote:
> > > > This allows xfs_quota to be used on ext4 for project quota testing
> > > > in xfstests.
> > > > 
> > > > This patch was originally submitted by Dave Chinner
> > > > (http://oss.sgi.com/archives/xfs/2016-02/msg00131.html)
> > > > 
> > > > Resubmitting with the following change:
> > > > quota/init.c: correct logic error in loop contained in init_args_command()
> > > > function (lines 85-91).
> > > 
> > > What logic error?
> > 
> > In your original patch, in init_args_command():
> > 
> >    	do {
> >  		fs_path = &fs_table[index++];
> > -	} while ((fs_path->fs_flags & FS_PROJECT_PATH) && index < fs_count);
> > +		if (fs_path->fs_flags & FS_PROJECT_PATH)
> > +			continue;
> > +		if (!foreign_allowed && (fs_path->fs_flags & FS_FOREIGN))
> > +			continue;
> > +	} while (index < fs_count);
> > 
> > The loop should break out, when (fs_path->fs_flags & FS_PROJECT_PATH) is false,
> > but instead moves onto the next test (and then back to the top). See in the
> > original while statement, the loop stops when the false condition occurs, that is,
> > ((fs_path->fs_flags & FS_PROJECT_PATH) && index < fs_count) == False.
> 
> Hi Bill - now I see *how* you changed the logic changed, but I still
> don't know *why* it needed to be changed. What problem did you
> encounter that needed to be solved?  The code I wrote had different
> logic for good reason: the fstable is now populated with non-XFS
> mount points now, and so we have to walk it differently.
> 
> In more detail, the fstable is initialised from two place - the
> mount table for FS_MOUNT_POINT entries, and the projects files for
> FS_PROJECT_PATH entries.  The original init_args_command() code was
> searching for the first mount point entry in the filesystem table
> (i.e. a FS_MOUNT_POINT entry) and it did so by skipping over
> FS_PROJECT_PATH entries. It could do this because it "knew" that the
> fs_table was only populated with XFS filesystem mount points. Hence
> once it found an entry that was not a project quota path entry, it
> could stop knowing it had an XFS mount point to work from.
> 
> Now we are populating the fstable with all types of filesystem mount
> points as well as project quota paths. Hence if we are operating
> only on XFS filesystems we now have to skip over any foreign mount
> point entries we find in the table.  IOWs, the original code I wrote
> is supposed to skip both project paths and foreign mounts when "-f"
> is not set.
> 
> But that said, I've analysed your change sufficiently that I can now
> see the problem you tried to solve: it doesn't break out of the
> search loop when it finds the first mount point it can use. This is
> the "why" of the logic change you made, and if you said that in the
> commit message, it would have been easy to spot it in the patch.
> 
> It would have also been much easier to review, because now it's
> clear that the logic change you've made makes it stop searching at
> the first FS_MOUNT_POINT entry, regardless of whether it is foreign
> or not, or whether we are allowing foreign mounts to be used. This
> is incorrect behaviour, as you can now see from the above
> explanation of what the code was supposed to be doing.
> 
> i.e. the search loop should now look something like this:
> 
> 	/* lookup the first FS_MOUNT_POINT entry we should use */
> 	do {
> 		/* skip project quota entries */
> 		if (fs_path->fs_flags & FS_PROJECT_PATH)
> 			continue;
> 
> 		/* only consider foreign filesystems if told to */
> 		if (!foreign_allowed && (fs_path->fs_flags & FS_FOREIGN))
> 			continue;
> 
> 		/* We can use this one */
> 		break;
> 	} while (index < fs_count);
> 
> > My commit message was completely terse, sorry. I'll clarify it in v3.
> 
> Writing good commit messages is hard and takes practice. If you
> read the commit message and you can't answer the following questions
> after reading it, the commit message needs more work:
> 
> 	1 what problem is being solved?
> 	2 why did the problem need to be solved?
> 	3 what unforeseen or tricky issues needed to be addressed
> 	  while solving the problem?
> 	4 what changed from the last version, and why did it change?
> 	  (see 1, 2 and 3)
> 
> Note that there's no "how did the problem get solved?" in that list?
> That's because the "how?" is the code. Reviewers can read the code
> change to understand the how - what they can't get from the code is
> the "why?" and "what changed from last time?" and that's what needs
> to be in comments and commit messages...
> 
> Often 1) and 2) can be described in the patch series summary (i.e.
> patch 0/N) as it doesn't need to be explained in every patch in the
> series.

Hi Dave-

Thanks for your thorough review. I do appreciate it, and I'll fix up
things in v3.

Cheers-
Bill


> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
