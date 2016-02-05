Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 951C57CA2
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 18:04:11 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 071BBAC001
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 16:04:07 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id IhTt8u2Xxf17N8il for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2016 16:04:04 -0800 (PST)
Subject: Re: [PATCH 1/2] xfs_quota: allow operation on foreign filesystem types
References: <1454627718-19583-1-git-send-email-david@fromorbit.com>
	<1454627718-19583-2-git-send-email-david@fromorbit.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56B3E6F3.802@sandeen.net>
Date: Thu, 4 Feb 2016 18:04:03 -0600
MIME-Version: 1.0
In-Reply-To: <1454627718-19583-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Cc: fstests@vger.kernel.org

Looks ok, but now with the new option:

1) needs a manpage update
2) usage() should be updated to include -f

3) and I just noticed,

_("foreign mount active, %s command is for XFS filesystems only\n"),

seems kind of unclear; maybe just

_("%s command is for XFS filesystems only\n"),



But I'm also seeing a lot of noise in output with "-f" -

# quota/xfs_quota -f -x -c "report -a" 
XFS_QSYNC proj quota: Invalid argument
XFS_QSYNC proj quota: Invalid argument
XFS_QSYNC proj quota: Invalid argument

# quota/xfs_quota -f -x -c "report" /dev/sdb2
XFS_QSYNC proj quota: Invalid argument

even though there are quotas...

# repquota /mnt/scratch
*** Report for user quotas on device /dev/sdb2
Block grace time: 7days; Inode grace time: 7days
                        Block limits                File limits
User            used    soft    hard  grace    used  soft  hard  grace
----------------------------------------------------------------------
root      --      20       0       0              2     0     0       

so something's not quite right :)

-Eric

