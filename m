Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53872 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751567AbeDCRa6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Apr 2018 13:30:58 -0400
Subject: Re: [PATCH 01/14] xfs_scrub: avoid buffer overflow when scanning
 attributes
References: <152160358015.8288.2700156777231657519.stgit@magnolia>
 <152160358636.8288.17415854751640340360.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d293fe79-73bd-220f-0148-ee82c98d8a9f@sandeen.net>
Date: Tue, 3 Apr 2018 12:30:57 -0500
MIME-Version: 1.0
In-Reply-To: <152160358636.8288.17415854751640340360.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 3/20/18 10:39 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Avoid a buffer overflow when we're formatting extended attribute names
> for name checking.

This won't /actually/ overflow, right, because you are doing
snprintf(NAME_MAX) into a buffer of size [NAME_MAX + 1].

However, it might truncate the attribute string if too long.
(just trying to avoid security folk wig-outs).

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  scrub/phase5.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/scrub/phase5.c b/scrub/phase5.c
> index 8e0a1be..36821d0 100644
> --- a/scrub/phase5.c
> +++ b/scrub/phase5.c
> @@ -143,6 +143,8 @@ static const struct xfs_attr_ns attr_ns[] = {
>  	{ATTR_SECURE,		"secure"},
>  	{0, NULL},
>  };
> +/* Enough space to handle the prefix. */
> +#define ATTR_NAME_MAX		(NAME_MAX + 8)

Unrelated to this change, really, but should NAME_MAX be
XATTR_NAME_MAX for clarity & consistency w/ the xattr code?

(it's defined in /usr/include/linux/limits.h)

>  
>  /*
>   * Check all the xattr names in a particular namespace of a file handle
> @@ -158,7 +160,7 @@ xfs_scrub_scan_fhandle_namespace_xattrs(
>  {
>  	struct attrlist_cursor		cur;
>  	char				attrbuf[XFS_XATTR_LIST_MAX];
> -	char				keybuf[NAME_MAX + 1];
> +	char				keybuf[ATTR_NAME_MAX + 1];
>  	struct attrlist			*attrlist = (struct attrlist *)attrbuf;
>  	struct attrlist_ent		*ent;
>  	struct unicrash			*uc;
> @@ -172,14 +174,14 @@ xfs_scrub_scan_fhandle_namespace_xattrs(
>  
>  	memset(attrbuf, 0, XFS_XATTR_LIST_MAX);
>  	memset(&cur, 0, sizeof(cur));
> -	memset(keybuf, 0, NAME_MAX + 1);
> +	memset(keybuf, 0, ATTR_NAME_MAX + 1);
>  	error = attr_list_by_handle(handle, sizeof(*handle), attrbuf,
>  			XFS_XATTR_LIST_MAX, attr_ns->flags, &cur);
>  	while (!error) {
>  		/* Examine the xattrs. */
>  		for (i = 0; i < attrlist->al_count; i++) {
>  			ent = ATTR_ENTRY(attrlist, i);
> -			snprintf(keybuf, NAME_MAX, "%s.%s", attr_ns->name,

To future proof this rather than relying on a hardcoded 8 based on the
current namespaces above, how about:

#define XATTR_NS_MAX 8
#define ATTR_STRING_MAX		(XATTR_NS_MAX + XATTR_NAME_MAX + 1) /* for '.' */

char				keybuf[ATTR_STRING_MAX + 1];

			ASSERT(strlen(attr_ns->name) <= XATTR_NS_MAX);
			snprintf(keybuf, ATTR_STRING_MAX, "%s.%s", attr_ns->name,
					ent->a_name);

just in case someone adds a new 

	ATTR_SUPERDELUXE, "superdeluxe"

namespace some day?  Is that overkill?

> +			snprintf(keybuf, ATTR_NAME_MAX, "%s.%s", attr_ns->name,
>  					ent->a_name);
>  			moveon = xfs_scrub_check_name(ctx, descr,
>  					_("extended attribute"), keybuf);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
