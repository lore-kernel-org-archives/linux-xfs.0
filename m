Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB48C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Oct 2022 19:06:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiJMTGA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Oct 2022 15:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiJMTF6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2022 15:05:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024FE152022
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 12:05:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1F66B81FAE
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 19:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7645EC433D6;
        Thu, 13 Oct 2022 19:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665687952;
        bh=iqnnuxLV7b9ohYmaUk7ycf23KrUj9T0YGFssqoIXQpI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tpw7FCOdH8f4T+pJDmylR8cYDIIzlMkIj6T10UsUbhbbiDQ3Ob7+uBBxVCTQxNHIl
         FtNcs+oJWAttreQBcDOD7HANaJHBM0Zu0TFV6dAT46eotWmhxl/bG8TzV4EW8Z+psl
         St8x1ZmEiBlpDStdTJFeWuuwcUejJxDH+p8M0l7qG0dSVglYkpvZTOtPn2J0QX0NQ1
         wRs7hhLTZWNoXgYi+eukdaR2HizUwYDFEBk1MLGgGaRytON1NoQ92k5xuIF28TzSlP
         a+CalV+/M4K2Fw0OvEMKUGhcI/pI4TR+OYMV9gcsZt6QItazKTKNBrxAGTbitwLMd+
         s/38WTsSVUAEw==
Date:   Thu, 13 Oct 2022 12:05:51 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Donald Douwsma <ddouwsma@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfsrestore: fix on-media inventory stream unpacking
Message-ID: <Y0hhj+FFF4TYA6N6@magnolia>
References: <20221013031518.1815861-1-ddouwsma@redhat.com>
 <20221013031518.1815861-3-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013031518.1815861-3-ddouwsma@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 13, 2022 at 02:15:16PM +1100, Donald Douwsma wrote:
