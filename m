Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D84DBC433F5
	for <linux-xfs@archiver.kernel.org>; Sat,  6 Nov 2021 16:43:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6FCF61242
	for <linux-xfs@archiver.kernel.org>; Sat,  6 Nov 2021 16:43:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbhKFQq3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 6 Nov 2021 12:46:29 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:53598 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231977AbhKFQq1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Nov 2021 12:46:27 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 1A6GhebM012167
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 6 Nov 2021 12:43:41 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id C4AEA15C00B9; Sat,  6 Nov 2021 12:43:40 -0400 (EDT)
Date:   Sat, 6 Nov 2021 12:43:40 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        leah.rumancik@gmail.com
Subject: Re: xfs/076 takes a long long time testing with a realtime volume
Message-ID: <YYawvNGGeQfctXWP@mit.edu>
References: <YYVo8ZyKpy4Di0pK@mit.edu>
 <YYXhNip3PctJAaDY@mit.edu>
 <20211106020804.GU24307@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211106020804.GU24307@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 05, 2021 at 07:08:04PM -0700, Darrick J. Wong wrote:
> On Fri, Nov 05, 2021 at 09:58:14PM -0400, Theodore Ts'o wrote:
> > After committing some exclusions into my test runner framework (see
> > below), I tested a potential fix to xfs/076 which disables the
> > real-time volume when creating the scratch volume.  Should I send it
> > as a formal patch to fstests?
> 
> Does adding:
> 
> _xfs_force_bdev data $SCRATCH_MNT
> 
> right after _scratch_mount make the performance problem go away?  Sparse
> inodes and realtime are a supported configuration.

The test fails with an "fpunch failed" in 076.out.bad, and nothing
enlightening in 076.full.  But it does complete in roughly two
minutes.

						- Ted
