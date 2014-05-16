Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2F4987F51
	for <xfs@oss.sgi.com>; Thu, 15 May 2014 21:22:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 16E7C30404E
	for <xfs@oss.sgi.com>; Thu, 15 May 2014 19:22:43 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id A3KAOYRoJxd1CbSZ for <xfs@oss.sgi.com>;
	Thu, 15 May 2014 19:22:41 -0700 (PDT)
Message-ID: <53757670.5060609@sandeen.net>
Date: Thu, 15 May 2014 21:22:40 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_repair: don't let bplist index go negative in prefetch
References: <53750E9F.3010301@redhat.com>
In-Reply-To: <53750E9F.3010301@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 5/15/14, 1:59 PM, Eric Sandeen wrote:
> After:
> 
> bbd3275 repair: don't unlock prefetch tree to read discontig buffers
> 
> Coverity spotted that it's possible for us to arrive at the loop
> below with num == 1, and then we decrement it to 0, and try to
> index bplist[num-1].
> 
> I think this was possible before the change, i.e. it's probably
> not a regression.
> 
> Fix this by not trying to shrink the window unless we have
> more than one buffer in the array.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

FWIW, I'm not sure this can actually be hit; see below.

> 
> diff --git a/repair/prefetch.c b/repair/prefetch.c
> index 4595310..b6d4755 100644
> --- a/repair/prefetch.c
> +++ b/repair/prefetch.c
> @@ -505,7 +505,7 @@ pf_batch_read(
>  		first_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(bplist[0]));
>  		last_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(bplist[num-1])) +
>  			XFS_BUF_SIZE(bplist[num-1]);

Indexing bplist[num-1] after we do num-- is only a problem if num==1.

If num==1, then last_off - first_off == XFS_BUF_SIZE(bplist[0]) above.

> -		while (last_off - first_off > pf_max_bytes) {

so we can only go here if XFS_BUF_SIZE(bplist[0] > pf_max_bytes, and

        pf_max_bytes = sysconf(_SC_PAGE_SIZE) << 7;

for a 4k page that's 512k.

So unless XFS_BUF_SIZE(bplist[0]) > 512k, we won't run into trouble.

And I don't ... think that can happen, right?  So it's probably impossible
to hit; worth being defensive, but not critical.

That's my take anyhoo.

-Eric

> +		while (num > 1 && last_off - first_off > pf_max_bytes) {
>  			num--;
>  			last_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(bplist[num-1])) +
>  				XFS_BUF_SIZE(bplist[num-1]);
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
