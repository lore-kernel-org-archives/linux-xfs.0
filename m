Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B3DE17CA0
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:36:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 75BB7304039
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 14:36:34 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id qJ8buXD0fL09EAFp for <xfs@oss.sgi.com>;
	Thu, 25 Aug 2016 14:36:31 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 8D92F56B
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:36:30 -0500 (CDT)
Subject: Re: [PATCH] Make __xfs_xattr_put_listen preperly report errors.
References: <1471967653-2561-1-git-send-email-asavkov@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ba120df9-d8dd-fa06-1c58-ca8c9eba1467@sandeen.net>
Date: Thu, 25 Aug 2016 16:36:30 -0500
MIME-Version: 1.0
In-Reply-To: <1471967653-2561-1-git-send-email-asavkov@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 8/23/16 10:54 AM, Artem Savkov wrote:
> Commit "xfs: only return -errno or success from attr ->put_listent" changes the
> returnvalue of __xfs_xattr_put_listen to 0 in case when there is insufficient
> space in the buffer assuming that setting context->count to -1 would be enough,
> but all of the ->put_listent callers only check seen_enough. This results in
> a failed assertion:
> XFS: Assertion failed: context->count >= 0, file: fs/xfs/xfs_xattr.c, line: 175
> in insufficient buffer size case.

Oof.  I remember spending a lot of time trying to track down all
of these cases.  It seems overly complex and obscure.  :(

I'll try to find time to dig through it again; offhand it doesn't
seem like "count = -1" means anything to anyone except in an
ASSERT check?

Thanks,
-Eric


> Signed-off-by: Artem Savkov <asavkov@redhat.com>
> ---
>  fs/xfs/xfs_xattr.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index ea62245..6290093 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -147,6 +147,7 @@ __xfs_xattr_put_listent(
>  	arraytop = context->count + prefix_len + namelen + 1;
>  	if (arraytop > context->firstu) {
>  		context->count = -1;	/* insufficient space */
> +		context->seen_enough = 1;
>  		return 0;
>  	}
>  	offset = (char *)context->alist + context->count;
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
