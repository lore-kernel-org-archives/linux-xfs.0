Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 050987F37
	for <xfs@oss.sgi.com>; Sun, 21 Apr 2013 00:55:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D8F54304051
	for <xfs@oss.sgi.com>; Sat, 20 Apr 2013 22:55:08 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id XWuvK0FUO8Nrqj8P for <xfs@oss.sgi.com>;
	Sat, 20 Apr 2013 22:55:04 -0700 (PDT)
Message-ID: <51737F3D.9070303@sandeen.net>
Date: Sun, 21 Apr 2013 00:55:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: xfs_quota allow user or group names beginning
	with digits
References: <20130417183323.465181485@sgi.com>
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

On 4/17/13 1:32 PM, rjohnston@sgi.com wrote:

<some kind of email that doesn't show up when I hit reply so repasting ;)>

> 
> 
> xfs_quota does not properly parse users or groups that begin with a number.
> Only call atoi when user or group consists of digits only.
> 
> Signed-off-by: Rich Johnston <rjohnston@sgi.com>

Seems sane to me.  I'd change i=0 to i = 0, but *shrug*

[xfsprogs]$ grep -r "i = 0" * | wc -l
404
[xfsprogs]$ grep -r "i=0" * | wc -l
10

Other than that,
Reviewed-by: Eric Sandeen <sandeen@redhat.com>

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
>  
>  #define HAVE_FTW_H 1	/* TODO: configure me */
>  
> Index: b/libxcmd/input.c
> ===================================================================
> --- a/libxcmd/input.c
> +++ b/libxcmd/input.c
> @@ -398,6 +398,18 @@ gid_from_string(
>  	return -1;
>  }
>  
> +boolean_t isdigits_only(
> +	const char *str)
> +{
> +	int i;
> +
> +	for (i=0; i < strlen(str); i++) {
> +		if (!isdigit(str[i]))
> +			return B_FALSE;
> +	}
> +	return B_TRUE;
> +}
> +
>  #define HAVE_FTW_H 1	/* TODO: configure me */
>  
>  #ifndef HAVE_FTW_H
> Index: b/quota/quota.c
> ===================================================================
> --- a/quota/quota.c
> +++ b/quota/quota.c
> @@ -224,7 +224,7 @@ quota_user_type(
>  	uid_t		id;
>  
>  	if (name) {
> -		if (isdigit(name[0])) {
> +		if (isdigits_only(name)) {
>  			id = atoi(name);
>  			name = getusername(id, flags & NO_LOOKUP_FLAG);
>  		} else if ((u = getpwnam(name))) {
> @@ -273,7 +273,7 @@ quota_group_type(
>  	int		i, ngroups, dofree = 0;
>  
>  	if (name) {
> -		if (isdigit(name[0])) {
> +		if (isdigits_only(name)) {
>  			gid = atoi(name);
>  			name = getgroupname(gid, flags & NO_LOOKUP_FLAG);
>  		} else {
> Index: b/quota/quota.h
> ===================================================================
> --- a/quota/quota.h
> +++ b/quota/quota.h
> @@ -80,4 +80,5 @@ enum {
>  extern char *uid_to_name(__uint32_t __uid);
>  extern char *gid_to_name(__uint32_t __gid);
>  extern char *prid_to_name(__uint32_t __prid);
> +extern boolean_t isdigits_only(const char *);
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
