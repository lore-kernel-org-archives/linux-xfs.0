Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36052 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750969AbeECSw3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 May 2018 14:52:29 -0400
Subject: Re: [PATCH 3/9] mkfs: use geometry generation / helper functions
References: <152401952391.13048.15040850425873030425.stgit@magnolia>
 <152401954281.13048.8462957622341585756.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <503e91d2-f369-9190-6da4-916bd3d2ba43@sandeen.net>
Date: Thu, 3 May 2018 13:52:28 -0500
MIME-Version: 1.0
In-Reply-To: <152401954281.13048.8462957622341585756.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 4/17/18 9:45 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Since libxfs now has a function to fill out the geometry structure
> and libfrog has a function to pretty-print the geometry, have mkfs
> use the two helpers instead of open-coding it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

We should make (lib)xfs_fs_geometry a void and get rid of the pointless
error handling, but that's a patch for another day.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
