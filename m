Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FACCC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Oct 2022 01:17:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiJNBRw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Oct 2022 21:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiJNBRu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2022 21:17:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D79F164BD5
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 18:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665710269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AZ9y8tKOu8PvZM+Ki1up7Wbldjs7xwlDEH15zyduYdg=;
        b=Ch6U9dVnzBtcFwsE9wX/ylEh//kcX8H4l8d1giW5hAuWgFPP8/vHLgICXRKA7ZTwMjcOgj
        N2yzGSwHcuWU9bpbNlyDcsAtGuXcDLQReIzHZzZgxIfzh2HzNM3dMc1D9hjeRKdkv+0o0n
        4yZW5kIEI/7m73ByJ17TWCGFOlecUGU=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-661-0AFscxZmPJKImMu82y-0mQ-1; Thu, 13 Oct 2022 21:17:47 -0400
X-MC-Unique: 0AFscxZmPJKImMu82y-0mQ-1
Received: by mail-pg1-f198.google.com with SMTP id y71-20020a638a4a000000b0046014b2258dso1823718pgd.19
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 18:17:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AZ9y8tKOu8PvZM+Ki1up7Wbldjs7xwlDEH15zyduYdg=;
        b=45I6utlVljYIm/RKnUnxZzPuZbdohaZeU0+QSU9qliD1xX2k025gijvwm5/v8bQWfA
         JVjNA8v+mVyBcv8Vhztc930Dxf/fF/WxPcJekoo04fJCxeoBxzqJsR/qHB74nZOzjmyA
         hXbtsHg0iRpPxF5zZdPb+uUT6roU9IKQORZpGogKYytSkOBpQUAyeXZ/GTY6UTYm/w8J
         lq42rBDl91thS3oS+uRaZCpVzW+1IbjP21BREafP9wvZN1lE8z8Juxh6RrXb0vCdUSFv
         6zAV61ZTwrWGkfTP4JXs0lxBCHVfykfRYRSATh2/ZvG6ee73caz/jOJqbchvPbqfp1gx
         uD4Q==
X-Gm-Message-State: ACrzQf1SYXJBo1donZx88ktPGobzeGNra0iw7ug1kFagOvxPmDNee6WU
        4uy1UyOtVwzbp+7SF/zuqnNcCYZH2n29BoD7md0lGrD84045/03dTGIZbpsR2pJyQU3r71t6CQ6
        x3nltA96vtxADCqo4tQFL
X-Received: by 2002:a05:6a00:1304:b0:555:6d3f:1223 with SMTP id j4-20020a056a00130400b005556d3f1223mr2484453pfu.60.1665710266150;
        Thu, 13 Oct 2022 18:17:46 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6HVxyk89iaHVTPmNuPIp3Jp0psLtEaR/btiGN+HEm78fRAOyLuT2j53cInOTKP21XZQhz1sA==
X-Received: by 2002:a05:6a00:1304:b0:555:6d3f:1223 with SMTP id j4-20020a056a00130400b005556d3f1223mr2484442pfu.60.1665710265850;
        Thu, 13 Oct 2022 18:17:45 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v14-20020a1709028d8e00b00176e2fa216csm469386plo.52.2022.10.13.18.17.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 18:17:45 -0700 (PDT)
Date:   Fri, 14 Oct 2022 09:17:41 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/5] populate: export the metadump description name
Message-ID: <20221014011741.ky4bml5ythuv3svb@zlang-mailbox>
References: <166553912229.422450.15473762183660906876.stgit@magnolia>
 <166553912788.422450.6797363004980943410.stgit@magnolia>
 <20221013145515.2vx3xy6hnf37777o@zlang-mailbox>
 <Y0g0u5byHQK/aOEz@magnolia>
 <20221013162826.hfs75s33giqmfu4t@zlang-mailbox>
 <Y0hjE3neN2rDhkxw@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0hjE3neN2rDhkxw@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 13, 2022 at 12:12:19PM -0700, Darrick J. Wong wrote:
