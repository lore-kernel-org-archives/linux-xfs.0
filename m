Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6EF8E776F0
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Oct 2023 03:32:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbjJCDcZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Oct 2023 23:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjJCDcX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Oct 2023 23:32:23 -0400
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1314C9D
        for <linux-xfs@vger.kernel.org>; Mon,  2 Oct 2023 20:32:20 -0700 (PDT)
Received: by mail-oo1-xc2e.google.com with SMTP id 006d021491bc7-57bbb38d5d4so247656eaf.2
        for <linux-xfs@vger.kernel.org>; Mon, 02 Oct 2023 20:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1696303939; x=1696908739; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RU41F7Q6OV/0/KdhPXX+Zr4mK7H3+EqyDj/vuFMgUwY=;
        b=XT6E4nEe2lpvHtnwQcZENIeLzw+dHyxIav2hEzJi3HEMLxhzQGbUCsiJuuY6Ptohg1
         EpAHAoMJiNr124BR0eGbirI9jDEqPbKbLHndbftA1Uo4N+3pi9Yz7TC9iJMDkCTk7TfD
         tsWNkVvgvMJED2SSeWPy6qVPrRd7sLmeS+IlIp3Mc4bAcgminkq8abwG5snQNSHmUR+z
         vAFwbHtJRYixbYr+eDZ75i3r8ptzfRpm5lxpwcHryyjgmNpseu928GP7KUNaHjavU+Sk
         MTTvTGitt+lHDUZbJ/TMqf5ge3n57gA/I8fZ1TNkPBqfpJrODIXHoNyJenQYdHQ7859H
         z1UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696303939; x=1696908739;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RU41F7Q6OV/0/KdhPXX+Zr4mK7H3+EqyDj/vuFMgUwY=;
        b=MuyrjcG1WG9YfEuC0k25rRSNbCnpycHTAJHZZ51lDmma9k7txTVy4gNgJaqPkvCw8C
         hE9qUViDNcCLNbfwcUkT6H3or7N2TXwxY7Ixjm0MrfV9jMS1QqZHfGDxsbf0E1Pyp7wp
         dVJ+6lIG4rOt9acmS0CSOyragnS14FGvNiPd7SJD5RdIM7FDDzl5hbOWJGhkazvzO/6V
         zO4IQiEnrKMYyN3uG7YO6gNDGTRS79m3hgNyF5C3yNqdb214fOBkwz/xwzkkFcvSMarU
         uldegn2C/PcDHg9q0NmjZXa2HZnNdpmK/bd2S2e6m7th+0gAxrXx40dKyW/Yok3HjrCV
         xpdg==
X-Gm-Message-State: AOJu0YxfvyUruwrzBt9VtokKd3bXrW1+IWetWwzs+n6+a5PhYVzOYdvO
        NfSZv3pLgbf1ZXqBs29U8s6PJw==
X-Google-Smtp-Source: AGHT+IE+l0s5pjMPvA3XUiId2MHvVR/AZFGjyb3rFVyjmEnq89vMNSByVxUcQTQOlmK6z2/vj7dVDg==
X-Received: by 2002:a05:6358:2496:b0:134:c682:213f with SMTP id m22-20020a056358249600b00134c682213fmr13720441rwc.31.1696303939244;
        Mon, 02 Oct 2023 20:32:19 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id v22-20020aa78516000000b0068fde95aa93sm244484pfn.135.2023.10.02.20.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Oct 2023 20:32:18 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qnW8u-008jvm-0S;
        Tue, 03 Oct 2023 14:32:16 +1100
Date:   Tue, 3 Oct 2023 14:32:16 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     John Garry <john.g.garry@oracle.com>
Cc:     axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
        viro@zeniv.linux.org.uk, brauner@kernel.org,
        chandan.babu@oracle.com, dchinner@redhat.com,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
        linux-api@vger.kernel.org
Subject: Re: [PATCH 15/21] fs: xfs: Support atomic write for statx
Message-ID: <ZRuLQKKPCzyUZtC9@dread.disaster.area>
References: <20230929102726.2985188-1-john.g.garry@oracle.com>
 <20230929102726.2985188-16-john.g.garry@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230929102726.2985188-16-john.g.garry@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 29, 2023 at 10:27:20AM +0000, John Garry wrote:
> Support providing info on atomic write unit min and max for an inode.
> 
> For simplicity, currently we limit the min at the FS block size, but a
> lower limit could be supported in future.
> 
> The atomic write unit min and max is limited by the guaranteed extent
> alignment for the inode.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  fs/xfs/xfs_iops.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_iops.h |  4 ++++
>  2 files changed, 55 insertions(+)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 1c1e6171209d..5bff80748223 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -546,6 +546,46 @@ xfs_stat_blksize(
>  	return PAGE_SIZE;
>  }
>  
> +void xfs_ip_atomic_write_attr(struct xfs_inode *ip,
> +			xfs_filblks_t *unit_min_fsb,
> +			xfs_filblks_t *unit_max_fsb)

