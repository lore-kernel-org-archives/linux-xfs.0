Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 692A229E0B
	for <xfs@oss.sgi.com>; Tue, 24 Sep 2013 13:59:53 -0500 (CDT)
Message-ID: <5241E125.7010902@sgi.com>
Date: Tue, 24 Sep 2013 13:59:49 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: fix potential memory leak in
	verify_set_primary_sb()
References: <1379829679.4089.2.camel@ThinkPad-T5421>
In-Reply-To: <1379829679.4089.2.camel@ThinkPad-T5421>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, xfsprogs <xfs@oss.sgi.com>

On 09/22/13 01:01, Li Zhong wrote:
> This patch tries to fix CID 997012, 997013 and 997014 reported by Coverity scan,
> as suggested by sekharan.
>
> Signed-off-by: Li Zhong<zhong@linux.vnet.ibm.com>
> ---


> @@ -756,8 +756,10 @@ verify_set_primary_sb(xfs_sb_t		*rsb,
>   	/*
>   	 * see if we have enough superblocks to bother with
>   	 */
> -	if (num_ok < num_sbs / 2)
> -		return(XR_INSUFF_SEC_SB);
> +	if (num_ok < num_sbs / 2) {
> +		retval = XR_INSUFF_SEC_SB;
> +		goto out_free_list;
> +	}

>

Looks good. list, sb and check could have been allocated at this point.

Isn't the list been added to before the conditional in the for loop?:

         list = add_geo(list, &geo, sb_index);

         /*
          * grab N secondaries.  check them off as we get them
          * so we only process each one once
          */
         for (round = 0; round < skip; round++)  {

...
                         if (get_sb(sb, off, size, agno) == XR_EOF)  {
                                 retval = 1;
                                 goto out;
				^^^^^^^^^ out_free_list?
                         }

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
