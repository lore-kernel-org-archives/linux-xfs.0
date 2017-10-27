Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45000 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751915AbdJ0CGL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Oct 2017 22:06:11 -0400
Subject: Re: [PATCH 06/10] xfs_repair: fix cowextsize field checking and
 repairing
References: <150905608689.28563.9670731739870415773.stgit@magnolia>
 <150905613147.28563.3642613984403228295.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b57f41c8-ce22-043a-ba04-b1692530a4de@sandeen.net>
Date: Thu, 26 Oct 2017 21:06:10 -0500
MIME-Version: 1.0
In-Reply-To: <150905613147.28563.3642613984403228295.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 10/26/17 5:15 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure that we never leave the filesystem with a zero cowextsize hint
> while the cowextsize inode flag is set.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Ok.  Is there anything that catches cowextsize set on di_version < 3?

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

