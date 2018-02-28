Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr014msb.fastweb.it ([85.18.95.103]:36820 "EHLO
        mr014msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932126AbeB1S2C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Feb 2018 13:28:02 -0500
Subject: Re: Reflink (cow) copy of busy files
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 28 Feb 2018 19:27:57 +0100
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <20180228170737.GL19312@magnolia>
References: <d105d0000652be75774cc1f5f23eae68@assyoma.it>
 <20180226002533.GG30854@dastard>
 <6eacd8faae2779b8dfb62fb0d65a9411@assyoma.it>
 <CAOQ4uxixAP6F8f6hT5VENQLD0o_3Bym6pkAJhXva5b99BhE9Eg@mail.gmail.com>
 <73ef828837683073feb1c49e3405dd6a@assyoma.it>
 <20180226172601.GC19312@magnolia> <20180227003348.GH30854@dastard>
 <fc797c0a-7263-c347-729d-c381b6936d3a@assyoma.it>
 <20180227220404.GI30854@dastard>
 <e20d5782df830e4ae36917191bbe0750@assyoma.it>
 <20180228170737.GL19312@magnolia>
Message-ID: <358aa0b224b6a7017f1c8af845a3b9bf@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Amir Goldstein <amir73il@gmail.com>, linux-xfs <linux-xfs@vger.kernel.org>, g.danti@assyoma.it

Il 28-02-2018 18:07 Darrick J. Wong ha scritto:
> reflink performs (more or less) a fdatasync of the source and dest file
> before it starts so that any dirty pages backed by delayed allocation
> reservation will be allocated and written to disk, but it doesn't do 
> the
> "force all dirty metadata out to log" action that distinguishes
> fdatasync from fsync.  That is a deliberate design decision because:
> 
> 1) fsync is fairly heavyweight,
> 2) customers might have disposable environments where it is preferable
>    to lose srcfile and destfile over paying performance penalties
>    all the time, and
> 3) if you need srcfile to be completely stable on disk, you needed to
>    call fsync anyway, and nothing prevents you from doing so before
>    calling copy_file_range/clone_file_range if that is part of your
>    operational requirements.
> 
> In other words, if at a certain point you can't afford to lose the
> source file due to a host crash, you have to call fsync, as has been 
> the
> case for ages.  reflink does not itself call fsync, nor does it 
> increase
> the chances of losing any file contents that weren't fsync'd before the
> host went down.

Ok, this is exactly what I expect.

To add some context: Qemu/KVM added safe barrier/fsync passing years 
ago, so when a guest issues a fsync+barrier operation (ie: after key 
operations, as a journal update or a COMMIT) they are immediately passed 
to the host, which issues real fsync+barrier on the backing file. In 
other words, host's writeback cache is used as the volatile disk's DRAM 
cache (which needs to be flushed at specific interval). See: 
https://www.static.linuxfound.org/jp_uploads/JLS2009/jls09_hellwig.pdf

Back to the original argument: are guest/user initiated fsyncs+barriers 
honored even *during a cp --reflink copy*? If so, I can't see any 
shortcoming in using reflinking to hot copy a busy file. Sure, I risk 
losing async writes (which are in writeback host cache *or* in the 
unflushed volatile disk's DRAM cache), but this is nothing more (or 
less) than a normal, interrupted copy. I am right saying that?

Maybe encapsulating the reflink copy in between two fsync calls is a 
good idea?

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
