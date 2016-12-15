Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33308 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754253AbcLOSig (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Dec 2016 13:38:36 -0500
Subject: Re: [PATCH 3/3] xfs_io: fix the minimum arguments to the reflink
 command
References: <148182550558.24784.5628335536185073955.stgit@birch.djwong.org>
 <148182551808.24784.14290922921211733530.stgit@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e5f24dd4-8c2b-7b72-0622-22a1e14e6ffc@sandeen.net>
Date: Thu, 15 Dec 2016 12:38:34 -0600
MIME-Version: 1.0
In-Reply-To: <148182551808.24784.14290922921211733530.stgit@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 12/15/16 12:11 PM, Darrick J. Wong wrote:
> The reflink command can reflink the entirety of two files if the
> offsets and lengths are not specified... but we forgot to permit
> that case.

Could you do me a favor and also make that clear in the help output?
The manpage says:

       reflink  [ -C ] [ -q ] src_file [src_offset dst_offset length]


but the short help doesn't indicate that it's optional:

reflink infile src_off dst_off len -- reflinks a number of bytes at a specified offset

and neither it nor the long help mentions the -C & -q switches:

xfs_io> help reflink
reflink infile src_off dst_off len -- reflinks a number of bytes at a specified offset

 Links a range of bytes (in block size increments) from a file into a range
 of bytes in the open file.  The two extent ranges need not contain identical
 data.

 Example:
 'reflink some_file 0 4096 32768' - links 32768 bytes from some_file at
                                    offset 0 to into the open file at
                                    position 4096
 'reflink some_file' - links all bytes from some_file into the open file
                       at position 0

 Reflink a range of blocks from a given input file to the open file.  Both
 files share the same range of physical disk blocks; a write to the shared
 range of either file should result in the write landing in a new block and
 that range of the file being remapped (i.e. copy-on-write).  Both files
 must reside on the same filesystem.

V2 or patch 4/3 is fine :)

Thanks,
-Eric

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  io/reflink.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/io/reflink.c b/io/reflink.c
> index a09e82d..d26cbdd 100644
> --- a/io/reflink.c
> +++ b/io/reflink.c
> @@ -302,7 +302,7 @@ reflink_init(void)
>  	reflink_cmd.name = "reflink";
>  	reflink_cmd.altname = "rl";
>  	reflink_cmd.cfunc = reflink_f;
> -	reflink_cmd.argmin = 4;
> +	reflink_cmd.argmin = 1;
>  	reflink_cmd.argmax = -1;
>  	reflink_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
>  	reflink_cmd.args =
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
