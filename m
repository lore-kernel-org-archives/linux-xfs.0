Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21EFCC3DA78
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Jan 2023 20:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbjAMULY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Jan 2023 15:11:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjAMULX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Jan 2023 15:11:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E068F88A3D
        for <linux-xfs@vger.kernel.org>; Fri, 13 Jan 2023 12:10:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673640640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rED86BZTa2+y92QALSBGJH4WIbHXICXT8jHSNDAfqm8=;
        b=ejhwm8Kw1VCOXYyuioadR75EQJM6R+cYMah5srPDAkJETEsF4kmvXumuFlV6TrPrUXokM9
        wrNRd0o6EOzOsPNVT/9bYrVvu69/Ws3eLBLYLk75hdCzNQwLHa1Pa/S3ZtOaMzOGLN2LB2
        v3zGMDMBI3Yn78nCv4P3CIdUfhM8S7I=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-605-4HzI92oKOY62hzxnTLeR_w-1; Fri, 13 Jan 2023 15:10:38 -0500
X-MC-Unique: 4HzI92oKOY62hzxnTLeR_w-1
Received: by mail-pl1-f197.google.com with SMTP id c17-20020a170902d49100b00192be705f76so15553848plg.13
        for <linux-xfs@vger.kernel.org>; Fri, 13 Jan 2023 12:10:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rED86BZTa2+y92QALSBGJH4WIbHXICXT8jHSNDAfqm8=;
        b=mY06MXGXPj5uUcZCavIZzu1SVpFf5rrpwjDFAzkOCcrms+isjqdXdPiiwIwtUk2RzM
         lky/2MhTo0Q8rGf/tECCUk9EvMvBnBLAvW3RJxsdsalUcK3KhiXmPwan48SyPxpVfCW0
         GRqF0fkLQO+z8gvB4IJi2vNtIEhgaZTeX43ptXm68k2YAea/ovxE5e80ArFJEYRgCnf1
         HZeySklB0OoxYi+HKehP10sVJzWQ1Iyno6mAtOAh858zWb5PPDiwJ6qFUs4gNEsS+3kp
         RKqLlAzDuA5AT3glctLg9uD/AoGKWNWZ4xEEWqkKEAQyy3+iJeR+0lMCHY9guZWuttcO
         +NqQ==
X-Gm-Message-State: AFqh2koEcIVymnx1erc0RsZ6Xbx+norAggg8Dedxi+C9rH1Y/KSWkoex
        jUHoIWT/OBGREhmvqr6JpoI39ixIMr2zO05aHLuWQXe4sUc211vFoxKPM3qmxqTCJW2RHg8BDIc
        uifbhcR4ggfxNWKqNzlMv
X-Received: by 2002:a17:90a:bb03:b0:225:a226:9fbb with SMTP id u3-20020a17090abb0300b00225a2269fbbmr80587602pjr.39.1673640637900;
        Fri, 13 Jan 2023 12:10:37 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvM38vHUcZYBj0DdseVmrXZUaSEI6IFXSkhYkERPDYaF5PRjPd3yuHTwEfk82n337WALECtBQ==
X-Received: by 2002:a17:90a:bb03:b0:225:a226:9fbb with SMTP id u3-20020a17090abb0300b00225a2269fbbmr80587587pjr.39.1673640637621;
        Fri, 13 Jan 2023 12:10:37 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id y4-20020a17090ad0c400b00218fb3bec27sm12944531pjw.56.2023.01.13.12.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 12:10:37 -0800 (PST)
Date:   Sat, 14 Jan 2023 04:10:33 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
Subject: Re: [NYE DELUGE 1/4] xfs: all pending online scrub improvements
Message-ID: <20230113201033.h2otptldp232pz3p@zlang-mailbox>
References: <Y69UceeA2MEpjMJ8@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y69UceeA2MEpjMJ8@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 30, 2022 at 01:13:21PM -0800, Darrick J. Wong wrote:
> Hi everyone,
> 
> As I've mentioned several times throughout 2022, I would like to merge
> the online fsck feature in time for the 2023 LTS kernel.  The first big
> step in this process is to merge all the pending bug fixes, validation
> improvements, and general reorganization of the existing metadata
> scrubbing functionality.
> 
> This first deluge starts with the design document for the entirety of
> the online fsck feature.  The design doc should be familiar to most of
> you, as it's been on the list for review for months already.  It
> outlines in brief the problems we're trying to solve, the use cases and
> testing plan, and the fundamental data structures and algorithms
> underlying the entire feature.
> 
> After that come all the code changes to wrap up the metadata checking
> part of the feature.  The biggest piece here is the scrub drains that
> allow scrub to quiesce deferred ops targeting AGs so that it can
> cross-reference recordsets.  Most of the rest is tweaking the btree code
> so that we can do keyspace scans to look for conflicting records.
> 
> For this review, I would like people to focus the following:
> 
> - Are the major subsystems sufficiently documented that you could figure
>   out what the code does?
> 
> - Do you see any problems that are severe enough to cause long term
>   support hassles? (e.g. bad API design, writing weird metadata to disk)
> 
> - Can you spot mis-interactions between the subsystems?
> 
> - What were my blind spots in devising this feature?
> 
> - Are there missing pieces that you'd like to help build?
> 
> - Can I just merge all of this?
> 
> The one thing that is /not/ in scope for this review are requests for
> more refactoring of existing subsystems.  While there are usually valid
> arguments for performing such cleanups, those are separate tasks to be
> prioritized separately.  I will get to them after merging online fsck.
> 
> I've been running daily online scrubs of every computer I own for the
> last five years, which has helped me iron out real problems in (limited
> scope) production.  All issues observed in that time have been corrected
> in this submission.

The 3 fstests patchsets of the [NYE DELUGE 1/4] look good to me. And I didn't
find more critical issues after Darrick fixed that "group name missing" problem.
By testing it a whole week, I decide to merge this 3 patchsets this weekend,
then we can shift to later patchsets are waiting for review and merge.

Reviewed-by: Zorro Lang <zlang@redhat.com>

Thanks,
Zorro

> 
> As a warning, the patches will likely take several days to trickle in.
> All four patch deluges are based off kernel 6.2-rc1, xfsprogs 6.1, and
> fstests 2022-12-25.
> 
> Thank you all for your participation in the XFS community.  Have a safe
> New Years, and I'll see you all next year!
> 
> --D
> 

