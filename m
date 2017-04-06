Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40620 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754573AbdDFQ6r (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Apr 2017 12:58:47 -0400
Subject: Re: [PATCH] mkfs: rtinherit minval should be 0
References: <20170406143426.19727-1-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6c83318d-ef75-4dc2-e366-d50d74fb71e6@sandeen.net>
Date: Thu, 6 Apr 2017 11:58:45 -0500
MIME-Version: 1.0
In-Reply-To: <20170406143426.19727-1-jtulak@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On 4/6/17 9:34 AM, Jan Tulak wrote:
> As with any other option, rtinherit=[0|1], but minval was incorrectly
> set to 1, so it was not possible to disable this option.

Long ago, when this option was added, it was simply a flag with
no option parsing, i.e. "-d rtinherit"

so I just want to double check ...

1) was it intentional that this turned into a "=0/=1" type option,
   i.e. an option which can be specified as disabled, essentially restating
   the default?  Is it the intent that every flag option must now take a
   value, and that it must take both "off" and "on" values?  Just checking
   that I haven't lost the thread, here.

IOWS: we used to have only "-d rtinherit"  But I think now we accept
-d rtinherit, -d rtinherit=0, and -d rtinherit=1.  Maybe it's water
under the bridge, I don't see the use in adding value parsing to
something that was just a simple flag before.  Can you enlighten
me?

2) really, this and projinherit and, um, extszinherit should
   probably all go away.  They were written for testing, nothing
   tests them, and they aren't documented.  Any volunteers for
   that?  It actually finds its way outside of pure mkfs code,
   so it's a little tricky to completely eradicate it, but it
   could be done in 2 steps I think.

thanks,
-Eric

> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 6fedc05c..5aac4d1b 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -290,7 +290,7 @@ struct opt_params dopts = {
>  		},
>  		{ .index = D_RTINHERIT,
>  		  .conflicts = { LAST_CONFLICT },
> -		  .minval = 1,
> +		  .minval = 0,
>  		  .maxval = 1,
>  		  .defaultval = 1,
>  		},
> 
