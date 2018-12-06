Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44864 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbeLFXJG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Dec 2018 18:09:06 -0500
Subject: Re: [PATCH 4/4] common/drive.c: include stdlib.h
References: <20181128165649.56853-1-jtulak@redhat.com>
 <20181128165649.56853-5-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <0d5c1f76-9e50-7e10-372b-9c8dc52b9361@sandeen.net>
Date: Thu, 6 Dec 2018 17:09:03 -0600
MIME-Version: 1.0
In-Reply-To: <20181128165649.56853-5-jtulak@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org
Cc: sandeen@redhat.com

On 11/28/18 10:56 AM, Jan Tulak wrote:
> We are using calloc() inside of this file, but it is not included in any
> way (resultin in "implicit declaration" warnings from the compiler). So,
> add the include.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  common/drive.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/common/drive.c b/common/drive.c
> index 4b0825f..edb63c0 100644
> --- a/common/drive.c
> +++ b/common/drive.c
> @@ -17,6 +17,7 @@
>   */
>  
>  #include <stdio.h>
> +#include <stdlib.h>
>  #include <unistd.h>
>  #include <sys/stat.h>
>  #include <time.h>


Seems fine, but why don't these files complain too?

# find . -name \*.c | xargs grep -lw calloc | xargs grep -L stdlib.h

./inventory/inv_oref.c
./inventory/inv_core.c
./inventory/inv_mgr.c
./inventory/testmain.c
(ok, narrator: because they aren't built?)

./common/global.c
./common/fs.c

*shrug* 

If it fixes a warning I'm not going dig too much, seems fine.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks,
-Eric
