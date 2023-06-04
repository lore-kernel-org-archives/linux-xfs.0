Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D4EFC7EE29
	for <linux-xfs@archiver.kernel.org>; Sun,  4 Jun 2023 22:59:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbjFDW7j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 4 Jun 2023 18:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjFDW7i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Jun 2023 18:59:38 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D88CD
        for <linux-xfs@vger.kernel.org>; Sun,  4 Jun 2023 15:59:37 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id e9e14a558f8ab-33d0b7114a9so21312735ab.2
        for <linux-xfs@vger.kernel.org>; Sun, 04 Jun 2023 15:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1685919577; x=1688511577;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E2iPK5M0CDqfau6CWyhKCIlEMLXEYnMBjg6mEkhZy8g=;
        b=Kptam07sYNPBh/u/XnT6d4ALltNIowDolWN0RCqNG0PpJ8W3WkMlADpoD0Hqtbag5y
         gjR8S0SySZqYHqCt5V1P6du9JRvG4J8xTuiRH6RX9ODw0j21VGyivy2xU4l1he5BbwCI
         4UJ9HYzzwNwcHS6p7+hn87GM90xVXEz4d7BtMh33rV9KofQRIRlCYjUgeiaHaIzxkrVg
         5SwEZ76XklgpHRN1PejPYw2AbFErc8BWLvYVjzVUN7A76cp+6DSX8g0xJUC6CM/2ChN8
         tOO61m7IpL/SzA2MkfhZaU4ce4huc9GC8rS3QRwlwb5RnfzgYia0q9nxKI7cVwVhPZU3
         V/AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685919577; x=1688511577;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E2iPK5M0CDqfau6CWyhKCIlEMLXEYnMBjg6mEkhZy8g=;
        b=gSwrhZbBMsp1jFLwxiq0uzAHXBkjcgkx/+oVRikXNt9BcM7SMnGcgCmIFlRfeJEgTD
         tTaJktlV3BBkIOYSsAt9dCRogx4sbm9NWehjtTNuii4qrYTsABDVpN33eCdMSwIq83tM
         KAEOD9l247TD0uKklrZHZYAn87wrwwYP2j3Dmlm/uJfASNmrvvjs8lc+Hx2WhcBzYpwZ
         fSjzlsYz75nCDi+XcT5Fy9UZW1F0sj5I2YTO6yfO5RMTIUYkAscLXVETzCdCd60j1Zpb
         Qcmkfan1A+8uYtx0EM/hZd8e+2oPL3SJKyAnmWY2886tzRgtk0t9GOdO7spfLHSzq5wu
         X80Q==
X-Gm-Message-State: AC+VfDzzN+LbkhbPHCAShVXfaZyHVcElBaWY1lRlC7nTLxpxRnfQhZBP
        qB2zmze02ee7twOBScTrvTrSEg==
X-Google-Smtp-Source: ACHHUZ7OilUJScOvJ3EACAAzeCMh4d2/g++qP0Rx1Q9e0t7noXEKnHJuSllSyMG4RXQ+Ir3WJVpwXA==
X-Received: by 2002:a92:cf43:0:b0:33b:7e4:167a with SMTP id c3-20020a92cf43000000b0033b07e4167amr19058578ilr.15.1685919577143;
        Sun, 04 Jun 2023 15:59:37 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-79-151.pa.nsw.optusnet.com.au. [49.179.79.151])
        by smtp.gmail.com with ESMTPSA id a6-20020aa78646000000b0064d4d11b8bfsm4039524pfo.59.2023.06.04.15.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jun 2023 15:59:36 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q5whB-007rsb-34;
        Mon, 05 Jun 2023 08:59:33 +1000
Date:   Mon, 5 Jun 2023 08:59:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, miklos@szeredi.hu,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: uuid ioctl - was: Re: [PATCH] overlayfs: Trigger file
 re-evaluation by IMA / EVM after writes
