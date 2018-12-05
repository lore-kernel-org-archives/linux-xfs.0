Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46226 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728156AbeLEVBa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Dec 2018 16:01:30 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 666EE613C
        for <linux-xfs@vger.kernel.org>; Wed,  5 Dec 2018 21:01:30 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2BD3618952
        for <linux-xfs@vger.kernel.org>; Wed,  5 Dec 2018 21:01:30 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH RFC 0/10] xfs: add verifier context structure
Message-ID: <542b81dc-b564-c5fa-86b4-b4dc8ac50b63@redhat.com>
Date: Wed, 5 Dec 2018 15:01:28 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This patchset adds and uses an "xfs verifier context" structure
in the callchains that lead into metadata verifiers and other
validators.

The high-level goal of this is twofold:

1) It lets us return whatever information we want about the point
   of failure by populating the structure.  We /could/ add file, line,
   function, code address, buffer offset, text description, whatever
   we'd like.  For now it only contains the same info as we have today,
   failaddr and errno.  For many of these options, we could easily
   encapsulate it in a macro used at each failure point.

1a) this hopefully may lead to more consistent error messages that don't
    change depending on the compiler used, etc (which IMHO is a problem
    with failaddr today).

2) By passing the verifier context by reference, we can move the
   verifiers back to booleans, instead of having the somewhat odd
   bool / failaddr_t dichotomy depending on what we're calling.  This
   then lets us condense some of the code.

So now we have macros that let us do things like:

	return XFS_CORRUPTED_RETURN(vc);
or
	return XFS_VERIFIED_RETURN(vc);

which populate the context and return true or false.  We can also
turn things like:

        if (xfs_sb_version_hascrc(&mp->m_sb) &&
            !xfs_buf_verify_cksum(bp, XFS_AGF_CRC_OFF))
                xfs_verifier_error(bp, -EFSBADCRC, __this_address);
        else {
                fa = xfs_agf_verify(bp);
                if (XFS_TEST_ERROR(fa, mp, XFS_ERRTAG_ALLOC_READ_AGF))
                        xfs_verifier_error(bp, -EFSCORRUPTED, fa);
        }

into:

       if ((xfs_sb_version_hascrc(&mp->m_sb) &&
                       !xfs_buf_verify_cksum(vc, bp, XFS_AGF_CRC_OFF)) ||
           XFS_TEST_ERROR(!xfs_agf_verify(vc, bp),
                       mp, XFS_ERRTAG_ALLOC_READ_AGF))
                xfs_verifier_error(bp, vc);

(is that better?)
(I've wondered about moving the hascrc check into the verify_cksum f'n)

when the failaddr return is changed to a bool.  Because all of the info
is in vc, we don't have to explicitly pass in the errno because the failure
point set it; this cleans up some other places as well.

There are definitely things to improve; my (ab)use of macros probably
isn't great, we should maybe have a verifier context initializer and
checks that it was used properly (I had one bug in development where
I forgot to set anything into the vc at failure and got back a garbage
errno), it could maybe be pushed into more validators, maybe "context"
is a bad name, etc.  Bikedshed away!

But I wanted to throw this out there to see if people thought it was
worth continuing on, and see what suggestions people have. 
(the first patch or two are cleanups that could go now, I think).

If the general approach seems good, I'll clean it up and then propose
something that may be a bit more consistent but still as useful as the
failaddr approach we have today.

Thanks,
-Eric
