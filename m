Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D70B9C433FE
	for <linux-xfs@archiver.kernel.org>; Sat, 15 Oct 2022 05:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiJOFKV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 15 Oct 2022 01:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiJOFKU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 15 Oct 2022 01:10:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55956EE1F
        for <linux-xfs@vger.kernel.org>; Fri, 14 Oct 2022 22:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665810617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YiktE4UqXz02VLIUD1p5kY7mxCJkQM4TjTzzp1mxpgA=;
        b=UFa2iMjtCd/B7Cnp74Io4HQqXlCCm/teZoMzTu28fR02jBncI+/nqxuHaxeDBw06b38FHd
        KmPc14i/MTV7cX+DC6IUpw1QZFtcv/2mHqFBgijseYZTCPFxO3eSPHvNrzZhDE9EeABAwM
        cvOVTyrsGKVMJYNyNz4k2h3ZP9QtAhM=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-237-XfeHESGWN2aci2-vtC1F9w-1; Sat, 15 Oct 2022 01:10:15 -0400
X-MC-Unique: XfeHESGWN2aci2-vtC1F9w-1
Received: by mail-pf1-f198.google.com with SMTP id p1-20020aa78601000000b00565a29d32e5so3813626pfn.5
        for <linux-xfs@vger.kernel.org>; Fri, 14 Oct 2022 22:10:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YiktE4UqXz02VLIUD1p5kY7mxCJkQM4TjTzzp1mxpgA=;
        b=TOgYvogcgB77Myukq2iBINKRLmp/AAVjVDFlkvkbU1Rdnz73LKMC8KkiAJNmNBQ95v
         U5djKSHYzbwsktL2l2mLCS6gU63IFeFkrcR4iNpuLpNJi/scnzRmJ+CmIa7EagXcUufW
         fBlQg7If8Xe/2UxCG7qkgz8v5h4+dLgdijODUUPisDktMFuikWCQ5eYpVK3QgtQDnGNc
         GS3FwemW+qJhbH+fUzPggw84HLEw9emgePygHCEBJQtiuT1lN25/SZ4+cyEEBREUsZTo
         oVouMofyRHIzFXw5n2ZAWnu+TbY9X2Csa8WD4OgADTcpcclfw8bm1OMHGJBoxQcBnajc
         XLZA==
X-Gm-Message-State: ACrzQf2qgmYnkpnxdgF+IKiuzEyVtDreWb5kqE98ZE/LrrshmjfSlDDF
        ZK82cvMfoCFChkR46a9XNy0jwWzuOKnEy86NDFHYkhbsgVmCoO07JdvZrlnASPyzov06hyI9Ubb
        sEVCulrIT/uzz6v2aELq+
X-Received: by 2002:a17:90b:384f:b0:20d:4761:3394 with SMTP id nl15-20020a17090b384f00b0020d47613394mr1630693pjb.144.1665810614588;
        Fri, 14 Oct 2022 22:10:14 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6vj5RbbrOft4fZZz0RmXWQ5tkIdjU2E0oMwqYQFRSR7ztYOXBxUurEBJvggSvetbClNyF/AQ==
X-Received: by 2002:a17:90b:384f:b0:20d:4761:3394 with SMTP id nl15-20020a17090b384f00b0020d47613394mr1630679pjb.144.1665810614264;
        Fri, 14 Oct 2022 22:10:14 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a1-20020a170902710100b0016f196209c9sm2535126pll.123.2022.10.14.22.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 22:10:13 -0700 (PDT)
Date:   Sat, 15 Oct 2022 13:10:09 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v1.1 1/5] populate: export the metadump description name
Message-ID: <20221015051009.y2pgscuadxfyljjx@zlang-mailbox>
References: <166553912229.422450.15473762183660906876.stgit@magnolia>
 <166553912788.422450.6797363004980943410.stgit@magnolia>
 <Y0mowyuRHSivs3ho@magnolia>
 <20221015050144.w4bq5vycditc6fgs@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221015050144.w4bq5vycditc6fgs@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 15, 2022 at 01:01:44PM +0800, Zorro Lang wrote:
> On Fri, Oct 14, 2022 at 11:21:55AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Make the variable that holds the contents of the metadump description
> > file a local variable since we don't need it outside of that function.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Zorro Lang <zlang@redhat.com>
> > ---
> > v1.1: dont export POPULATE_METADUMP; change the description a bit
> > ---
> 
> So you don't need to export the POPULATE_METADUMP anymore? I remembered you
> said something broken and "exporting the variable made it work". Before I
> merge this patch, hope to double check with you.

And the subject is still "populate: export the metadump description name", I
think it's not suit for this change. Anyway, as this patch is not depended by
others, I can merge other 4 patches at first. To give you enough time to think
about what do you really like to change :)

Thanks,
Zorro

> 
> Thanks,
> Zorro
> 
> >  common/populate |    8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/common/populate b/common/populate
> > index cfdaf766f0..ba34ca5844 100644
> > --- a/common/populate
> > +++ b/common/populate
> > @@ -868,15 +868,15 @@ _scratch_populate_cached() {
> >  	local meta_tag="$(echo "${meta_descr}" | md5sum - | cut -d ' ' -f 1)"
> >  	local metadump_stem="${TEST_DIR}/__populate.${FSTYP}.${meta_tag}"
> >  
> > -	# These variables are shared outside this function
> > +	# This variable is shared outside this function
> >  	POPULATE_METADUMP="${metadump_stem}.metadump"
> > -	POPULATE_METADUMP_DESCR="${metadump_stem}.txt"
> > +	local populate_metadump_descr="${metadump_stem}.txt"
> >  
> >  	# Don't keep metadata images cached for more 48 hours...
> >  	rm -rf "$(find "${POPULATE_METADUMP}" -mtime +2 2>/dev/null)"
> >  
> >  	# Throw away cached image if it doesn't match our spec.
> > -	cmp -s "${POPULATE_METADUMP_DESCR}" <(echo "${meta_descr}") || \
> > +	cmp -s "${populate_metadump_descr}" <(echo "${meta_descr}") || \
> >  		rm -rf "${POPULATE_METADUMP}"
> >  
> >  	# Try to restore from the metadump
> > @@ -885,7 +885,7 @@ _scratch_populate_cached() {
> >  
> >  	# Oh well, just create one from scratch
> >  	_scratch_mkfs
> > -	echo "${meta_descr}" > "${POPULATE_METADUMP_DESCR}"
> > +	echo "${meta_descr}" > "${populate_metadump_descr}"
> >  	case "${FSTYP}" in
> >  	"xfs")
> >  		_scratch_xfs_populate $@
> > 
> 

