Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:56780 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932295AbeB1RHp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Feb 2018 12:07:45 -0500
Date: Wed, 28 Feb 2018 09:07:37 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Reflink (cow) copy of busy files
Message-ID: <20180228170737.GL19312@magnolia>
References: <d105d0000652be75774cc1f5f23eae68@assyoma.it>
 <20180226002533.GG30854@dastard>
 <6eacd8faae2779b8dfb62fb0d65a9411@assyoma.it>
 <CAOQ4uxixAP6F8f6hT5VENQLD0o_3Bym6pkAJhXva5b99BhE9Eg@mail.gmail.com>
 <73ef828837683073feb1c49e3405dd6a@assyoma.it>
 <20180226172601.GC19312@magnolia>
 <20180227003348.GH30854@dastard>
 <fc797c0a-7263-c347-729d-c381b6936d3a@assyoma.it>
 <20180227220404.GI30854@dastard>
 <e20d5782df830e4ae36917191bbe0750@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e20d5782df830e4ae36917191bbe0750@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: Dave Chinner <david@fromorbit.com>, Amir Goldstein <amir73il@gmail.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Feb 28, 2018 at 08:08:47AM +0100, Gionatan Danti wrote:
> Il 27-02-2018 23:04 Dave Chinner ha scritto:
> >A host crash can lose data from the original file when it is
> >configured in writeback mode (as you've said you are using). If the
> >clone is there, both source and clone should be fully intact. If
> >it's not, then you will have lost data from the original image file.
> 
> I have difficult grasping how a system crash during a cp --refcopy could
> corrupt the source file.
> As per Darrick explanation, new writes on the original file should be
> blocked/queued during the copy. Even if this is not the case, fsync writes
> should complete only when data successfully landed on the disk platter.

reflink performs (more or less) a fdatasync of the source and dest file
before it starts so that any dirty pages backed by delayed allocation
reservation will be allocated and written to disk, but it doesn't do the
"force all dirty metadata out to log" action that distinguishes
fdatasync from fsync.  That is a deliberate design decision because:

1) fsync is fairly heavyweight,
2) customers might have disposable environments where it is preferable
   to lose srcfile and destfile over paying performance penalties
   all the time, and
3) if you need srcfile to be completely stable on disk, you needed to
   call fsync anyway, and nothing prevents you from doing so before
   calling copy_file_range/clone_file_range if that is part of your
   operational requirements.

In other words, if at a certain point you can't afford to lose the
source file due to a host crash, you have to call fsync, as has been the
case for ages.  reflink does not itself call fsync, nor does it increase
the chances of losing any file contents that weren't fsync'd before the
host went down.

--D

> Losing some second on async writes should not be a problem in many
> environments (this is the very reasoning behind providing Qemu/KVM with a
> working writeback option).
> 
> Clearly a crash during the copy *will* produce an invalid destination file,
> but this can not be avoided (after all, the system crashed!).
> 
> >But, really, why risk losing data or filesystem corruption by trying
> >to take shortcuts?
> 
> Losing data and filesystem corruption are two *very* different things. On
> many VMs, I can afford losing some seconds of async writes; obviously, fsync
> writes (which can lead do filesystem corruption) must *not* be lost on *any*
> condition.
> 
> The point of the discussion is that if a cp --reflink is suitable for hot
> backup, it would be an extremely fast and convenient method to take "cheap"
> snapshot of key files. But if an interrupted copy can lead to total loss of
> the *original* file/filesystem, than this is clearly the wrong idea.
> 
> I am missing something?
> Thanks.
> 
> -- 
> Danti Gionatan
> Supporto Tecnico
> Assyoma S.r.l. - www.assyoma.it
> email: g.danti@assyoma.it - info@assyoma.it
> GPG public key ID: FF5F32A8
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
