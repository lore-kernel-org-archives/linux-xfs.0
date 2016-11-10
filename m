Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47032 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752933AbcKJEdi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 9 Nov 2016 23:33:38 -0500
Date: Thu, 10 Nov 2016 12:33:36 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH v2] xfs/021: filter out detailed array element info from
 xfs_db
Message-ID: <20161110043336.GE3327@dhcp12-143.nay.redhat.com>
References: <1478752183-27499-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1478752183-27499-1-git-send-email-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, Nov 10, 2016 at 12:29:43PM +0800, Eryu Guan wrote:
> Starting from xfsprogs commit 384283555871 ("xfs_db: print one array
> element per line"), xfs_db prints one array element per line. This
> breaks the filter in xfs/021, which now fails as:
> 
>   hdr.freemap[0-2] = [base,size] [FREEMAP..]
>  +0:[104,1892]
>  +1:[0,0]
>  +2:[0,0]
>   entries[0-2] = [hashval,nameidx,incomplete,root,local] [ENTRIES..]
> 
> So we have extra lines that need to be filtered out,
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---

V2 looks better to me,
Reviewed-by: Zorro Lang <zlang@redhat.com>

> - be more precise on matching the array output, address Zorro's comment
> 
>  tests/xfs/021 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/021 b/tests/xfs/021
> index 67a4346..0471b95 100755
> --- a/tests/xfs/021
> +++ b/tests/xfs/021
> @@ -151,7 +151,7 @@ s/^(hdr.info.magic =) 0x3bee/\1 0xfbee/;
>  s/^(hdr.firstused =) (\d+)/\1 FIRSTUSED/;
>  s/^(hdr.freemap\[0-2] = \[base,size]).*/\1 [FREEMAP..]/;
>  s/^(entries\[0-2] = \[hashval,nameidx,incomplete,root,local]).*/\1 [ENTRIES..]/;
> -	print;'
> +	print unless /^\d+:\[.*/;'
>  
>  echo "*** done"
>  exit
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
