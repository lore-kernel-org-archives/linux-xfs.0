Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 811F1C32771
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Sep 2022 15:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234053AbiI1PMP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Sep 2022 11:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234642AbiI1PMJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Sep 2022 11:12:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9BDA99FB
        for <linux-xfs@vger.kernel.org>; Wed, 28 Sep 2022 08:12:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71B3AB81FA2
        for <linux-xfs@vger.kernel.org>; Wed, 28 Sep 2022 15:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30935C433D6;
        Wed, 28 Sep 2022 15:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664377924;
        bh=h0JmURxbGmsMguuC52Zro5MoPiMyeCDxG0+NQIWiEmE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aMaO1TLJRs4eTF9O7h415nxO5QpL0Ba7B5Zu9xY7XP3hMttU0j3GS6OEoIH9uWP3Q
         NjZiKh7JVrMmlRrIKD36UrwGQVAB6XK7i9efRG/QobezQdPEAITDi/E0S3N1JhCUE2
         0PMIESIzDswhgi92YYY0ZtEjjmo+o9qc6DucfMH69Tesr6+3p7uS6Hj03EeJ0W1une
         tFdDw8Fxzs0LjPjrKpQjlgFYUXeZ+H/gmgQzIrvuvagEX2tJ+LG7evl9+GXj5GXRa2
         sL1vd5hQPpPUfxzemkMMlmdcrYRgDRCNzVcFhWyKcUC2bszGn9GJUNWJx8L487jeQn
         JBOCiolgCYBfA==
Date:   Wed, 28 Sep 2022 08:12:03 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Donald Douwsma <ddouwsma@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfsrestore: fix inventory unpacking
Message-ID: <YzRkQ8zxKWPiyGNa@magnolia>
References: <20220928055307.79341-1-ddouwsma@redhat.com>
 <20220928055307.79341-2-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928055307.79341-2-ddouwsma@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 28, 2022 at 03:53:05PM +1000, Donald Douwsma wrote:
