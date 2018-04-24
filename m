Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35824 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753551AbeDXL12 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Apr 2018 07:27:28 -0400
Date: Tue, 24 Apr 2018 07:27:27 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: XFS and Memory allocation
Message-ID: <20180424112727.GB49785@bfoster.bfoster>
References: <CA+1g8semVirCEfbQRNt8h-Cj7NV7p1FYP76XLjH4vVMVU7F=aw@mail.gmail.com>
 <20180423143605.GH43600@bfoster.bfoster>
 <CA+1g8seTYOgERkM=dnDZFDX3QZQ1w6pMGOw1HVC-tdQxVON=vA@mail.gmail.com>
 <20180423153447.GI43600@bfoster.bfoster>
 <CA+1g8segDPZo821caCX73ARLa3Ly9_u6O9iseqoE3b+LntqSLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1g8segDPZo821caCX73ARLa3Ly9_u6O9iseqoE3b+LntqSLw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrea del Monaco <andrea.delmonaco@clustervision.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 24, 2018 at 09:25:41AM +0200, Andrea del Monaco wrote:
> Hi Brian,
> 
> I've been tunining some kernel parameters here and there. Seems that the
> reclaim_zone set to 1 has had a positive impact - or at least, the
> number of errors reduced drastically.
> 
> Do you now if and when will it be available?
> I am very tempted to get the packages from Fedora repos (Which seems
> to be available there), but you know, it might get messy.
> 

Not really.

> I guess that in order to reduce the extent counts of the files, would
> mean re-create the FS. Wouldn't it?
> 

Not necessarily. You may have to recreate individual files so they are
not as fragmented or sparse (via preallocation, extent size hints,
etc.), but this probably depends on the specifics of your use case,
workload, current fs layout, etc.

For example, if the use case is large virtual disk image files, I
believe it is fairly common for random access via the guest to cause
huge extent counts due to the random/sparse and smallish nature of the
writes. XFS has extent size hints (see the 'extsize' command in 'man
xfs_io') to combat this particular behavior, which creates a minimum
size allocation/alignment (i.e., I think 1MB is a common setting) for
writes that helps prevent the proliferation of tiny extents. IIRC, an
extent size hint can only be set on a file before any extents are
allocated, however. It is thus not a retroactive fix, but doesn't
necessarily require to recreate the entire fs. If you had hundreds or
thousands of such files to deal with, however, then it may very well be
easier to create a new fs and set a recursive hint on the appropriate
directory.

Brian

> Regards,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
