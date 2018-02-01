Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:34422 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751296AbeBAW2L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Feb 2018 17:28:11 -0500
Date: Thu, 1 Feb 2018 14:28:04 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_mdrestore: Don't restore over a dump file
Message-ID: <20180201222804.GU4849@magnolia>
References: <1517517463-99951-1-git-send-email-marco.antonio.780@gmail.com>
 <3c874559-f69f-c2c0-fb40-4c40621dd58b@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c874559-f69f-c2c0-fb40-4c40621dd58b@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Marco A Benatto <marco.antonio.780@gmail.com>, linux-xfs@vger.kernel.org

On Thu, Feb 01, 2018 at 02:50:19PM -0600, Eric Sandeen wrote:
> On 2/1/18 2:37 PM, Marco A Benatto wrote:
> > Currently, if the user switch source and target parameters
> > position, xfs_mdrestore truncates the dumpfile before abort
> > the execution.
> > 
> > This patch checks the target parameter and if XFS_MD_MAGIC is
> > found, it aborts execution and leave dump file intact.
> 
> Yeah, I think this is a good idea.  It's pretty unforgiving
> to get it wrong and destroy your metadump in the process.
> 
> (though tbh I usually get a compressed dump, and
> # bzcat dumpfile.bz2 | xfs_mdrestore - target
> works quite well and is more foolproof)
> 
> So, despite the fact that I already talked with you about
> this a bit online, I think my subconscious was working on
> it in the meantime.  What you've got is generally ok, but
> I wonder if the goal is to detect switched arguments, if
> it might be simpler to first validate the given source, and
> stop if it's not a metadump file.  We've already got that in
> place, and it'd just be a question of checking the header
> unconditionally, something like this, which just moves some
> of the existing stuff work of the conditional:
> 
>         xfs_metablock_t         mb;
> 
> 
>         /* validate that our source file is really a metadump */
>         if (fread(&mb, sizeof(mb), 1, src_f) != 1)
>                 fatal("error reading from source file: %s\n", strerror(errno));
> 
>         if (be32_to_cpu(mb.mb_magic) != XFS_MD_MAGIC)
>                 fatal("specified source file is not a metadata dump\n");
> 
>         if (show_info) {
>                 if (mb.mb_info & XFS_METADUMP_INFO_FLAGS) {
>                         printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
>                         argv[optind],
>                         mb.mb_info & XFS_METADUMP_OBFUSCATED ? "":"not ",
>                         mb.mb_info & XFS_METADUMP_DIRTYLOG ? "dirty":"clean",
>                         mb.mb_info & XFS_METADUMP_FULLBLOCKS ? "full":"zeroed");
>                 } else {
>                         printf("%s: no informational flags present\n",
>                                 argv[optind]);
>                 }
> 
>                 if (argc - optind == 1)
>                         exit(0);
>         }
> 
>         /* Go back to the beginning for the restore function */
>         fseek(src_f, 0L, SEEK_SET);

So now you got /me/ looking at mdrestore and wondering, if the metadump
source is a pipe (as in your example above), won't this seek fail?  We
already read the metadump super from the stream, so we can't seek
backwards and read it again:

# cat foo.md | xfs_mdrestore -i - /dev/sda
-: not obfuscated, clean log, full metadata blocks
xfs_mdrestore: specified file is not a metadata dump

Not to mention xfs_mdrestore --help doesn't tell you there's an -i
option.

Also, we already /do/ check that the source actually has a metadump
header, the problem is that we open the destination O_TRUNC before we
read the header and so if the target was a file, *poof* it's empty.

I think we'll need to fix both of those problems.  Maybe we solve it by
opening src_f, checking the magic, optionally printing the metadump
info, and then passing both src_f and the header into perform_restore?

Separate patch, though.

> It's not explicitly checking the target, but it would probably serve
> the same purpose with fewer lines of new code.  Either is ok with me,
> really.  Any thoughts?
> 
> Thanks,
> -Eric
> 
> 
> > 
> > Signed-off-by: Marco A Benatto <marco.antonio.780@gmail.com>
> > ---
> >  mdrestore/xfs_mdrestore.c | 16 +++++++++++++++-
> >  1 file changed, 15 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> > index c49c13a..b4bf7b4 100644
> > --- a/mdrestore/xfs_mdrestore.c
> > +++ b/mdrestore/xfs_mdrestore.c
> > @@ -205,7 +205,7 @@ main(
> >  	int 		argc,
> >  	char 		**argv)
> >  {
> > -	FILE		*src_f;
> > +	FILE		*src_f, *dst_f;
> >  	int		dst_fd;
> >  	int		c;
> >  	int		open_flags;
> > @@ -277,6 +277,7 @@ main(
> >  
> >  	optind++;
> >  
> > +
> >  	/* check and open target */
> >  	open_flags = O_RDWR;
> >  	is_target_file = 0;
> > @@ -285,6 +286,19 @@ main(
> >  		open_flags |= O_CREAT;
> >  		is_target_file = 1;
> >  	} else if (S_ISREG(statbuf.st_mode))  {
> > +		xfs_metablock_t mb;

dst_f could be declared here, right?

> > +
> > +		dst_f = fopen(argv[optind], "rb");
> > +		if (dst_f == NULL)
> > +			fatal("cannot open target\n");
> > +
> > +		if (fread(&mb, sizeof(mb), 1, dst_f) == 1) {
> > +			if (be32_to_cpu(mb.mb_magic) == XFS_MD_MAGIC)
> > +				fatal("target file is a xfs_metadump. switched arguments?\n");
> > +		}

if (fread(&mb, sizeof(mb), 1, dst_f) == 1 &&
    mb.mb_magic == cpu_to_be32(XFS_MD_MAGIC))
	fatal("...");

?

--D

> > +
> > +		fclose(dst_f);
> > +
> >  		open_flags |= O_TRUNC;
> >  		is_target_file = 1;
> >  	} else  {
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
