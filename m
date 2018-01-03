Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36479 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751154AbeACITU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jan 2018 03:19:20 -0500
Received: by mail-wm0-f47.google.com with SMTP id b76so1249735wmg.1
        for <linux-xfs@vger.kernel.org>; Wed, 03 Jan 2018 00:19:19 -0800 (PST)
Date: Wed, 3 Jan 2018 09:19:16 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Block size and read-modify-write
Message-ID: <20180103081916.3mpadfsdkk2bh2ph@odin.usersys.redhat.com>
References: <021d36d95a9de952ddd38cc56d18df4f@assyoma.it>
 <20180102102539.5kh2tjo5gmlewiek@odin.usersys.redhat.com>
 <20180103011926.GJ5858@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180103011926.GJ5858@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Gionatan Danti <g.danti@assyoma.it>, linux-xfs@vger.kernel.org

On Wed, Jan 03, 2018 at 12:19:26PM +1100, Dave Chinner wrote:
> On Tue, Jan 02, 2018 at 11:25:39AM +0100, Carlos Maiolino wrote:
> > On Fri, Dec 29, 2017 at 12:14:14AM +0100, Gionatan Danti wrote:
> > > Hi list,
> > > I would ask a question: how XFS block size affect read-modify-write in case
> > > of very small writes?
> > > 
> > 
> > Hi,
> > 
> > > For example, suppose an XFS filesystem with the default 4K data block size.
> > > Am I correct saying that:
> > > - a 512B normal, cached writes will cause a read-modify-write of the entire
> > > 4K sector?
> 
> Cached writes smaller than a *page* will cause RMW cycles in the
> page cache, regardless of the block size of the filesystem.
> 
> > > - a 512B O_DIRECT write will *not* cause a read-modify-write of the 4K
> > > sector, rather it will be flushed to disk as-is (512 bytes in length)?
> 
> Ok, there is a difference between *sector size* and *filesystem
> block size*. You seem to be using them interchangably in your
> question, and that's not correct.
> 
> > IIRC, although the DIO requirement is to have writes aligned to the logical sector
> > size, issuing such IOs not properly aligned with the filesystem block size, have
> > a few consequences.
> > 
> > - It will require exclusive inode io locks, so serializing IOs to the inode
> 
> That is correct, but....
> 
> > - And yes, it will require a RMW to the block in question, all IO are always
> >   made in filesystem block size units.
> 
> .... this is not correct for direct IO. The direct IO path does not
> do RMW cycles at all.
> 
> Put simply: a 512B DIO write on a (real or emulated) 512B sector
> device with a 4k FSB will be serialised by the filesystem and do a
> single 512B sector write to the device.  However, if the device
> reports as a 4k sector device then a 512B DIO write will be rejected
> by the filesystem because sub-sector IO is not possible.

Oh, thanks for the correction :)

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
