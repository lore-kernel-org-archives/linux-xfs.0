Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 67CDA7CA7
	for <xfs@oss.sgi.com>; Fri,  2 Sep 2016 18:10:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 330E88F8037
	for <xfs@oss.sgi.com>; Fri,  2 Sep 2016 16:10:33 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id soRQKzX6sK8a3JIG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 02 Sep 2016 16:10:32 -0700 (PDT)
Date: Fri, 2 Sep 2016 18:10:29 -0500
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: [PATCH v2] xfsprogs: (xfs_quota) foreign fs path handling changes
Message-ID: <20160902231029.GA26718@redhat.com>
References: <1472478012-23627-1-git-send-email-billodo@redhat.com>
	<1472851328-25542-1-git-send-email-billodo@redhat.com>
	<45ba5c3c-9971-b117-98c0-cc8b65ea0704@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <45ba5c3c-9971-b117-98c0-cc8b65ea0704@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Fri, Sep 02, 2016 at 05:57:12PM -0500, Eric Sandeen wrote:
> On 9/2/16 4:22 PM, Bill O'Donnell wrote:
> > Version 2 of this patch to xfs_quota in order to properly
> > handle foreign fs mount paths. Note that this version (2)
> > abandons the incorrect approach of version 1, in which the
> > fs-table wasn't populated with the foreign fs paths.
> 
> Normally version stuff goes after the "---" so that it doesn't
> end up in the permanent commitlog; it's useful to a reviewer,
> but not so much to a code archaeologist in the future.
> In theory, the committed version corrects the sins of all prior
> versions.  :)
agreed.
> 
> > Commits b20b6c2 and 29647c8 modified xfs_quota for use on
> > non-XFS filesystems. Modifications to fs_initialise_mounts
> > (paths.c) resulted in an xfstest fail (xfs/261), due to foreign
> > fs paths being picked up from the fs table, and the xfs_quota
> > print command complaining about not being able to print the
> > foreign paths.
> > 
> > This patch fixes the foreign path print problem, with a
> > modification of the print and path commands to always be
> > allowed, regardless of fs type (similar to the help and quit
> > commands).
> > 
> > Additionally, the printpath() function in path.c is corrected
> > to skip printing foreign paths unless the -f flag is thrown
> > in the xfs_quota invocation. Also, some minor formatting
> > changes and comment clarifications to the print command are
> > made.
> 
> In general, if you say "Additionally..." in a commitlog that's
> your hint that you should be starting a new commitlog on a
> new patch.  :)  Probably best to do the formatting stuff as
> a last patch once everything else works nicely.
agreed.

> 
> I think this commit contains at least 3 distinct changes:
> 
> * Fix the print & path command functionality
> * Fix the printpath text alignment
> * Modify the init_check_command to cover a new case
yep.

> 
> > Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> > ---
> >  quota/init.c | 19 +++++++++++++------
> >  quota/path.c | 19 ++++++++++++++-----
> >  2 files changed, 27 insertions(+), 11 deletions(-)
> > 
> > diff --git a/quota/init.c b/quota/init.c
> > index 44be322..9f95e8f 100644
> > --- a/quota/init.c
> > +++ b/quota/init.c
> > @@ -112,21 +112,28 @@ init_check_command(
> >  	if (!fs_path)
> >  		return 1;
> >  
> > -	/* Always run commands that we are told to skip here */
> > +	/* Always run commands that are valid for all fs types. */
> >  	if (ct->flags & CMD_ALL_FSTYPES)
> >  		return 1;
> >  
> > -	/* if it's an XFS filesystem, always run the command */
> > +	/* If it's an XFS filesystem, always run the command. */
> >  	if (!(fs_path->fs_flags & FS_FOREIGN))
> >  		return 1;
> >  
> > -	/* If the user specified foreign filesysetms are ok, run it */
> > +	/* If the user specified foreign filesystems are ok (-f), run cmd. */
> >  	if (foreign_allowed &&
> > -	    (ct->flags & CMD_FLAG_FOREIGN_OK))
> > +		(ct->flags & CMD_FLAG_FOREIGN_OK))
> 
> original indentation is preferred, otherwise it looks like this line
> is inside the conditional rather than part of it.

