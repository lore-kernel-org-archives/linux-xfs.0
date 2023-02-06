Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A220C05027
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Feb 2023 23:14:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjBFXOE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Feb 2023 18:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjBFXOD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Feb 2023 18:14:03 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64E930E4
        for <linux-xfs@vger.kernel.org>; Mon,  6 Feb 2023 15:13:35 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id bg10-20020a17090b0d8a00b00230c7f312d4so3614394pjb.3
        for <linux-xfs@vger.kernel.org>; Mon, 06 Feb 2023 15:13:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VtiKyis8wROJvySNhhFxr+CO0/6MKvixB6wldUx5mPM=;
        b=V9yv43Ox2Z0JcVE0FfF0qsTc+JM+rOocUyu7xAk9AwHQzjLR/NHJtSZZ1IKCImPpet
         GO54+uawQCEgUoI6H9AHtv68nLXZbLAzGjH0+WNyO+j3ak60eo4VRT2IqEsxKWdF6g93
         SApi++sWR0+jMXzFVArUJhu7++ozkouH81ixLFL7s9HGEYI8mcDV2KtUUL9jk8ilELXW
         Ay+FtWV1910vSQSBGgqHc8MXBdaMZOduoRZwE2auP9IoVH5WeaTEo+D191tzoFTnDky+
         kYvTTq2hQue4uFvoRw6dR09Odu5qCHFymyb3WUNoZaP9AUl88va8NdzNkMH1kPuU+IYn
         hLRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VtiKyis8wROJvySNhhFxr+CO0/6MKvixB6wldUx5mPM=;
        b=QWbf42gmHNu8QIXHF/I1wcJMlZ1QBemjdqrO0PGVkYN4fKOyUFkvfsdY9vziKxmY6H
         k1lxVPHW94dLX7TTjMh4NmjEnZeQRt0JjELxCCn11CONkq/pnChDAYl0XYJGUJCpE+CJ
         DFYh1NzqiBJUnkTGxSV86IUIT6ppgppUdus7/uSSlk2IAU+BH7qZq1Wp8RBGNv6Eaaqj
         aIWZS/S36KPLji7pNCnEySHqmz3wJ7LJ3JVTxy4W8UtL/kw3X5YpC9MdQb3eRNwa9EbC
         dxKQ+zT77cgd8kOcQp3uJyyftWrV402Bjtr5Izz9Z43VLvbbsprYVSa0aknfCbArrt7V
         QaaQ==
X-Gm-Message-State: AO0yUKVJSGPMrFVKexGqLma8wteuxLR5Ui3sy7roWqtAvS8a076qLucw
        TmW28+cbxYFGH2evGsQNq7AbVc3ZtCWeowvF
X-Google-Smtp-Source: AK7set/5n+xAbg//apAJZyFEKX1E4T5QWmB3yO2BWZOHAa904DzK19qo0IGGaB1APhMlA8uW69qPDA==
X-Received: by 2002:a17:903:41ca:b0:198:d004:bfa0 with SMTP id u10-20020a17090341ca00b00198d004bfa0mr693499ple.15.1675725215216;
        Mon, 06 Feb 2023 15:13:35 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id c2-20020a170902b68200b00194c2f78581sm7384992pls.199.2023.02.06.15.13.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 15:13:34 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pPAfz-00CDw0-S4; Tue, 07 Feb 2023 10:13:31 +1100
Date:   Tue, 7 Feb 2023 10:13:31 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/42] xfs: per-ag centric allocation alogrithms
Message-ID: <20230206231331.GW360264@dread.disaster.area>
References: <20230118224505.1964941-1-david@fromorbit.com>
 <Y9sAXRqdBESTHMSC@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9sAXRqdBESTHMSC@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 01, 2023 at 04:14:21PM -0800, Darrick J. Wong wrote:
> On Thu, Jan 19, 2023 at 09:44:23AM +1100, Dave Chinner wrote:
> > This series continues the work towards making shrinking a filesystem
> > possible.  We need to be able to stop operations from taking place
> > on AGs that need to be removed by a shrink, so before shrink can be
> > implemented we need to have the infrastructure in place to prevent
> > incursion into AGs that are going to be, or are in the process, of
> > being removed from active duty.
> > 
> > The focus of this is making operations that depend on access to AGs
> > use the perag to access and pin the AG in active use, thereby
> > creating a barrier we can use to delay shrink until all active uses
> > of an AG have been drained and new uses are prevented.
> > 
> > This series starts by fixing some existing issues that are exposed
> > by changes later in the series. They stand alone, so can be picked
> > up independently of the rest of this patchset.
> 
> Hmm if I had to pick up only the bugfixes, which patches are those?
> Patches 1-3 look like bug fixes, 4-6 might be but might not be?

1-3 are bug fixes. 4-6 are dependent on 1 and they expand the range
of AGs that can be allocated in when a single AG is at ENOSPC. We
have had users reporting premature ENOSPC being reported to
applications in this exact situation in the past (maybe half a dozen
in the past decade or so?), so it is a bug fix of sorts. It's not a
critical bug fix, though, as it's not a common problem.

.....
> 
> For all the patches that I have not sent replies to,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> IIRC that's patches 1-6, 8, 10-13, 16, 18-19, 24-27, and 30-40.

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
