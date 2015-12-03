Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5FADA7F5A
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 23:44:04 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4F903304039
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 21:44:04 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 8UE2oBmxLoE5qBPU for <xfs@oss.sgi.com>;
	Wed, 02 Dec 2015 21:44:03 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 1DC1663C5A9F
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 23:44:03 -0600 (CST)
Subject: Re: [PATCH 07/11] xfsprogs: xfs_fsr: replace sprintf with snprintf to
	avoid buffer overflow
References: <1449055167-19936-1-git-send-email-t.vivek@samsung.com>
	<1449055167-19936-8-git-send-email-t.vivek@samsung.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <565FD6A2.9040406@sandeen.net>
Date: Wed, 2 Dec 2015 23:44:02 -0600
MIME-Version: 1.0
In-Reply-To: <1449055167-19936-8-git-send-email-t.vivek@samsung.com>
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


it seems like the sprintfs in i.e. fsrall_cleanup() and tmp_init()
might have the same problem, no?

And then what happens if it is truncated to SMBUFSZ; at that point
I think this needs error handling, if the string got truncated.

-Eric

On 12/2/15 5:19 AM, Vivek Trivedi wrote:
> Fix possible buffer overflow by replacing sprintf with snprintf in tmp_next
> and tmp_close.
> Reported by coverity.
> 
> Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
> ---
>  fsr/xfs_fsr.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index 424fbce..bd459b6 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -1804,7 +1804,7 @@ tmp_next(char *mnt)
>  {
>  	static char	buf[SMBUFSZ];
>  
> -	sprintf(buf, "%s/.fsr/ag%d/tmp%d",
> +	snprintf(buf, SMBUFSZ, "%s/.fsr/ag%d/tmp%d",
>  	        ( (strcmp(mnt, "/") == 0) ? "" : mnt),
>  	        tmp_agi,
>  	        getpid());
> @@ -1823,7 +1823,7 @@ tmp_close(char *mnt)
>  
>  	/* No data is ever actually written so we can just do rmdir's */
>  	for (i=0; i < fsgeom.agcount; i++) {
> -		sprintf(buf, "%s/.fsr/ag%d", mnt, i);
> +		snprintf(buf, SMBUFSZ, "%s/.fsr/ag%d", mnt, i);
>  		if (rmdir(buf) < 0) {
>  			if (errno != ENOENT) {
>  				fsrprintf(
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