On 2/4/16 5:15 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This allows xfs_quota to be used on ext4 for project quota testing
> in xfstests.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  include/command.h |  3 ++-
>  include/path.h    |  1 +
>  io/init.h         |  2 +-
>  libxcmd/paths.c   |  7 +++----
>  quota/free.c      |  2 ++
>  quota/init.c      | 29 +++++++++++++++++++++++++++--
>  quota/init.h      |  1 +
>  quota/path.c      |  5 +++--
>  quota/project.c   |  1 +
>  quota/quot.c      |  1 +
>  quota/quota.c     |  2 ++
>  quota/report.c    | 11 +++++++++--
>  quota/state.c     |  4 +++-
>  quota/util.c      |  1 +
>  14 files changed, 57 insertions(+), 13 deletions(-)
> 
> diff --git a/include/command.h b/include/command.h
> index 7b9fc28..81d5a4d 100644
> --- a/include/command.h
> +++ b/include/command.h
> @@ -20,7 +20,8 @@
>  
>  #include <sys/time.h>
>  
> -#define CMD_FLAG_GLOBAL	((int)0x80000000)	/* don't iterate "args" */
> +#define CMD_FLAG_GLOBAL		(1<<31)	/* don't iterate "args" */
> +#define CMD_FLAG_FOREIGN_OK	(1<<30)	/* command not restricted to XFS */
>  
>  typedef int (*cfunc_t)(int argc, char **argv);
>  typedef void (*helpfunc_t)(void);
> diff --git a/include/path.h b/include/path.h
> index 46a887e..39c1a95 100644
> --- a/include/path.h
> +++ b/include/path.h
> @@ -29,6 +29,7 @@
>  
>  #define FS_MOUNT_POINT	(1<<0)
>  #define FS_PROJECT_PATH	(1<<1)
> +#define FS_FOREIGN	(1<<2)
>  
>  typedef struct fs_path {
>  	char		*fs_name;	/* Data device for filesystem 	*/
> diff --git a/io/init.h b/io/init.h
> index d773b1b..bb25242 100644
> --- a/io/init.h
> +++ b/io/init.h
> @@ -18,7 +18,7 @@
>  
>  #define CMD_NOFILE_OK	(1<<0)	/* command doesn't need an open file	*/
>  #define CMD_NOMAP_OK	(1<<1)	/* command doesn't need a mapped region	*/
> -#define CMD_FOREIGN_OK	(1<<2)	/* command not restricted to XFS files	*/
> +#define CMD_FOREIGN_OK	CMD_FLAG_FOREIGN_OK
>  
>  extern char	*progname;
>  extern int	exitcode;
> diff --git a/libxcmd/paths.c b/libxcmd/paths.c
> index 71af25f..7c8c673 100644
> --- a/libxcmd/paths.c
> +++ b/libxcmd/paths.c
> @@ -113,6 +113,9 @@ fs_table_insert(
>  			goto out_nodev;
>  	}
>  
> +	if (!platform_test_xfs_path(dir))
> +		flags |= FS_FOREIGN;
> +
>  	/*
>  	 * Make copies of the directory and data device path.
>  	 * The log device and real-time device, if non-null,
> @@ -301,8 +304,6 @@ fs_table_initialise_mounts(
>  			return errno;
>  
>  	while ((mnt = getmntent(mtp)) != NULL) {
> -		if (strcmp(mnt->mnt_type, "xfs") != 0)
> -			continue;
>  		if (!realpath(mnt->mnt_dir, rmnt_dir))
>  			continue;
>  		if (!realpath(mnt->mnt_fsname, rmnt_fsname))
> @@ -360,8 +361,6 @@ fs_table_initialise_mounts(
>  			return errno;
>  
>  	for (i = 0; i < count; i++) {
> -		if (strcmp(stats[i].f_fstypename, "xfs") != 0)
> -			continue;
>  		if (!realpath(stats[i].f_mntfromname, rmntfromname))
>  			continue;
>  		if (!realpath(stats[i].f_mntonname, rmntonname))
> diff --git a/quota/free.c b/quota/free.c
> index dcbe8ce..487260a 100644
> --- a/quota/free.c
> +++ b/quota/free.c
> @@ -16,6 +16,7 @@
>   * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  
> +#include <stdbool.h>
>  #include "command.h"
>  #include "init.h"
>  #include "quota.h"
> @@ -371,6 +372,7 @@ free_init(void)
>  	free_cmd.args = _("[-bir] [-hn] [-f file]");
>  	free_cmd.oneline = _("show free and used counts for blocks and inodes");
>  	free_cmd.help = free_help;
> +	free_cmd.flags = CMD_FLAG_FOREIGN_OK;
>  
>  	add_command(&free_cmd);
>  }
> diff --git a/quota/init.c b/quota/init.c
> index 52f7941..dfd8ce7 100644
> --- a/quota/init.c
> +++ b/quota/init.c
> @@ -24,6 +24,7 @@
>  char	*progname;
>  int	exitcode;
>  int	expert;
> +bool	foreign_allowed = false;
>  
>  static char **projopts;	/* table of project names (cmdline) */
>  static int nprojopts;	/* number of entries in name table. */
> @@ -83,15 +84,36 @@ init_args_command(
>  
>  	do {
>  		fs_path = &fs_table[index++];
> -	} while ((fs_path->fs_flags & FS_PROJECT_PATH) && index < fs_count);
> +		if (fs_path->fs_flags & FS_PROJECT_PATH)
> +			continue;
> +		if (!foreign_allowed && (fs_path->fs_flags & FS_FOREIGN))
> +			continue;
> +	} while (index < fs_count);
>  
>  	if (fs_path->fs_flags & FS_PROJECT_PATH)
>  		return 0;
> +	if (!foreign_allowed && (fs_path->fs_flags & FS_FOREIGN))
> +		return 0;
>  	if (index > fs_count)
>  		return 0;
>  	return index;
>  }
>  
> +static int
> +init_check_command(
> +	const cmdinfo_t	*ct)
> +{
> +	if (fs_path &&
> +	    !(ct->flags & CMD_FLAG_FOREIGN_OK) &&
> +	     (fs_path->fs_flags & FS_FOREIGN)) {
> +		fprintf(stderr,
> +	_("foreign mount active, %s command is for XFS filesystems only\n"),
> +			ct->name);
> +		return 0;
> +	}
> +	return 1;
> +}
> +
>  static void
>  init(
>  	int		argc,
> @@ -104,7 +126,7 @@ init(
>  	bindtextdomain(PACKAGE, LOCALEDIR);
>  	textdomain(PACKAGE);
>  
> -	while ((c = getopt(argc, argv, "c:d:D:P:p:t:xV")) != EOF) {
> +	while ((c = getopt(argc, argv, "c:d:D:fP:p:t:xV")) != EOF) {
>  		switch (c) {
>  		case 'c':	/* commands */
>  			add_user_command(optarg);
> @@ -112,6 +134,8 @@ init(
>  		case 'd':
>  			add_project_opt(optarg);
>  			break;
> +		case 'f':
> +			foreign_allowed = true;
>  		case 't':
>  			mtab_file = optarg;
>  			break;
> @@ -140,6 +164,7 @@ init(
>  
>  	init_commands();
>  	add_args_command(init_args_command);
> +	add_check_command(init_check_command);
>  
>  	/*
>  	 * Ensure that global commands don't end up with an invalid path pointer
> diff --git a/quota/init.h b/quota/init.h
> index 71706cb..6879855 100644
> --- a/quota/init.h
> +++ b/quota/init.h
> @@ -19,6 +19,7 @@
>  extern char	*progname;
>  extern int	exitcode;
>  extern int	expert;
> +extern bool	foreign_allowed;
>  
>  extern void	edit_init(void);
>  extern void	free_init(void);
> diff --git a/quota/path.c b/quota/path.c
> index bdb8c98..a623d25 100644
> --- a/quota/path.c
> +++ b/quota/path.c
> @@ -42,6 +42,7 @@ printpath(
>  	if (number) {
>  		printf(_("%c%03d%c "), braces? '[':' ', index, braces? ']':' ');
>  	}
> +	printf("%s ", (path->fs_flags & FS_FOREIGN) ? "(F)" : "   ");
>  	printf(_("%-19s %s"), path->fs_dir, path->fs_name);
>  	if (path->fs_flags & FS_PROJECT_PATH) {
>  		prj = getprprid(path->fs_prid);
> @@ -127,7 +128,7 @@ path_init(void)
>  	path_cmd.cfunc = path_f;
>  	path_cmd.argmin = 0;
>  	path_cmd.argmax = 1;
> -	path_cmd.flags = CMD_FLAG_GLOBAL;
> +	path_cmd.flags = CMD_FLAG_GLOBAL | CMD_FLAG_FOREIGN_OK;
>  	path_cmd.oneline = _("set current path, or show the list of paths");
>  
>  	print_cmd.name = "print";
> @@ -135,7 +136,7 @@ path_init(void)
>  	print_cmd.cfunc = print_f;
>  	print_cmd.argmin = 0;
>  	print_cmd.argmax = 0;
> -	print_cmd.flags = CMD_FLAG_GLOBAL;
> +	print_cmd.flags = CMD_FLAG_GLOBAL | CMD_FLAG_FOREIGN_OK;
>  	print_cmd.oneline = _("list known mount points and projects");
>  
>  	if (expert)
> diff --git a/quota/project.c b/quota/project.c
> index 17a83b0..79a0a8e 100644
> --- a/quota/project.c
> +++ b/quota/project.c
> @@ -355,6 +355,7 @@ project_init(void)
>  	project_cmd.argmax = -1;
>  	project_cmd.oneline = _("check, setup or clear project quota trees");
>  	project_cmd.help = project_help;
> +	project_cmd.flags = CMD_FLAG_FOREIGN_OK;
>  
>  	if (expert)
>  		add_command(&project_cmd);
> diff --git a/quota/quot.c b/quota/quot.c
> index 9116e48..cff8629 100644
> --- a/quota/quot.c
> +++ b/quota/quot.c
> @@ -16,6 +16,7 @@
>   * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  
> +#include <stdbool.h>
>  #include "command.h"
>  #include <ctype.h>
>  #include <pwd.h>
> diff --git a/quota/quota.c b/quota/quota.c
> index f6b24c3..dd12158 100644
> --- a/quota/quota.c
> +++ b/quota/quota.c
> @@ -16,6 +16,7 @@
>   * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  
> +#include <stdbool.h>
>  #include "command.h"
>  #include <ctype.h>
>  #include <pwd.h>
> @@ -464,6 +465,7 @@ quota_init(void)
>  	quota_cmd.args = _("[-bir] [-gpu] [-hnNv] [-f file] [id|name]...");
>  	quota_cmd.oneline = _("show usage and limits");
>  	quota_cmd.help = quota_help;
> +	quota_cmd.flags = CMD_FLAG_FOREIGN_OK;
>  
>  	add_command(&quota_cmd);
>  }
> diff --git a/quota/report.c b/quota/report.c
> index 8653134..e8e5d96 100644
> --- a/quota/report.c
> +++ b/quota/report.c
> @@ -15,7 +15,7 @@
>   * along with this program; if not, write the Free Software Foundation,
>   * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
> -
> +#include <stdbool.h>
>  #include "command.h"
>  #include <sys/types.h>
>  #include <pwd.h>
> @@ -592,6 +592,8 @@ report_any_type(
>  	if (type & XFS_USER_QUOTA) {
>  		fs_cursor_initialise(dir, FS_MOUNT_POINT, &cursor);
>  		while ((mount = fs_cursor_next_entry(&cursor))) {
> +			if (!foreign_allowed && (mount->fs_flags & FS_FOREIGN))
> +				continue;
>  			if (xfsquotactl(XFS_QSYNC, mount->fs_name,
>  						XFS_USER_QUOTA, 0, NULL) < 0
>  					&& errno != ENOENT && errno != ENOSYS)
> @@ -603,6 +605,8 @@ report_any_type(
>  	if (type & XFS_GROUP_QUOTA) {
>  		fs_cursor_initialise(dir, FS_MOUNT_POINT, &cursor);
>  		while ((mount = fs_cursor_next_entry(&cursor))) {
> +			if (!foreign_allowed && (mount->fs_flags & FS_FOREIGN))
> +				continue;
>  			if (xfsquotactl(XFS_QSYNC, mount->fs_name,
>  						XFS_GROUP_QUOTA, 0, NULL) < 0
>  					&& errno != ENOENT && errno != ENOSYS)
> @@ -614,6 +618,8 @@ report_any_type(
>  	if (type & XFS_PROJ_QUOTA) {
>  		fs_cursor_initialise(dir, FS_MOUNT_POINT, &cursor);
>  		while ((mount = fs_cursor_next_entry(&cursor))) {
> +			if (!foreign_allowed && (mount->fs_flags & FS_FOREIGN))
> +				continue;
>  			if (xfsquotactl(XFS_QSYNC, mount->fs_name,
>  						XFS_PROJ_QUOTA, 0, NULL) < 0
>  					&& errno != ENOENT && errno != ENOSYS)
> @@ -728,16 +734,17 @@ report_init(void)
>  	dump_cmd.args = _("[-gpu] [-f file]");
>  	dump_cmd.oneline = _("dump quota information for backup utilities");
>  	dump_cmd.help = dump_help;
> +	dump_cmd.flags = CMD_FLAG_FOREIGN_OK;
>  
>  	report_cmd.name = "report";
>  	report_cmd.altname = "repquota";
>  	report_cmd.cfunc = report_f;
>  	report_cmd.argmin = 0;
>  	report_cmd.argmax = -1;
> -	report_cmd.flags = CMD_FLAG_GLOBAL;
>  	report_cmd.args = _("[-bir] [-gpu] [-ahnt] [-f file]");
>  	report_cmd.oneline = _("report filesystem quota information");
>  	report_cmd.help = report_help;
> +	report_cmd.flags = CMD_FLAG_GLOBAL | CMD_FLAG_FOREIGN_OK;
>  
>  	if (expert) {
>  		add_command(&dump_cmd);
> diff --git a/quota/state.c b/quota/state.c
> index 8186762..d134580 100644
> --- a/quota/state.c
> +++ b/quota/state.c
> @@ -15,7 +15,7 @@
>   * along with this program; if not, write the Free Software Foundation,
>   * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
> -
> +#include <stdbool.h>
>  #include "command.h"
>  #include "init.h"
>  #include "quota.h"
> @@ -527,6 +527,7 @@ state_init(void)
>  	off_cmd.args = _("[-gpu] [-v]");
>  	off_cmd.oneline = _("permanently switch quota off for a path");
>  	off_cmd.help = off_help;
> +	off_cmd.flags = CMD_FLAG_FOREIGN_OK;
>  
>  	state_cmd.name = "state";
>  	state_cmd.cfunc = state_f;
> @@ -535,6 +536,7 @@ state_init(void)
>  	state_cmd.args = _("[-gpu] [-a] [-v] [-f file]");
>  	state_cmd.oneline = _("get overall quota state information");
>  	state_cmd.help = state_help;
> +	state_cmd.flags = CMD_FLAG_FOREIGN_OK;
>  
>  	enable_cmd.name = "enable";
>  	enable_cmd.cfunc = enable_f;
> diff --git a/quota/util.c b/quota/util.c
> index 7c43fbd..42746d9 100644
> --- a/quota/util.c
> +++ b/quota/util.c
> @@ -17,6 +17,7 @@
>   */
>  
>  #include <sys/types.h>
> +#include <stdbool.h>
>  #include <pwd.h>
>  #include <grp.h>
>  #include <utmp.h>
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
