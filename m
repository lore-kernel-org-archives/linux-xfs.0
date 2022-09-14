Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ADA0C6FA82
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Sep 2022 17:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiINRar (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Sep 2022 13:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiINRaq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Sep 2022 13:30:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BDE7E808
        for <linux-xfs@vger.kernel.org>; Wed, 14 Sep 2022 10:30:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95225B81A7D
        for <linux-xfs@vger.kernel.org>; Wed, 14 Sep 2022 17:30:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5284AC433D6;
        Wed, 14 Sep 2022 17:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663176642;
        bh=1Cn21YbgUaY5448BLQuB+OlI91APR7U92NDD7vA3aJs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lYarfYYaPTrwbukvY4Ca+0Sf88ZbugLJuatGUj3M1vhpZ4P+xsdHYg6GToqtKp4CT
         8D/nFrLg/3STk3N+t3xE6fQ/k9yg26fS4KnTIF7BdeRQJ/2GtoKVvvZyGcOrld/LaB
         XsLIuPaUWL+FncwzSe/X/Ich4QbuLQXCSTlG7CyCON709AGM5UXGrUUQV4zFkEO5IX
         wlWigj6TmeJv/DdhBvgoxmdMkFFb5g2zQeoeLVdDrrf3uoR1HF76LA24bPFq2iIyw/
         Ge5VYZEwkauLgAcbNwtaCKhb8IfuTDuLMomzWu68wmvnEIUJK/Dgybsvj+H6NQ6iOL
         lj5lpcJTAcIPA==
Date:   Wed, 14 Sep 2022 10:30:41 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Donald Douwsma <ddouwsma@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsrestore: fix inventory unpacking
Message-ID: <YyIPwdERzZsaGDO1@magnolia>
References: <20220914034708.1605288-1-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220914034708.1605288-1-ddouwsma@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 14, 2022 at 01:47:08PM +1000, Donald Douwsma wrote:
> When xfsrestore reads the inventory from tape media it fails to convert
> media file records from bigendin. If the xfsdump inventory is not

bigendian?

> available xfsrestore will write this invalid record to the on-line
> inventory.
> 
> [root@rhel8 xfsdump-dev]# xfsdump -I
> file system 0:
>         fs id:          26dd5aa0-b901-4cf5-9b68-0c5753cb3ab8
>         session 0:
>                 mount point:    rhel8:/boot
>                 device:         rhel8:/dev/sda1
>                 time:           Fri Sep  9 14:29:03 2022
>                 session label:  ""
>                 session id:     05f11cfe-2301-4000-89f2-2025091da413
>                 level:          0
>                 resumed:        NO
>                 subtree:        NO
>                 streams:        1
>                 stream 0:
>                         pathname:       /dev/nst0
>                         start:          ino 133 offset 0
>                         end:            ino 1572997 offset 0
>                         interrupted:    YES
>                         media files:    1
>                         media file 0:
>                                 mfile index:    33554432
>                                 mfile type:     data
>                                 mfile size:     211187836911616
>                                 mfile start:    ino 9583660007044415488 offset 0
>                                 mfile end:      ino 9583686395323482112 offset 0
>                                 media label:    ""
>                                 media id:       4bf9ed40-6377-4926-be62-1bf7b59b1619
> xfsdump: Dump Status: SUCCESS
> 
> The invalid start and end inode information cause xfsrestore to consider

What's invalid here?  I gather it's the transition from 1572997 to
9583660007044415488?

> that non-directory files do not reside in the current media and will
> fail to restore them.
> 
> The behaviour of an initial restore may succeed if the position of the
> tape is such that the data file is encountered before the inventory
> file. Subsequent restores will use the invalid on-line inventory and
> fail to restore files.
> 
> Fix this by correctly unpacking the inventory data.

Which chunk makes this happen?  I'm afraid I'm not that familiar with
xfsrestore, so I can't really spot where the endian conversion is made.
Is it that chunk where you remove the "#ifdef INVT_DELETION" (which
AFAICT is never defined anywhere) and make it so that
xlate_invt_mediafile is always called?

> Also handle multiple
> streams and untangle the logic where stobj_unpack_sessinfo is called.

This sounds like multiple patches to me -- one to fix the missing
endianness conversion, another to handle the multiple streams, and a
third to do the cleanup in pi_addfile.

> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
> ---
>  inventory/inv_stobj.c | 38 ++++++++++++++------------------------
>  restore/content.c     | 13 +++++--------
>  2 files changed, 19 insertions(+), 32 deletions(-)
> 
> diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
> index c20e71c..efaf46d 100644
> --- a/inventory/inv_stobj.c
> +++ b/inventory/inv_stobj.c
> @@ -1008,7 +1008,7 @@ stobj_unpack_sessinfo(
>          size_t             bufsz,
>  	invt_sessinfo_t   *s)
>  {
> -	uint 		 i;
> +	uint 		 i, j;
>  	char	         *tmpbuf;
>  	char 		 *p = (char *)bufp;
>  
> @@ -1080,35 +1080,25 @@ stobj_unpack_sessinfo(
>  	p += sizeof(invt_session_t);
>  
>  	/* the array of all the streams belonging to this session */
> -	xlate_invt_stream((invt_stream_t *)p, (invt_stream_t *)tmpbuf, 1);
> -	bcopy(tmpbuf, p, sizeof(invt_stream_t));
>  	s->strms = (invt_stream_t *)p;
> -	p += s->ses->s_cur_nstreams * sizeof(invt_stream_t);
> +        for (i = 0; i < s->ses->s_cur_nstreams; i++) {

Indentation damage here.

> +                xlate_invt_stream((invt_stream_t *)p, 
> +				  (invt_stream_t *)tmpbuf, 1);
> +                bcopy(tmpbuf, p, sizeof(invt_stream_t));
> +                p += sizeof(invt_stream_t);
> +        }
>  
>  	/* all the media files */
>  	s->mfiles = (invt_mediafile_t *)p;
> -
> -#ifdef INVT_DELETION
> -	{
> -		int tmpfd = open("moids", O_RDWR | O_CREAT, S_IRUSR|S_IWUSR);
> -		uint j;
> -		invt_mediafile_t *mmf = s->mfiles;
> -		for (i=0; i< s->ses->s_cur_nstreams; i++) {
> -			for (j=0; j< s->strms[i].st_nmediafiles;
> -			     j++, mmf++)
> -				xlate_invt_mediafile((invt_mediafile_t *)mmf, (invt_mediafile_t *)tmpbuf, 1);
> -				bcopy(tmpbuf, mmf, sizeof(invt_mediafile_t));
> -				put_invtrecord(tmpfd, &mmf->mf_moid,
> -					 sizeof(uuid_t), 0, SEEK_END, 0);
> +	for (i=0; i< s->ses->s_cur_nstreams; i++) {
> +		for (j=0; j < s->strms[i].st_nmediafiles; j++) {
> +			xlate_invt_mediafile((invt_mediafile_t *)p, 
> +					     (invt_mediafile_t *)tmpbuf, 1);
> +			bcopy(tmpbuf, p, sizeof(invt_mediafile_t));
> +			p +=  sizeof(invt_mediafile_t);
>  		}
> -		close(tmpfd);
>  	}
> -#endif
> -	for (i = 0; i < s->ses->s_cur_nstreams; i++) {
> -		p += (size_t) (s->strms[i].st_nmediafiles)
> -			* sizeof(invt_mediafile_t);
> -	}
> -
> +	
>  	/* sanity check the size of the buffer given to us vs. the size it
>  	   should be */
>  	if ((size_t) (p - (char *) bufp) != bufsz) {
> diff --git a/restore/content.c b/restore/content.c
> index b3999f9..bbced2d 100644
> --- a/restore/content.c
> +++ b/restore/content.c
> @@ -5463,17 +5463,14 @@ pi_addfile(Media_t *Mediap,
>  			 * desc.
>  			 */
>  			sessp = 0;
> -			if (!buflen) {
> -				ok = BOOL_FALSE;
> -			} else {
> -			    /* extract the session information from the buffer */
> -			    if (stobj_unpack_sessinfo(bufp, buflen, &sessinfo)<0) {
> -				ok = BOOL_FALSE;
> -			    } else {
> +			ok = BOOL_FALSE;
> +			/* extract the session information from the buffer */
> +			if (buflen && 

There's a lot of trailing whitespace added by this patch.

Also, what is the purpose of this change?  Is there something
significant about calling stobj_convert_sessinfo even if
stobj_unpack_sessinfo returns a negative number?

*OH* that unpack function returns "bool_t", which means that we only
care about zero and nonzero.  So I think this is just a cleanup?

--D

> +			    stobj_unpack_sessinfo(bufp, buflen, &sessinfo)) {
>  				stobj_convert_sessinfo(&sessp, &sessinfo);
>  				ok = BOOL_TRUE;
> -			    }
>  			}
> +
>  			if (!ok || !sessp) {
>  				mlog(MLOG_DEBUG | MLOG_WARNING | MLOG_MEDIA, _(
>  				      "on-media session "
> -- 
> 2.31.1
> 
