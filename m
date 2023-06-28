Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47906EB64D7
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jun 2023 09:02:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbjF1JBv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jun 2023 05:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234296AbjF1IZ4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jun 2023 04:25:56 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EABD294C
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 01:17:34 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id d75a77b69052e-4008b90d2f9so47674231cf.2
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 01:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687940253; x=1690532253;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uHAgK31V+qto7lF6nuR/80Td2cQl7pkgJYcZX0wiCp0=;
        b=leRJ3DCLBProlSABh12KVuGRuXb9dOS74ytKKjQlFBJ+Nckv7hCmqzbFWfVrefC8xv
         KgKbRvw6sJQLSO0oJfwwPoMifszxniTBp3YH4skmhKkK6zD1MJMhhHOKQsv/ctnzS7M5
         HwXELPUSfKBF3uxbI480imS7glFwJtEXQP2NEgYEkobo145Cu3fUXXZJ8lvFQMleQyHm
         1WyMC0WmGKVR0AijvBi/D6u+Ws+esPF/qGBCyWqluWSoKHVAzxUdMD/HFeHzFOfRWZJV
         J1Oc7UZXWMyVMpLPSLoF3GXPxGDVxluAl2/2y5zp2t9MrujhLmJyUwcUAQigwUUw4cIY
         EShg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687940253; x=1690532253;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uHAgK31V+qto7lF6nuR/80Td2cQl7pkgJYcZX0wiCp0=;
        b=SMb3YHS8N84R0jrGPIw8KDfJNSZsW4NsY4FUzla/6ALozJ/gDr+dlFLwTIYbUAFo5U
         05aC90Y6ILIjEf/S+FK/X7vqlRdpv9pqzwO72ZmwDTjRXk4oEq5+0nY0HdO6r7TG8wN1
         qvRLg3BL1eYKggwk8lFsnYpcAnJj1QY5YDwc3reDXkI0fF3/wODd7b7FCIMmfmeJXwmc
         2oVkx1vuBfMBZcwX66yLeXfamtW5Xd4XUwad+79cjjcQMn5dilORGE0tygsA7ps/L88a
         jiECcXXCVsxQFDR/P9eRNAOiJZJvQjXxAmFzA/vMjyKhahUJQVbzLv+BxbR/rhagRi7m
         FlSA==
X-Gm-Message-State: AC+VfDyK9fwMA8jJYZYUcYJa02NqqXWItXnArA3OhDXkAyaMOmKixWiz
        PkklldYrNKo7T92mZtRsJCZQMuGZHDmsGuABCA4=
X-Google-Smtp-Source: ACHHUZ5pcyU1ZdsQRDTFTZhqk3lwq5J3PYJPPfCxFLzmOpkCbD/rrIPtsr4daA6QuGSFAL44K0Qikg==
X-Received: by 2002:a05:6a00:1a87:b0:66a:386c:e6a6 with SMTP id e7-20020a056a001a8700b0066a386ce6a6mr27418447pfv.6.1687934300968;
        Tue, 27 Jun 2023 23:38:20 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-94-37.pa.vic.optusnet.com.au. [49.186.94.37])
        by smtp.gmail.com with ESMTPSA id v26-20020aa7851a000000b0064f708ca12asm4682222pfn.70.2023.06.27.23.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 23:38:20 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qEOoi-00H80M-2E;
        Wed, 28 Jun 2023 16:38:16 +1000
Date:   Wed, 28 Jun 2023 16:38:16 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs: journal geometry is not properly bounds checked
Message-ID: <ZJvVWOHGnW/KGfe2@dread.disaster.area>
References: <20230627224412.2242198-1-david@fromorbit.com>
 <20230627224412.2242198-7-david@fromorbit.com>
 <ZJvObtDmbYVyR+KO@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJvObtDmbYVyR+KO@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 27, 2023 at 11:08:46PM -0700, Christoph Hellwig wrote:
> > +	if (sbp->sb_logblocks > XFS_MAX_LOG_BLOCKS) {
> > +		xfs_notice(mp,
> > +		"Log size 0x%x blocks too large, maximum size is 0x%llx blocks",
> > +			 sbp->sb_logblocks, XFS_MAX_LOG_BLOCKS);
> 
> Just a little nitpick, didn't we traditionally align the overly
> long format strings with a single tab and not to the same line as
> the xfs_notice/warn/etc?

I don't think we have a particluarly formal definition of that.
 
I mean, just look at all the different variants in
xfs_sb_validate_common:

	if (xfs_sb_is_v5(sbp)) {
                if (sbp->sb_blocksize < XFS_MIN_CRC_BLOCKSIZE) {
                        xfs_notice(mp,
"Block size (%u bytes) too small for Version 5 superblock (minimum %d bytes)",
                                sbp->sb_blocksize, XFS_MIN_CRC_BLOCKSIZE);
                        return -EFSCORRUPTED;
                }

                /* V5 has a separate project quota inode */
                if (sbp->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) {
                        xfs_notice(mp,
                           "Version 5 of Super block has XFS_OQUOTA bits.");
                        return -EFSCORRUPTED;
                }

                /*
                 * Full inode chunks must be aligned to inode chunk size when
                 * sparse inodes are enabled to support the sparse chunk
                 * allocation algorithm and prevent overlapping inode records.
                 */
                if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_SPINODES) {
                        uint32_t        align;

                        align = XFS_INODES_PER_CHUNK * sbp->sb_inodesize
                                        >> sbp->sb_blocklog;
                        if (sbp->sb_inoalignmt != align) {
                                xfs_warn(mp,
"Inode block alignment (%u) must match chunk size (%u) for sparse inodes.",
                                         sbp->sb_inoalignmt, align);
                                return -EINVAL;
                        }
                }
        } else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
                                XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
                        xfs_notice(mp,
"Superblock earlier than Version 5 has XFS_{P|G}QUOTA_{ENFD|CHKD} bits.");
                        return -EFSCORRUPTED;
        }

        if (unlikely(
            sbp->sb_logstart == 0 && mp->m_logdev_targp == mp->m_ddev_targp)) {
                xfs_warn(mp,
                "filesystem is marked as having an external log; "
                "specify logdev on the mount command line.");
                return -EINVAL;
        }

        if (unlikely(
            sbp->sb_logstart != 0 && mp->m_logdev_targp != mp->m_ddev_targp)) {
                xfs_warn(mp,
                "filesystem is marked as having an internal log; "
                "do not specify logdev on the mount command line.");
                return -EINVAL;
        }

There's 4-5 different variations in indenting in 6-7 warning
messages. And there are more variations in that function, too.

There's no consistent rule to follow, so I just set the indenting
such that the format string didn't run over 80 columns and didn't
think any further..

I think that if we really care, a separate cleanup patch to make all
the long format strings use consistent zero-indenting and the
variables one tab like this one:

                        xfs_notice(mp,
"Block size (%u bytes) too small for Version 5 superblock (minimum %d bytes)",
                                sbp->sb_blocksize, XFS_MIN_CRC_BLOCKSIZE);

Could be done. If I'm ever lacking for something to do...

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

_dave.
-- 
Dave Chinner
david@fromorbit.com
