Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F35CCC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Feb 2022 22:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345199AbiBJWqP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Feb 2022 17:46:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241709AbiBJWqP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Feb 2022 17:46:15 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 60CFA26F3
        for <linux-xfs@vger.kernel.org>; Thu, 10 Feb 2022 14:46:15 -0800 (PST)
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 47CAB88;
        Thu, 10 Feb 2022 16:45:42 -0600 (CST)
Message-ID: <8eafb32b-10ab-b5eb-d80a-571bf803c832@sandeen.net>
Date:   Thu, 10 Feb 2022 16:46:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Anthony Iliopoulos <ailiop@suse.com>
References: <20220203174540.GT8313@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfs_restore: remove DMAPI support
In-Reply-To: <20220203174540.GT8313@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/3/22 11:45 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The last of the DMAPI stubs were removed from Linux 5.17, so drop this
> functionality altogether.

Why is this better than letting it EINVAL/ENOTTY/ENOWHATEVER when the
ioctl gets called?  Though I don't really care, so I will go ahead and
review it. :)

At this point I suppose finally pulling in Anthony's
	xfsdump: remove BMV_IF_NO_DMAPI_READ flag
would make sense as well.


> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  doc/xfsdump.html  |    1 -
>  po/de.po          |    5 ---
>  po/pl.po          |    5 ---
>  restore/content.c |   99 +++--------------------------------------------------
>  restore/tree.c    |   33 ------------------
>  restore/tree.h    |    1 -
>  6 files changed, 6 insertions(+), 138 deletions(-)
> 

...

> diff --git a/restore/content.c b/restore/content.c
> index 6b22965..e9b0a07 100644
> --- a/restore/content.c
> +++ b/restore/content.c
> @@ -477,9 +477,6 @@ struct pers {
>  			/* how many pages following the header page are reserved
>  			 * for the subtree descriptors
>  			 */
> -		bool_t restoredmpr;
> -			/* restore DMAPI event settings
> -			 */
>  		bool_t restoreextattrpr;
>  			/* restore extended attributes
>  			 */
> @@ -858,7 +855,6 @@ static void partial_reg(ix_t d_index, xfs_ino_t ino, off64_t fsize,
>                          off64_t offset, off64_t sz);
>  static bool_t partial_check (xfs_ino_t ino, off64_t fsize);
>  static bool_t partial_check2 (partial_rest_t *isptr, off64_t fsize);
> -static int do_fssetdm_by_handle(char *path, fsdmidata_t *fdmp);

with fsdmidata_t completely gone I think its typedef can go too?

...

> @@ -8796,19 +8748,6 @@ restore_extattr(drive_t *drivep,
>  			}
>  		} else if (isfilerestored && path[0] != '\0') {
>  			setextattr(path, ahdrp);

Pretty sure there's a hunk in setextattr that could go too, right?

@@ -8840,20 +8779,16 @@ restore_dir_extattr_cb_cb(extattrhdr_t *ahdrp, void *ctxp)
 static void
 setextattr(char *path, extattrhdr_t *ahdrp)
 {
-       static  char dmiattr[] = "SGI_DMI_";
        bool_t isrootpr = ahdrp->ah_flags & EXTATTRHDR_FLAGS_ROOT;
        bool_t issecurepr = ahdrp->ah_flags & EXTATTRHDR_FLAGS_SECURE;
-       bool_t isdmpr;
        int attr_namespace;
        int rval;
 
-       isdmpr = (isrootpr &&
-                  !strncmp((char *)(&ahdrp[1]), dmiattr, sizeof(dmiattr)-1));
 
        /* If restoreextattrpr not set, then we are here because -D was
         * specified. So return unless it looks like a root DMAPI attribute.
         */
-       if (!persp->a.restoreextattrpr && !isdmpr)
+       if (!persp->a.restoreextattrpr)
                return;

> -
> -			if (persp->a.dstdirisxfspr && persp->a.restoredmpr) {
> -				int flag = 0;
> -				char *attrname = (char *)&ahdrp[1];
> -				if (ahdrp->ah_flags & EXTATTRHDR_FLAGS_ROOT)
> -					flag = ATTR_ROOT;
> -				else if (ahdrp->ah_flags & EXTATTRHDR_FLAGS_SECURE)
> -					flag = ATTR_SECURE;
> -
> -				HsmRestoreAttribute(flag,
> -						     attrname,
> -						     &strctxp->sc_hsmflags);

And with the only user of strctxp gone it's now an unused local var, I think.

Anyway....

I wonder if there's still more that could be ripped out:

        uint32_t        bs_dmevmask;    /* DMI event mask        4    6c */
        uint16_t        bs_dmstate;     /* DMI state info        2    6e */

Those can't go, I guess, because they are part of the header in the on-disk format.

But why are we still fiddling with them? For that matter, why does hsmapi.c still
exist at all?

I have the sense that if we really want to remove all dmapi support there's further
to go, but as with all things xfsdump, it scares me a bit ...

-Eric

