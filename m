Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pASB20Rn232915 for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 05:02:01 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3395F943993
	for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 03:01:59 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	xdaJew4qGTfrRUex for <xfs@oss.sgi.com>;
	Mon, 28 Nov 2011 03:01:59 -0800 (PST)
Date: Mon, 28 Nov 2011 06:01:58 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: make xattr test 020 generic
Message-ID: <20111128110158.GB13766@infradead.org>
References: <4ECD4579.4080706@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4ECD4579.4080706@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Wed, Nov 23, 2011 at 01:11:53PM -0600, Eric Sandeen wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> 020 can be made generic by limiting the total attribute space
> used in the tests as appropriate.  Unless we know we have a
> large-xattr-capable fs, limit total space to a bit under one
> fs block.
> 
> Now passes for me on ext3, ext4, btrfs, as well as xfs.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> - ---
> 
> incidentally the test used to send a 100k xattr value to
> the attr command on xfs; it wrote only 64k but did not complain.
> Feature or bug?
> 
> diff --git a/020 b/020
> index 56b9c3c..d196318 100755
> - --- a/020
> +++ b/020
> @@ -80,7 +80,7 @@ _attr_list()
>  
>  
>  # real QA test starts here
> - -_supported_fs xfs udf
> +_supported_fs generic
>  _supported_os Linux
>  
>  _require_attrs
> @@ -119,9 +119,19 @@ _attr_list $testfile
>  
>  echo "*** add lots of attributes"
>  v=0
> - -while [ $v -lt 1000 ]
> +
> +# set maximum total attr space based on fs type
> +if [ "$FSTYP" == "xfs" -o "$FSTYP" == "udf" ]; then
> +	NUMATTRS=1000
> +else # Assume max ~1 block of attrs
> +	BLOCK_SIZE=`stat -f $TEST_DEV | grep "Block size" | cut -d " " -f3`
> +	# user.attribute_XXX="value.XXX" is about 32 bytes; leave some overhead
> +	let NUMATTRS=$BLOCK_SIZE/40
> +fi

I'd prefer if we define the limits in common.rc - we shouldn't have to
spread too much fs knowledege over individual tests.

> +if [ "$FSTYP" == "xfs" -o "$FSTYP" == "udf" -o "$FSTYP" == "btrfs" ]; then
> +	ATTRVAL_SIZE=64
> +else # Assume max ~1 block of attrs
> +	BLOCK_SIZE=`stat -f $TEST_DEV | grep "Block size" | cut -d " " -f3`
> +	# leave a little overhead
> +	let ATTRVAL_SIZE=$BLOCK_SIZE-256
> +fi

same for this one.

Except for that these changes looks fine to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
