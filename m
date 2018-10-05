Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38022 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727725AbeJEWve (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Oct 2018 18:51:34 -0400
Subject: Re: [PATCH 0/15] xfsprogs: sparse fixes
References: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
 <20181005154123.GQ19324@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <1afba543-0a8d-6805-5fec-051aba616639@sandeen.net>
Date: Fri, 5 Oct 2018 10:52:16 -0500
MIME-Version: 1.0
In-Reply-To: <20181005154123.GQ19324@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org



On 10/5/18 10:41 AM, Darrick J. Wong wrote:
> On Thu, Oct 04, 2018 at 11:03:01PM -0500, Eric Sandeen wrote:
>> A handful of sparse fixes, more or less one patch per issue.
> 
> Mostly looks fine except for the things I complained about on IRC:
> 
> Patch 7 commit message ought to identify the other definer of MS_
> constants.
> 
> Patch 14 commit message has a typo "activel".
> 
> *progname probably should be in libfrog.h so that scrub doesn't
> have to include libxfs.h (scrub doesn't link against libxfs) (patch 11).
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Will fix, scout's honor, thanks for the review.

-Eric
