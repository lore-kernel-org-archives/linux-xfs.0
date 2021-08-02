Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E610C4338F
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 22:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2275260EE6
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 22:35:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbhHBWgA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Aug 2021 18:36:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230313AbhHBWgA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 2 Aug 2021 18:36:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB38E60F11;
        Mon,  2 Aug 2021 22:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627943750;
        bh=cUgv9uizKfNJMu4XqafE9x5qINoO4ap7X78wbHWY5/I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mtRsUdWmCgOM/kJMB2mxvxo6uDn3oIqUOu/PmClU80u5WjipySzgX2JWCc90kGSKG
         s5rdZi3gOsxvq6nu5UIVLP/j6lZuzeSsbecBBRFpfIGXuSWK34jUwKLuaCWLJxu1aB
         yt8wZptvNGTU2nq79rhu9VOFK+f6XYHw1yBxLK9zjY/JnO48Q7D+2O0/VMMl9OEiHL
         u1xWq1yrtMz3pMYl94mnxWYk7KrnZQisy6XtMHRzqIWMbqb6A/jBgwFvlK87pEaz/7
         Bv2kRK6OLPqbVMN3A7GPFzMPDHF38PLPr24GtxzUeheF/INmnygqhkzUf0S4YU8iAZ
         WTUmL/tfB6BIw==
Date:   Mon, 2 Aug 2021 15:35:49 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfsprogs: remove platform_uuid_compare()
Message-ID: <20210802223549.GR3601443@magnolia>
References: <20210802215024.949616-1-preichl@redhat.com>
 <20210802215024.949616-4-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802215024.949616-4-preichl@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 02, 2021 at 11:50:19PM +0200, Pavel Reichl wrote:
> ---
>  copy/xfs_copy.c      | 2 +-
>  db/sb.c              | 2 +-
>  include/linux.h      | 5 -----

It's fine to change the platform_uuid_compare usages inside xfsprogs
itself, but linux.h is shipped as part of the development headers, which
means that you can't get rid of the wrapper functions without causing
build problems for other userspace programs.

--D