Message-ID: <ZH0XVWBqs9zJF69X@dread.disaster.area>
References: <20230407-trasse-umgearbeitet-d580452b7a9b@brauner>
 <078d8c1fd6b6de59cde8aa85f8e59a056cb78614.camel@linux.ibm.com>
 <20230520-angenehm-orangen-80fdce6f9012@brauner>
 <ZGqgDjJqFSlpIkz/@dread.disaster.area>
 <20230522-unsensibel-backblech-7be4e920ba87@brauner>
 <20230602012335.GB16848@frogsfrogsfrogs>
 <20230602042714.GE1128744@mit.edu>
 <ZHmNksPcA9tudSVQ@dread.disaster.area>
 <20230602-dividende-model-62b2bdc073cf@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602-dividende-model-62b2bdc073cf@brauner>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 02, 2023 at 03:52:16PM +0200, Christian Brauner wrote:
> On Fri, Jun 02, 2023 at 04:34:58PM +1000, Dave Chinner wrote:
> > On Fri, Jun 02, 2023 at 12:27:14AM -0400, Theodore Ts'o wrote:
> > > On Thu, Jun 01, 2023 at 06:23:35PM -0700, Darrick J. Wong wrote:
> > There's an obvious solution: a newly provisioned filesystem needs to
> > change the uuid at first mount. The only issue is the
> > kernel/filesystem doesn't know when the first mount is.
> > 
> > Darrick suggested "mount -o setuuid=xxxx" on #xfs earlier, but that
> > requires changing userspace init stuff and, well, I hate single use
> > case mount options like this.
> > 
> > However, we have a golden image that every client image is cloned
> > from. Say we set a special feature bit in that golden image that
> > means "need UUID regeneration". Then on the first mount of the
> > cloned image after provisioning, the filesystem sees the bit and
> > automatically regenerates the UUID with needing any help from
> > userspace at all.
> > 
> > Problem solved, yes? We don't need userspace to change the uuid on
> > first boot of the newly provisioned VM - the filesystem just makes
> > it happen.
> 
> systemd-repart implements the following logic currently: If the GPT
> *partition* and *disk* UUIDs are 0 then it will generate new UUIDs
> before the first mount.
> 
> So for the *filesystem* UUID I think the golden image should either have
> the UUID set to zero as well or to a special UUID. Either way, it would
> mean the filesystem needs to generate a new UUID when it is mounted the
> first time.
> 
> If we do this then all filesystems that support this should use the same
> value to indicate "generate new UUID".

Ok, the main problem here is that all existing filesystem
implementations don't consider a zero UUID special. If you do this
on an existing kernel, it won't do anything and will not throw any
errors. Now we have the problem that userspace infrastructure can't
rely on the kernel telling it that it doesn't support the
functionality it is relying on. i.e. we have a mounted filesystems
and now userspace has to detect and handle the fact it still needs
to change the filesystem UUID.

Further, if this is not handled properly, every root filesystem
having a zero or duplicate "special" UUID is a landmine for OS
kernel upgrades to trip over. i.e. upgrade from old, unsupported to
new supported kernel and the next boot regens the UUID unexpectedly
and breaks anything relying on the old UUID.

Hence the point of using a feature bit is that the kernel will
refuse to mount the filesysetm if it does not understand the feature
bit. This way we have a hard image deployment testing failure that people
building and deploying images will notice. Hence they can configure
the build scripts to use the correct "change uuid" mechanism
with older OS releases and can take appropriate action when building
"legacy OS" images.

Yes, distros and vendors can backport the feature bit support if
they want, and then deployment of up-to-date older OS releases will
work with this new infrastructure correctly. But that is not
guaranteed to happen, so we really need a hard failure for
unsupported kernels.

So, yeah, I really do think this needs to be driven by a filesystem
feature bit, not retrospectively defining a special UUID value to
trigger this upgrade behaviour...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
