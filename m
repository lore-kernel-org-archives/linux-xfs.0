Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB2NRwme109585 for <xfs@oss.sgi.com>; Fri, 2 Dec 2011 17:27:58 -0600
Date: Fri, 2 Dec 2011 15:27:57 -0800
From: Phil White <pwhite@sgi.com>
Subject: Re: [2/8] xfstests: add different logging option to fsstress
Message-ID: <20111202232757.GB28903@caliban.corp.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: xfs@oss.sgi.com

On Sat, Oct 29, 2011 at 12:48:11AM -0000, Dmitry Monakhov wrote:
> Currently the only way to log fsstress's output is to redirect it's shared
> stdout to pipe which is very painfull because:
> 
> 1) Pipe writers are serialized via i_mutex so we waste cpu-cores power on stupid
>    sinchronization for loging purpose, instead of hunting real race conditions,
>    and bugs inside file system.
> 2) Usually output is corrupted due to luck of sychronization on shared stdout.
> 
> Since fsstress's children operate on independend paths, let's just open didicated
> log file for each child and simply avoid useless sycnhronization.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> 
> ---
> ltp/fsstress.c |   33 ++++++++++++++++++++++++++++++++-
>  1 files changed, 32 insertions(+), 1 deletions(-)
> 
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 51ecda2..c7001f3 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -258,6 +258,8 @@ int main(int argc, char **argv)
>  	char		buf[10];
>  	int		c;
>  	char		*dirname = NULL;
> +	char		*logname = NULL;
> +	char		rpath[PATH_MAX];
>  	int		fd;
>  	int		i;
>  	int		j;
> @@ -273,7 +275,7 @@ int main(int argc, char **argv)
>  	nops = sizeof(ops) / sizeof(ops[0]);
>  	ops_end = &ops[nops];
>  	myprog = argv[0];
> -	while ((c = getopt(argc, argv, "d:e:f:i:m:n:p:rs:vwzHS")) != -1) {
> +	while ((c = getopt(argc, argv, "d:e:f:i:m:n:o:p:rs:vwzHS")) != -1) {
>  		switch (c) {
>  		case 'd':
>  			dirname = optarg;
> @@ -311,6 +313,10 @@ int main(int argc, char **argv)
>  		case 'n':
>  			operations = atoi(optarg);
>  			break;
> +		case 'o':
> +			logname = optarg;
> +			break;
> +
>  		case 'p':
>  			nproc = atoi(optarg);
>  			break;
> @@ -351,10 +357,26 @@ int main(int argc, char **argv)
>          }
>  
>  	(void)mkdir(dirname, 0777);
> +	if (logname && logname[0] != '/') {
> +		if (getcwd(rpath, sizeof(rpath)) < 0){
> +			perror("getcwd failed");
> +			exit(1);
> +		}
> +	} else {
> +		rpath[0] = '\0';
> +	}
>  	if (chdir(dirname) < 0) {
>  		perror(dirname);
>  		exit(1);
>  	}
> +	if (logname) {
> +		char path[PATH_MAX];
> +		snprintf(path, sizeof(path), "%s/%s", rpath, logname);
> +		if (freopen(path, "a", stdout) == NULL) {
> +			perror("freopen logfile failed");
> +			exit(1);
> +		}
> +	}
>  	sprintf(buf, "fss%x", (unsigned int)getpid());
>  	fd = creat(buf, 0666);
>  	if (lseek64(fd, (off64_t)(MAXFSIZE32 + 1ULL), SEEK_SET) < 0)
> @@ -409,6 +431,15 @@ int main(int argc, char **argv)
>  		close(fd);
>  	for (i = 0; i < nproc; i++) {
>  		if (fork() == 0) {
> +			if (logname) {
> +				char path[PATH_MAX];
> +				snprintf(path, sizeof(path), "%s/%s.%d",
> +					 rpath, logname, i);
> +				if (freopen(path, "a", stdout) == NULL) {
> +					perror("freopen logfile failed");
> +					exit(1);
> +				}
> +			}
>  			procid = i;
>  			doproc();
>  			return 0;

Looks good to me.

Reviewed-By: Phil White <pwhite@sgi.com>
Tested-By: Phil White <pwhite@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
