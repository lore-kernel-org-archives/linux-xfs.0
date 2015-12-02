Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1AF3B7F76
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 11:55:11 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 99561AC001
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 09:55:10 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id VRCmM4s9ZBFaxBhy for <xfs@oss.sgi.com>;
	Wed, 02 Dec 2015 09:55:07 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 8395B60006DA
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 11:55:07 -0600 (CST)
Subject: Re: [PATCH 01/11] xfsprogs: xfs_io: fix a memory leak in imap_f
References: <1449055167-19936-1-git-send-email-t.vivek@samsung.com>
	<1449055167-19936-2-git-send-email-t.vivek@samsung.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <565F307A.1040402@sandeen.net>
Date: Wed, 2 Dec 2015 11:55:06 -0600
MIME-Version: 1.0
In-Reply-To: <1449055167-19936-2-git-send-email-t.vivek@samsung.com>
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



On 12/2/15 5:19 AM, Vivek Trivedi wrote:
> add NULL check for malloc return and free allocated memory in
> return path in imap_f
> 
> Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  io/imap.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/io/imap.c b/io/imap.c
> index 34901cb..6ed98eb 100644
> --- a/io/imap.c
> +++ b/io/imap.c
> @@ -39,6 +39,8 @@ imap_f(int argc, char **argv)
>  		nent = atoi(argv[1]);
>  
>  	t = malloc(nent * sizeof(*t));
> +	if (!t)
> +		return 0;
>  
>  	bulkreq.lastip  = &last;
>  	bulkreq.icount  = nent;
> @@ -46,8 +48,10 @@ imap_f(int argc, char **argv)
>  	bulkreq.ocount  = &count;
>  
>  	while (xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS, &bulkreq) == 0) {
> -		if (count == 0)
> +		if (count == 0) {
> +			free(t);
>  			return 0;
> +		}
>  		for (i = 0; i < count; i++) {
>  			printf(_("ino %10llu count %2d mask %016llx\n"),
>  				(unsigned long long)t[i].xi_startino,
> @@ -55,6 +59,7 @@ imap_f(int argc, char **argv)
>  				(unsigned long long)t[i].xi_allocmask);
>  		}
>  	}
> +	free(t);
>  	perror("xfsctl(XFS_IOC_FSINUMBERS)");
>  	exitcode = 1;
>  	return 0;
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
