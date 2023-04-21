Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AFD9C77B75
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Apr 2023 09:10:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbjDUJKZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Apr 2023 05:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231674AbjDUJKV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2023 05:10:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DCE51B5
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 02:10:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E12FF61161
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 09:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064DAC433D2;
        Fri, 21 Apr 2023 09:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682068211;
        bh=5shi6FQOxoHUBBwzgGPUzNmr6lYyeaCX0IliWnWbszk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TiCVO/qp3M18Cf1m+4yGYGNx8xFM7oXXxne1yy6qFS92padk4sez3k3FoRkJ6aLEd
         EN78wygrxrwEcRgZJbtqaqa6KPn1lfbpAXJrErNTon4lASKlUxy0w4lmKRzqolsvFV
         cTP/3jHv0ezVq4W3MZGMK4+3jhNMv/zw556cHW9FCmAbowhIu+8/FcK12X1GtvjXoU
         94w33iYszrfrzzjOzZHpofB/BFAhberJeeEvTcBY4BbyGGzMH+iODUfMDtMy3O4TMl
         n5uL6jU8TISjloyJ3apxx4AZzFEzXIwUF9OTnywHMNaBOUE52nidT8KDSQ+PSFpacP
         cbIneZf9oz0qA==
Date:   Fri, 21 Apr 2023 11:10:06 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Hironori Shiina <shiina.hironori@gmail.com>,
        linux-xfs@vger.kernel.org, Donald Douwsma <ddouwsma@redhat.com>,
        Hironori Shiina <shiina.hironori@fujitsu.com>
Subject: Re: [RFC PATCH V3] xfsrestore: fix rootdir due to xfsdump bulkstat
 misuse
Message-ID: <20230421091006.nodvelbpuztwoir6@andromeda>
References: <20201116080723.1486270-1-hsiangkao@redhat.com>
 <20220928191052.410437-1-shiina.hironori@fujitsu.com>
 <YzXhMJmbEsEueRKy@magnolia>
 <b706af2d-c897-438e-a735-e0bd66c6b33a@sandeen.net>
 <LAvnQdcGzRYtveHjS-tySO1gRNmy5raB5aJrBSZwWew8UvwsG4yAVHofbI7CK0c5H1-ZpnLimrxtGYVwKHmbGg==@protonmail.internalid>
 <20230419154045.GG360889@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419154045.GG360889@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick.

> > >> This patch adds a '-x' option (another awkward thing is that
> > >> the codebase doesn't support long options) to address
> > >> problamatic images by searching for the real dir, the reason
> > >> that I don't enable it by default is that I'm not very confident
> > >> with the xfsrestore codebase and xfsdump bulkstat issue will
> > >> also be fixed immediately as well, so this function might be
> > >> optional and only useful for pre-exist corrupted dumps.
> > >
> > > As far as fixing xfsdump -- wasn't XFS_BULK_IREQ_SPECIAL_ROOT supposed
> > > to solve that problem by enabling dump to discover it it's really been
> > > passed the fs root directory?
> >
> > Yes, but as I understand it this patch is to allow the user to recover
> > from an already corrupted dump, at restore time, right?
> 
> Right, though I still haven't seen any patches to dump to employ
> XFS_BULK_IREQ_SPECIAL_ROOT to avoid spitting out bad dumps in the first
> place.  I think the heuristic that we applied is probably good enough,
> but we might as well query the kernel when possible.
> 
> > This still feels like deep magic in xfsdump that most people struggle
> > to understand, but it seems clear to me that the changes here are truly
> > isolated to the new "-x" option - IOWs if "-x" is not specified, there is
> > no behavior change at all.
> >
> > Since this is intended to attempt recovery from an already-corrupted
> > dump image as a last resort, and given that there are already some xfstests
> > in place to validate the behavior, I feel reasonably comfortable with
> > merging this.
> 
> Documentation nit: Can restore detect that it's been given a corrupt
> dump, and if so, should it warn the user to rerun with -x?
> 
> --D

I am assuming that even though you have concerns about not having
XFS_BULK_IREQ_SPECIAL_ROOT employed in dump yet (and the documentation nit :),
you are not opposed to have this patch merged?


-- 
Carlos Maiolino
