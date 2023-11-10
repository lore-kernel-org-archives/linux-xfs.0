Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A26EBC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Nov 2023 18:10:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235744AbjKJSKT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Nov 2023 13:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344411AbjKJSIS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Nov 2023 13:08:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6703638227
        for <linux-xfs@vger.kernel.org>; Fri, 10 Nov 2023 05:57:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699624622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FkBe2/uLSA+w6T92ie2OnmQtjDN0moqsVzizFE4ajKg=;
        b=VVvtQ6mQhFLBOqDtiMcnQ4cSC6pVk8PKUvG7kzQ1eTkxP3psQoqoaFHJFE1SW6gXTS6HiH
        +b63cStFy2oa26kO1UoGZU082mjsaDs4KMdBJCFCpm85edt3QZxhVXx8S06USWnmOqYcdC
        8vqtEo9dIO1nZPlToXJy1m4S4L40DAQ=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-541-ANxkVnWeP5m1YhoHGpnANw-1; Fri, 10 Nov 2023 08:57:01 -0500
X-MC-Unique: ANxkVnWeP5m1YhoHGpnANw-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1cc1ddb34ccso22069005ad.1
        for <linux-xfs@vger.kernel.org>; Fri, 10 Nov 2023 05:57:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699624620; x=1700229420;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FkBe2/uLSA+w6T92ie2OnmQtjDN0moqsVzizFE4ajKg=;
        b=GZhy6wKEvx1HRBiIdBGOGwK9jm7lwwWw15jXcTpL32YQ6ly7JNgxEqAT1UL0qf0U5c
         8ePuvTs98WsF87iu3jJpXg0WSGU9VWrm4dPJueZzcNOdf2K+HuHSsBitOP9adijTeu/F
         MCuBULt1p5ystcIPqa1/FhWj9iAqRzXm75cthZexnmUZFTjdpPy36uWvpX2f7elEiw1i
         K6/g788pfW1+y37hehZ8PgwvJQ+pyo4MmABTzhn7VzNEI8+sImYTUgKgolYQ4W1PIId7
         vbR21EW58OVw/BhNjTNgY15fWfAmdPWrbykKf0Ln6ZfatultgTH6li78FUXFwzlgrMPY
         hdCQ==
X-Gm-Message-State: AOJu0YzOGpnQbfuP1NRegLBdr9aHXWXcfXpGjgNzme6sfZ7KiSWilmwD
        z7UxzcJyWRHCWaX3v+fYukYCsapt1E+wysFmFllC7Yb5Q0jXTlyOt8jw1A0KVGZIcMBSdIijS8U
        g01tir00txVVGS5qWQVNRFURZqisoj+o=
X-Received: by 2002:a17:902:a9ca:b0:1cc:3fce:8aa8 with SMTP id b10-20020a170902a9ca00b001cc3fce8aa8mr7213831plr.6.1699624619773;
        Fri, 10 Nov 2023 05:56:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHvnibCFGLD2LcrWpIyyqBVGGUrCAA1OS5JcLToi16rJYWpgNia3pmRKEPmzhNrQrfoynXqrQ==
X-Received: by 2002:a17:902:a9ca:b0:1cc:3fce:8aa8 with SMTP id b10-20020a170902a9ca00b001cc3fce8aa8mr7213816plr.6.1699624619397;
        Fri, 10 Nov 2023 05:56:59 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id f18-20020a170902ce9200b001bbd1562e75sm5401702plg.55.2023.11.10.05.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Nov 2023 05:56:59 -0800 (PST)
Date:   Fri, 10 Nov 2023 21:56:54 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <carlos@maiolino.me>
Subject: Re: [Bug report][fstests generic/047] Internal error !(flags &
 XFS_DABUF_MAP_HOLE_OK) at line 2572 of file fs/xfs/libxfs/xfs_da_btree.c.
 Caller xfs_dabuf_map.constprop.0+0x26c/0x368 [xfs]
Message-ID: <20231110135654.26yq5s5ttp7dautk@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20231107080522.5lowalssbmi6lus3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUnxswEfoeZQhw5P@dread.disaster.area>
 <20231107151314.angahkixgxsjwbot@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUstA+1+IvHJ87eP@dread.disaster.area>
 <CAN=2_H+CdEK_rEUmYbmkCjSRqhX2cwi5yRHQcKAmKDPF16vqOw@mail.gmail.com>
 <ZUx429/S9H07xLrA@dread.disaster.area>
 <20231109140929.jq7bpnuustsup3xf@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZU1nltE2X6qLJ8EL@dread.disaster.area>
 <20231110013651.fw3j6khkdtjfe2bj@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZU2PhTKqwNEbjK13@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZU2PhTKqwNEbjK13@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 10, 2023 at 01:03:49PM +1100, Dave Chinner wrote:
