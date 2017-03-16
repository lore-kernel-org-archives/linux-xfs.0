Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35026 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752064AbdCPSj3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Mar 2017 14:39:29 -0400
Subject: Re: [PATCH 08/22] mkfs: move conflicts into the table
References: <20170315160017.27805-1-jtulak@redhat.com>
 <20170315160017.27805-9-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <435070bc-d00b-ac32-a319-4cce9c4b7246@sandeen.net>
Date: Thu, 16 Mar 2017 11:39:11 -0700
MIME-Version: 1.0
In-Reply-To: <20170315160017.27805-9-jtulak@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On 3/15/17 9:00 AM, Jan Tulak wrote:
> @@ -640,7 +655,9 @@ struct opt_params {
>  			  .defaultval = SUBOPT_NEEDS_VAL,
>  			},
>  			{ .index = R_DEV,
> -			  .conflicts = { {LAST_CONFLICT} },
> +			  .conflicts = { {OPT_M, M_RMAPBT, false, 0, 0,
> +		"rmapbt not supported without CRC support."},
> +					 {LAST_CONFLICT} },
>  			  .defaultval = SUBOPT_NEEDS_VAL,
>  			},
>  			{ .index = R_FILE,
> @@ -650,7 +667,9 @@ struct opt_params {
>  			  .conflicts = { {LAST_CONFLICT} },
>  			},
>  			{ .index = R_NAME,
> -			  .conflicts = { {LAST_CONFLICT} },
> +			  .conflicts = { {OPT_M, M_RMAPBT, false, 0, 0,
> +		"rmapbt not supported without CRC support."},
> +					 {LAST_CONFLICT} },
>  			  .defaultval = SUBOPT_NEEDS_VAL,
>  			},
>  			{ .index = R_NOALIGN,

These two should be:

"rmapbt not supported with realtime devices."

I think.

(sorry for the scattershot review, I'll try to get organized going forward) ;)

-Eric
