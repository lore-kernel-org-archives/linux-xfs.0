Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr011msb.fastweb.it ([85.18.95.108]:51880 "EHLO
        mr011msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750877AbeBZVXv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Feb 2018 16:23:51 -0500
Subject: Re: Reflink (cow) copy of busy files
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 26 Feb 2018 22:23:45 +0100
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <20180226172601.GC19312@magnolia>
References: <20180224220757.GC30854@dastard>
 <711dd96e3c4b3e92d3fb38a01e77dc64@assyoma.it>
 <20180225024727.GD30854@dastard>
 <25ebcdb42650430d83d283435053efed@assyoma.it>
 <20180225211309.GF30854@dastard>
 <d105d0000652be75774cc1f5f23eae68@assyoma.it>
 <20180226002533.GG30854@dastard>
 <6eacd8faae2779b8dfb62fb0d65a9411@assyoma.it>
 <CAOQ4uxixAP6F8f6hT5VENQLD0o_3Bym6pkAJhXva5b99BhE9Eg@mail.gmail.com>
 <73ef828837683073feb1c49e3405dd6a@assyoma.it>
 <20180226172601.GC19312@magnolia>
Message-ID: <2f48d103c0a6eff6c0a1136057e828b6@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, g.danti@assyoma.it

Il 26-02-2018 18:26 Darrick J. Wong ha scritto:
> The way reflink is supposed to work wrt consistency is:
> 
> 1. lock out all new io/fallocate activity on both inodes 
> (iolock/mmaplock)
> 2. wait for all directio to complete
> 3. fsync both files (write all the dirty pagecache to disk)
> 4. lock both inodes (ilock)
> 5. clone each extent atomically
> 6. unlock ilock
> 7. unlock iolock/mmaplock
> 
> So at least in theory the cloned file will match whatever the host saw
> on disk and page cache at the time the reflink call was initiated.
> I say 'in theory' because there could be bugs.

Great! CoW will be a great addition for XFS when it will be considered 
stable.

> Whatever dirty state is in the guest VM stays in that VM, which means
> that if you only cp --reflink on the host, the clone you get will
> reflect the virtual disk state as if you'd kill -9'd the VM, cloned the
> VM disk, and restarted the VM.  Upon restart the log recovers whatever
> metadata made it out of the VM.

Sure, it is what I means for "crash-consistent".

> However, if you tell the guest to freeze the fs before cloning (as Dave
> suggested earlier) the guest will flush all its state to the upper 
> level
> (the host) and the host will push all that out to disk before cloning.
> The snapshot you create should be cleaner because you're effectively
> prepaying the recovery costs by flushing everything before taking the
> snapshot.

True, and this is "application-level consistency" (which requires a 
guest agent and possibly even an application-specific agent)

> Also note that if the host goes down before returning from the syscall,
> the log will continue on with whichever extent was being cloned at the
> time in order to preserve metadata integrity, but the destination file
> will reflect a partial copy.

Thanks for pointing that, and for your extremely clear explanation!


-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