> On Fri, Nov 10, 2023 at 09:36:51AM +0800, Zorro Lang wrote:
> > The g/047 still fails with this 2nd patch. So I did below steps [1],
> > and get the trace output as [2], those dump_inodes() messages you
> > added have been printed, please check.
> 
> And that points me at the bug.
> 
> dump_inodes: disk ino 0x83: init nblocks 0x8 nextents 0x0/0x0 anextents 0x0/0x0 v3_pad 0x0 nrext64_pad 0x0 di_flags2 0x18
> dump_inodes: log ino 0x83: init nblocks 0x8 nextents 0x0/0x1 anextents 0x0/0x0 v3_pad 0x1 nrext64_pad 0x0 di_flags2 0x18 big
>                                                      ^^^^^^^
> The initial log inode is correct.
> 
> dump_inodes: disk ino 0x83: pre nblocks 0x8 nextents 0x0/0x0 anextents 0x0/0x0 v3_pad 0x0 nrext64_pad 0x0 di_flags2 0x18
> dump_inodes: log ino 0x83: pre nblocks 0x8 nextents 0x0/0x0 anextents 0x0/0x0 v3_pad 0x0 nrext64_pad 0x0 di_flags2 0x18 big
>                                                     ^^^^^^^
> 
> .... but on the second sample, it's been modified and the extent
> count has been zeroed? Huh, that is unexpected - what did that?
> 
> Oh.
> 
> Can you test the patch below and see if it fixes the issue? Keep
> the first verifier patch I sent, then apply the patch below. You can
> drop the debug traceprintk patch - the patch below should fix it.

Great, Dave! It works, below testing [1] passed on my s390x now. Maybe I should
write Tested-by, but as a reporter, so Reported-by might be proper, so...

Reported-by: Zorro Lang <zlang@redhat.com>

Anyway, I'm doing a full round fstests "auto" group testing on s390x with this
patch, to check if there're more issue on big endian machine. If you have
any specific concern (testing condition) hope to test, please tell me, I'll
enhance the testing of that part.

Thanks,
Zorro

[1]
# ./check generic/047 generic/039 generic/065
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/s390x ibm-z-507 6.6.0+ #1 SMP Wed Nov  8 12:51:20 EST 2023
MKFS_OPTIONS  -- -f -m crc=1,finobt=1,rmapbt=0,reflink=1,bigtime=1,inobtcount=1 /dev/loop1
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/loop1 /mnt/fstests/SCRATCH_DIR

generic/039        0s
generic/047 10s ...  10s
generic/065        1s
Ran: generic/039 generic/047 generic/065
Passed all 3 tests

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> xfs: recovery should not clear di_flushiter unconditionally
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because on v3 inodes, di_flushiter doesn't exist. It overlaps with
> zero padding in the inode, except when NREXT64=1 configurations are
> in use and the zero padding is no longer padding but holds the 64
> bit extent counter.
> 
> This manifests obviously on big endian platforms (e.g. s390) because
> the log dinode is in host order and the overlap is the LSBs of the
> extent count field. It is not noticed on little endian machines
> because the overlap is at the MSB end of the extent count field and
> we need to get more than 2^^48 extents in the inode before it
> manifests. i.e. the heat death of the universe will occur before we
> see the problem in little endian machines.
> 
> This is a zero-day issue for NREXT64=1 configuraitons on big endian
> machines. Fix it by only clearing di_flushiter on v2 inodes during
> recovery.
> 
> Fixes: 9b7d16e34bbe ("xfs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers")
> cc: stable@kernel.org # 5.19+
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_inode_item_recover.c | 32 +++++++++++++++++---------------
>  1 file changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> index f4c31c2b60d5..dbdab4ce7c44 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -371,24 +371,26 @@ xlog_recover_inode_commit_pass2(
>  	 * superblock flag to determine whether we need to look at di_flushiter
>  	 * to skip replay when the on disk inode is newer than the log one
>  	 */
> -	if (!xfs_has_v3inodes(mp) &&
> -	    ldip->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
> -		/*
> -		 * Deal with the wrap case, DI_MAX_FLUSH is less
> -		 * than smaller numbers
> -		 */
> -		if (be16_to_cpu(dip->di_flushiter) == DI_MAX_FLUSH &&
> -		    ldip->di_flushiter < (DI_MAX_FLUSH >> 1)) {
> -			/* do nothing */
> -		} else {
> -			trace_xfs_log_recover_inode_skip(log, in_f);
> -			error = 0;
> -			goto out_release;
> +	if (!xfs_has_v3inodes(mp)) {
> +		if (ldip->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
> +			/*
> +			 * Deal with the wrap case, DI_MAX_FLUSH is less
> +			 * than smaller numbers
> +			 */
> +			if (be16_to_cpu(dip->di_flushiter) == DI_MAX_FLUSH &&
> +			    ldip->di_flushiter < (DI_MAX_FLUSH >> 1)) {
> +				/* do nothing */
> +			} else {
> +				trace_xfs_log_recover_inode_skip(log, in_f);
> +				error = 0;
> +				goto out_release;
> +			}
>  		}
> +
> +		/* Take the opportunity to reset the flush iteration count */
> +		ldip->di_flushiter = 0;
>  	}
>  
> -	/* Take the opportunity to reset the flush iteration count */
> -	ldip->di_flushiter = 0;
>  
>  	if (unlikely(S_ISREG(ldip->di_mode))) {
>  		if ((ldip->di_format != XFS_DINODE_FMT_EXTENTS) &&
> 

