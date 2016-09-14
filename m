Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37422 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754539AbcINWOp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Sep 2016 18:14:45 -0400
Subject: Re: [PATCH 2/3] xfs_quota: print and path output formatting: maintain
 reverse compatibility
References: <1473866381-28975-1-git-send-email-billodo@redhat.com>
 <1473866381-28975-3-git-send-email-billodo@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <0e879c60-df5f-b408-8624-5bcddb42301d@sandeen.net>
Date: Wed, 14 Sep 2016 17:14:40 -0500
MIME-Version: 1.0
In-Reply-To: <1473866381-28975-3-git-send-email-billodo@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bill O'Donnell <billodo@redhat.com>, linux-xfs@vger.kernel.org
Cc: xfs@oss.sgi.com

On 9/14/16 10:19 AM, Bill O'Donnell wrote:
> This patch adjusts the formatting of the xfs_quota print and
> path outputs, in order to maintain reverse compatability:
> when -f flag isn't used, need to keep the output same as in
> previous version.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> ---
>  quota/path.c | 67 +++++++++++++++++++++++++++++++++++-------------------------
>  1 file changed, 39 insertions(+), 28 deletions(-)
> 
> diff --git a/quota/path.c b/quota/path.c
> index aa3d33e..ed9c044 100644
> --- a/quota/path.c
> +++ b/quota/path.c
> @@ -36,39 +36,50 @@ printpath(
>  	int		c;
>  
>  	if (index == 0) {
> -		printf(_("%sFilesystem          Pathname\n"),
> -			number ? _("      ") : "");
> +		if (foreign_allowed)
> +			printf(_("%s    Filesystem          Pathname\n"),
> +			       number ? _("      ") : "");
> +		else
> +			printf(_("%sFilesystem          Pathname\n"),
> +			       number ? _("      ") : "");

Ok, this prints the header, with differing leading whitespace depending on
foreign and/or "are we printing the path number?"  It works but it seems
confusing to me.

What about just being explicit about it, something like:

+       /* print header, accommodating for path nr and/or foreign flag */
  	if (index == 0) {
+               if (number)
+                       printf(_("      "));
+               if (foreign_allowed)
+                       printf(_("    "));
+               printf(_("Filesystem          Pathname\n"));

or maybe:

  	if (index == 0) {
+		printf(_("%s%sFilesystem          Pathname\n"),
+			number ? _("      ") : "",
+			foreign_allowed ? _("    ") : "");

to follow the existing code, just with another "optional" column for (F)?

>  	}
>  	if (number) {
>  		printf(_("%c%03d%c "), braces? '[':' ', index, braces? ']':' ');
>  	}
> -	printf("%s ", (path->fs_flags & FS_FOREIGN) ? "(F)" : "   ");
> -	printf(_("%-19s %s"), path->fs_dir, path->fs_name);
> -	if (path->fs_flags & FS_PROJECT_PATH) {
> -		prj = getprprid(path->fs_prid);
> -		printf(_(" (project %u"), path->fs_prid);
> -		if (prj)
> -			printf(_(", %s"), prj->pr_name);
> -		printf(")");
> -	} else if (xfsquotactl(XFS_GETQSTAT, path->fs_name, 0, 0,
> -				(void *)&qstat) == 0 && qstat.qs_flags) {
> -		c = 0;
> -		printf(" (");
> -		if (qstat.qs_flags & XFS_QUOTA_UDQ_ENFD)
> -			c = printf("uquota");
> -		else if (qstat.qs_flags & XFS_QUOTA_UDQ_ACCT)
> -			c = printf("uqnoenforce");
> -		if (qstat.qs_flags & XFS_QUOTA_GDQ_ENFD)
> -			c = printf("%sgquota", c ? ", " : "");
> -		else if (qstat.qs_flags & XFS_QUOTA_GDQ_ACCT)
> -			c = printf("%sgqnoenforce", c ? ", " : "");
> -		if (qstat.qs_flags & XFS_QUOTA_PDQ_ENFD)
> -			printf("%spquota", c ? ", " : "");
> -		else if (qstat.qs_flags & XFS_QUOTA_PDQ_ACCT)
> -			printf("%spqnoenforce", c ? ", " : "");
> -		printf(")");

Ok below is mostly just moving indentation under this:

> +	if (!((path->fs_flags & FS_FOREIGN) && !foreign_allowed)) {

a big conditional, which I think means "If it's not a foreign filesystem
with foreign filesystems disallowed..."

Can we ever get her when that's not true?  Do we ever call into this
with a foreign fs when !foreign_allowed?  I don't think so, because we
break in the pathlist_f caller, right?  and in print_f ... oh right, need
to break out of print_f, too.  See my latest reply to patch 1.

With that, should not need to move any of this code under the conditional;
it can go away and the code can remain where it's at.

> +		printf("%s", (path->fs_flags & FS_FOREIGN) ? "(F) " : "");
> +		if (path->fs_flags & FS_FOREIGN)
> +			printf(_("%-19s %s"), path->fs_dir, path->fs_name);
> +		else if (foreign_allowed)
> +			printf(_("    %-19s %s"), path->fs_dir, path->fs_name);
> +		else
> +			printf(_("%-19s %s"), path->fs_dir, path->fs_name);

Hm, above you've got 3 cases for 2 different printf strings.  ;)  This would
be much simpler as:

 	if (number) {
  		printf(_("%c%03d%c "), braces? '[':' ', index, braces? ']':' ');
+       if (foreign_allowed)
+               printf("%s", path->fs_flags & FS_FOREIGN ? "(F) " : "    ");
+
        printf(_("%-19s %s"), path->fs_dir, path->fs_name);

So if we're printing numbers, print that column; if we're dealing with foreign FS's,
print that column, and then print the common information in the last 2 columns.

> +		if (path->fs_flags & FS_PROJECT_PATH) {
> +			prj = getprprid(path->fs_prid);
> +			printf(_(" (project %u"), path->fs_prid);
> +			if (prj)
> +				printf(_(", %s"), prj->pr_name);
> +			printf(")");
> +		} else if (xfsquotactl(XFS_GETQSTAT, path->fs_name, 0, 0,
> +				       (void *)&qstat) == 0 && qstat.qs_flags) {
> +			c = 0;
> +			printf(" (");
> +			if (qstat.qs_flags & XFS_QUOTA_UDQ_ENFD)
> +				c = printf("uquota");
> +			else if (qstat.qs_flags & XFS_QUOTA_UDQ_ACCT)
> +				c = printf("uqnoenforce");
> +			if (qstat.qs_flags & XFS_QUOTA_GDQ_ENFD)
> +				c = printf("%sgquota", c ? ", " : "");
> +			else if (qstat.qs_flags & XFS_QUOTA_GDQ_ACCT)
> +				c = printf("%sgqnoenforce", c ? ", " : "");
> +			if (qstat.qs_flags & XFS_QUOTA_PDQ_ENFD)
> +				printf("%spquota", c ? ", " : "");
> +			else if (qstat.qs_flags & XFS_QUOTA_PDQ_ACCT)
> +				printf("%spqnoenforce", c ? ", " : "");
> +			printf(")");
> +		}
> +		printf("\n");

and again w/o the conditional this whole indentation move goes away, and
the patch looks much simpler overall :)  -

diff --git a/quota/path.c b/quota/path.c
index cf00fc5..622c6b5 100644
--- a/quota/path.c
+++ b/quota/path.c
@@ -36,14 +36,19 @@ printpath(
        int             c;
 
        if (index == 0) {
-               printf(_("%sFilesystem          Pathname\n"),
-                       number ? _("      ") : "");
+               printf(_("%s%sFilesystem          Pathname\n"),
+                       number ? _("      ") : "",
+                       foreign_allowed ? _("    ") : "");
        }
-       if (number) {
+
+       if (number)
                printf(_("%c%03d%c "), braces? '[':' ', index, braces? ']':' ');
-       }
-       printf("%s ", (path->fs_flags & FS_FOREIGN) ? "(F)" : "   ");
+
+       if (foreign_allowed)
+               printf("%s", path->fs_flags & FS_FOREIGN ? "(F) " : "    ");
+
        printf(_("%-19s %s"), path->fs_dir, path->fs_name);
+
        if (path->fs_flags & FS_PROJECT_PATH) {
                prj = getprprid(path->fs_prid);
                printf(_(" (project %u"), path->fs_prid);



(but don't take my word for it!  ;)  I think this works though.)
