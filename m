Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4112C76196
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 00:20:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjDLAUf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 20:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjDLAUe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 20:20:34 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630032D50
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 17:20:33 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id m18so9545181plx.5
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 17:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1681258833;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3Ps2ccXSswrrJcXDPmlmJQwz6LTcVvWcbrmNOQbXncA=;
        b=IzJBqN+pcGkvevM440sjLsW3FeR1lKW/1pQt0m3qGRTfdTyERGzAuL3R08izxJXg8K
         o/CIgZ2nz47OPeJyYFLmBQNbc7Mr+oIXSM3qpN5KXqt5os85mWZzQypfwdsJjjgNn1Wl
         xJbvfpccjgmnqCSdvz4J0If0+ny0F0jiwUPIpAsoGwmZ4Wnpg2QGzgF4UPqfEbch7B7J
         Yp4FuLWvbsyao/QdMxewe7YaXbwR+vwI390vs5iPJB3nX2dDcD9Oq+5MJUOc63xNa4Ld
         Wm2obZVlVyCyeiV8+cAwFuvfdcMqf1WPX/dSwPuSYYPlPzj44+KEvXf72lO3Kas7vnmT
         nuEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681258833;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Ps2ccXSswrrJcXDPmlmJQwz6LTcVvWcbrmNOQbXncA=;
        b=gw9GMWMEoj9v6AsmBW2sI7f8zmGu95ULVIyTCM/JNNCL6LJ2hj0aitJ5Q7otD44NPA
         nHTQl0FFQkpRFb6CgoMMv7iNeHP66flCWEYha6jcnRgjVz9+TLEo2fqUxP+E8P4TIqon
         mrYsJMQP8uD5sbv+9KchbAyGO4Bi5hShGtoVUUUx54p+nt7suJfCKEqJlcPU3CC0Nspu
         axThF4sLv1Yc5viWMl5d+vJVbesXsbqoQqZ37iwBxfkdM1w0BycMkxRWn/J8iCvdPqpO
         JohMfp2FL1JxTuG7Z8w0lov4d4VPQiWR0mcj4QwnFdIiUXcxnu7r9Lb247+/Js2sZ7ny
         IQPw==
X-Gm-Message-State: AAQBX9c7sXO0BvsJ5zZJYjdjFq5tCuDIeVfowu2gwfw2+wUCVd4I25Q7
        Q9HShbHBXCQJ4jOJIqeggSdmnA==
X-Google-Smtp-Source: AKy350bH2iQEjR414ayErz//6KojD/NYPf03O3+fUKe+urYWch9yHh+4Ixl8U2KTOKlUxaQZI96c4Q==
X-Received: by 2002:a17:90b:38c4:b0:23d:35c9:bf1c with SMTP id nn4-20020a17090b38c400b0023d35c9bf1cmr17257944pjb.16.1681258832885;
        Tue, 11 Apr 2023 17:20:32 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id o73-20020a17090a0a4f00b0024677263e36sm161699pjo.43.2023.04.11.17.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 17:20:32 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pmODs-002I7W-Jz; Wed, 12 Apr 2023 10:20:28 +1000
Date:   Wed, 12 Apr 2023 10:20:28 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     allison.henderson@oracle.com, dchinner@redhat.com, hch@lst.de,
        linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE online fsck 1/2] xfs-linux:
 scrub-strengthen-rmap-checking updated to d95b1fa39fab
Message-ID: <20230412002028.GG3223426@dread.disaster.area>
References: <168123761359.4118338.3332729538416597681.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168123761359.4118338.3332729538416597681.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 11, 2023 at 11:29:58AM -0700, Darrick J. Wong wrote:
> Hi folks (mostly Dave),
> 
> The scrub-strengthen-rmap-checking branch of the xfs-linux repository at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git
> 
> has just been updated for your review.  These are all the accumulated
> fixes for online scrub, as well as the design document for the entire
> online fsck effort.
> 
> This code snapshot has been rebased against recent upstream, freshly
> QA'd, and is ready for people to examine.  For veteran readers, the new
> snapshot can be diffed against the previous snapshot; and for new
> readers, this is a reasonable place to begin reading.  For the best
> experience, it is recommended to pull this branch and walk the commits
> instead of trying to read any patch deluge.  Mostly it's tweaks to
> naming and APIs that Dave mentioned last week.

Ok, I've been through all the changes since the last version, it
looks good to me.

Consider the entire series:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
