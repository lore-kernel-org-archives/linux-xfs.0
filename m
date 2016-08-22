Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 40F1F7CA0
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2016 11:02:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 043318F804B
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2016 09:02:11 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id V867cj5ntVnWLydE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 22 Aug 2016 09:02:10 -0700 (PDT)
Date: Mon, 22 Aug 2016 11:02:07 -0500
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: [PATCH v2 1/3] xfs_quota: add capabilities for use on ext4
Message-ID: <20160822160207.GC2736@redhat.com>
References: <1471356998-2876-1-git-send-email-billodo@redhat.com>
	<1471356998-2876-2-git-send-email-billodo@redhat.com>
	<20160822014742.GQ19025@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160822014742.GQ19025@dastard>
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

On Mon, Aug 22, 2016 at 11:47:42AM +1000, Dave Chinner wrote:
> On Tue, Aug 16, 2016 at 09:16:36AM -0500, Bill O'Donnell wrote:
> > This allows xfs_quota to be used on ext4 for project quota testing
> > in xfstests.
> > 
> > This patch was originally submitted by Dave Chinner
> > (http://oss.sgi.com/archives/xfs/2016-02/msg00131.html)
> > 
> > Resubmitting with the following change:
> > quota/init.c: correct logic error in loop contained in init_args_command()
> > function (lines 85-91).
> 
> What logic error?

In your original patch, in init_args_command():

   	do {
 		fs_path = &fs_table[index++];
-	} while ((fs_path->fs_flags & FS_PROJECT_PATH) && index < fs_count);
+		if (fs_path->fs_flags & FS_PROJECT_PATH)
+			continue;
+		if (!foreign_allowed && (fs_path->fs_flags & FS_FOREIGN))
+			continue;
+	} while (index < fs_count);

The loop should break out, when (fs_path->fs_flags & FS_PROJECT_PATH) is false,
but instead moves onto the next test (and then back to the top). See in the
original while statement, the loop stops when the false condition occurs, that is,
((fs_path->fs_flags & FS_PROJECT_PATH) && index < fs_count) == False.

My commit message was completely terse, sorry. I'll clarify it in v3.

Thanks-
Bill

> 
> Commit messages like this really don't tell the reader anything
> about what is different the original patch.  I've had to go archive
> spelunking to work out what is different, and I'm still not sure
> what the logic error you fixed is....
> 
> And, FWIW, whilst spelunking, I noticed that Eric's last review
> comments on my original patch:
> 
> 	Looks ok, but now with the new option:
> 
> 	1) needs a manpage update
> 	2) usage() should be updated to include -f
> 
> 	3) and I just noticed,
> 
> 	_("foreign mount active, %s command is for XFS filesystems only\n"),
> 
> 	seems kind of unclear; maybe just
> 
> 	_("%s command is for XFS filesystems only\n"),
> 
> have not been addressed by this update.
> 
> Can you please add these these changes, update the commit message
> and resubmit?
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
