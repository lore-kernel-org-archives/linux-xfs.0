Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B903F7F55
	for <xfs@oss.sgi.com>; Thu,  1 Oct 2015 17:47:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 92C7D304051
	for <xfs@oss.sgi.com>; Thu,  1 Oct 2015 15:47:48 -0700 (PDT)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) by
	cuda.sgi.com with ESMTP id sYSUO9BGEUU23YyM for
	<xfs@oss.sgi.com>; Thu, 01 Oct 2015 15:47:46 -0700 (PDT)
Date: Thu, 1 Oct 2015 16:47:45 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/7] Revert "mm: take i_mmap_lock in
	unmap_mapping_range() for DAX"
Message-ID: <20151001224745.GB7634@linux.intel.com>
References: <1443685599-4843-1-git-send-email-david@fromorbit.com>
	<1443685599-4843-2-git-send-email-david@fromorbit.com>
	<20151001202729.GA23495@linux.intel.com>
	<20151001223240.GI27164@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151001223240.GI27164@dastard>
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
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, willy@linux.intel.com, Ross Zwisler <ross.zwisler@linux.intel.com>, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com

On Fri, Oct 02, 2015 at 08:32:40AM +1000, Dave Chinner wrote:
> I couldn't work out what set of commits I needed to revert to get a
> clean revert, so I just reverted the commits and hacked out the
> revert failures to what looked ok. Feel free to send me a clean set
> of reverts, and I'll replace these patches with them... :)

Will do.  I will queue the reverts in my external tree & ask Linus to pull
them into v4.3 so we don't ship with deadlocks.

> > Also, if I understood your previous mails correctly you were targeting the
> > first two revert patches for v4.3 so we get back to v4.2 level locking, and
> > the rest of the series will target v4.4, correct?  How does this work?  Do the
> > patches need to be split into two series and tested separately?
> 
> Test it and push the reverts however you like. I don't care how the
> reverts get to 4.3 - I'll be carrying them locally in my trees from
> now and so my development and testing is now unaffected by the bugs
> that are in the 4.3 code. If you aren't going to push them for 4.3
> then I'd suggest that they go to linus along with the rest of the
> XFS changes in this series.
> 
> FWIW, I'm quite happy to host all the pending DAX changes in a
> public git tree and ask for it to be included in linux-next. It's
> probably a good idea to do this because it makes it much easier to
> co-ordinate merges when we are touching multiple subsystems (ext4,
> xfs, dax, mm, etc). And it will help prevent the "patches molder on
> the list until Andrew hoovers them up" problem and so prevent this
> situation from happening in the future...

No objections from me. :)  I agree that it would be nice to have a central
home for all the DAX patches.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
