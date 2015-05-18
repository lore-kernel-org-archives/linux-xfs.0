Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8E6787F5E
	for <xfs@oss.sgi.com>; Mon, 18 May 2015 12:19:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7F3C88F8037
	for <xfs@oss.sgi.com>; Mon, 18 May 2015 10:19:51 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id pfB2THmHmGkMkg8G (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 18 May 2015 10:19:49 -0700 (PDT)
Date: Mon, 18 May 2015 18:19:46 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/4 linux-next] xfs: use swap() in
	xfs_dir2_leafn_rebalance()
Message-ID: <20150518171946.GY7232@ZenIV.linux.org.uk>
References: <1431969231-12834-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1431969231-12834-1-git-send-email-fabf@skynet.be>
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
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, May 18, 2015 at 07:13:48PM +0200, Fabian Frederick wrote:
>  	 * If the block order is wrong, swap the arguments.
>  	 */
> -	if ((swap = xfs_dir2_leafn_order(dp, blk1->bp, blk2->bp))) {
> -		xfs_da_state_blk_t	*tmp;	/* temp for block swap */
> +	swap = xfs_dir2_leafn_order(dp, blk1->bp, blk2->bp);
> +	if (swap)
> +		swap(blk1, blk2);

Egads...  Have you even read what you'd written?  Yes, sure, preprocessor
will do the right thing, but it's a very noticable annoyance for somebody
reading that.  Rename the bleeding flag, please.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
