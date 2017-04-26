Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22920 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1437745AbdDZPLJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Apr 2017 11:11:09 -0400
Date: Wed, 26 Apr 2017 08:10:59 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] mkfs.xfs: Assign proper defaults to rmapbt and reflink
 flags
Message-ID: <20170426151059.GN5205@birch.djwong.org>
References: <0f7c888b-5c62-e874-53d1-9159f1a3beba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f7c888b-5c62-e874-53d1-9159f1a3beba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Jan Tulak <jtulak@redhat.com>

On Wed, Apr 26, 2017 at 09:02:44AM -0500, Eric Sandeen wrote:
> The "defaultval" field in the options structure was a bit confusing,
> so when the rmapbt & reflink options got added, the desire was
> to keep them off by default, and "defaultval = 0" got set.
> 
> However, the purpose of this field is to define the default value
> when the flag is specified with no associated value, i.e.
> 
> -m rmapbt vs. -m rmapbt=0 or -m rmapbt=1
> 
> Today, the resulting behavior is unexpected, and different from any
> other mkfs flags; specifying "-m rmapbt,reflink" results in a
> filesystem /without/ those features.
> 
> Fix these to be consistent with every other boolean flag in the
> mkfs options, so that specifying the flag with no value will
> enable the feature.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Someone should document that 'defaultval' is not the way to say
'disabled by default' in whatever the mkfs option processing code
turns into.

(Granted maybe it does and I just can't read :P)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> I want to get this fixed up for 4.11, so just sending it separately
> ahead of any other change Jan may make in this area.
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index affa405..10858e4 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -697,13 +697,13 @@ struct opt_params mopts = {
>  		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = 1,
> -		  .defaultval = 0,
> +		  .defaultval = 1,
>  		},
>  		{ .index = M_REFLINK,
>  		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = 1,
> -		  .defaultval = 0,
> +		  .defaultval = 1,
>  		},
>  	},
>  };
> 
