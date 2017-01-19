Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57670 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753087AbdASPbC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Jan 2017 10:31:02 -0500
Subject: Re: [PATCH] xfs_io: add DAX and CoW extent-size flags to chattr
 manpage
References: <20170119073511.11590-1-eguan@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a1c2477e-f7e9-7537-77bb-ead8682bb578@sandeen.net>
Date: Thu, 19 Jan 2017 09:14:11 -0600
MIME-Version: 1.0
In-Reply-To: <20170119073511.11590-1-eguan@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org

On 1/19/17 1:35 AM, Eryu Guan wrote:
> Manpage is not updated after adding set/clear DAX and CoW
> extent-size flags support to xfs_io.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

The manpage also references xfsctl(3) for descriptions, so that
could probably use some updating as well, if you feel inclined.

-Eric

> ---
>  man/man8/xfs_io.8 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 885df7f..fccddcf 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -798,7 +798,7 @@ can be used to restrict the output to directories only).
>  This is a depth first descent, it does not follow symlinks and
>  it also does not cross mount points.
>  .TP
> -.BR chattr " [ " \-R " | " \-D " ] [ " + / \-riasAdtPneEfS " ]"
> +.BR chattr " [ " \-R " | " \-D " ] [ " + / \-riasAdtPneEfSxC " ]"
>  Change extended inode flags on the currently open file. The
>  .B \-R
>  and
> 
