Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33100 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725831AbeLDTYj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Dec 2018 14:24:39 -0500
Subject: Re: [PATCH 1/4] xfsdump: (style) remove trailing whitespaces
References: <20181128165649.56853-1-jtulak@redhat.com>
 <20181128165649.56853-2-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d4ae9b40-5cc1-32c4-0b18-b57502c8a5a1@sandeen.net>
Date: Tue, 4 Dec 2018 13:24:37 -0600
MIME-Version: 1.0
In-Reply-To: <20181128165649.56853-2-jtulak@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org
Cc: sandeen@redhat.com

On 11/28/18 10:56 AM, Jan Tulak wrote:
> There were many trailing whitespaces through the whole code. As the rate
> of changes in xfsdump is low, it should not cause trouble if we fix it
> in all files at once and avoid issues (unintended changes) with sensibly
> configured editors that automatically remove these on a file save.
> 
> Can be tested with objdump.
> 
> Created by this script:
> 
> #!/usr/bin/env bash
> # remove trailing whitespaces
> 
> find . -name '*.[ch]' ! -type d -exec bash -c '
> sed -i \
>     -e "s/\s*$//" \
>     $0
> ' {} \;
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

Hi Jan - 

Finally got to looking at these, but this patch doesn't apply for me
(even if retrieved from patchwork)

...


> diff --git a/common/arch_xlate.c b/common/arch_xlate.c
> index 1b8e687..4043a9d 100644
> --- a/common/arch_xlate.c
> +++ b/common/arch_xlate.c
> @@ -135,12 +135,12 @@ xlate_drive_hdr(drive_hdr_t *dh1, drive_hdr_t *dh2, int dir)
>  	     "\tdh_pad1 %s\n"
>  	     "\tdh_specific %s\n"
>  	     "\tdh_upper %s\n",
> -	     ptr1->dh_drivecnt,
> +	     ptr1->dh_drivecnt,
>  	     ptr1->dh_driveix,
>  	     ptr1->dh_strategyid,
>  	     ptr1->dh_pad1,
>  	     ptr1->dh_specific,
> -	     ptr1->dh_upper);
> +	     ptr1->dh_upper);


...

there seems to be no actual trailing whitespace on the "-" lines?

-Eric
