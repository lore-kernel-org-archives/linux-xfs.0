Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21247 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756682AbcLPAv7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Dec 2016 19:51:59 -0500
Date: Thu, 15 Dec 2016 16:51:52 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] xfs_io: fix the minimum arguments to the reflink
 command
Message-ID: <20161216005152.GD5357@birch.djwong.org>
References: <148182550558.24784.5628335536185073955.stgit@birch.djwong.org>
 <148182551808.24784.14290922921211733530.stgit@birch.djwong.org>
 <e5f24dd4-8c2b-7b72-0622-22a1e14e6ffc@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5f24dd4-8c2b-7b72-0622-22a1e14e6ffc@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, Dec 15, 2016 at 12:38:34PM -0600, Eric Sandeen wrote:
> On 12/15/16 12:11 PM, Darrick J. Wong wrote:
> > The reflink command can reflink the entirety of two files if the
> > offsets and lengths are not specified... but we forgot to permit
> > that case.
> 
> Could you do me a favor and also make that clear in the help output?
> The manpage says:
> 
>        reflink  [ -C ] [ -q ] src_file [src_offset dst_offset length]
> 
> 
> but the short help doesn't indicate that it's optional:
> 
> reflink infile src_off dst_off len -- reflinks a number of bytes at a specified offset

Hah, ok, yes, that's unclear and I'll fix it in a 4/3 patch.

--D

> 
> and neither it nor the long help mentions the -C & -q switches:
> 
> xfs_io> help reflink
> reflink infile src_off dst_off len -- reflinks a number of bytes at a specified offset
> 
>  Links a range of bytes (in block size increments) from a file into a range
>  of bytes in the open file.  The two extent ranges need not contain identical
>  data.
> 
>  Example:
>  'reflink some_file 0 4096 32768' - links 32768 bytes from some_file at
>                                     offset 0 to into the open file at
>                                     position 4096
>  'reflink some_file' - links all bytes from some_file into the open file
>                        at position 0
> 
>  Reflink a range of blocks from a given input file to the open file.  Both
>  files share the same range of physical disk blocks; a write to the shared
>  range of either file should result in the write landing in a new block and
>  that range of the file being remapped (i.e. copy-on-write).  Both files
>  must reside on the same filesystem.
> 
> V2 or patch 4/3 is fine :)
> 
> Thanks,
> -Eric
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  io/reflink.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > 
> > diff --git a/io/reflink.c b/io/reflink.c
> > index a09e82d..d26cbdd 100644
> > --- a/io/reflink.c
> > +++ b/io/reflink.c
> > @@ -302,7 +302,7 @@ reflink_init(void)
> >  	reflink_cmd.name = "reflink";
> >  	reflink_cmd.altname = "rl";
> >  	reflink_cmd.cfunc = reflink_f;
> > -	reflink_cmd.argmin = 4;
> > +	reflink_cmd.argmin = 1;
> >  	reflink_cmd.argmax = -1;
> >  	reflink_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> >  	reflink_cmd.args =
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
