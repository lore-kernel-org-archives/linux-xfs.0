Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84ABBC43217
	for <linux-xfs@archiver.kernel.org>; Sat, 15 Oct 2022 08:22:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiJOIV7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 15 Oct 2022 04:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiJOIV6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 15 Oct 2022 04:21:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335784BD3B
        for <linux-xfs@vger.kernel.org>; Sat, 15 Oct 2022 01:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665822116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UJlIsjKFHK/t6VZqOubYAsE15nmVTuE0c/G5WFp1qrc=;
        b=eG7J6m5k7lN4ajAuvaS3+g1BMfNECqX7UlkE92127Uxkqo//JuiUMSx2yCsUcjQU0qsGZC
        YCaLBF6xfPiP8NKl37vDuJuqThNBa8kdLk3D6M5HjWczS5FqQ1XI6oIjtu59iy4qwARCZI
        dpbPXhNalXBnEg8AeTOr6HU2pJ+2iY8=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-674-j95Lwp7TNJG7uY7I8kL61A-1; Sat, 15 Oct 2022 04:21:55 -0400
X-MC-Unique: j95Lwp7TNJG7uY7I8kL61A-1
Received: by mail-pf1-f199.google.com with SMTP id k11-20020aa792cb000000b00558674e8e7fso3952765pfa.6
        for <linux-xfs@vger.kernel.org>; Sat, 15 Oct 2022 01:21:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UJlIsjKFHK/t6VZqOubYAsE15nmVTuE0c/G5WFp1qrc=;
        b=vqKdU9HvbeOx06QVXZPku1nkfSX/UTzm/jhtSXd7/j92SjK79L+ecBXE2aZ2UH9ffD
         8ML+Qyf8sd50zduuC+BBAgA2sAnMsNKrl3o2O/4KcHtqnVyGO3bnot2M4JQENztzxEBt
         R+Chcruc0HahHD/w5gCDXj2pCJPuCY9RKx3RumeHuTL/5L22nxinm9QY38loAqUYtxcV
         3plB3HeFHgfAh9CIk1756jo5EmsAilGMuf24o9e73AUwumIPA6TY3iZs08b0bsiSRMX2
         byDsxleXliDM9gIcsZem5Dnn7H0mAJDHRZWrNu8JaC1Ov08SuKsDSNvOM3pjQ6iZRwg8
         ILtg==
X-Gm-Message-State: ACrzQf09jM5lqclG09j8oY+43mG8WQLzQpCstWAYIcKDAAEkl2CUmzsV
        ATk9jTFLqnwPfd3ZKtQ+10JeXSTElb7OY8wfCk7oglH0pkTpfthOw/mjQ4/PCMhRFe7NsYsl+yH
        ajE/SA1rwMyBwLMybhpry
X-Received: by 2002:a63:2bd4:0:b0:451:5df1:4b15 with SMTP id r203-20020a632bd4000000b004515df14b15mr1732961pgr.518.1665822113594;
        Sat, 15 Oct 2022 01:21:53 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM43oAQz5LBxzsRBzyWhwjzyhOz6EbG1kzUarZdQ1LEzFvF2O9stoEnEuSFfz1WDfLYdtOidQg==
X-Received: by 2002:a63:2bd4:0:b0:451:5df1:4b15 with SMTP id r203-20020a632bd4000000b004515df14b15mr1732941pgr.518.1665822113218;
        Sat, 15 Oct 2022 01:21:53 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l10-20020a170902f68a00b0017834a6966csm2920131plg.176.2022.10.15.01.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Oct 2022 01:21:52 -0700 (PDT)
Date:   Sat, 15 Oct 2022 16:21:47 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v1.1 1/5] populate: export the metadump description name
Message-ID: <20221015082147.dghjrnjelgu6oszx@zlang-mailbox>
References: <166553912229.422450.15473762183660906876.stgit@magnolia>
 <166553912788.422450.6797363004980943410.stgit@magnolia>
 <Y0mowyuRHSivs3ho@magnolia>
 <20221015050144.w4bq5vycditc6fgs@zlang-mailbox>
 <20221015051009.y2pgscuadxfyljjx@zlang-mailbox>
 <Y0phCRO5Y3QMIBMU@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0phCRO5Y3QMIBMU@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 15, 2022 at 12:28:09AM -0700, Darrick J. Wong wrote:
