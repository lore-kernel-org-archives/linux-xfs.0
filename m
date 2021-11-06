Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CFC1C433EF
	for <linux-xfs@archiver.kernel.org>; Sat,  6 Nov 2021 14:52:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E559160EBB
	for <linux-xfs@archiver.kernel.org>; Sat,  6 Nov 2021 14:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbhKFOzA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 6 Nov 2021 10:55:00 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:38629 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230527AbhKFOzA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Nov 2021 10:55:00 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 1A6EqATv010505
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 6 Nov 2021 10:52:10 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 04B1815C00B9; Sat,  6 Nov 2021 10:52:09 -0400 (EDT)
Date:   Sat, 6 Nov 2021 10:52:09 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, leah.rumancik@gmail.com
Subject: Re: soft lockup in xfs/170 on a file system formatted with -m crc=0
Message-ID: <YYaWma0v5qrECIts@mit.edu>
References: <YYVo8ZyKpy4Di0pK@mit.edu>
 <20211106021031.GV24307@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211106021031.GV24307@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 05, 2021 at 07:10:31PM -0700, Darrick J. Wong wrote:
> On Fri, Nov 05, 2021 at 01:25:05PM -0400, Theodore Ts'o wrote:
> > Is this a known failure?  I can reliably reproduce this soft lockup
> > running xfs/170 using "gce-xfstests -c xfs/v4 xfs/170" using
> > v5.15-rc4.  The xfs/v4 test config formats the file system using -m
> > crc=0 with no special mount options.
> > 
> > I've attached the kernel config that I used; it's the standard one
> > obtained via "gce-xfstests install-kconfig"[1].
> 
> Also, uh... 5.15 didn't prove to be a stable testing base (at least not
> without a bunch of other patches to kvm, the memory manager, and the
> block layer) until 5.15-rc7.

Thanks, I haven't had a problem using 5.15-rc4 as a testing base for
ext4, so I wasn't aware of that.  I just tested xfs/170 on 5.15 final,
and it is no longer triggering a soft lockup.

Thanks again,

					- Ted
