Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42230 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbeLFWiG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Dec 2018 17:38:06 -0500
Subject: Re: [PATCH 3/4] common/types.h: Wrap #define UUID_STR_LEN 36 in
 #ifndef
References: <20181128165649.56853-1-jtulak@redhat.com>
 <20181128165649.56853-4-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <315d73ef-e305-5e3a-b0bd-31364468686b@sandeen.net>
Date: Thu, 6 Dec 2018 16:38:04 -0600
MIME-Version: 1.0
In-Reply-To: <20181128165649.56853-4-jtulak@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org
Cc: sandeen@redhat.com



On 11/28/18 10:56 AM, Jan Tulak wrote:
> Current Fedora 28 has the constant it in uuid/uuid.h where it belongs (per
> comment next to the define), so we should treat the define as a
> backward-compatibility workaround, rather than enforcing it for all.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

so I think the comment can use an update too, but I'll just do that
on checkin:

- * Should be, but isn't, defined in uuid/uuid.h
+ * If not defined in uuid/uuid.h

[sandeen: tweak comment to match]
Reviewed-by: Eric Sandeen <sandeen@redhat.com>


> ---
>  common/types.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/common/types.h b/common/types.h
> index 50c841e..096c5b7 100644
> --- a/common/types.h
> +++ b/common/types.h
> @@ -35,7 +35,9 @@
>  /*
>   * Should be, but isn't, defined in uuid/uuid.h
>   */
> +#ifndef UUID_STR_LEN
>  #define UUID_STR_LEN	36
> +#endif
>  
>  /* fundamental page size - probably should not be hardwired, but
>   * for now we will
> 
