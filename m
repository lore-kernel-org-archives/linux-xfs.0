Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45088 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750812AbcIJHkg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Sep 2016 03:40:36 -0400
Date: Sat, 10 Sep 2016 00:40:34 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ovl: use copy_file_range for copy up if possible
Message-ID: <20160910074034.GA18332@infradead.org>
References: <1473348594-31425-1-git-send-email-amir73il@gmail.com>
 <20160908202511.GV30056@dastard>
 <CAOQ4uxigN71Evm_mhFzijtDaXAvKQqstryvNoBEL7=Uwgt5xFg@mail.gmail.com>
 <20160909075439.GE30056@dastard>
 <CAOQ4uxguEpSeq5A==gGCcVocY=5xSO+cEcUNr2GDYAbjvx4+Dw@mail.gmail.com>
 <20160909235221.GH30056@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160909235221.GH30056@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Sat, Sep 10, 2016 at 09:52:21AM +1000, Dave Chinner wrote:
> > vfs_copy_file_range() implementation because ovl_copy_up_data()
> > splices in small chunks allowing the user to kill the copying process.
> > This makes sense because the poor process only called open(),
> > so the app writer may not have been expecting a stall of copying
> > a large file...
> 
> So call vfs_copy_file_range() iteratively, just like is being done
> right now for do_splice_direct() to limit latency on kill.

I wish vfs_copy_file_range would do useful chinking itself.

But either way it might be a good idea to call vfs_clone_file_range
first, because that gives your a very efficient copy without the need
to copy anything if supported.
