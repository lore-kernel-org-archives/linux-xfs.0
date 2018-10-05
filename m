Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:32884 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbeJEWko (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 18:40:44 -0400
Date: Fri, 5 Oct 2018 08:41:23 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/15] xfsprogs: sparse fixes
Message-ID: <20181005154123.GQ19324@magnolia>
References: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 04, 2018 at 11:03:01PM -0500, Eric Sandeen wrote:
> A handful of sparse fixes, more or less one patch per issue.

Mostly looks fine except for the things I complained about on IRC:

Patch 7 commit message ought to identify the other definer of MS_
constants.

Patch 14 commit message has a typo "activel".

*progname probably should be in libfrog.h so that scrub doesn't
have to include libxfs.h (scrub doesn't link against libxfs) (patch 11).

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> -Eric
> 
