Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55310 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1034743AbdD1IW6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 28 Apr 2017 04:22:58 -0400
Date: Fri, 28 Apr 2017 10:22:53 +0200
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] xfs: Allow user to kill fstrim process
Message-ID: <20170428082253.n3kemqg2frw5zdco@localhost.localdomain>
References: <1493282368-32422-1-git-send-email-lczerner@redhat.com>
 <c9a4476c-51d7-b945-4f03-7e5485f3bcb4@sandeen.net>
 <20170427153841.GD23371@birch.djwong.org>
 <6e38c12b-6af9-1613-87dd-0c35df976338@sandeen.net>
 <d9463c18-025e-0b7d-502f-3da43e822938@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9463c18-025e-0b7d-502f-3da43e822938@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Apr 27, 2017 at 10:50:02AM -0500, Eric Sandeen wrote:
> On 4/27/17 10:46 AM, Eric Sandeen wrote:
> > On 4/27/17 10:38 AM, Darrick J. Wong wrote:
> >> On Thu, Apr 27, 2017 at 09:34:04AM -0500, Eric Sandeen wrote:
> >>> On 4/27/17 3:39 AM, Lukas Czerner wrote:
> >>>> fstrim can take really long time on big, slow device or on file system
> >>>> with a lots of allocation groups. Currently there is no way for the user
> >>>> to cancell the operation. This patch makes it possible for the user to
> >>>> kill fstrim pocess by adding the check for fatal_signal_pending() in
> >>>> xfs_trim_extents().
> >>>
> >>> With this patch, it seems that if it is killed, then nothing is copied
> >>> back to the user about the number of blocks trimmed before the kill.
> >>>
> >>> Is that intentional?
> >>>
> >>> I think it could be done in a way that the progress until the kill
> >>> does get reported, and that might be more useful?
> >>
> >> AFAICT ext4 doesn't report anything if somoene ERESTARTSYS's it...
> > 
> > Well we aren't ext4, are we?  ;)
> > 
> > actually, it seems that it may report "count" as ERESTARTSYS in:
> > 
> >         ext4_debug("trimmed %d blocks in the group %d\n",
> >                 count, group);
> > 
> > But yeah, although it does update the &range values, they don't
> > get copied out on any error.
> > 
> > Anyway, ok, ext4 doesn't.  Is there a reason that we shouldn't?
> 
> Ok I am probably misunderstanding how things work, maybe it's
> not actually possible (he says after a little experimentation.)
> Feel free to ignore me on this one.  :)
> 
> -Eric

Hi Eric,

I agree with Darrick, at the moment fstrim is not sticikng around to
care, I am not even sure if it can stick around to care.

Thanks!
-Lukas
