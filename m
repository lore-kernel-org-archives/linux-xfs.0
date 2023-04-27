Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51149C77B61
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Apr 2023 05:26:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242702AbjD0F0J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 01:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjD0F0I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2023 01:26:08 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19736268A
        for <linux-xfs@vger.kernel.org>; Wed, 26 Apr 2023 22:26:05 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1a5197f00e9so62770145ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 26 Apr 2023 22:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682573164; x=1685165164;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SjvRKFkHA3gmBHkz0pe9hpP1vXfg9LF/OXzM+nsooLU=;
        b=XwAjl6+eqTR0ewkviOfBCMCKUZa4X47fuvokkqrxPfNsBIDC0gPiJW6YdwCh93QtI4
         cI6PQvqBvDt2FnVpV89m0wtLGFDwCIgXhX9HAa3OxqZYqxXvY9uAtkQ2KnbV7SUCtd+T
         5q0zo0U/xDxgnNl2S3Kcgw9RId7uGjVtzEkAzvjEbRN8r2qqFg/vCe19NmCXsFweedA5
         gpFdjMlzVBVkpQdTKF4PlV/Xtm+WKejvQhmVYopwtL4Rfa9+e8Te4V3A4SrXt+C+vbSY
         5R/+t9gBnD2B+ePGK+Ma07LCzVSUgKiEW8EouvOnpGEOMAI7MfDvNe6quiFQHL5M8X8j
         iN1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682573164; x=1685165164;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SjvRKFkHA3gmBHkz0pe9hpP1vXfg9LF/OXzM+nsooLU=;
        b=C/jF4kdV4HproA/WMt3EulbGk3JOIibrbxmnsEq5ReGev59K/ve4s/HZmtvVU+ezQP
         X5K13n1xgYLQHgFYR7OvhTE5DWeqLA482mz+GIpHFAF3IrxGNkjMqoTmvGpNF4Y/ygyh
         sJZkCIPDInms81DahcihcIjIDJZpw7vyYyugl3Wt3u2qQlG9hVxsTUBQ2YZpsieCz8NC
         kEZ2ZN2008BJNSkAJzVqp6BN0z1KJCTwQLYXJ8X7DZq61StbgVY50sIXywuUqfFyxNOr
         YJ67yX0Ri+zonF7jRApEF6Rjn6QKmn56U2DDHDQKKQ9f3/e3O7mKd51SThfDgBFBmAS9
         O4eA==
X-Gm-Message-State: AC+VfDxvCW5+zQMDoo2IkpBpL1P4aEl/BihtRBq44q48h7D/CVl1B/Qc
        GwWvg4g0/fVjYreLZkBOwMT8+DS1uwojuhN4yPY=
X-Google-Smtp-Source: ACHHUZ74PSquwAlu9iLF/I5K/LvU5/z7dSW9J9DxSTuMYHlsk9jFCWv2eA+4oZ+WbSeHzpaZBqDMBg==
X-Received: by 2002:a17:902:b203:b0:1a5:1f13:67fc with SMTP id t3-20020a170902b20300b001a51f1367fcmr301332plr.31.1682573164488;
        Wed, 26 Apr 2023 22:26:04 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id y9-20020a170902864900b001a800e03cf9sm10705091plt.256.2023.04.26.22.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 22:26:03 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pru8m-008Mnn-Oa; Thu, 27 Apr 2023 15:26:00 +1000
Date:   Thu, 27 Apr 2023 15:26:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH] xfs: fix livelock in delayed allocation at ENOSPC
Message-ID: <20230427052600.GM3223426@dread.disaster.area>
References: <20230421222440.2722482-1-david@fromorbit.com>
 <20230425152052.GT360889@frogsfrogsfrogs>
 <20230426230135.GJ3223426@dread.disaster.area>
 <20230426233831.GB59245@frogsfrogsfrogs>
 <20230427001124.GL3223426@dread.disaster.area>
 <20230427005333.GC59245@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427005333.GC59245@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 26, 2023 at 05:53:33PM -0700, Darrick J. Wong wrote:
> On Thu, Apr 27, 2023 at 10:11:24AM +1000, Dave Chinner wrote:
> > On Wed, Apr 26, 2023 at 04:38:31PM -0700, Darrick J. Wong wrote:
> > > I also added a su=128k,sw=4 config to the fstests fleet and am now
> > > trying to fix all the fstests bugs that produce incorrect test failures.
> > 
> > The other thing I noticed is a couple of the FIEMAP tests fail
> > because they find data blocks where they expect holes such as:
> > 
> > generic/225 21s ... - output mismatch (see /home/dave/src/xfstests-dev/results//xfs_align/generic/225.out.bad)
> >     --- tests/generic/225.out   2022-12-21 15:53:25.479044361 +1100
> >     +++ /home/dave/src/xfstests-dev/results//xfs_align/generic/225.out.bad      2023-04-26 04:24:31.426016818 +1000
> >     @@ -1,3 +1,79 @@
> >      QA output created by 225
> >      fiemap run without preallocation, with sync
> >     +ERROR: FIEMAP claimed there was data at a block which should be a hole, and FIBMAP confirmend that it is in fact a hole, so FIEMAP is wrong: 35
> >     +ERROR: found an allocated extent where a hole should be: 35
> >     +map is 'DHDDHHDDHDDHHHHDDDDDHHHHHHHDHDDDHHDHDHHHHHDDHDDHHDDHDHHDDDHHHHDDDDHDHHDDHHHDDDDHHDHDDDHHDHDDDHDHHHHHDHDHDHDHHDDHDHHHHDHHDDDDDDDH'
> >     +logical: [      27..      27] phys:       67..      67 flags: 0x000 tot: 1
> >     +logical: [      29..      31] phys:       69..      71 flags: 0x000 tot: 3
> >     ...
> >     (Run 'diff -u /home/dave/src/xfstests-dev/tests/generic/225.out /home/dave/src/xfstests-dev/results//xfs_align/generic/225.out.bad'  to see the entire diff)
> > 
> > I haven't looked into this yet, but nothing is reporting data
> > corruptions so I suspect it's just the stripe aligned allocation
> > leaving unwritten extents in places the test is expecting holes to
> > exist...
> 
> That's the FIEMAP tester program not expecting that areas of the file
> that it didn't write to can have unwritten extents mapped.  I'm testing
> patches to fix all that tonight too.  If I can ever get these %#@%)#%!!!
> orchestration scripts to work correctly.

OK.

FWIW, I've just found another bug in the stripe aligned allocation
at EOF that is triggered by the filestreams code hitting ENOSPC
conditions. xfs/170 seems to hit it fairly reliably - it's marking
args->pag as NULL and not resetting the caller pag correctly and the
high level filestreams failure code is expecting args->pag to be set
because it owns the reference...

I hope to have a fix for that one on the list this afternoon....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
