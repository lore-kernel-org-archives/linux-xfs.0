Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47174 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751799AbdKTRs0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 Nov 2017 12:48:26 -0500
Subject: Re: [PATCH 1/2] xfs_io: stat: fix typo in statfs->f_flags
References: <20171117195457.16218-1-jeffm@suse.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <46e31c4f-0802-3ea0-d488-ce079664d028@sandeen.net>
Date: Mon, 20 Nov 2017 11:48:25 -0600
MIME-Version: 1.0
In-Reply-To: <20171117195457.16218-1-jeffm@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: jeffm@suse.com, linux-xfs@vger.kernel.org

On 11/17/17 1:54 PM, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> The field name is f_flags.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  io/stat.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io/stat.c b/io/stat.c
> index 060ff833..6ab10abf 100644
> --- a/io/stat.c
> +++ b/io/stat.c
> @@ -199,7 +199,7 @@ statfs_f(
>  		printf(_("statfs.f_bavail = %lld\n"), (long long) st.f_bavail);
>  		printf(_("statfs.f_files = %lld\n"), (long long) st.f_files);
>  		printf(_("statfs.f_ffree = %lld\n"), (long long) st.f_ffree);
> -		printf(_("statfs.f_fflags = 0x%llx\n"), (long long) st.f_flags);
> +		printf(_("statfs.f_flags = 0x%llx\n"), (long long) st.f_flags);
>  	}
>  	if (file->flags & IO_FOREIGN)
>  		return 0;
> 
