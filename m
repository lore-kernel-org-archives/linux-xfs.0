Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6DFF87CA0
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 16:42:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2A5F48F8037
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 14:42:07 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ktgL9wRdOSeqPIkc for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2016 14:42:03 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 9EA1E16C150
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 16:42:03 -0500 (CDT)
Subject: Re: [PATCH 17/19] xfsprogs: disable truncating of files
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-18-git-send-email-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <570582AA.9020909@sandeen.net>
Date: Wed, 6 Apr 2016 16:42:02 -0500
MIME-Version: 1.0
In-Reply-To: <1458818136-56043-18-git-send-email-jtulak@redhat.com>
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
To: xfs@oss.sgi.com

On 3/24/16 6:15 AM, jtulak@redhat.com wrote:
> From: Jan Tulak <jtulak@redhat.com>
> 
> Unify mkfs.xfs behaviour a bit and never truncate files. If the user
> is trying to mkfs an existing file, we don't want to destroy anything
> he did with the file before (sparse file, allocations...)

Hm, I guess so ...  What motivated this change?  I see that it
changes behavior, but I'm not sure what it unifies or fixes - 
can you explain more?

a bit more below.
 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  libxfs/init.c   |  2 +-
>  mkfs/xfs_mkfs.c | 18 +++++++++++-------
>  2 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 268136f..5f4b6c4 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -112,7 +112,7 @@ libxfs_device_open(char *path, int creat, int xflags, int setblksize)
>  
>  retry:
>  	flags = (readonly ? O_RDONLY : O_RDWR) | \
> -		(creat ? (O_CREAT|O_TRUNC) : 0) | \
> +		(creat ? O_CREAT : 0) | \
>  		(dio ? O_DIRECT : 0) | \
>  		(excl ? O_EXCL : 0);
>  
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 9a6ae2c..2bb3b35 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1029,15 +1029,19 @@ check_device_type(
>  	const char	*optname)
>  {
>  	struct stat64 statbuf;
> +	int statres;
>  
> -	if (*isfile && (no_size || no_name)) {
> +	statres = stat64(name, &statbuf);
> +
> +	if (*isfile && statres != 0 && (no_size || no_name)) {

statres !=0 doesn't imply ENOENT; it could be EACCES
or several other errors.  You'd need to check errno to know
for sure.

>  		fprintf(stderr,
> -	_("if -%s file then -%s name and -%s size are required\n"),
> -			optname, optname, optname);
> +			_("if -%s file and the file does not exists, " \

don't need a "\" there, and should read "does not exist"

> +			"then -%s name and -%s size are required\n"),

Better, just tab it out if possible, though it's a long line... perhaps:

_("-%s file requires -%s name and -%s size for file creation\n");

or something like that.

> +					optname, optname, optname);
>  		usage();
>  	}
>  
> -	if (stat64(name, &statbuf)) {
> +	if (statres) {
>  		if (errno == ENOENT && *isfile) {
>  			if (create)
>  				*create = 1;
> @@ -1059,9 +1063,9 @@ check_device_type(
>  	}
>  
>  	/*
> -	 * We only want to completely truncate and recreate an existing file if
> -	 * we were specifically told it was a file. Set the create flag only in
> -	 * this case to trigger that behaviour.
> +	 * We only want to create a file only if we were specifically told
> +	 * we want a file. Set the create flag only in this case to trigger
> +	 * that behaviour.

+	 * We only want to create a file if we were specifically told it is a
+	 * file. Set the create flag only in this case to trigger that behaviour.

>  	 */
>  	if (S_ISREG(statbuf.st_mode)) {
>  		if (!*isfile)
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
