Return-Path: <SRS0=3qtu=37=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CECD8C352A3
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 09:08:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 907FE20842
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 09:08:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eJ7hUBti"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbgBKJIn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Feb 2020 04:08:43 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:37768 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725787AbgBKJIn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Feb 2020 04:08:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581412122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r5Qmrcm0vXYf+rMkk26UDWeUoUNnNuzer/IIUzBGlWM=;
        b=eJ7hUBti84blaTczlh3KjHkOOUTFCH98FfQKdZMEg9UW2NbMH0CStn25nt+e6L8pSK7wAS
        dPokYJ2P6kA4hkfWGF6Q/haVtpp5bvb6FteyhBx8Fh/20e1nNsQMsAKnoerx5D6d4AydFi
        ZlqK55sRvRczNPDtw3gu+E7/zWTpzEE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-4cXPsET9PD2cwwSq4j3wQw-1; Tue, 11 Feb 2020 04:08:40 -0500
X-MC-Unique: 4cXPsET9PD2cwwSq4j3wQw-1
Received: by mail-wm1-f69.google.com with SMTP id t17so1047671wmi.7
        for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2020 01:08:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=r5Qmrcm0vXYf+rMkk26UDWeUoUNnNuzer/IIUzBGlWM=;
        b=B2F+DxTgviY/bZma+eTzAgHQ3Xksv54EJsxtn1N8B+/7KRlILFsR38FhiWVNfk4f7R
         sVEX3sYBjpO499cSC0naBym+Y6k04Fyz1JxLBLyTlCQIVZnvttwL39F65iX3ylyXRMa6
         OhmVV1U7LCDys69OzBnUxYmV73bCENIUxmiJKfi1uBEdxRsGt0a926iB1HCmUhiL/fsf
         yYRRTedzcj51WI5cM+UrLUq6Lbde4jAln/pE2ID+HxX711nxSZo/Tc7Zq1JfPf4YPMkT
         UMaM/DM+o/PdYtyPAeJBDBZLGaXX95Y0/JiH7NvrowspJAC6WT7ydB8raQoEhoRh22ll
         W6sg==
X-Gm-Message-State: APjAAAV+PYSZWn0YAxhvtVBgckghHZgBo+xPhPxhCXO4GHAyenB6JfNl
        zp+jesnapUzrFC70DweT3MDI0xcpvbK+vGXNo4gV0iUrPrsH17gsRz8wKCsKefplJjEe8nc1gtX
        24xz2RG9ykgaYVXSloZLu
X-Received: by 2002:adf:ea8a:: with SMTP id s10mr7108238wrm.278.1581412119279;
        Tue, 11 Feb 2020 01:08:39 -0800 (PST)
X-Google-Smtp-Source: APXvYqw7+XbPzelxIsY3f6HVMbA8H+9FdWT4mIDUqyL0+a/5elyfcX1tRVyrY9q/DdeGQYUJFrUaqg==
X-Received: by 2002:adf:ea8a:: with SMTP id s10mr7108217wrm.278.1581412119121;
        Tue, 11 Feb 2020 01:08:39 -0800 (PST)
Received: from andromeda (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id 4sm2835123wmg.22.2020.02.11.01.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 01:08:38 -0800 (PST)
Date:   Tue, 11 Feb 2020 10:08:36 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>, John Jore <john@jore.no>
Subject: Re: [PATCH] xfs_repair: fix bad next_unlinked field
Message-ID: <20200211090836.cims7r4jvrds2e7w@andromeda>
Mail-Followup-To: Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>, John Jore <john@jore.no>
References: <f5b8a2a9-e691-3bf5-c2c7-f4986a933454@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5b8a2a9-e691-3bf5-c2c7-f4986a933454@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +	unlinked_ino = be32_to_cpu(dino->di_next_unlinked);
> +	if (!xfs_verify_agino_or_null(mp, agno, unlinked_ino)) {
> +		retval = 1;
> +		if (!uncertain)
> +			do_warn(_("bad next_unlinked 0x%x on inode %" PRIu64 "%c"),
> +				(__s32)dino->di_next_unlinked, lino,
				^^^^
				shouldn't we be using be32_to_cpu()
				here, instead of a direct casting to
				__s32?



Cheers.

-- 
Carlos