>  libxfs/libxfs_priv.h | 2 +-
>  libxlog/util.c       | 2 +-
>  repair/agheader.c    | 4 ++--
>  repair/attr_repair.c | 2 +-
>  repair/dinode.c      | 6 +++---
>  repair/phase6.c      | 2 +-
>  repair/scan.c        | 4 ++--
>  10 files changed, 13 insertions(+), 18 deletions(-)
> 
> diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
> index c80b42d1..2a17bf38 100644
> --- a/copy/xfs_copy.c
> +++ b/copy/xfs_copy.c
> @@ -15,7 +15,7 @@
>  #include "libfrog/common.h"
>  
>  #define	rounddown(x, y)	(((x)/(y))*(y))
> -#define uuid_equal(s,d) (platform_uuid_compare((s),(d)) == 0)
> +#define uuid_equal(s,d) (uuid_compare((*s),(*d)) == 0)
>  
>  extern int	platform_check_ismounted(char *, char *, struct stat *, int);
>  
> diff --git a/db/sb.c b/db/sb.c
> index cec7dce9..7017e1e5 100644
> --- a/db/sb.c
> +++ b/db/sb.c
> @@ -17,7 +17,7 @@
>  #include "output.h"
>  #include "init.h"
>  
> -#define uuid_equal(s,d)		(platform_uuid_compare((s),(d)) == 0)
> +#define uuid_equal(s,d)		(uuid_compare((*s),(*d)) == 0)
>  
>  static int	sb_f(int argc, char **argv);
>  static void     sb_help(void);
> diff --git a/include/linux.h b/include/linux.h
> index a22f7812..9c7ea189 100644
> --- a/include/linux.h
> +++ b/include/linux.h
> @@ -85,11 +85,6 @@ static __inline__ void platform_getoptreset(void)
>  	optind = 0;
>  }
>  
> -static __inline__ int platform_uuid_compare(uuid_t *uu1, uuid_t *uu2)
> -{
> -	return uuid_compare(*uu1, *uu2);
> -}
> -
>  static __inline__ void platform_uuid_unparse(uuid_t *uu, char *buffer)
>  {
>  	uuid_unparse(*uu, buffer);
> diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
> index 2815c79f..22b4f606 100644
> --- a/libxfs/libxfs_priv.h
> +++ b/libxfs/libxfs_priv.h
> @@ -505,7 +505,7 @@ static inline int retzero(void) { return 0; }
>  #define xfs_qm_dqattach(i)			(0)
>  
>  #define uuid_copy(s,d)		platform_uuid_copy((s),(d))
> -#define uuid_equal(s,d)		(platform_uuid_compare((s),(d)) == 0)
> +#define uuid_equal(s,d)		(uuid_compare((*s),(*d)) == 0)
>  
>  #define xfs_icreate_log(tp, agno, agbno, cnt, isize, len, gen) ((void) 0)
>  #define xfs_sb_validate_fsb_count(sbp, nblks)		(0)
> diff --git a/libxlog/util.c b/libxlog/util.c
> index a85d70c9..b4dfeca0 100644
> --- a/libxlog/util.c
> +++ b/libxlog/util.c
> @@ -76,7 +76,7 @@ header_check_uuid(xfs_mount_t *mp, xlog_rec_header_t *head)
>  
>      if (print_skip_uuid)
>  		return 0;
> -    if (!platform_uuid_compare(&mp->m_sb.sb_uuid, &head->h_fs_uuid))
> +    if (!uuid_compare(mp->m_sb.sb_uuid, head->h_fs_uuid))
>  		return 0;
>  
>      platform_uuid_unparse(&mp->m_sb.sb_uuid, uu_sb);
> diff --git a/repair/agheader.c b/repair/agheader.c
> index 2af24106..1c4138e4 100644
> --- a/repair/agheader.c
> +++ b/repair/agheader.c
> @@ -100,7 +100,7 @@ verify_set_agf(xfs_mount_t *mp, xfs_agf_t *agf, xfs_agnumber_t i)
>  	if (!xfs_sb_version_hascrc(&mp->m_sb))
>  		return retval;
>  
> -	if (platform_uuid_compare(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid)) {
> +	if (uuid_compare(agf->agf_uuid, mp->m_sb.sb_meta_uuid)) {
>  		char uu[64];
>  
>  		retval = XR_AG_AGF;
> @@ -179,7 +179,7 @@ verify_set_agi(xfs_mount_t *mp, xfs_agi_t *agi, xfs_agnumber_t agno)
>  	if (!xfs_sb_version_hascrc(&mp->m_sb))
>  		return retval;
>  
> -	if (platform_uuid_compare(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid)) {
> +	if (uuid_compare(agi->agi_uuid, mp->m_sb.sb_meta_uuid)) {
>  		char uu[64];
>  
>  		retval = XR_AG_AGI;
> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> index bc3c2bef..25bdff73 100644
> --- a/repair/attr_repair.c
> +++ b/repair/attr_repair.c
> @@ -947,7 +947,7 @@ _("expected block %" PRIu64 ", got %llu, inode %" PRIu64 "attr block\n"),
>  		return 1;
>  	}
>  	/* verify uuid */
> -	if (platform_uuid_compare(&info->uuid, &mp->m_sb.sb_meta_uuid) != 0) {
> +	if (uuid_compare(info->uuid, mp->m_sb.sb_meta_uuid) != 0) {
>  		do_warn(
>  _("wrong FS UUID, inode %" PRIu64 " attr block %" PRIu64 "\n"),
>  			ino, bp->b_bn);
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 291c5807..a6156830 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -1098,7 +1098,7 @@ null_check(char *name, int length)
>   * This does /not/ do quotacheck, it validates the basic quota
>   * inode metadata, checksums, etc.
>   */
> -#define uuid_equal(s,d) (platform_uuid_compare((s),(d)) == 0)
> +#define uuid_equal(s,d) (uuid_compare((*s),(*d)) == 0)
>  static int
>  process_quota_inode(
>  	struct xfs_mount	*mp,
> @@ -2329,8 +2329,8 @@ _("inode identifier %llu mismatch on inode %" PRIu64 "\n"),
>  				return 1;
>  			goto clear_bad_out;
>  		}
> -		if (platform_uuid_compare(&dino->di_uuid,
> -					  &mp->m_sb.sb_meta_uuid)) {
> +		if (uuid_compare(dino->di_uuid,
> +				mp->m_sb.sb_meta_uuid)) {
>  			if (!uncertain)
>  				do_warn(
>  			_("UUID mismatch on inode %" PRIu64 "\n"), lino);
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 6bddfefa..05e6a321 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -1886,7 +1886,7 @@ _("expected block %" PRIu64 ", got %llu, directory inode %" PRIu64 "\n"),
>  		return 1;
>  	}
>  	/* verify uuid */
> -	if (platform_uuid_compare(uuid, &mp->m_sb.sb_meta_uuid) != 0) {
> +	if (uuid_compare(*uuid, mp->m_sb.sb_meta_uuid) != 0) {
>  		do_warn(
>  _("wrong FS UUID, directory inode %" PRIu64 " block %" PRIu64 "\n"),
>  			ino, bp->b_bn);
> diff --git a/repair/scan.c b/repair/scan.c
> index 2c25af57..361c3b3c 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
> @@ -268,8 +268,8 @@ _("expected block %" PRIu64 ", got %llu, bmbt block %" PRIu64 "\n"),
>  			return 1;
>  		}
>  		/* verify uuid */
> -		if (platform_uuid_compare(&block->bb_u.l.bb_uuid,
> -					  &mp->m_sb.sb_meta_uuid) != 0) {
> +		if (uuid_compare(block->bb_u.l.bb_uuid,
> +			mp->m_sb.sb_meta_uuid) != 0) {
>  			do_warn(
>  _("wrong FS UUID, bmbt block %" PRIu64 "\n"),
>  				bno);
> -- 
> 2.31.1
> 
