Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F764C77B6E
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Apr 2023 15:45:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbjDMPo6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Apr 2023 11:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbjDMPo6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2023 11:44:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15FD710FC
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 08:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681400646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=squ5eir7T6UxKskfuIHNw09rOCoZSHwkrvOiBeWIBqo=;
        b=I+Ci2MKlrp43+jyZkMSvh05BfL7DLFEJ+nWLTI+domVnkc1VGMo+WpbAGdEFiwsTtk7SK9
        Q0Q/FCpfWC5f3jJw6ud74sV7hCX3j579CCwEmlMpQve9TUnkigGF0LxyWW3OobzlcKfDbM
        +Rhhy27TOHpsiE1KEhri+bt9iYFHOcQ=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-lJyLPDP8OWy5jGQSOfEDkg-1; Thu, 13 Apr 2023 11:44:05 -0400
X-MC-Unique: lJyLPDP8OWy5jGQSOfEDkg-1
Received: by mail-qv1-f71.google.com with SMTP id l1-20020a0cc201000000b005ad0ce58902so7492133qvh.5
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 08:44:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681400644; x=1683992644;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=squ5eir7T6UxKskfuIHNw09rOCoZSHwkrvOiBeWIBqo=;
        b=fkIWu1honzsceBgY6MmKdP7LT200QhdM+y+Pvbh92E/NoZ0joNHCGe72wNNlszd5na
         TvdRQAulmb37nI9KOdV3a2nKluYVh7z3M850Y3NDwGT/GIkpRN1DzTcdu7c2yn3Q8Zw8
         567RSChk9WEEisCJwnqcWv1NdXsAvOrgrw8nbCFZiedFoRoiXuuV1RUUqp/ry0xfG2Cs
         Rl8WA9XL2uZWtKwUR6Fq2tjimq2YkR8U2gRlbrtEYVNO8t5+PsxYcUhPyR06igu2dh1l
         OOHoMaipg1a6KCcsGSEFed4jqooa2bH0rgaWFnCYC8kWADDp3rHxLC61elG0HheukuWf
         LBpQ==
X-Gm-Message-State: AAQBX9cMWAb6f4zQza8ne7Ah8xFUY+N5SK3G5FTfLS2GV/fKDHXds/mP
        e3FiE6V/RDgaGOr8KIJ0ZwChpQJurYtbNCo2/eHwzhs92AONZkBlZpQP4eAuGMRK9o9ljq6UEuQ
        iomhUWmMGvR65d4ID+dc=
X-Received: by 2002:ac8:7f89:0:b0:3bf:d1c6:d375 with SMTP id z9-20020ac87f89000000b003bfd1c6d375mr3262191qtj.36.1681400644706;
        Thu, 13 Apr 2023 08:44:04 -0700 (PDT)
X-Google-Smtp-Source: AKy350YTWPIyg97x0Ux9S/G0S7I+ShE0QA+aAE5p3auD4U7HismQi6v5oQ30ApllDP3Eo85KitikFA==
X-Received: by 2002:ac8:7f89:0:b0:3bf:d1c6:d375 with SMTP id z9-20020ac87f89000000b003bfd1c6d375mr3262131qtj.36.1681400643990;
        Thu, 13 Apr 2023 08:44:03 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id c3-20020ac84e03000000b003e635f0fdb4sm572602qtw.53.2023.04.13.08.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 08:43:59 -0700 (PDT)
Date:   Thu, 13 Apr 2023 17:43:52 +0200
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCHSET 0/3] fstests: direct specification of looping test
 duration
Message-ID: <20230413154352.v55cc3tfhezxlw5s@aalbersh.remote.csb>
References: <168123682679.4086541.13812285218510940665.stgit@frogsfrogsfrogs>
 <20230413104836.zw2uoe4mhocs3afz@aalbersh.remote.csb>
 <20230413144708.GL360895@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413144708.GL360895@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 13, 2023 at 07:47:08AM -0700, Darrick J. Wong wrote:
> On Thu, Apr 13, 2023 at 12:48:36PM +0200, Andrey Albershteyn wrote:
> > >  tests/generic/648     |    8 +++--
> > >  17 files changed, 229 insertions(+), 13 deletions(-)
> > >  create mode 100644 src/soak_duration.awk
> > > 
> > 
> > The set looks good to me (the second commit has different var name,
> > but fine by me)
> 
> Which variable name, specifically?

STRESS_DURATION in the commit message

-- 
- Andrey