> On Fri, Oct 14, 2022 at 12:28:26AM +0800, Zorro Lang wrote:
> > On Thu, Oct 13, 2022 at 08:54:35AM -0700, Darrick J. Wong wrote:
> > > On Thu, Oct 13, 2022 at 10:55:15PM +0800, Zorro Lang wrote:
> > > > On Tue, Oct 11, 2022 at 06:45:27PM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > 
> > > > > Not sure why this hasn't been broken all along, but we should be
> > > > > exporting this variable so that it shows up in subshells....
> > > > 
> > > > May I ask where's the subshell which uses $POPULATE_METADUMP?
> > > 
> > > _scratch_xfs_fuzz_metadata does this:
> > > 
> > > 	echo "${fields}" | while read field; do
> > > 		echo "${verbs}" | while read fuzzverb; do
> > > 			__scratch_xfs_fuzz_mdrestore
> > > 				_xfs_mdrestore "${POPULATE_METADUMP}"
> > > 
> > > The (nested) echo piped to while starts subshells.
> > 
> > I'm not so familar with this part, so I didn't a simple test[1], and looks like
> > the PARAM can be seen, even it's not exported. Do I misunderstand something?
> > 
> > Thanks,
> > Zorro
> > 
> > [1]
> > $ echo "$list"
> > a
> > b
> > cc
> > $ PARAM="This's a test"
> > $ echo "$list"|while read c1;do echo "$list"|while read c2;do echo $PARAM;done; done
> > This's a test
> > This's a test
> > This's a test
> > This's a test
> > This's a test
> > This's a test
> > This's a test
> > This's a test
> > This's a test
> 
> Hmm.  I can't figure out why I needed the export here.  It was late one
> night, something was broken, and exporting the variable made it work.
> Now I can't recall exactly what that was and it seems fine without
> it...?
> 
> I guess I'll put it back and rerun the entire fuzz suite to see what
> pops out...

Sure, I don't have objection on this patch, so you can have the RVB when
you change "local POPULATE_METADUMP_DESCR" to lower-case, and show at least
one example about why POPULATE_METADUMP need to be exported in next version.
No push:)

Reviewed-by: Zorro Lang <zlang@redhat.com>

Thanks,
Zorro

> 
> --D
> 
> > > 
> > > > > 
> > > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > > ---
> > > > >  common/populate |    6 +++---
> > > > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > > > 
> > > > > 
> > > > > diff --git a/common/populate b/common/populate
> > > > > index cfdaf766f0..b501c2fe45 100644
> > > > > --- a/common/populate
> > > > > +++ b/common/populate
> > > > > @@ -868,9 +868,9 @@ _scratch_populate_cached() {
> > > > >  	local meta_tag="$(echo "${meta_descr}" | md5sum - | cut -d ' ' -f 1)"
> > > > >  	local metadump_stem="${TEST_DIR}/__populate.${FSTYP}.${meta_tag}"
> > > > >  
> > > > > -	# These variables are shared outside this function
> > > > > -	POPULATE_METADUMP="${metadump_stem}.metadump"
> > > > > -	POPULATE_METADUMP_DESCR="${metadump_stem}.txt"
> > > > > +	# This variable is shared outside this function
> > > > > +	export POPULATE_METADUMP="${metadump_stem}.metadump"
> > > > > +	local POPULATE_METADUMP_DESCR="${metadump_stem}.txt"
> > > > 
> > > > If the POPULATE_METADUMP_DESCR is not shared outside anymore, how about change
> > > > it to lower-case?
> > > 
> > > Ok.
> > > 
> > > --D
> > > 
> > > > >  
> > > > >  	# Don't keep metadata images cached for more 48 hours...
> > > > >  	rm -rf "$(find "${POPULATE_METADUMP}" -mtime +2 2>/dev/null)"
> > > > > 
> > > > 
> > > 
> > 
> 

