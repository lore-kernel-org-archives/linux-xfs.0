Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 041BD7F5A
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 22:54:27 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9FCC4AC002
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 20:54:23 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id jYw0Vx7htgOmwBkj for <xfs@oss.sgi.com>;
	Wed, 02 Dec 2015 20:54:20 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 3088763C5A9F
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 22:54:20 -0600 (CST)
Subject: Re: [PATCH 05/11] xfsprogs: xfs_mdrestore: check bad read count in
	perform_restore
References: <1449055167-19936-1-git-send-email-t.vivek@samsung.com>
	<1449055167-19936-6-git-send-email-t.vivek@samsung.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <565FCAFB.5020502@sandeen.net>
Date: Wed, 2 Dec 2015 22:54:19 -0600
MIME-Version: 1.0
In-Reply-To: <1449055167-19936-6-git-send-email-t.vivek@samsung.com>
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
> fix error reported by coverity - Integer overflowed argument
> 
> also, add print incase of invalid read count to get more debug
> information.
> 
> Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
> ---
>  mdrestore/xfs_mdrestore.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index 5764616..a87a091 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -93,6 +93,10 @@ perform_restore(
>  	block_index = (__be64 *)((char *)metablock + sizeof(xfs_metablock_t));
>  	block_buffer = (char *)metablock + block_size;
>  
> +	if (block_size < sizeof(tmb))
> +		fatal("bad read count, block_size: %d, tmb size %d\n",
> +				block_size, sizeof(tmb));
> +

block_size is block_size = 1 << tmb.mb_blocklog; where mb_blocklog is
always metablock->mb_blocklog = BBSHIFT;, so block_size is always 512.

On the other hand, sizeof(tmb) is simply 8.

There seems to be no possible path for this to be a problem, so it hardly
seems worth the printf.

Would an ASSERT(block_size >= sizeof(tmb)) make coverity happy?

-Eric


>  	if (fread(block_index, block_size - sizeof(tmb), 1, src_f) != 1)
>  		fatal("error reading from file: %s\n", strerror(errno));
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
