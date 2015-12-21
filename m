Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 068967F37
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 12:36:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 980BBAC004
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 10:35:59 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id BIg0X4yuakajWuCq for <xfs@oss.sgi.com>;
	Mon, 21 Dec 2015 10:35:56 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 9064663C5A9F
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 12:35:56 -0600 (CST)
Subject: Re: [PATCH] XFS: Use a signed return type for suffix_kstrtoint()
References: <5676520D.2060806@users.sourceforge.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5678468B.1040008@sandeen.net>
Date: Mon, 21 Dec 2015 12:35:55 -0600
MIME-Version: 1.0
In-Reply-To: <5676520D.2060806@users.sourceforge.net>
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

On 12/20/15 1:00 AM, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sun, 20 Dec 2015 07:56:36 +0100
> 
> The return type "unsigned long" was used by the suffix_kstrtoint()
> function even though it will eventually return a negative error code.

> Improve this implementation detail by using the type "int" instead.
> 
> This issue was detected by using the Coccinelle software.

> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

yep, looks like an oversight left over from a17164e5

Harmless, because callers only check for non-zero value, but still
worth fixing.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks,
-Eric

> ---
>  fs/xfs/xfs_super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 436b6ef..59c9b7b 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -137,7 +137,7 @@ static const match_table_t tokens = {
>  };
>  
>  
> -STATIC unsigned long
> +STATIC int
>  suffix_kstrtoint(char *s, unsigned int base, int *res)
>  {
>  	int	last, shift_left_factor = 0, _res;
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
