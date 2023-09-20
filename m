Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30D8FCE79AD
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Sep 2023 05:53:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbjITFxv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Sep 2023 01:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjITFxv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2023 01:53:51 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E4894
        for <linux-xfs@vger.kernel.org>; Tue, 19 Sep 2023 22:53:45 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-690f7d73a3aso60751b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 19 Sep 2023 22:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1695189224; x=1695794024; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fyvicw7DvbDcButhDiTfGTTUtQ6dxKBZ+I6EO47ZTDo=;
        b=rPBaquPRPXeCYzQJkv1ZeSdIN/7sjegEmomQHTMYgrXjxqzmobyJXent7wUAHpWkF9
         llg3UyKzKRi787pzxay0Gks0z+Xjah6ZGNsCDxBo0Y9fsweFlEDgY2RPE6jxiTe+HaDw
         C5JGvs62yHnYUZl51VHulZSqdYjUGwh40/1eu2z06D0VEFXXEoQoXDrkdYw8bNL+SlzI
         rgN3t4cRqMt8+vc47s0vXJTmTtx2VlRDuhUdSelUIftsick9yBb/mWgP0E3KP+GyhzYw
         GCReX53DHacoN8RnGdgL6PP6TCRcQqY5rXX/DtUvDFRtQ4l+WArR7abBURvnjGeFQcIw
         /yfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695189224; x=1695794024;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fyvicw7DvbDcButhDiTfGTTUtQ6dxKBZ+I6EO47ZTDo=;
        b=cos5eB0tQagiymXgoAev1oh9hM41x8iev2Fpjv4ins5H30yhGGIkhHIlSCKS/wOybZ
         0AWLzITgtOqZe3P8d6AfiQzeiZV0ZrUAdcc9ArzK+qoPzdcon8W0ExGNYzJGNA6PqG6A
         Lb0srY1mEWajTNC79Dw/YpvV6Nn6oLcRmFtib0k+dyfemD/Fe0HA+ZQPeKmQ5pqN9baH
         45uhMDMxnNgOkXGrl1kIy0LdcWmF7n8T5bhqA5XMoe58cEYp3G2yBENbd/PWxbXHOB3/
         HfZx4j6admFQL9MkcSmtWhgnZ/Ohijz+8g3NEXYyZytNdbGqlv/J5KU6OarylQStMZdk
         A8wg==
X-Gm-Message-State: AOJu0YwNG1Z1iBJBN1TbOpm4DRHaTwhiv/saFiu/0ij2EgV7lPdJskGW
        qjFDNFaUxo1AP5XpQOsUXmqhqjIIYdcxTIbTsk0=
X-Google-Smtp-Source: AGHT+IEJKUOpY208HTFnypvLTJpWQ5nb5Rd6AOYCZ5qoM/Gj/Hl3x2j3X29CxoCPYZcw7SOgYXMusg==
X-Received: by 2002:a05:6a20:7d88:b0:13a:43e8:3fb5 with SMTP id v8-20020a056a207d8800b0013a43e83fb5mr1953730pzj.51.1695189224593;
        Tue, 19 Sep 2023 22:53:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id 27-20020a17090a031b00b0026fa1931f66sm589981pje.9.2023.09.19.22.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Sep 2023 22:53:44 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qiq9c-0036M3-2i;
        Wed, 20 Sep 2023 15:53:40 +1000
Date:   Wed, 20 Sep 2023 15:53:40 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cheng.lin130@zte.com.cn, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, jiang.yong5@zte.com.cn,
        wang.liang82@zte.com.cn, liu.dong3@zte.com.cn
Subject: Re: [PATCH v3] xfs: introduce protection for drop nlink
Message-ID: <ZQqI5KNgghI5iFrC@dread.disaster.area>
References: <ZQeBY3kmww8qAjfP@dread.disaster.area>
 <202309181144537682244@zte.com.cn>
 <ZQfktqPJ5Qzs7unT@dread.disaster.area>
 <20230919033335.GF348018@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230919033335.GF348018@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 18, 2023 at 08:33:35PM -0700, Darrick J. Wong wrote:
> On Mon, Sep 18, 2023 at 03:48:38PM +1000, Dave Chinner wrote:
> > It is only when we are trying to modify something that corruption
> > becomes a problem with fatal consequences. Once we've made a
> > modification, the in-memory state is different to the on-disk state
> > and whilst we are in that state any corruption we discover becomes
> > fatal. That is because there is no way to reconcile the changes
> > we've already made in memory with what is on-disk - we don't know
> > that the in-memory changes are good because we tripped over
> > corruption, and so we must not propagate bad in-memory state and
> > metadata to disk over the top of what may be still be uncorrupted
> > metadata on disk.
> 
> It'd be a massive effort, but wouldn't it be fun if one could attach
> defer ops to a transaction that updated incore state on commit but
> otherwise never appeared on disk?
>
> Let me cogitate on that during part 2 of vacation...

Sure, I'm interested to see what you might come up with.

My thoughts on rollback of dirty transactions come from a different
perspective.

Conceptually being able to roll back individual transactions isn't
that difficult. All it takes is a bit more memory and CPU - when we
join the item to the transaction we take a copy of the item we are
about to modify.

If we then cancel a dirty transaction, we then roll back all the
dirty items to their original state before we unlock them.  This
works fine for all the on-disk stuff we track in log items.

I have vague thoughts about how this could potentially be tied into
the shadow buffers we already use for keeping a delta copy of all
the committed in-memory changes in the CIL that we haven't yet
committed to the journal - that's actually the entire delta between
what is on disk and what we've changed prior to the current
transaction we are cancelling.

Hence, in theory, a rollback for a dirty log item is simply "read it
from disk again, copy the CIL shadow buffer delta into it".

However, the complexity comes with trying to roll back associated
in-memory state changes that we don't track as log items.  e.g.
incore extent list changes, in memory inode flag state (e.g.
XFS_ISTALE), etc. that's where all the hard problems to solve lie, I
think.

Another problem is how do we rollback from the middle of an intent
(defer ops) chain? We have to complete that chain for things to end
up consistent on disk, so we can't just cancel the current
transaction and say we are done and everything is clean.  Maybe
that's what you are thinking of here - each chain has an "undo"
intent chain that can roll back all the changes already made?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
