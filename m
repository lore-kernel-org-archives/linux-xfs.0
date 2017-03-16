Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60474 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751864AbdCPSFj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Mar 2017 14:05:39 -0400
Subject: Re: [PATCH 08/22] mkfs: move conflicts into the table
References: <20170315160017.27805-1-jtulak@redhat.com>
 <20170315160017.27805-9-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9fdad56d-6d27-8380-d6d0-00caa3b29762@sandeen.net>
Date: Thu, 16 Mar 2017 11:04:39 -0700
MIME-Version: 1.0
In-Reply-To: <20170315160017.27805-9-jtulak@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org



On 3/15/17 9:00 AM, Jan Tulak wrote:
> @@ -564,7 +575,9 @@ struct opt_params {
>  			  .defaultval = SUBOPT_NEEDS_VAL,
>  			},
>  			{ .index = L_LAZYSBCNTR,
> -			  .conflicts = { {LAST_CONFLICT} },
> +			  .conflicts = { {OPT_M, M_CRC, true, 1, 0,
> +		"Lazy superblock counted always enabled for CRC enabled filesytems."},
> +					 {LAST_CONFLICT} },
>  			  .minval = 0,
>  			  .maxval = 1,
>  			  .defaultval = 1,

Ah, and I know this is just a copy from elsewhere, but this string
has a typo; it should be "Lazy superblock counters always enabled ..."
so this might be a decent time to fix it.

-Eric
