Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E433C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Dec 2022 10:34:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbiLQKeZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 17 Dec 2022 05:34:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiLQKeY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Dec 2022 05:34:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464D217A8B
        for <linux-xfs@vger.kernel.org>; Sat, 17 Dec 2022 02:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671273221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tV8AoKPTx/CWbAFWLvSiiyPv/0YYAV4pZXVpcnZfEnc=;
        b=d5TIyuQdoLbzFqeM5vovqCPyTLTyc9umY/t3T5vhVKiVyGfTxrevcpt5khGqefhjA5UfBf
        DwDReKqazyq0w+2eep4RWFHSnXggyZh/AOZqt6zQHXtBw8+Ld/jpDaH2631P+hcrKfUSI4
        +/NwmlpSCPNkQQhnjHFp4meV0FoaC7I=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-533-lbv74EZnN8O0R4EMSBuxCg-1; Sat, 17 Dec 2022 05:33:39 -0500
X-MC-Unique: lbv74EZnN8O0R4EMSBuxCg-1
Received: by mail-pl1-f199.google.com with SMTP id x18-20020a170902ec9200b00189d3797fc5so3389755plg.12
        for <linux-xfs@vger.kernel.org>; Sat, 17 Dec 2022 02:33:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tV8AoKPTx/CWbAFWLvSiiyPv/0YYAV4pZXVpcnZfEnc=;
        b=zBXgM5KPKiK7gRER25x2wR07c1xtIPfmhCSMmaEbnswoU1Ipx0opfjFUYd3g7LH0os
         aF73y6pfnNzGb+8DxOpNbSi26bv2NZGJHU/mebiL9EHm+BGkMSMQhQdodLozvQ3pYa0h
         Y9qqkhaiMtZV+VTK/EP5IYVsNQdm/gdPJdwRvFUBIU2rgPDs4nOQrBtMJINLnK83NbSV
         2Wq4/LHRWvvYsVzfYS3LzppW7JHHKeGTIYyrEIkXsufROgKrcNa4FZvGtvzRAu3ahqM2
         oMb4QlfoVttWFlDG9Gw6Wj26Iuxpu4F/puCt73ftxcu0QSWb6sOHFK2Xe0TNGtw+PVmv
         jsmg==
X-Gm-Message-State: AFqh2kouoEx92tNliY/d+7J/GJ//zPRj2B4mpnLSv5hxlFl9mf0DqB33
        IqpcWim5UJkG333Xs1ZB2yeD+6YtGZoCmzfCVt375jVm+gdigCMu2XlTPNFT++kHDBBl8f2l4SA
        w8pMA8db+L5SbJOJSC+P1
X-Received: by 2002:a17:902:e993:b0:189:e290:c65f with SMTP id f19-20020a170902e99300b00189e290c65fmr1522416plb.66.1671273218335;
        Sat, 17 Dec 2022 02:33:38 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuxapm7cYP8eJ1kc3ILfhK4zfuEe6z+Qp4UMT2pD7m0lY/vDfxIaU8v33G4rUkOLcPj7C6Bkg==
X-Received: by 2002:a17:902:e993:b0:189:e290:c65f with SMTP id f19-20020a170902e99300b00189e290c65fmr1522400plb.66.1671273218015;
        Sat, 17 Dec 2022 02:33:38 -0800 (PST)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g6-20020a170902c38600b0017f64ab80e5sm3190347plg.179.2022.12.17.02.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 02:33:37 -0800 (PST)
Date:   Sat, 17 Dec 2022 18:33:33 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 4/4] fuzzy: don't fail on compressed metadumps
Message-ID: <20221217103333.knedx24lltmnodxq@zlang-mailbox>
References: <167096070957.1750373.5715692265711468248.stgit@magnolia>
 <167096073394.1750373.2942809607367883189.stgit@magnolia>
 <20221217070329.holhjbwq6xcjrgsa@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221217070329.holhjbwq6xcjrgsa@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Dec 17, 2022 at 03:03:29PM +0800, Zorro Lang wrote:
> On Tue, Dec 13, 2022 at 11:45:33AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > This line in __scratch_xfs_fuzz_mdrestore:
> > 
> > 	test -e "${POPULATE_METADUMP}"
> > 
> > Breaks spectacularly on a setup that uses DUMP_COMPRESSOR to compress
> > the metadump files, because the metadump files get the compression
> > program added to the name (e.g. "${POPULATE_METADUMP}.xz").  The check
> > is wrong, and since the naming policy is an implementation detail of
> > _xfs_mdrestore, let's get rid of the -e test.
> > 
> > However, we still need a way to fail the test if the metadump cannot be
> > restored.  _xfs_mdrestore returns nonzero on failure, so use that
> > instead.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> 
> Looks good to me,
> Reviewed-by: Zorro Lang <zlang@redhat.com>
> 
> >  common/fuzzy |    5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/common/fuzzy b/common/fuzzy
> > index e634815eec..49c850f2d5 100644
> > --- a/common/fuzzy
> > +++ b/common/fuzzy
> > @@ -156,10 +156,9 @@ __scratch_xfs_fuzz_unmount()
> >  # Restore metadata to scratch device prior to field-fuzzing.
> >  __scratch_xfs_fuzz_mdrestore()
> >  {
> > -	test -e "${POPULATE_METADUMP}" || _fail "Need to set POPULATE_METADUMP"
> > -
> >  	__scratch_xfs_fuzz_unmount
> > -	_xfs_mdrestore "${POPULATE_METADUMP}" "${SCRATCH_DEV}" compress
> > +	_xfs_mdrestore "${POPULATE_METADUMP}" "${SCRATCH_DEV}" compress || \

FYI, I've also removed the "compress" parameter according to:
  [PATCH v1.1 3/4] common/populate: move decompression code to _{xfs,ext4}_mdrestore
When I merged this patch.

> > +		_fail "${POPULATE_METADUMP}: Could not find metadump to restore?"
> >  }
> >  
> >  __fuzz_notify() {
> > 

