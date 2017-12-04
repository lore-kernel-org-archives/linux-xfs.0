Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:25162 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751405AbdLDTVg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Dec 2017 14:21:36 -0500
Date: Mon, 4 Dec 2017 11:21:23 -0800
From: Eduardo Valentin <eduval@amazon.com>
Subject: Re: [PATCH] treewide: remove duplicate includes
Message-ID: <20171204192123.GA1463@u40b0340c692b58f6553c.ant.amazon.com>
References: <1512337779-16842-1-git-send-email-pravin.shedge4linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1512337779-16842-1-git-send-email-pravin.shedge4linux@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Pravin Shedge <pravin.shedge4linux@gmail.com>
Cc: gregkh@linuxfoundation.org, davem@davemloft.net, sstabellini@kernel.org, x86@kernel.org, mchehab@kernel.org, linux-xfs@vger.kernel.org, mcgrof@kernel.org, ast@kernel.org, shuah@kernel.org, namhyung@kernel.org, mhiramat@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, devel@driverdev.osuosl.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

Hello,

On Mon, Dec 04, 2017 at 03:19:39AM +0530, Pravin Shedge wrote:
<cut>

> diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
> index d04ec3b..e09f035 100644
> --- a/drivers/thermal/of-thermal.c
> +++ b/drivers/thermal/of-thermal.c
> @@ -30,7 +30,6 @@
>  #include <linux/err.h>
>  #include <linux/export.h>
>  #include <linux/string.h>
> -#include <linux/thermal.h>
>  
>  #include "thermal_core.h"
>  

No issues with this but,

Please send a separate patch to linux-pm@vger.kernel.org and copy edubezva@gmail.com

thanks,

-- 
All the best,
Eduardo Valentin
