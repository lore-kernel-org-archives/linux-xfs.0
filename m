Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7D0937F37
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 11:19:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0E0AAAC004
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 09:19:06 -0700 (PDT)
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id zAFxK6OH4rge9cNq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 22 Apr 2013 09:19:02 -0700 (PDT)
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Mon, 22 Apr 2013 12:19:02 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id A8B5A6E8083
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 12:18:50 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r3MGIm4D270618 for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 12:18:48 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r3MGIltj016203 for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 13:18:47 -0300
Subject: Re: [V2] xfsprogs: xfs_quota allow user or group names beginning
	with digits
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130422133106.892072381@sgi.com>
References: <20130422133106.892072381@sgi.com>
Date: Mon, 22 Apr 2013 11:18:46 -0500
Message-ID: <1366647526.3762.32396.camel@chandra-dt.ibm.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: rjohnston@sgi.com
Cc: xfs@oss.sgi.com


Is there any specific reason why quota_proj_type() is not changed ?

On Mon, 2013-04-22 at 08:31 -0500, rjohnston@sgi.com wrote:
> plain text document attachment
> (V2-xfsprogs-xfs_quota-allow-user-or-group-names-beginning-with-digits.patch)
> xfs_quota does not properly parse users or groups that begin with a number.
> Only call atoi when user or group consists of digits only.
> 
> Signed-off-by: Rich Johnston <rjohnston@sgi.com>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> ---
> V2:
> 	Change 'i=0' to 'i = 0' (sandeen suggestion) 
> 	Use bool instead of boolean_t (dchinner suggestion)
> 
> include/input.h |    1 +
>  libxcmd/input.c |   12 ++++++++++++
>  quota/quota.c   |    4 ++--
>  quota/quota.h   |    1 +
>  4 files changed, 16 insertions(+), 2 deletions(-)
> 
> Index: xfsprogs/include/input.h
> ===================================================================
> --- xfsprogs.orig/include/input.h	2013-03-22 14:22:09.000000000 -0500
> +++ xfsprogs/include/input.h	2013-04-22 08:10:56.000000000 -0500
> @@ -22,6 +22,7 @@
>  #include <grp.h>
>  #include <sys/types.h>
>  #include <xfs/project.h>
> +#include <stdbool.h>
> 
>  extern char	**breakline(char *input, int *count);
>  extern void	doneline(char *input, char **vec);
> @@ -46,6 +47,7 @@
>  extern uid_t	uid_from_string(char *user);
>  extern gid_t	gid_from_string(char *group);
>  extern prid_t	prid_from_string(char *project);
> +extern bool	isdigits_only(const char *str);
> 
>  #define HAVE_FTW_H 1	/* TODO: configure me */
> 
> Index: xfsprogs/libxcmd/input.c
> ===================================================================
> --- xfsprogs.orig/libxcmd/input.c	2013-03-22 14:22:09.000000000 -0500
> +++ xfsprogs/libxcmd/input.c	2013-04-22 08:07:01.000000000 -0500
> @@ -19,6 +19,7 @@
>  #include <xfs/xfs.h>
>  #include <xfs/input.h>
>  #include <ctype.h>
> +#include <stdbool.h>
> 
>  #if defined(ENABLE_READLINE)
>  # include <readline/history.h>
> @@ -398,6 +399,18 @@
>  	return -1;
>  }
> 
> +bool isdigits_only(
> +	const char *str)
> +{
> +	int i;
> +
> +	for (i = 0; i < strlen(str); i++) {
> +		if (!isdigit(str[i]))
> +			return false;
> +	}
> +	return true;
> +}
> +
>  #define HAVE_FTW_H 1	/* TODO: configure me */
> 
>  #ifndef HAVE_FTW_H
> Index: xfsprogs/quota/quota.c
> ===================================================================
> --- xfsprogs.orig/quota/quota.c	2013-03-22 14:22:09.000000000 -0500
> +++ xfsprogs/quota/quota.c	2013-04-22 07:20:52.000000000 -0500
> @@ -224,7 +224,7 @@
>  	uid_t		id;
> 
>  	if (name) {
> -		if (isdigit(name[0])) {
> +		if (isdigits_only(name)) {
>  			id = atoi(name);
>  			name = getusername(id, flags & NO_LOOKUP_FLAG);
>  		} else if ((u = getpwnam(name))) {
> @@ -273,7 +273,7 @@
>  	int		i, ngroups, dofree = 0;
> 
>  	if (name) {
> -		if (isdigit(name[0])) {
> +		if (isdigits_only(name)) {
>  			gid = atoi(name);
>  			name = getgroupname(gid, flags & NO_LOOKUP_FLAG);
>  		} else {
> Index: xfsprogs/quota/quota.h
> ===================================================================
> --- xfsprogs.orig/quota/quota.h	2013-03-22 14:22:09.000000000 -0500
> +++ xfsprogs/quota/quota.h	2013-04-22 08:12:26.000000000 -0500
> @@ -19,6 +19,7 @@
>  #include <xfs/xqm.h>
>  #include <xfs/path.h>
>  #include <xfs/project.h>
> +#include <stdbool.h>
> 
>  /*
>   * Different forms of XFS quota
> @@ -80,4 +81,5 @@
>  extern char *uid_to_name(__uint32_t __uid);
>  extern char *gid_to_name(__uint32_t __gid);
>  extern char *prid_to_name(__uint32_t __prid);
> +extern bool isdigits_only(const char *);
> 
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
