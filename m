Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3B7227F50
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 09:43:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D742CAC004
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 07:43:20 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id EySGK642Xk33xrPi for <xfs@oss.sgi.com>;
	Thu, 26 Sep 2013 07:43:19 -0700 (PDT)
Message-ID: <52444806.6020900@sandeen.net>
Date: Thu, 26 Sep 2013 09:43:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfsprogs: fix return value of verify_set_primary_sb()
References: <1379829679.4089.2.camel@ThinkPad-T5421> <5241E125.7010902@sgi.com>
	<1380094327.2526.5.camel@ThinkPad-T5421>
	<5242F31B.4060902@sandeen.net>
	<1380177932.2983.11.camel@ThinkPad-T5421>
	<1380178092.2983.14.camel@ThinkPad-T5421>
In-Reply-To: <1380178092.2983.14.camel@ThinkPad-T5421>
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
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, Mark Tinguely <tinguely@sgi.com>, xfsprogs <xfs@oss.sgi.com>

On 9/26/13 1:48 AM, Li Zhong wrote:
> If get_sb() fails because of EOF, it will return with retval 1, which will
> then be interpreted as XR_BAD_MAGIC("bad magic number") in phase1() when
> warning the user.
> 
> This patch fix it by using XR_EOF here, so it would be interpreted correctly.
> Also change the associated comments about the return value.
> 
> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>

I think this is OK.  I had originally thought we should return whatever XR_*
code get_sb() returned, but I wasn't thinking straight; we ignore those
other codes, and only stop if we see XR_EOF.

So this is fine as far as it goes; I noticed something else in the process
though so I'll send a patch for that.  :)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  repair/sb.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/repair/sb.c b/repair/sb.c
> index d34d7a2..2e35a4c 100644
> --- a/repair/sb.c
> +++ b/repair/sb.c
> @@ -665,7 +665,7 @@ get_sb_geometry(fs_geometry_t *geo, xfs_sb_t *sbp)
>   * primary and compare the geometries in the secondaries against
>   * the geometry indicated by the primary.
>   *
> - * returns 1 if bad, 0 if ok
> + * returns 0 if ok, else error code (XR_EOF, XR_INSUFF_SEC_SB, etc).
>   */
>  int
>  verify_set_primary_sb(xfs_sb_t		*rsb,
> @@ -732,7 +732,7 @@ verify_set_primary_sb(xfs_sb_t		*rsb,
>  			checked[agno] = 1;
>  
>  			if (get_sb(sb, off, size, agno) == XR_EOF)  {
> -				retval = 1;
> +				retval = XR_EOF;
>  				goto out_free_list;
>  			}
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