> When xfsrestore reads the inventory from tape media it fails to convert
> media file records from bigendian. If the xfsdump inventory is not
> available xfsrestore will write this invalid record to the on-line
> inventory.
> 
> [root@rhel8 ~]# xfsdump -L Test1 -M "" -f /dev/st0 /boot > /dev/null
> [root@rhel8 ~]# xfsdump -L Test2 -M "" -f /dev/st0 /boot > /dev/null
> [root@rhel8 ~]# rm -rf /var/lib/xfsdump/inventory/
> [root@rhel8 ~]# mt -f /dev/nst0 asf 2
> [root@rhel8 ~]# xfsrestore -f /dev/nst0 -L Test2 /tmp/test2
> xfsrestore: using scsi tape (drive_scsitape) strategy
> xfsrestore: version 3.1.8 (dump format 3.0) - type ^C for status and control
> xfsrestore: searching media for dump
> xfsrestore: preparing drive
> xfsrestore: examining media file 3
> xfsrestore: found dump matching specified label:
> xfsrestore: hostname: rhel8
> xfsrestore: mount point: /boot
> xfsrestore: volume: /dev/sda1
> xfsrestore: session time: Tue Sep 27 16:05:28 2022
> xfsrestore: level: 0
> xfsrestore: session label: "Test2"
> xfsrestore: media label: ""
> xfsrestore: file system id: 26dd5aa0-b901-4cf5-9b68-0c5753cb3ab8
> xfsrestore: session id: 62402423-7ae0-49ed-8ecb-9e5bc7642b91
> xfsrestore: media id: 47ba45ca-3417-4006-ab10-3dc6419b83e2
> xfsrestore: incorporating on-media session inventory into online inventory
> xfsrestore: /var/lib/xfsdump/inventory created
> xfsrestore: using on-media session inventory
> xfsrestore: searching media for directory dump
> xfsrestore: rewinding
> xfsrestore: examining media file 0
> xfsrestore: inventory session uuid (62402423-7ae0-49ed-8ecb-9e5bc7642b91) does not match the media header's session uuid (1771d9e8-a1ba-4e87-a61e-f6be97e41b45)
> xfsrestore: examining media file 1
> xfsrestore: inventory session uuid (62402423-7ae0-49ed-8ecb-9e5bc7642b91) does not match the media header's session uuid (1771d9e8-a1ba-4e87-a61e-f6be97e41b45)
> xfsrestore: examining media file 2
> xfsrestore: reading directories
> xfsrestore: 9 directories and 320 entries processed
> xfsrestore: directory post-processing
> xfsrestore: restore complete: 0 seconds elapsed
> xfsrestore: Restore Summary:
> xfsrestore:   stream 0 /dev/nst0 OK (success)
> xfsrestore: Restore Status: SUCCESS
> [root@rhel8 ~]# xfsdump -I
> file system 0:
>         fs id:          26dd5aa0-b901-4cf5-9b68-0c5753cb3ab8
>         session 0:
>                 mount point:    rhel8:/boot
>                 device:         rhel8:/dev/sda1
>                 time:           Tue Sep 27 16:05:28 2022
>                 session label:  "Test2"
>                 session id:     62402423-7ae0-49ed-8ecb-9e5bc7642b91
>                 level:          0
>                 resumed:        NO
>                 subtree:        NO
>                 streams:        1
>                 stream 0:
>                         pathname:       /dev/st0
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
>                                 media id:       47ba45ca-3417-4006-ab10-3dc6419b83e2
> xfsdump: Dump Status: SUCCESS
> [root@rhel8 ~]#
> [root@rhel8 ~]# ls /tmp/test2
> efi  grub2  loader
> 
> The invalid start and end inode information cause xfsrestore to consider
> that non-directory files do not reside in the current media and will
> fail to restore them.
> 
> The behaviour of an initial restore may succeed if the position of the
> tape is such that the data file is encountered before the inventory
> file, or if there is only one dump session on tape, xfsrestore is
> somewhat inconsistent in this regard. Subsequent restores will use the
> invalid on-line inventory and fail to restore files.
> 
> Fix this by correctly unpacking the inventory data.
> 
> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
> ---
>  inventory/inv_stobj.c | 27 +++++++--------------------
>  1 file changed, 7 insertions(+), 20 deletions(-)
> 
> diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
> index c20e71c..5075ee4 100644
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
> @@ -1087,26 +1087,13 @@ stobj_unpack_sessinfo(
>  
>  	/* all the media files */
>  	s->mfiles = (invt_mediafile_t *)p;
> -
> -#ifdef INVT_DELETION
> -	{
> -		int tmpfd = open("moids", O_RDWR | O_CREAT, S_IRUSR|S_IWUSR);

I wonder, do you need to preserve this behavior (writing the inventory
records to "moids")?  testmain.c seems to want to read the file, but
OTOH that looks like some sort of test program; arbitrarily overwriting
a file in $PWD seems ... risky?  And I guess this chunk has never run.

Also testmain.c has such gems as:

"/dana/hates/me"

"/the/krays"

and mentions that -I supersedes most of its functionality.  So maybe
that's why you deleted moids?  Aside from the name just sounding gross?

:)

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

Nit: trailing whitespace                                      here ^

If the the answer to the above question is "Yeah, nobody wants the moids
file" then:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +					     (invt_mediafile_t *)tmpbuf, 1);
> +			bcopy(tmpbuf, p, sizeof(invt_mediafile_t));
> +			p +=  sizeof(invt_mediafile_t);
>  		}
> -		close(tmpfd);
> -	}
> -#endif
> -	for (i = 0; i < s->ses->s_cur_nstreams; i++) {
> -		p += (size_t) (s->strms[i].st_nmediafiles)
> -			* sizeof(invt_mediafile_t);
>  	}
>  
>  	/* sanity check the size of the buffer given to us vs. the size it
> -- 
> 2.31.1
> 
