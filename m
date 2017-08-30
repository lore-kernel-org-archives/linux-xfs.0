Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:32988 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751366AbdH3NyH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Aug 2017 09:54:07 -0400
Subject: Re: [PATCH] mkfs.xfs: Don't stagger AG for a single disk
References: <1504066712-26973-1-git-send-email-ddouwsma@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9aacc5d8-c935-24f0-4a0b-89993dd48769@sandeen.net>
Date: Wed, 30 Aug 2017 08:54:06 -0500
MIME-Version: 1.0
In-Reply-To: <1504066712-26973-1-git-send-email-ddouwsma@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Donald Douwsma <ddouwsma@redhat.com>, linux-xfs@vger.kernel.org

On 8/29/17 11:18 PM, Donald Douwsma wrote:
> When sunit and swidth are used mkfs.xfs tries to avoid all allocation
> groups aligning on the same stripe and will attempt to stagger them
> across the stripes that make up swidth.  If there is only one stripe
> then there is no benefit in this optimisation.
> 
> $ truncate -s10G xfs_10G_su256k_sw1.image
> $ mkfs.xfs -d su=256k,sw=1 xfs_10G_su256k_sw1.image
> meta-data=xfs_10G_su256k_sw1.image isize=512    agcount=16, agsize=163776 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=0, sparse=0
> data     =                       bsize=4096   blocks=2620416, imaxpct=25
>          =                       sunit=64     swidth=64 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> log      =internal log           bsize=4096   blocks=2560, version=2
>          =                       sectsz=512   sunit=64 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> A side effect of the optimisation is that the size adjustment used to stager
> the allocation groups causes the last sunit of storage to be unused.
> 
> $ echo $((2620416*4096))
> 10733223936
> $ ls -l xfs_10G_su256k_sw1.image
> -rw-rw-r--. 1 test test 10737418240 Aug 30 10:54 xfs_10G_su256k_sw1.image
> 
> Skip this optimisation when sunit == swidth.
> 
> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>

Interesting.  Yeah, I suppose this makes sense, though I'm surprised
anyone would notice.  :)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks,
-Eric

> ---
>  mkfs/xfs_mkfs.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index b5c3a57..35dae48 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2534,7 +2534,9 @@ reported by the device (%u).\n"),
>  				}
>  			}
>  		}
> -		if (dswidth && ((agsize % dswidth) == 0) && (agcount > 1)) {
> +		if (dswidth && ((agsize % dswidth) == 0)
> +			    && (dswidth != dsunit)
> +			    && (agcount > 1)) {
>  			/* This is a non-optimal configuration because all AGs
>  			 * start on the same disk in the stripe.  Changing
>  			 * the AG size by one sunit will guarantee that this
> 
