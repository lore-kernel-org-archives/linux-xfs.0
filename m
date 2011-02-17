Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1HHS3UF166425 for <xfs@oss.sgi.com>; Thu, 17 Feb 2011 11:28:03 -0600
Received: from e3.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2D6119BB987
	for <xfs@oss.sgi.com>; Thu, 17 Feb 2011 09:30:42 -0800 (PST)
Received: from e3.ny.us.ibm.com (e3.ny.us.ibm.com [32.97.182.143]) by
	cuda.sgi.com with ESMTP id 1qdUAUv3BWFhmKu0 for
	<xfs@oss.sgi.com>; Thu, 17 Feb 2011 09:30:42 -0800 (PST)
Received: from d01dlp02.pok.ibm.com (d01dlp02.pok.ibm.com [9.56.224.85])
	by e3.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p1HHAclN004302
	for <xfs@oss.sgi.com>; Thu, 17 Feb 2011 12:10:57 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 891306E8039
	for <xfs@oss.sgi.com>; Thu, 17 Feb 2011 12:30:39 -0500 (EST)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p1HHUeal198164 for <xfs@oss.sgi.com>; Thu, 17 Feb 2011 12:30:41 -0500
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p1HHUerq009801
	for <xfs@oss.sgi.com>; Thu, 17 Feb 2011 10:30:40 -0700
Subject: Re: [PATCH] xfstests: Notify via syslog when godown is shutting
	down fs
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <4D5C554D.8080004@sandeen.net>
References: <1297798863.32230.222.camel@chandra-lucid.beaverton.ibm.com>
	<20110215223022.GE13052@dastard>
	<1297886433.32230.224.camel@chandra-lucid.beaverton.ibm.com>
	<20110216221433.GG13052@dastard>  <4D5C554D.8080004@sandeen.net>
Date: Thu, 17 Feb 2011 09:33:25 -0800
Message-ID: <1297964005.32230.230.camel@chandra-lucid.beaverton.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Thanks Eric. This makes it clear that it is intentional.

chandra 
On Wed, 2011-02-16 at 16:53 -0600, Eric Sandeen wrote:
> Just a hint for those perusing logs that the ensuing shutdown is
> intentional...
> 
> Feb 16 17:06:17 hostname godown: xfstests-induced forced shutdown of /mnt/scratch
> Feb 16 17:06:17 hostname kernel: Filesystem "sdb3": xfs_log_force: error 5 returned.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/src/godown.c b/src/godown.c
> index 07b6980..b140a41 100644
> --- a/src/godown.c
> +++ b/src/godown.c
> @@ -16,6 +16,7 @@
>   * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
> 
> +#include <syslog.h>
>  #include "global.h"
> 
>  static char *xprogname;
> @@ -109,6 +110,8 @@ main(int argc, char *argv[])
>  	if (verbose_opt) {
>  		printf("Calling XFS_IOC_GOINGDOWN\n");
>  	}
> +	syslog(LOG_WARNING, "xfstests-induced forced shutdown of %s:\n",
> +		mnt_dir);
>  	if ((xfsctl(mnt_dir, fd, XFS_IOC_GOINGDOWN, &flag)) == -1) {
>  		fprintf(stderr, "%s: error on xfsctl(GOINGDOWN) of \"%s\": %s\n",
>  			xprogname, mnt_dir, strerror(errno));
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
