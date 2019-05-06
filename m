Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21837 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbfEFNOV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 May 2019 09:14:21 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DDB28308626F
        for <linux-xfs@vger.kernel.org>; Mon,  6 May 2019 13:14:20 +0000 (UTC)
Date: Mon, 6 May 2019 09:14:18 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfsdump: (style) remove spaces in front of
 commas/semicolons
Message-ID: <20190506131418.GA48302@bfoster>
References: <20190506115212.9876-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190506115212.9876-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, May 06, 2019 at 01:52:12PM +0200, Jan Tulak wrote:
> Hi guys,
> 
> Here is another xfsdump cleaning patch.
> Git stat: 31 files changed, 206 insertions(+), 206 deletions(-)
> 
> Cheers,
> Jan
> 
> ---
> 
> Turn all the "x , y , z" into "x, y, z" and "for (moo ; foo ; bar)"
> to "for (moo; foo; bar)".
> 
> When doing a clean build, no new warning is produced or existing one
> removed.
> 
> Changed macros:
> __arch__swab[16,32,64] in include/swab.h.
> 
> Created by this script:
> *****
> set -euo pipefail
> 
> find . -name '*.[ch]' ! -type d -exec gawk -i inplace '{
>     $0 = gensub(/^([^"]*[^[:space:]][^"]*) ,/, "\\1,", "g")
>     $0 = gensub(/^([^"]*[^[:space:]][^"]*) ;/, "\\1;", "g")
>     $0 = gensub(/^(.*[^[:space:]].*) ,([^"]*)$/, "\\1,\\2", "g")
>     $0 = gensub(/(.*[^[:space:]].*) ;([^"]*)$/, "\\1;\\2", "g")
> }; {print }' {} \;
> *****
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
...
> diff --git a/common/drive.c b/common/drive.c
> index b01b916..a3514a9 100644
> --- a/common/drive.c
> +++ b/common/drive.c
...
> @@ -3088,7 +3088,7 @@ prepare_drive(drive_t *drivep)
>  	 * if not present or write-protected during dump, return.
>  	 */
>  	maxtries = 15;
> -	for (try = 1 ; ; sleep(10), try++) {
> +	for (try = 1;; sleep(10), try++) {

FWIW, I think the spaces actually make sense in contexts like the above
where we've intentionally left a statement empty. Without the space this
kind of looks like a double semicolon, which is slightly misleading at a
glance.

>  		if (cldmgr_stop_requested()) {
>  			return DRIVE_ERROR_STOP;
>  		}
> @@ -3139,7 +3139,7 @@ prepare_drive(drive_t *drivep)
>  	else
>  		tape_recsz = tape_blksz;
>  
> -	/* if the overwrite option was specified , return.
> +	/* if the overwrite option was specified, return.
>  	 */
>  	if (contextp->dc_overwritepr) {
>  		mlog(MLOG_DEBUG | MLOG_DRIVE,
> @@ -3157,7 +3157,7 @@ prepare_drive(drive_t *drivep)
>  	maxtries = 5;
>  	changedblkszpr = BOOL_FALSE;
>  
> -	for (try = 1 ; ; try++) {
> +	for (try = 1;; try++) {
>  		int nread;
>  		int saved_errno;
>  
> @@ -3896,7 +3896,7 @@ rewind_and_verify(drive_t *drivep)
>  	int rval;
>  
>  	rval = mt_op(contextp->dc_fd, MTREW, 0);
> -	for (try = 1 ; ; try++) {
> +	for (try = 1;; try++) {
>  		if (rval) {
>  			sleep(1);
>  			rval = mt_op(contextp->dc_fd, MTREW, 0);
...
> diff --git a/dump/content.c b/dump/content.c
> index 43f51db..72ff7c4 100644
> --- a/dump/content.c
> +++ b/dump/content.c
...
> @@ -5240,7 +5240,7 @@ dump_session_inv(drive_t *drivep,
>  	 * until we are successful or until the media layer
>  	 * tells us to give up.
>  	 */
> -	for (done = BOOL_FALSE ; ! done ;) {
> +	for (done = BOOL_FALSE; ! done;) {

Perhaps we should remove the space after the ! here and below as well.

>  		uuid_t mediaid;
>  		char medialabel[GLOBAL_HDR_STRING_SZ];
>  		bool_t partial;
> @@ -5390,7 +5390,7 @@ dump_terminator(drive_t *drivep, context_t *contextp, media_hdr_t *mwhdrp)
>  	 * until we are successful or until the media layer
>  	 * tells us to give up.
>  	 */
> -	for (done = BOOL_FALSE ; ! done ;) {
> +	for (done = BOOL_FALSE; ! done;) {
>  		bool_t partial;
>  		rv_t rv;
>  
...
> diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
> index 74893d3..6339e4e 100644
> --- a/inventory/inv_stobj.c
> +++ b/inventory/inv_stobj.c
> @@ -909,7 +909,7 @@ stobj_getsession_bylabel(
>  bool_t
>  stobj_delete_mobj(int fd,
>  		  invt_seshdr_t *hdr,
> -		  void *arg ,
> +		  void *arg,
>  		  void **buf)
>  {
>  	/* XXX fd needs to be locked EX, not SH */
> @@ -977,7 +977,7 @@ stobj_delete_mobj(int fd,
>  				       mfiles[j-1].mf_nextmf = mf->mf_nextmf;
>  
>  				if (j == nmfiles - 1)
> -				       strms[i].st_lastmfile = ;
> +				       strms[i].st_lastmfile =;

The above code appears to be commented out..?

...
> diff --git a/restore/tree.c b/restore/tree.c
> index 3f3084e..9806777 100644
> --- a/restore/tree.c
> +++ b/restore/tree.c
...
> @@ -4821,7 +4821,7 @@ fix_quoted_span(char *string, char *liter)
>  	/* scan for the next non-literal quote, marking all
>  	 * characters in between as literal
>  	 */
> -	for (s = string, l = liter ; *s && (*s != '\"' || *l) ; s++, l++) {
> +	for (s = string, l = liter ; *s && (*s != '\"' || *l); s++, l++) {

Missed one here:                  ^

Brian

>  		*l = (char)1;
>  	}
>  
> @@ -4839,7 +4839,7 @@ collapse_white(char *string, char *liter)
>  	size_t cnt;
>  
>  	cnt = 0;
> -	for (s = string, l = liter ; is_white(*s) && ! *l ; s++, l++) {
> +	for (s = string, l = liter; is_white(*s) && ! *l; s++, l++) {
>  		cnt++;
>  	}
>  
> @@ -4856,7 +4856,7 @@ distance_to_space(char *s, char *l)
>  {
>  	size_t cnt;
>  
> -	for (cnt = 0 ; *s && (! is_white(*s) || *l) ; s++, l++) {
> +	for (cnt = 0; *s && (! is_white(*s) || *l); s++, l++) {
>  		cnt++;
>  	}
>  
> -- 
> 2.21.0
> 