> xfsdump can create multiple streams, when restoring the online inventory
> with multiple streams we fail to process these and assert when the
> inventory buffer is not fully decoded.
> 
> [root@rhel8 ~]# xfsdump -L "Test1" -f /dev/nst0 -M tape1 -f /dev/nst1 -M tape2 /boot
> xfsdump: using scsi tape (drive_scsitape) strategy
> xfsdump: using scsi tape (drive_scsitape) strategy
> xfsdump: version 3.1.8 (dump format 3.0) - type ^C for status and control
> xfsdump: level 0 dump of rhel8:/boot
> xfsdump: dump date: Thu Oct  6 13:50:45 2022
> xfsdump: session id: aa25fa48-4493-45c7-9027-61e53e486445
> xfsdump: session label: "Test1"
> xfsdump: ino map phase 1: constructing initial dump list
> xfsdump: ino map phase 2: skipping (no pruning necessary)
> xfsdump: ino map phase 3: identifying stream starting points
> xfsdump: stream 0: ino 133 offset 0 to ino 28839 offset 0
> xfsdump: stream 1: ino 28839 offset 0 to end
> xfsdump: ino map construction complete
> xfsdump: estimated dump size: 328720704 bytes
> xfsdump: estimated dump size per stream: 164375728 bytes
> xfsdump: /var/lib/xfsdump/inventory created
> xfsdump: drive 0: preparing drive
> xfsdump: drive 1: preparing drive
> xfsdump: drive 1: creating dump session media file 0 (media 0, file 0)
> xfsdump: drive 1: dumping ino map
> xfsdump: drive 1: dumping non-directory files
> xfsdump: drive 0: creating dump session media file 0 (media 0, file 0)
> xfsdump: drive 0: dumping ino map
> xfsdump: drive 0: dumping directories
> xfsdump: drive 0: dumping non-directory files
> xfsdump: drive 1: ending media file
> xfsdump: drive 1: media file size 166723584 bytes
> xfsdump: drive 1: waiting for synchronized session inventory dump
> xfsdump: drive 0: ending media file
> xfsdump: drive 0: media file size 165675008 bytes
> xfsdump: drive 0: waiting for synchronized session inventory dump
> xfsdump: drive 0: dumping session inventory
> xfsdump: drive 0: beginning inventory media file
> xfsdump: drive 0: media file 1 (media 0, file 1)
> xfsdump: drive 0: ending inventory media file
> xfsdump: drive 0: inventory media file size 2097152 bytes
> xfsdump: drive 0: writing stream terminator
> xfsdump: drive 0: beginning media stream terminator
> xfsdump: drive 0: media file 2 (media 0, file 2)
> xfsdump: drive 0: ending media stream terminator
> xfsdump: drive 0: media stream terminator size 1048576 bytes
> xfsdump: drive 1: dumping session inventory
> xfsdump: drive 1: beginning inventory media file
> xfsdump: drive 1: media file 1 (media 0, file 1)
> xfsdump: drive 1: ending inventory media file
> xfsdump: drive 1: inventory media file size 2097152 bytes
> xfsdump: drive 1: writing stream terminator
> xfsdump: drive 1: beginning media stream terminator
> xfsdump: drive 1: media file 2 (media 0, file 2)
> xfsdump: drive 1: ending media stream terminator
> xfsdump: drive 1: media stream terminator size 1048576 bytes
> xfsdump: dump size (non-dir files) : 328189016 bytes
> xfsdump: dump complete: 4 seconds elapsed
> xfsdump: Dump Summary:
> xfsdump:   stream 0 /dev/nst0 OK (success)
> xfsdump:   stream 1 /dev/nst1 OK (success)
> xfsdump: Dump Status: SUCCESS
> [root@rhel8 ~]# xfsdump -I
> file system 0:
> 	fs id:		26dd5aa0-b901-4cf5-9b68-0c5753cb3ab8
> 	session 0:
> 		mount point:	rhel8:/boot
> 		device:		rhel8:/dev/sda1
> 		time:		Thu Oct  6 13:50:45 2022
> 		session label:	"Test1"
> 		session id:	aa25fa48-4493-45c7-9027-61e53e486445
> 		level:		0
> 		resumed:	NO
> 		subtree:	NO
> 		streams:	2
> 		stream 0:
> 			pathname:	/dev/nst0
> 			start:		ino 133 offset 0
> 			end:		ino 28839 offset 0
> 			interrupted:	NO
> 			media files:	2
> 			media file 0:
> 				mfile index:	0
> 				mfile type:	data
> 				mfile size:	165675008
> 				mfile start:	ino 133 offset 0
> 				mfile end:	ino 28839 offset 0
> 				media label:	"tape1"
> 				media id:	adb31f2a-f026-4597-a20a-326f28ecbaf1
> 			media file 1:
> 				mfile index:	1
> 				mfile type:	inventory
> 				mfile size:	2097152
> 				media label:	"tape1"
> 				media id:	adb31f2a-f026-4597-a20a-326f28ecbaf1
> 		stream 1:
> 			pathname:	/dev/nst1
> 			start:		ino 28839 offset 0
> 			end:		ino 1572997 offset 0
> 			interrupted:	NO
> 			media files:	2
> 			media file 0:
> 				mfile index:	0
> 				mfile type:	data
> 				mfile size:	166723584
> 				mfile start:	ino 28839 offset 0
> 				mfile end:	ino 1572997 offset 0
> 				media label:	"tape2"
> 				media id:	22224f02-b6c7-47d5-ad61-a61ba071c8a8
> 			media file 1:
> 				mfile index:	1
> 				mfile type:	inventory
> 				mfile size:	2097152
> 				media label:	"tape2"
> 				media id:	22224f02-b6c7-47d5-ad61-a61ba071c8a8
> xfsdump: Dump Status: SUCCESS
> [root@rhel8 ~]# mv /var/lib/xfsdump/inventory /var/lib/xfsdump/inventory_two_sessions
> [root@rhel8 ~]# xfsdump -I
> xfsdump: Dump Status: SUCCESS
> 
> [root@rhel8 ~]# xfsrestore -L Test1 -f /dev/nst0 /tmp/test1/
> xfsrestore: using scsi tape (drive_scsitape) strategy
> xfsrestore: version 3.1.8 (dump format 3.0) - type ^C for status and control
> xfsrestore: searching media for dump
> xfsrestore: preparing drive
> xfsrestore: examining media file 2
> xfsrestore: found dump matching specified label:
> xfsrestore: hostname: rhel8
> xfsrestore: mount point: /boot
> xfsrestore: volume: /dev/sda1
> xfsrestore: session time: Thu Oct  6 13:50:45 2022
> xfsrestore: level: 0
> xfsrestore: session label: "Test1"
> xfsrestore: media label: "tape1"
> xfsrestore: file system id: 26dd5aa0-b901-4cf5-9b68-0c5753cb3ab8
> xfsrestore: session id: aa25fa48-4493-45c7-9027-61e53e486445
> xfsrestore: media id: adb31f2a-f026-4597-a20a-326f28ecbaf1
> xfsrestore: searching media for directory dump
> xfsrestore: rewinding
> xfsrestore: examining media file 0
> xfsrestore: reading directories
> xfsrestore: 9 directories and 320 entries processed
> xfsrestore: directory post-processing
> xfsrestore: restoring non-directory files
> xfsrestore: examining media file 1
> xfsrestore: inv_stobj.c:1119: stobj_unpack_sessinfo: Assertion `(size_t) ( p - (char *) bufp ) == bufsz' failed.
> Aborted (core dumped)
> 
> Make sure we unpack multiple streams when restoring the online
> inventory from media.
> 
> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>

Much better now, though I hope there's an fstest coming to make sure
that multistream restore/dump work properly.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  inventory/inv_stobj.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
> index b461666..025d431 100644
> --- a/inventory/inv_stobj.c
> +++ b/inventory/inv_stobj.c
> @@ -1065,25 +1065,26 @@ stobj_unpack_sessinfo(
>  		return BOOL_FALSE;
>  	}
>  
> +	/* get the seshdr and then, the remainder of the session */
>  	xlate_invt_seshdr((invt_seshdr_t *)p, (invt_seshdr_t *)tmpbuf, 1);
>  	bcopy(tmpbuf, p, sizeof(invt_seshdr_t));
> -
> -	/* get the seshdr and then, the remainder of the session */
>  	s->seshdr = (invt_seshdr_t *)p;
>  	s->seshdr->sh_sess_off = -1;
>  	p += sizeof(invt_seshdr_t);
>  
> -
>  	xlate_invt_session((invt_session_t *)p, (invt_session_t *)tmpbuf, 1);
>  	bcopy (tmpbuf, p, sizeof(invt_session_t));
>  	s->ses = (invt_session_t *)p;
>  	p += sizeof(invt_session_t);
>  
>  	/* the array of all the streams belonging to this session */
> -	xlate_invt_stream((invt_stream_t *)p, (invt_stream_t *)tmpbuf, 1);
> -	bcopy(tmpbuf, p, sizeof(invt_stream_t));
>  	s->strms = (invt_stream_t *)p;
> -	p += s->ses->s_cur_nstreams * sizeof(invt_stream_t);
> +	for (i = 0; i < s->ses->s_cur_nstreams; i++) {
> +		xlate_invt_stream((invt_stream_t *)p,
> +				  (invt_stream_t *)tmpbuf, 1);
> +		bcopy(tmpbuf, p, sizeof(invt_stream_t));
> +		p += sizeof(invt_stream_t);
> +	}
>  
>  	/* all the media files */
>  	s->mfiles = (invt_mediafile_t *)p;
> -- 
> 2.31.1
> 
