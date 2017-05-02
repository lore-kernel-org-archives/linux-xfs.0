Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23260 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750758AbdEBXQ1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 May 2017 19:16:27 -0400
Date: Tue, 2 May 2017 16:16:19 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 2/2] xfs_io: add missed quotation marks in man page
Message-ID: <20170502231619.GE5973@birch.djwong.org>
References: <1493012000-9454-1-git-send-email-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1493012000-9454-1-git-send-email-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 24, 2017 at 01:33:20PM +0800, Zorro Lang wrote:
> The description about set_encpolicy command in xfs_io man page missed
> some quotation marks. It's a little picky, but it really causes the
> quotation marks can't match each other.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
> 
> Hi,
> 
> Actually this's the first version for this patch, I hit this problem
> when I tried to add "inode" command under "set_encpolicy" command.
> 
> That missed quotation marks always break the format which I used to
> describe the "inode" command, so I have to do this change with that
> inode command patch together.

/me hates looking at nroff, but I think this looks ok....
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>


--D

> 
> Thanks,
> Zorro
> 
>  man/man8/xfs_io.8 | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index a7c2a1e..a686ef5 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -949,7 +949,7 @@ was specified on the commandline, the maximum possible inode number in
>  the system will be printed along with its size.
>  .PD
>  .TP
> -.BI "set_encpolicy [ \-c " mode " ] [ \-n " mode " ] [ \-f " flags " ] [ \-v " version " ] [ " keydesc " ]
> +.BI "set_encpolicy [ \-c " mode " ] [ \-n " mode " ] [ \-f " flags " ] [ \-v " version " ] [ " keydesc " ]"
>  On filesystems that support encryption, assign an encryption policy to the
>  current file.
>  .I keydesc
> @@ -958,16 +958,16 @@ If not specified, a "default" key descriptor of all 0's will be used.
>  .RS 1.0i
>  .PD 0
>  .TP 0.4i
> -.BI \-c " mode
> +.BI \-c " mode"
>  contents encryption mode (e.g. AES-256-XTS)
>  .TP
> -.BI \-n " mode
> +.BI \-n " mode"
>  filenames encryption mode (e.g. AES-256-CTS)
>  .TP
> -.BI \-f " flags
> +.BI \-f " flags"
>  policy flags (numeric)
>  .TP
> -.BI \-v " version
> +.BI \-v " version"
>  version of policy structure (numeric)
>  .RE
>  .PD
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
