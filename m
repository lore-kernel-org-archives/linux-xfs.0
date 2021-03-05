Return-Path: <SRS0=x8pl=ID=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3D0FC433DB
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 21:46:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75E10650A6
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 21:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbhCEVqS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Mar 2021 16:46:18 -0500
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:33230 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229709AbhCEVpx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 16:45:53 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id E0A4EFA81B2;
        Sat,  6 Mar 2021 08:45:48 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lIIGZ-00GgGU-94; Sat, 06 Mar 2021 08:45:47 +1100
Date:   Sat, 6 Mar 2021 08:45:47 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Martin Svec <martin.svec@zoner.cz>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Incorrect user quota handling in fallocate
Message-ID: <20210305214547.GV4662@dread.disaster.area>
References: <c0e98a3b-35e3-ecfe-2393-c0325d70e62f@zoner.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0e98a3b-35e3-ecfe-2393-c0325d70e62f@zoner.cz>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=PM2R8IWaDskedUDMr6YA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 11:14:32AM +0100, Martin Svec wrote:
> Hi all,
> 
> I've found a bug in XFS user quota handling in two subsequent fallocate() calls. This bug can be
> easily reproduced by the following script:
> 
> # assume empty XFS mounted on /mnt/testxfs with -o usrquota, grpquota
> 
> FILE="/mnt/testxfs/test.file"
> USER="testuser"
> 
> setquota -u $USER $QUOTA $QUOTA 0 0 -a
> touch $FILE
> chown $USER:users $FILE
> fallocate --keep-size -o 0 -l $FILESIZE $FILE
> fallocate -o 0 -l $FILESIZE $FILE
> 
> That is, we create an empty file, preallocate requested size while keeping zero file size and then
> call fallocate again to set the file size. Assume that there's enaugh free quota to fit the
> requested file size. In this case, both fallocate calls should succeed because the second one just
> increases the file size but does not change the allocated space. However, I observed that the second
> fallocate fails with EDQUOT if the free quota is less than _two times_ of the requested file size. I

I'd call that expected behaviour. We enforce space restrictions
(ENOSPC and EDQUOT) on the size being requested before the operation
takes place and return the unused space reservation after the
fallocate() completes and has allocated space.

We cannot overcommit space or quota in XFS - that way leads to
deadlocks and data loss at ENOSPC because we can end up in
situations where we cannot write back data that users have written.
Hence we check up front, and if the worst case space requirement for
a given operation cannot fit under the ENOSPC or EDQUOT limits, it
is rejected with EDQUOT/ENOSPC.

Yes, that means we get corner cases when near EDQUOT/ENOSPC where
stuff like this happens, but that tends to be exceedingly rare in
the rare world as few applications use the entire filesystem space
or quota allowance in just 1-2 allocations.

> guess that the second fallocate ignores the fact that the space was already preallocated and
> accounts the requested size for the second time. For example, if QUOTA=2GiB, file size FILESIZE=800
> MiB succeeds but FILESIZE=1600 MiB triggers EDQUOT in second fallocate. The same test performed on
> EXT4 always succeeds.

Yup, filesystems behave differently at edge cases.

> I've found this issue while investigating why Samba (ver. 4.9.5) returns disk full error although
> there's still enaugh room for the copied file. Indeed, when Samba's "strict allocate" options is
> turned on Samba uses the above described sequence of two fallocate() syscalls to create a new file.

I'd say using fallocate to extend the file like this is .... not a
very good idea. All you actually need is a ftruncate() to change the
file size after the first fallocate (or use the first fallocate to
extend the file, too). The second fallocate() is largely useless on
most filesystems - internally they turn it into an extending
truncate because no allocation is required, so you may as well just
call ftruncate() and that way you will not trip over this space
reservation issue at all..

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
