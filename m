Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44688 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751548AbdJ0CBR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Oct 2017 22:01:17 -0400
Subject: Re: [PATCH 05/10] xfs_repair: clear DAX flag from non-file inodes
References: <150905608689.28563.9670731739870415773.stgit@magnolia>
 <150905612541.28563.17883126104053106652.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <766b4cf0-f6ba-732a-8095-5391281ac8c9@sandeen.net>
Date: Thu, 26 Oct 2017 21:01:15 -0500
MIME-Version: 1.0
In-Reply-To: <150905612541.28563.17883126104053106652.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 10/26/17 5:15 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The DAX flag should only be set for files and directories.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/dinode.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 


Reviewed-by: Eric Sandeen <sandeen@redhat.com>
