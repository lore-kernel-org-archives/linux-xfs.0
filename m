Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52824 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754592AbcK1QdB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Nov 2016 11:33:01 -0500
Subject: Re: Silent skipping of file during xfsrestore
References: <b6f1eb73-c038-1573-c026-c38ae8eea2f0@gmail.com>
 <20161128015956.GX28177@dastard>
 <d669a091-dd58-6809-f18c-2fc796568a1d@gmail.com>
 <20161128082116.GA28177@dastard>
 <eaf5e5dc-5fa8-176b-7d39-47570ee7fd83@gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3bf9711f-5fa4-4446-47f5-12108b8802c6@sandeen.net>
Date: Mon, 28 Nov 2016 10:32:59 -0600
MIME-Version: 1.0
In-Reply-To: <eaf5e5dc-5fa8-176b-7d39-47570ee7fd83@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Will Dormann <wdormann@gmail.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On 11/28/16 10:10 AM, Will Dormann wrote:

> Another possible scenario that I'm wondering whether it's plausible:
> 
> My XFS filesystem was mildly corrupted (e.g. because of power failure or
> other trouble).  But not in a way that was checked/noticed/corrected
> automatically on system boot, or even had a noticeable effect on the
> system other than the missing file on xfsrestore?

There is no explicit check on boot for xfs, so nothing would happen there.

If the fs were corrupted, it likely would have been noticed by the kernel
when xfsdump was traversing the filesystem.  If the filesystem didn't
shut down, and you didn't see anything in kernel messages, then there
is likely no corruption.  You could always unmount & check manually
w/ xfs_repair (possibly with -n) to confirm.

> The system is back up and running, seemingly-fine.  But perhaps
> obviously, my main concern here is to avoid this kind of scenario in the
> future.   e.g., is there something I'm missing in my backup routine?
> Silent failures on backup/restore are not very reassuring.

Can you check timestamps on the file to be sure that your assumption
that it's not getting written is correct?  I know cups likes to write
and rewrite config files even if no changes occur, for example.

-Eric

> 
> 
> Thanks!
> -WD
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
