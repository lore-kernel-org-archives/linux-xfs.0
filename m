Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7957329E03
	for <xfs@oss.sgi.com>; Sun, 21 Apr 2013 21:44:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ECED2AC003
	for <xfs@oss.sgi.com>; Sun, 21 Apr 2013 19:44:28 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	tRfU8ZbZyI0FEnGt for <xfs@oss.sgi.com>;
	Sun, 21 Apr 2013 19:44:26 -0700 (PDT)
Date: Mon, 22 Apr 2013 12:45:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: xfs_quota allow user or group names beginning
	with digits
Message-ID: <20130422024501.GH13938@destitution>
References: <20130417183323.465181485@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130417183323.465181485@sgi.com>
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
To: rjohnston@sgi.com
Cc: xfs@oss.sgi.com

On Wed, Apr 17, 2013 at 01:32:53PM -0500, rjohnston@sgi.com wrote:
> xfs_quota does not properly parse users or groups that begin with a number.
> Only call atoi when user or group consists of digits only.
> 
> Signed-off-by: Rich Johnston <rjohnston@sgi.com>
> 
> ---
>  include/input.h |    1 +
>  libxcmd/input.c |   12 ++++++++++++
>  quota/quota.c   |    4 ++--
>  quota/quota.h   |    1 +
>  4 files changed, 16 insertions(+), 2 deletions(-)
> 
> Index: b/include/input.h
> ===================================================================
> --- a/include/input.h
> +++ b/include/input.h
> @@ -46,6 +46,7 @@ extern void	timestr(struct timeval *tv,
>  extern uid_t	uid_from_string(char *user);
>  extern gid_t	gid_from_string(char *group);
>  extern prid_t	prid_from_string(char *project);
> +extern boolean_t isdigits_only(const char *str);

bool is the correct type, not boolean_t. My CRC patchset makes
userspace fall in line with the removal of boolean_t from the kernel
code, so we should probably make this correct from the start. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