> On Sat, Oct 15, 2022 at 01:10:09PM +0800, Zorro Lang wrote:
> > On Sat, Oct 15, 2022 at 01:01:44PM +0800, Zorro Lang wrote:
> > > On Fri, Oct 14, 2022 at 11:21:55AM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Make the variable that holds the contents of the metadump description
> > > > file a local variable since we don't need it outside of that function.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > Reviewed-by: Zorro Lang <zlang@redhat.com>
> > > > ---
> > > > v1.1: dont export POPULATE_METADUMP; change the description a bit
> > > > ---
> > > 
> > > So you don't need to export the POPULATE_METADUMP anymore? I remembered you
> > > said something broken and "exporting the variable made it work". Before I
> > > merge this patch, hope to double check with you.
> > 
> > And the subject is still "populate: export the metadump description name", I
> > think it's not suit for this change. Anyway, as this patch is not depended by
> > others, I can merge other 4 patches at first. To give you enough time to think
> > about what do you really like to change :)
> 
> <sigh> I updated the commit message in git and forgot to copy-paste the
> new subject into the email.  Sorry about all this stupid crap, bash is a
> terrible language and email is a godawful process and both should be
> smote off the planet.

I can help to change this subject if you're sure this change is fine for you.

BTW, if the POPULATE_METADUMP isn't affect your test anymore, I think we're
not hurry to have this patch which only make a variable to be local. How about
I merge other 4 patches at first, then you can have more time to watch your
later testing results, and think about if you need more changes?

Thanks,
Zorro

> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > > 
> > > Thanks,
> > > Zorro
> > > 
> > > >  common/populate |    8 ++++----
> > > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/common/populate b/common/populate
> > > > index cfdaf766f0..ba34ca5844 100644
> > > > --- a/common/populate
> > > > +++ b/common/populate
> > > > @@ -868,15 +868,15 @@ _scratch_populate_cached() {
> > > >  	local meta_tag="$(echo "${meta_descr}" | md5sum - | cut -d ' ' -f 1)"
> > > >  	local metadump_stem="${TEST_DIR}/__populate.${FSTYP}.${meta_tag}"
> > > >  
> > > > -	# These variables are shared outside this function
> > > > +	# This variable is shared outside this function
> > > >  	POPULATE_METADUMP="${metadump_stem}.metadump"
> > > > -	POPULATE_METADUMP_DESCR="${metadump_stem}.txt"
> > > > +	local populate_metadump_descr="${metadump_stem}.txt"
> > > >  
> > > >  	# Don't keep metadata images cached for more 48 hours...
> > > >  	rm -rf "$(find "${POPULATE_METADUMP}" -mtime +2 2>/dev/null)"
> > > >  
> > > >  	# Throw away cached image if it doesn't match our spec.
> > > > -	cmp -s "${POPULATE_METADUMP_DESCR}" <(echo "${meta_descr}") || \
> > > > +	cmp -s "${populate_metadump_descr}" <(echo "${meta_descr}") || \
> > > >  		rm -rf "${POPULATE_METADUMP}"
> > > >  
> > > >  	# Try to restore from the metadump
> > > > @@ -885,7 +885,7 @@ _scratch_populate_cached() {
> > > >  
> > > >  	# Oh well, just create one from scratch
> > > >  	_scratch_mkfs
> > > > -	echo "${meta_descr}" > "${POPULATE_METADUMP_DESCR}"
> > > > +	echo "${meta_descr}" > "${populate_metadump_descr}"
> > > >  	case "${FSTYP}" in
> > > >  	"xfs")
> > > >  		_scratch_xfs_populate $@
> > > > 
> > > 
> > 
> 