Formatting.

Also, we don't use variable name shorthand for function names -
xfs_get_atomic_write_hint(ip) to match xfs_get_extsz_hint(ip)
would be appropriate, right?



> +{
> +	xfs_extlen_t		extsz_hint = xfs_get_extsz_hint(ip);
> +	struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
> +	struct block_device	*bdev = target->bt_bdev;
> +	struct xfs_mount	*mp = ip->i_mount;
> +	xfs_filblks_t		atomic_write_unit_min,
> +				atomic_write_unit_max,
> +				align;
> +
> +	atomic_write_unit_min = XFS_B_TO_FSB(mp,
> +		queue_atomic_write_unit_min_bytes(bdev->bd_queue));
> +	atomic_write_unit_max = XFS_B_TO_FSB(mp,
> +		queue_atomic_write_unit_max_bytes(bdev->bd_queue));

These should be set in the buftarg at mount time, like we do with
sector size masks. Then we don't need to convert them to fsbs on
every single lookup.

> +	/* for RT, unset extsize gives hint of 1 */
> +	/* for !RT, unset extsize gives hint of 0 */
> +	if (extsz_hint && (XFS_IS_REALTIME_INODE(ip) ||
> +	    (ip->i_diflags2 & XFS_DIFLAG2_FORCEALIGN)))

Logic is non-obvious. The compound is (rt || force), not
(extsz && rt), so it took me a while to actually realise I read this
incorrectly.

	if (extsz_hint &&
	    (XFS_IS_REALTIME_INODE(ip) ||
	     (ip->i_diflags2 & XFS_DIFLAG2_FORCEALIGN))) {

> +		align = extsz_hint;
> +	else
> +		align = 1;

And now the logic looks wrong to me. We don't want to use extsz hint
for RT inodes if force align is not set, this will always use it
regardless of the fact it has nothing to do with force alignment.

Indeed, if XFS_DIFLAG2_FORCEALIGN is not set, then shouldn't this
always return min/max = 0 because atomic alignments are not in us on
this inode?

i.e. the first thing this code should do is:

	*unit_min_fsb = 0;
	*unit_max_fsb = 0;
	if (!(ip->i_diflags2 & XFS_DIFLAG2_FORCEALIGN))
		return;

Then we can check device support:

	if (!buftarg->bt_atomic_write_max)
		return;

Then we can check for extent size hints. If that's not set:

	align = xfs_get_extsz_hint(ip);
	if (align <= 1) {
		unit_min_fsb = 1;
		unit_max_fsb = 1;
		return;
	}

And finally, if there is an extent size hint, we can return that.

> +	if (atomic_write_unit_max == 0) {
> +		*unit_min_fsb = 0;
> +		*unit_max_fsb = 0;
> +	} else if (atomic_write_unit_min == 0) {
> +		*unit_min_fsb = 1;
> +		*unit_max_fsb = min_t(xfs_filblks_t, atomic_write_unit_max,
> +					align);

Why is it valid for a device to have a zero minimum size? If it can
set a maximum, it should -always- set a minimum size as logical
sector size is a valid lower bound, yes?

> +	} else {
> +		*unit_min_fsb = min_t(xfs_filblks_t, atomic_write_unit_min,
> +					align);
> +		*unit_max_fsb = min_t(xfs_filblks_t, atomic_write_unit_max,
> +					align);
> +	}

Nothing here guarantees the power-of-2 sizes that the RWF_ATOMIC
user interface requires....

It also doesn't check that the extent size hint is aligned with
atomic write units.

It also doesn't check either against stripe unit alignment....

> +}
> +
>  STATIC int
>  xfs_vn_getattr(
>  	struct mnt_idmap	*idmap,
> @@ -614,6 +654,17 @@ xfs_vn_getattr(
>  			stat->dio_mem_align = bdev_dma_alignment(bdev) + 1;
>  			stat->dio_offset_align = bdev_logical_block_size(bdev);
>  		}
> +		if (request_mask & STATX_WRITE_ATOMIC) {
> +			xfs_filblks_t unit_min_fsb, unit_max_fsb;
> +
> +			xfs_ip_atomic_write_attr(ip, &unit_min_fsb,
> +				&unit_max_fsb);
> +			stat->atomic_write_unit_min = XFS_FSB_TO_B(mp, unit_min_fsb);
> +			stat->atomic_write_unit_max = XFS_FSB_TO_B(mp, unit_max_fsb);

That's just nasty. We pull byte units from the bdev, convert them to
fsb to round them, then convert them back to byte counts. We should
be doing all the work in one set of units....

> +			stat->attributes |= STATX_ATTR_WRITE_ATOMIC;
> +			stat->attributes_mask |= STATX_ATTR_WRITE_ATOMIC;
> +			stat->result_mask |= STATX_WRITE_ATOMIC;

If the min/max are zero, then atomic writes are not supported on
this inode, right? Why would we set any of the attributes or result
mask to say it is supported on this file?


-Dave.
-- 
Dave Chinner
david@fromorbit.com
