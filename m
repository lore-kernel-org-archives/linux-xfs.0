Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D88677F37
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 06:53:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B80DD304043
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 04:53:12 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HorS72QoiPZpaaYp (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Aug 2015 04:53:11 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 44BCD8CF41
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 11:53:11 +0000 (UTC)
Date: Wed, 26 Aug 2015 07:53:10 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfsprogs: properly terminate string in quota's
	restore_file()
Message-ID: <20150826115308.GB11759@bfoster.bfoster>
References: <55DC9A41.8060006@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55DC9A41.8060006@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Aug 25, 2015 at 11:39:29AM -0500, Eric Sandeen wrote:
> This code copies up to the entire size of devbuffer, and then
> tries to use "strlen" to null terminate it.
> 
> But strlen works by *finding* the null, so it's at best a
> no-op, and at worst not properly terminating the string.
> 
> Fix this by placing the null at the last byte of the buffer.
> 
> Addresses-Coverity-Id: 1297519
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/quota/edit.c b/quota/edit.c
> index d226e89..a53a7e6 100644
> --- a/quota/edit.c
> +++ b/quota/edit.c
> @@ -385,7 +385,7 @@ restore_file(
>  	while (fgets(buffer, sizeof(buffer), fp) != NULL) {
>  		if (strncmp("fs = ", buffer, 5) == 0) {
>  			dev = strncpy(devbuffer, buffer+5, sizeof(devbuffer));
> -			dev[strlen(dev) - 1] = '\0';
> +			dev[sizeof(devbuffer) - 1] = '\0';

According to the man page, fgets() NULL terminates the provided buffer.
Next, we attempt to strncpy() just the device name part of the string
(copying up to 512 bytes from a 512-5 byte buffer). I'm not quite sure,
but it looks like the above line could be trying to replace a newline
with a NULL terminator..? E.g., it expects the last character in an
already NULL terminated line to be a newline.

Brian

>  			continue;
>  		}
>  		rtbsoft = rtbhard = 0;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
