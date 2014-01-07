Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4722B7F3F
	for <xfs@oss.sgi.com>; Tue,  7 Jan 2014 01:28:35 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2FAEA8F8033
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 23:28:32 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id yOpHBRyUHToDxSPI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 Jan 2014 23:28:30 -0800 (PST)
Message-ID: <52CBAC99.7020400@oracle.com>
Date: Tue, 07 Jan 2014 15:28:25 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs/io: set argmax to 1 for imap command
References: <1389021866-10793-1-git-send-email-bfoster@redhat.com>
In-Reply-To: <1389021866-10793-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On 01/06 2014 23:24 PM, Brian Foster wrote:
> The imap command supports an optional argument to specify the
> number of inode records to capture per ioctl(), but argmax is
> currently set to 0. This leads to an error if an argument is
> provided on the command line. Set argmax to 1 to support the
> optional argument.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  io/imap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io/imap.c b/io/imap.c
> index 0a4f14e..4f3f883 100644
> --- a/io/imap.c
> +++ b/io/imap.c
> @@ -67,7 +67,7 @@ imap_init(void)
>  	imap_cmd.name = "imap";
>  	imap_cmd.cfunc = imap_f;
>  	imap_cmd.argmin = 0;
> -	imap_cmd.argmax = 0;
> +	imap_cmd.argmax = 1;
>  	imap_cmd.args = _("[nentries]");
>  	imap_cmd.flags = CMD_NOMAP_OK;
>  	imap_cmd.oneline = _("inode map for filesystem of current file");
> 
With this fix, the command behaviour is consistent with the help menu,
and the optional argument is useful to extend our test coverage.
Hence if no other objections, this patch looks good to me.

Reviewed-by: Jie Liu <jeff.liu@oracle.com>

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