Yeah, my editor config on the test box didn't match my workstation's. :(
I'll fix it.

> 
> >  		return 1;
> >  
> > -	/* foreign filesystem and it's not a valid command! */
> > -	fprintf(stderr, _("%s command is for XFS filesystems only\n"),
> > +	/* If cmd not allowed on foreign fs, regardless of -f flag, skip it. */
> > +	if (!(ct->flags & CMD_FLAG_FOREIGN_OK)) {
> > +		fprintf(stderr, _("%s: command is for XFS filesystems only\n"),
> > +		ct->name);
> 
> and here we'd normally tab the argument over to the start of the first (, like:
> 
> +		fprintf(stderr, _("%s: command is for XFS filesystems only\n"),
> +			ct->name);
> 

yep.


> > +		return 0;
> > +	}
> > +
> > +	/* foreign fs, but cmd only allowed via -f flag. Skip it. */
> > +	fprintf(stderr, _("%s: foreign filesystem. Use -f to enable.\n"),
> >  		ct->name);
> 
> I *think* that changes to this function - determining when a command is OK, and
> what to say if it's not - should probably be a separate commit for ease of
> review.

agreed.

> 
> >  	return 0;
> >  }
> > diff --git a/quota/path.c b/quota/path.c
> > index a623d25..d8f8f3c 100644
> > --- a/quota/path.c
> > +++ b/quota/path.c
> > @@ -36,14 +36,23 @@ printpath(
> >  	int		c;
> >  
> >  	if (index == 0) {
> > -		printf(_("%sFilesystem          Pathname\n"),
> > +		printf(_("%s    Filesystem          Pathname\n"),
> >  			number ? _("      ") : "");
> 
> This unconditionally changes the resulting table even without -f;
> probably best to avoid that if the goal is to behave as before
> without -f.
> 
> >  	}
> >  	if (number) {
> >  		printf(_("%c%03d%c "), braces? '[':' ', index, braces? ']':' ');
> >  	}
> 
> so we print a path number unconditionally here if asked...
> 
> > -	printf("%s ", (path->fs_flags & FS_FOREIGN) ? "(F)" : "   ");
> > -	printf(_("%-19s %s"), path->fs_dir, path->fs_name);
> > +	if (path->fs_flags & FS_FOREIGN) {
> > +	    if (foreign_allowed) {
> > +	      printf("(F) ");
> > +	      printf(_("%-19s %s"), path->fs_dir, path->fs_name);
> > +	    }
> > +	}
> 
> 4-space tabs?

sorry. editor problem again.

> 
> If it's foreign and foreign is allowed, you print (F) and the info,
> above...
> 
> > +	else {
> 
> On the same line as the previous closing brace, please: } else {

yep.

> 
> > +	      printf("    ");
> > +	      printf(_("%-19s %s"), path->fs_dir, path->fs_name);
> > +	}
> 
> 4-space tabs?
> 
> And here, if it's not foreign, you print the info without the (F).
> 
> but the remaining case is if it's foreign and foreign isn't allowed,
> in that case we fall through and print "\n", so we get a blank line.
> 
> So now with -f we get:
> 
> # quota/xfs_quota -x -f -c print
>     Filesystem          Pathname
> (F) /                   /dev/mapper/vg_bp05-lv_root
> (F) /boot               /dev/sda1
>     /mnt/test2          /dev/sdc1
>     /root/mnt           /dev/loop0
> 
> 
> but without -f we get:
> 
> # quota/xfs_quota -x -c print
>     Filesystem          Pathname
> 
> 
>     /mnt/test2          /dev/sdc1
>     /root/mnt           /dev/loop0
> 
> those blank lines probably aren't quite what you wanted.
> (same behavior exists for the path command)

Yeah, I noticed that, but forgot to fix it.

> 
> I think the way to fix this is to not call printpath from path_f
> and print_f if (flags & FOREIGN && !foreign_allowed); just skip
> over those filesystems.
> 
> But that leads to another issue; if the first path in the
> table is foreign, we won't get index zero, so we won't get the
> header line.  And, we'll have weird gaps in the ordering,
> because we skip over intermingled foreign filesystems.
> 
> The way to fix that is to change fs_table_insert() to insert xfs
> filesystems at the front of the fs_table, and foreign filesystems
> at the end of the fs_table.  The easiest way to do that is to
> just push xfs filesystems onto the front and foreign filesystems
> onto the end, but that will reverse the ordering of the xfs
> filesystems; probably best to keep that ordering intact - again,
> to keep things as close as possible to prior behavior.
> 
> That patch to sort fs_table should probably be a separate patch,
> early in a series.
> 
> If you do all that, I think you can clean up the the various formatting
> conditionals in this function, too; you'll only get here with a foreign
> filesystem if foreign filesystems are OK, and that might simplify
> things, something like:
> 
>         /* print header, accommodating for path nr and/or foreign flag */
>         if (index == 0) {
>                 if (number)
>                         printf(_("      "));
>                 if (foreign_allowed)
>                         printf("    ");
>                 printf(_("Filesystem          Pathname\n"));
>         }
> 	/* print path number if requested */
>         if (number)
>                 printf(_("%c%03d%c "), braces? '[':' ', index, braces? ']':' ');
> 
> 	/* Print foreign or not, if we're into that kind of thing */
>         if (foreign_allowed)
>                 printf("%s", path->fs_flags & FS_FOREIGN ? "(F) " : "    ");
> 
> 	/* Ok finally, print the actual fs info */
>         printf(_("%-19s %s"), path->fs_dir, path->fs_name);
> 
> I *think* that should make the output identical to before, if -f
> isn't specified.

Agreed.

> 
> > +
> >  	if (path->fs_flags & FS_PROJECT_PATH) {
> >  		prj = getprprid(path->fs_prid);
> >  		printf(_(" (project %u"), path->fs_prid);
> > @@ -128,7 +137,7 @@ path_init(void)
> >  	path_cmd.cfunc = path_f;
> >  	path_cmd.argmin = 0;
> >  	path_cmd.argmax = 1;
> > -	path_cmd.flags = CMD_FLAG_GLOBAL | CMD_FLAG_FOREIGN_OK;
> > +	path_cmd.flags = CMD_FLAG_GLOBAL | CMD_ALL_FSTYPES;
> 
> that's a little unexpected, because we don't actually want to
> unconditionally print all filesystem types; it's only done if requested
> with -f.
> 
> I think you did this so we didn't get a failure on the first foreign fs,
> if -f wasn't specified, and stop printing anything else after that.

Correct.

> 
> But if the table is sorted as suggested above, you can just break out
> of the loops calling printpath when you hit the first foreign path,
> if foreign filesystems aren't allowed with "-f," and then it looks a
> little more consistent here, if you leave it as FOREIGN_OK.

Agreed.
I'll sort it out on V3.

Thanks for the review!
Bill


> 
> -Eric
> 
> >  	path_cmd.oneline = _("set current path, or show the list of paths");
> >  
> >  	print_cmd.name = "print";
> > @@ -136,7 +145,7 @@ path_init(void)
> >  	print_cmd.cfunc = print_f;
> >  	print_cmd.argmin = 0;
> >  	print_cmd.argmax = 0;
> > -	print_cmd.flags = CMD_FLAG_GLOBAL | CMD_FLAG_FOREIGN_OK;
> > +	print_cmd.flags = CMD_FLAG_GLOBAL | CMD_ALL_FSTYPES;
> >  	print_cmd.oneline = _("list known mount points and projects");
> >  
> >  	if (expert)
> > 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
