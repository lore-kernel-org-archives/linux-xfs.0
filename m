Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr014msb.fastweb.it ([85.18.95.103]:50348 "EHLO
        mr014msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751793AbeB1HIw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Feb 2018 02:08:52 -0500
Subject: Re: Reflink (cow) copy of busy files
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 28 Feb 2018 08:08:47 +0100
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <20180227220404.GI30854@dastard>
References: <25ebcdb42650430d83d283435053efed@assyoma.it>
 <20180225211309.GF30854@dastard>
 <d105d0000652be75774cc1f5f23eae68@assyoma.it>
 <20180226002533.GG30854@dastard>
 <6eacd8faae2779b8dfb62fb0d65a9411@assyoma.it>
 <CAOQ4uxixAP6F8f6hT5VENQLD0o_3Bym6pkAJhXva5b99BhE9Eg@mail.gmail.com>
 <73ef828837683073feb1c49e3405dd6a@assyoma.it>
 <20180226172601.GC19312@magnolia> <20180227003348.GH30854@dastard>
 <fc797c0a-7263-c347-729d-c381b6936d3a@assyoma.it>
 <20180227220404.GI30854@dastard>
Message-ID: <e20d5782df830e4ae36917191bbe0750@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Amir Goldstein <amir73il@gmail.com>, linux-xfs <linux-xfs@vger.kernel.org>, g.danti@assyoma.it

Il 27-02-2018 23:04 Dave Chinner ha scritto:
> A host crash can lose data from the original file when it is
> configured in writeback mode (as you've said you are using). If the
> clone is there, both source and clone should be fully intact. If
> it's not, then you will have lost data from the original image file.

I have difficult grasping how a system crash during a cp --refcopy could 
corrupt the source file.
As per Darrick explanation, new writes on the original file should be 
blocked/queued during the copy. Even if this is not the case, fsync 
writes should complete only when data successfully landed on the disk 
platter. Losing some second on async writes should not be a problem in 
many environments (this is the very reasoning behind providing Qemu/KVM 
with a working writeback option).

Clearly a crash during the copy *will* produce an invalid destination 
file, but this can not be avoided (after all, the system crashed!).

> But, really, why risk losing data or filesystem corruption by trying
> to take shortcuts?

Losing data and filesystem corruption are two *very* different things. 
On many VMs, I can afford losing some seconds of async writes; 
obviously, fsync writes (which can lead do filesystem corruption) must 
*not* be lost on *any* condition.

The point of the discussion is that if a cp --reflink is suitable for 
hot backup, it would be an extremely fast and convenient method to take 
"cheap" snapshot of key files. But if an interrupted copy can lead to 
total loss of the *original* file/filesystem, than this is clearly the 
wrong idea.

I am missing something?
Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
