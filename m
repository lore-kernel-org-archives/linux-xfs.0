Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E9A097CA2
	for <xfs@oss.sgi.com>; Sat,  3 Sep 2016 20:23:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BC454304032
	for <xfs@oss.sgi.com>; Sat,  3 Sep 2016 18:23:56 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id bcOGUtK7lICK2o6k for <xfs@oss.sgi.com>;
	Sat, 03 Sep 2016 18:23:53 -0700 (PDT)
Subject: Re: [PATCH 2/6] libxfs/linux.c: Replace use of ustat by stat
References: <cover.1452627740.git.felix.janda@posteo.de>
	<20160112195945.GC568@nyan>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5d979944-cd03-dbdd-8308-cd8fe4eefe73@sandeen.net>
Date: Sat, 3 Sep 2016 20:23:51 -0500
MIME-Version: 1.0
In-Reply-To: <20160112195945.GC568@nyan>
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
To: xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

Ok, this has become a bit more urgent:

Building on F24 on arm64, I noticed this:

../libxfs/.libs/libxfs.a(linux.o): In function `platform_check_ismounted':
/root/sandeen/xfsprogs-dev/libxfs/linux.c:66: warning: ustat is not implemented and will always fail

And lo:

# xfs_metadump -o /dev/sda3 dump
# mount /dev/sda3 /mnt/scratch
# xfs_mdrestore dump /dev/sda3
# echo $?
0
#

Are we scared yet?

(I independently rewrote Felix's patch after seeing the above, then
searched and found this old thread)

We need to fix this, now.  Performance issues or not I'd advocate for
taking this patch, unless hch made any progress on the O_EXCL approach.

hch said:

> That being said I think ustat fits pretty well for this use case,
> so getting rid of it might need a little more justification.

but it looks like that ship has sailed.

So for this patch I'll add:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

-Eric

On 1/12/16 1:59 PM, Felix Janda wrote:
> ustat has been used to check whether a device file is mounted.
> The function is deprecated and not supported by uclibc and musl.
> Now do the check using the *mntent functions.
> 
> Based on patch by Natanael Copa <ncopa@alpinelinux.org>.
> 
> Signed-off-by: Felix Janda <felix.janda@posteo.de>
> ---
>  libxfs/linux.c | 29 ++++++++++++++++++++---------
>  1 file changed, 20 insertions(+), 9 deletions(-)
> 
> diff --git a/libxfs/linux.c b/libxfs/linux.c
> index c532d65..e7adcf2 100644
> --- a/libxfs/linux.c
> +++ b/libxfs/linux.c
> @@ -16,11 +16,8 @@
>   * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  
> -#define ustat __kernel_ustat
>  #include <mntent.h>
>  #include <sys/stat.h>
> -#undef ustat
> -#include <sys/ustat.h>
>  #include <sys/mount.h>
>  #include <sys/ioctl.h>
>  #include <sys/sysinfo.h>
> @@ -51,9 +48,10 @@ static int max_block_alignment;
>  int
>  platform_check_ismounted(char *name, char *block, struct stat64 *s, int verbose)
>  {
> -	/* Pad ust; pre-2.6.28 linux copies out too much in 32bit compat mode */
> -	struct ustat	ust[2];
> -	struct stat64	st;
> +	FILE		*f;
> +	struct stat64	st, mst;
> +	struct mntent	*mnt;
> +	char		mounts[MAXPATHLEN];
>  
>  	if (!s) {
>  		if (stat64(block, &st) < 0)
> @@ -63,14 +61,27 @@ platform_check_ismounted(char *name, char *block, struct stat64 *s, int verbose)
>  		s = &st;
>  	}
>  
> -	if (ustat(s->st_rdev, ust) >= 0) {
> +	strcpy(mounts, (!access(PROC_MOUNTED, R_OK)) ? PROC_MOUNTED : MOUNTED);
> +	if ((f = setmntent(mounts, "r")) == NULL) {
> +		fprintf(stderr,
> +		    _("%s: %s possibly contains a mounted filesystem\n"),
> +		    progname, name);
> +		return 1;
> +	}
> +	while ((mnt = getmntent(f)) != NULL) {
> +		if (stat64(mnt->mnt_dir, &mst) < 0)
> +			continue;
> +		if (mst.st_dev != s->st_rdev)
> +			continue;
> +
>  		if (verbose)
>  			fprintf(stderr,
>  				_("%s: %s contains a mounted filesystem\n"),
>  				progname, name);
> -		return 1;
> +		break;
>  	}
> -	return 0;
> +	endmntent(f);
> +	return mnt == NULL;
>  }
>  
>  int
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
