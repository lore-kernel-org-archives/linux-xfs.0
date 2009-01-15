Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0F5EeQR002280 for <xfs@oss.sgi.com>; Wed, 14 Jan 2009 23:14:41 -0600
In-Reply-To: <496E9A84.2060304@sandeen.net>
References: <496E9A84.2060304@sandeen.net>
Mime-Version: 1.0 (Apple Message framework v753.1)
Message-Id: <6FD6CEDB-79CA-4988-B8BC-0EEC41936357@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
Subject: Re: [PATCH] xfstests: only run 197 on 32-bit machines
Date: Wed, 14 Jan 2009 23:14:22 -0600
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>


On Jan 14, 2009, at 8:08 PM, Eric Sandeen wrote:

> Don't run test 197 on 64-bit machines
>
> If it always passes on 64 bits, this gives a false
> sense of security.  Make it obvious.

Sounds reasonable.

>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Signed-off-by: Felix Blyakher <felixb@sgi.com>

> --
>
> diff --git a/197 b/197
> index 4c81941..f77bfa2 100644
> --- a/197
> +++ b/197
> @@ -37,6 +37,10 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
>  _supported_fs xfs
>  _supported_os Linux
>
> +bitsperlong=`src/feature -w`
> +if [ "$bitsperlong" -ne 32 ]; then
> +	_notrun "This test is only valid on 32 bit machines"
> +fi
>
>  mkdir $TEST_DIR/ttt
>  for n in {1..168}; do
>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
