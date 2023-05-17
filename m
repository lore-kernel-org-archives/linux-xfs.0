Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3C54C7EE24
	for <linux-xfs@archiver.kernel.org>; Wed, 17 May 2023 01:44:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjEQBoH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 May 2023 21:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbjEQBoG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 May 2023 21:44:06 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C931BC3
        for <linux-xfs@vger.kernel.org>; Tue, 16 May 2023 18:44:05 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-6438d95f447so109967b3a.3
        for <linux-xfs@vger.kernel.org>; Tue, 16 May 2023 18:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1684287844; x=1686879844;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k1af6FCYZfX+7lmXHwTRqYGZsIIGWwSUbxjgXmCazEw=;
        b=XtgLTZ4jo4iSymgPO8h0u4HytTfGAeYwhj/uch9NipD1pOLha9k0eCkSs1HT7WQ6xC
         fsm4nOuEUBMqagKYkdqfAt1K15eP8Ht+F2tVgCVhtnU+UzIl6hH/ylh6FGsdgFDinM8t
         lHw972/BAGPyE1gYCk24CDw1rcXTNBJSp1dtbWg/A0qePdJMiUEpq3Pw0TQQ+qYA4stL
         z+Gz+bIX9PfeE6yyT4hMq8sVuLf0oUVAxXg22/J+5FOKaUicv5dpj1VxAZQtuO4ALGKA
         boJzjH9syFqW7qQyAseY4b9yY9z11KeTCptoKtio9Sf8RENSARKrC/3l7haPTv706uha
         5uuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684287844; x=1686879844;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k1af6FCYZfX+7lmXHwTRqYGZsIIGWwSUbxjgXmCazEw=;
        b=MQ4l147cz3Lo8JYOQ8spOnpdefN+tLKOa1K4xNt8UdVhXRL45aPX10vhAXg+nC6/in
         hwCK1xVBay2156gHhgJWXXUNpVYj1MIN3xsChiGu8TKwKsUp9Oa692gHM6vb9PlXTUxg
         o6dJO+8qE2cfTQChsaeJgrOR9dnLkVH/J6p/3OjUHnNjEP3GqORQpYIyALovr7soaZq7
         YoomitD5GVf6w/Xuq863ndbGmVLO18W9vnD0DsIY3ZiuJyfQdR7Y0hGINI2wDcfEQyun
         ieL4/yLUoVMB9aF9DADIp75ElbeRZ2PeiUqzoRDduiYkwryzifYeZ0yizZL4TRFx5m5i
         IjQg==
X-Gm-Message-State: AC+VfDw9UQcye7NERddcANPG7EdAUe6xybPo2PCevY693vOmVaPMMHsd
        GwrSUyZkqf+BbpZ//XsAvj/0wlPum8tjYV0UrAo=
X-Google-Smtp-Source: ACHHUZ4auGB5+O+yhboxROUlidwUrB6zw2OYLzMJiK2Hmb6nAjVEqVRN+/sGKEqxFHp8B5rc+UgOvw==
X-Received: by 2002:a05:6a00:1823:b0:63b:7fc0:a4af with SMTP id y35-20020a056a00182300b0063b7fc0a4afmr48370631pfa.26.1684287844575;
        Tue, 16 May 2023 18:44:04 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id v10-20020aa7808a000000b0063d3fbf4783sm14005209pff.80.2023.05.16.18.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 18:44:04 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1pz6Cw-000NGX-0G;
        Wed, 17 May 2023 11:44:02 +1000
Date:   Wed, 17 May 2023 11:44:02 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: defered work could create precommits
Message-ID: <ZGQxYn/nwtcvw0+M@dread.disaster.area>
References: <20230517000449.3997582-1-david@fromorbit.com>
 <20230517000449.3997582-4-david@fromorbit.com>
 <20230517012059.GO858799@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517012059.GO858799@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 16, 2023 at 06:20:59PM -0700, Darrick J. Wong wrote:
> On Wed, May 17, 2023 at 10:04:48AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > To fix a AGI-AGF-inode cluster buffer deadlock, we need to move
> > inode cluster buffer oeprations to the ->iop_precommit() method.
> 
>                        operations
> 
> > However, this means that deferred operations can require precommits
> > to be run on the final transaction that the deferred ops pass back
> > to xfs_trans_commit() context. This will be exposed by attribute
> > handling, in that the last changes to the inode in the attr set
> > state machine "disappear" because the precommit operation is not run.
> 
> Wait, what?

That was exactly the reaction I had when attribute tests failed
unexpectedly. Then a quick bit of traceprintk debugging (which I
probably forgot to remove!) pointed me at shortform attr updates
where no precommit was running...

> OH, this is because the LARP state machine can log the inode in the
> final transaction in its chain.  __xfs_trans_commit calls the noroll
> variant of xfs_defer_finish, which means that when we get to...

Yes.

> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_trans.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index 8afc0c080861..664084509af5 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -970,6 +970,11 @@ __xfs_trans_commit(
> >  		error = xfs_defer_finish_noroll(&tp);
> >  		if (error)
> >  			goto out_unreserve;
> 
> ...here, tp might actually be a dirty transaction.  Prior to
> xlog_cil_committing the dirty transaction, we need to run the precommit
> hooks or else we don't actually (re)attach the inode cluster buffer to
> the transaction, and everything goes batty from there.  Right?

Yes.

> This isn't specific to LARP; any defer item that logs an item with a
> precommit hook is subject to this.  Right?

Yes.

But right now, the only precommit hook is the unlinked inode
processing, which doesn't run from defer-ops context...

> > +
> > +		/* Run precomits from final tx in defer chain */
> 
>                        precommits
> 
> If the answers to the last 2 questions are 'yes' and the spelling errors
> get fixed, I think I'm ok enough with this one to throw it at
> fstestscloud.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!

-Dave.

-- 
Dave Chinner
david@fromorbit.com
