Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D3A2E92FCD
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Oct 2023 04:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjJFEgL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Oct 2023 00:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjJFEgK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2023 00:36:10 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796A3F1
        for <linux-xfs@vger.kernel.org>; Thu,  5 Oct 2023 21:36:09 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1c62d61dc96so12701765ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 05 Oct 2023 21:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1696566969; x=1697171769; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=epVD+O3eK3Sh02vYhEYZBr/dPfg5N7O+BozopjtpKCQ=;
        b=yOmxBU/7x4MvHgP5tKcvlkGH0QFmI4Cs2Owzw3yHfej7Xq0Bj+gCgvZVpgPysKz0Xp
         elBlYHrSslEOHUdje7DoMvxBhzK+YDpqusotDfTbiRg/5RgaJzTFytNC9vYIPtqJYUsU
         Bmwe4nIw5ny9ri7NQh7GKgdczkBwQKuEZ7cazOlK+e2kdLP4bu4WOnbNY7Md176xGg0/
         UIm2uV0mD5HK3i8nHRs5fBxTfyPXroiQew433/czxhpTS4UzRvPETBcVNEiBVY3/1zck
         t0MDOqzyE5H7kVQi0/7F9CDAeIZ1hieg7pV9sO1c/xyCzsNF1j0dc5ctKpDNuowzXQjz
         dxSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696566969; x=1697171769;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=epVD+O3eK3Sh02vYhEYZBr/dPfg5N7O+BozopjtpKCQ=;
        b=FEv4aj5Wb4MMX9IWwUn+KvRzfpOSn8odIRQjy0fyk6QdLqN2OvAVpjdms536r4TXyg
         z5sjomiRDBmbzIyYVr5Wgm9hPPbEDg0SAlWGd8ga6NPZPlvwTkrlNaC8qmXcqnm5Kv6p
         5ByFq6EfgY4awXXTQHGblbuGs/GYr0HxJUHnFlShBjjnEdqjqwC66bvmu2elBhe/18Ru
         qONAKy+o6jJ4PLm+G3aptZCg3VCixhrZYPxsqajPqK5bPi/0VxxPhtS9mAd7DCPnNvQ9
         bEUAMLvHJxQegYCU+nIupQel2/ZsmO+oxtqp7nFZjrARHwg8qbsvuegfbjNPqtTkFO4E
         /iqg==
X-Gm-Message-State: AOJu0YwekcfKG7XfytnxQw8DC7AEUsadILeMBcnIfHqFMT7hH/LvE1Vo
        vob+gh29ef5N91GzdVYYQBlGAg==
X-Google-Smtp-Source: AGHT+IF4CgdMwn2K1XihHTYdBud2UfL8L6xkmrOqvGPBf+/ahoJakhghwxlIyVTFT526IoVL83VLtg==
X-Received: by 2002:a17:903:1c9:b0:1c5:f110:efa0 with SMTP id e9-20020a17090301c900b001c5f110efa0mr8258009plh.30.1696566968874;
        Thu, 05 Oct 2023 21:36:08 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id u18-20020a170902e5d200b001c6052152fdsm2665945plf.50.2023.10.05.21.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Oct 2023 21:36:08 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qocZJ-00A4YN-3A;
        Fri, 06 Oct 2023 15:36:05 +1100
Date:   Fri, 6 Oct 2023 15:36:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Daan De Meyer <daan.j.demeyer@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: mkfs.xfs with --protofile does not copy extended attributes into
 the generated filesystem
Message-ID: <ZR+OtcVIsVrJeqMO@dread.disaster.area>
References: <CAO8sHc=UYg7SFh8DWYq6wRet2CW2P8tNr-pWRNJ2wN=+_qW17g@mail.gmail.com>
 <ZR8qWqksNx1kNhvi@dread.disaster.area>
 <20231006042250.GP21298@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231006042250.GP21298@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 05, 2023 at 09:22:50PM -0700, Darrick J. Wong wrote:
> On Fri, Oct 06, 2023 at 08:27:54AM +1100, Dave Chinner wrote:
> > On Thu, Oct 05, 2023 at 10:37:34AM +0200, Daan De Meyer wrote:
> > > Hi,
> > > 
> > > It seems using --protofile ignores any extended attributes set on
> > > source files. I would like to generate an XFS filesystem using
> > > --protofile where extended attributes are copied from the source files
> > > into the generated filesystem. Any way to make this happen with
> > > --protofile?
> > 
> > mkfs.xfs doesn't have a '--protofile' option. It has a '-p <file>'
> > option for specifying a protofile - is that what you mean?
> 
> While we're on the topic, would it also be useful to have a -p switch
> that would copy the fsxattr options as well?

If protofile support is going to be extended then supporting
everything that can be read/set through generic kernel interfaces
would be appropriate...

But I'm not convinced that we should extend protofile support
because mounting the filesytsem and running rsync, xfs_restore, etc
can already do all this stuffi with no development work necessary...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
