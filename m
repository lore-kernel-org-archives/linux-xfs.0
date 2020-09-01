Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE67DC433E2
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 08:40:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9382F206A5
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 08:40:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yn6f0AGB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgIAIkn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 04:40:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35293 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726064AbgIAIkn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 04:40:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598949642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P8mbtzCGYfQfm5lHtTGk8GXxAU/gT07DDVFgZne/C1Y=;
        b=Yn6f0AGB8IcobE1H35ogSyh0mTJFu2a2gEP6hBzMp0kh2WjJLibwK13n26PTSSTjC447fN
        Som7lGBLvt+w9/vguyaZuAlwijG2FdUY6vk9kU4/LzOLoZyuMEVa8AjZXGYMbCxuTgr3R7
        xBcLOc3u1Iu+WE/TC7DL+O7LJ9rz/D4=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-VwIonnaJNBG0X7gYjndYYA-1; Tue, 01 Sep 2020 04:40:40 -0400
X-MC-Unique: VwIonnaJNBG0X7gYjndYYA-1
Received: by mail-pg1-f198.google.com with SMTP id k26so349347pgf.8
        for <linux-xfs@vger.kernel.org>; Tue, 01 Sep 2020 01:40:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=P8mbtzCGYfQfm5lHtTGk8GXxAU/gT07DDVFgZne/C1Y=;
        b=bOUc11/Wh0z2ii6iVlCMOtXGRYohHUFx0Ro0lYk7WoXMeL6wNorwDsKcjjnhSf69Jw
         msHPVi+Uyz+gB+4JTeBp+fMqrYLjF5uuIHB+EAJZVPj0f8ttnU0MT966R/dbM2AXYX+j
         pctUJWB3vXPyt1goIKMpv1O0cLYtFot7DV1v28h2CbzoEqrWymzf9Yj6myeH1Q3gNCj5
         4qr6F+/SUidO8SQhk92j5zFQBTooVt+0GF2iKv4xXBFL8P4JyalmBmIetfGaJlYGyWpn
         uoc5lDC7VTsr7CpvbdfaHyCavPtX2h4Dh49lNIUkxhjcOGrmwox7yRsxHerzVRXZRHw9
         LSbQ==
X-Gm-Message-State: AOAM533kE0Qae78wwwRTXOxLf9v5lYfTH7tZxzn1hz6yqzy5UFaEkGFp
        H+aRWxA+cMM6v0wfkldOoLunWpSCDrGWhqAR9fRox1SI3AHywkCkrDRLXteWYlmIqBk3SfyVHoA
        0itLrtarB4/IRPdI9xIH2
X-Received: by 2002:aa7:96cc:: with SMTP id h12mr922538pfq.44.1598949639219;
        Tue, 01 Sep 2020 01:40:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXAGfwyOOxeXuzBxU3pyHr5aMkmLQCtYeLrgIkQsjYEpznaSLo1kONC2/qPBZr47Uf3aUX4A==
X-Received: by 2002:aa7:96cc:: with SMTP id h12mr922517pfq.44.1598949638947;
        Tue, 01 Sep 2020 01:40:38 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 72sm925924pfx.79.2020.09.01.01.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 01:40:38 -0700 (PDT)
Date:   Tue, 1 Sep 2020 16:40:27 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, hch@infradead.org, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, sandeen@sandeen.net
Subject: Re: [PATCH 06/11] xfs: redefine xfs_timestamp_t
Message-ID: <20200901084027.GC32609@xiangao.remote.csb>
References: <159885400575.3608006.17716724192510967135.stgit@magnolia>
 <159885404651.3608006.10399319045770054721.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159885404651.3608006.10399319045770054721.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 30, 2020 at 11:07:26PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Redefine xfs_timestamp_t as a __be64 typedef in preparation for the
> bigtime functionality.  Preserve the legacy structure format so that we
> can let the compiler take care of masking and shifting.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Gao Xiang <hsiangkao@redhat.com>

(Although I preferr something like (untested),

struct timespec64
xfs_inode_from_disk_ts(
	const xfs_timestamp_t		ts)
{
	struct xfs_legacy_timestamp     *lts = (void *)&ts;

	return (struct timespec64) {
		.tv_sec = (int64_t)be32_to_cpu(lts->t_sec),
		.tv_nsec = (int)be32_to_cpu(lts->t_nsec)		
	};
}

and similiar to xfs_log_dinode_to_disk_ts()... that's quite minor...)

Thanks,
Gao Xiang

