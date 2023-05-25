Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3DD1C77B7E
	for <linux-xfs@archiver.kernel.org>; Thu, 25 May 2023 06:15:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbjEYGPI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 02:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbjEYGPH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 02:15:07 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA38FA
        for <linux-xfs@vger.kernel.org>; Wed, 24 May 2023 23:15:06 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 98e67ed59e1d1-2535edae73cso1026536a91.2
        for <linux-xfs@vger.kernel.org>; Wed, 24 May 2023 23:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1684995305; x=1687587305;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vWj1NDHztpajdByGl8W9ETBey9E/craKURuflERme5A=;
        b=irJu/0HkrPgR40BbmgvreqkaM2s6s1J+fNgkoXZp74IJbNh5VwXtvXXPHdxVPynT0T
         mmOIltoV800LH/SE/ex3EspLQwYY2b9iV9NSdJvm6Aw9j2VfjI7UblX5/RX4B0+AzM32
         JOwMEtC8nsh3lfyOetM8RA7azSZnEu30o4L9+/vWfuAV0dQYfAcd/HV0lakgeR+u/N0j
         CfSnbK7YdKNUsv+83IYS9+zaO/Tp20JL2u3n+uTA/Xg8N1YXA++HrixSolt2vagu+UDu
         0DMcOlITNTrw8Mq6frP5w/hJm3PgnC+QtJ+YRGM9kHz976zhmEkWa/+sRJj7FHoFFLtC
         XwMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684995305; x=1687587305;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vWj1NDHztpajdByGl8W9ETBey9E/craKURuflERme5A=;
        b=SAtKwE5UU3VdzMLbum24NlduwXryr+8WVnso4x6e7gYGjSO6JCMs+bSgceQfws1O/W
         drlirNnxVnzLyR/aieCCZ1AcS0A19x5NvoL66lnE+S1ksh9NvQ9pXIZU/fLAjKqn8at2
         5ec6GspOx/EOs9PoBcH3KOvSW3m5JdhCZUbvW3Xs1en6LVw0e00huYWLBUOUf7ah4Zki
         7YtQeJWF5UBWv3aeXM45MUbQOO64mqwDMaSWwdi/dfT7OPu5MSWr0o0C8rUzMSOEY/3x
         ueFsZrjzyIY9T0KY9m/9FTrFTwxdLBFbe/VdISOTAU0loWg9lhQTtwtbX99+wbz+l4rh
         Ge5g==
X-Gm-Message-State: AC+VfDyBpqQTV/tZ7Yh51Lf+ylwXOnl3aOzZMKJxKUnA0EJUZp7No4rH
        JjIJHQqJDcFEM39BCYKUoy18Fw==
X-Google-Smtp-Source: ACHHUZ4TZTH+0zaquEfsgNr1vqFgjfKek1/wEZuZifn47Awn6TCsmUpojm5o1bYrQESref13pZlAmQ==
X-Received: by 2002:a17:90b:3841:b0:255:63ae:f943 with SMTP id nl1-20020a17090b384100b0025563aef943mr485225pjb.35.1684995305486;
        Wed, 24 May 2023 23:15:05 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id g3-20020a17090a578300b00247735d1463sm476657pji.39.2023.05.24.23.15.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 23:15:04 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q24FZ-003cdd-2J;
        Thu, 25 May 2023 16:15:01 +1000
Date:   Thu, 25 May 2023 16:15:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Pengfei Xu <pengfei.xu@intel.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, dchinner@redhat.com,
        djwong@kernel.org, heng.su@intel.com, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, lkp@intel.com
Subject: Re: [Syzkaller & bisect] There is "soft lockup in __cleanup_mnt" in
 v6.4-rc3 kernel
Message-ID: <ZG785SwJtvR4pO/6@dread.disaster.area>
References: <ZG7PGdRED5A68Jyh@xpf.sh.intel.com>
 <f723cb17-ca68-4db9-c296-cf33b16c529c@sandeen.net>
 <ZG71v9dlDm0h4idA@xpf.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZG71v9dlDm0h4idA@xpf.sh.intel.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 25, 2023 at 01:44:31PM +0800, Pengfei Xu wrote:
> On 2023-05-24 at 22:51:27 -0500, Eric Sandeen wrote:
> > On 5/24/23 9:59 PM, Pengfei Xu wrote:
> > > Hi Dave,
> > > 
> > > Greeting!
> > > 
> > > Platform: Alder lake
> > > There is "soft lockup in __cleanup_mnt" in v6.4-rc3 kernel.
> > > 
> > > Syzkaller analysis repro.report and bisect detailed info: https://github.com/xupengfe/syzkaller_logs/tree/main/230524_140757___cleanup_mnt
> > > Guest machine info: https://github.com/xupengfe/syzkaller_logs/blob/main/230524_140757___cleanup_mnt/machineInfo0
> > > Reproduced code: https://github.com/xupengfe/syzkaller_logs/blob/main/230524_140757___cleanup_mnt/repro.c
> > > Reproduced syscall: https://github.com/xupengfe/syzkaller_logs/blob/main/230524_140757___cleanup_mnt/repro.prog
> > > Bisect info: https://github.com/xupengfe/syzkaller_logs/blob/main/230524_140757___cleanup_mnt/bisect_info.log
> > > Kconfig origin: https://github.com/xupengfe/syzkaller_logs/blob/main/230524_140757___cleanup_mnt/kconfig_origin
> > 
> > There was a lot of discussion yesterday about how turning the crank on
> > syzkaller and throwing un-triaged bug reports over the wall at stressed-out
> > xfs developers isn't particularly helpful.
> > 
> > There was also a very specific concern raised in that discussion:
> > 
> > > IOWs, the bug report is deficient and not complete, and so I'm
> > > forced to spend unnecessary time trying to work out how to extract
> > > the filesystem image from a weird syzkaller report that is basically
> > > just a bunch of undocumented blobs in a github tree.
> > 
> > but here we are again, with another undocumented blob in a github tree, and
> > no meaningful attempt at triage.
> > 
> > Syzbot at least is now providing filesystem images[1], which relieves some
> > of the burden on the filesystem developers you're expecting to fix these
> > bugs.
> > 
> > Perhaps before you send the /next/ filesystem-related syzkaller report, you
> > can at least work out how to provide a standard filesystem image as part of
> > the reproducer, one that can be examined with normal filesystem development
> > and debugging tools?
> > 
>   There is a standard filesystem image after
> 
> git clone https://gitlab.com/xupengfe/repro_vm_env.git
> cd repro_vm_env
> tar -xvf repro_vm_env.tar.gz
> image is named as centos8_3.img, and will boot by start3.sh.

No. That is not the filesystem image that is being asked for. The
syzkaller reproducer (i.e. what you call repro.c) contructs a
filesystem image in it's own memory which it then mounts and runs
the test operations on.  That's the filesystem image that we need
extracted into a separate image file because that's the one that is
corrupted and we need to look at when triaging these issues.
Google's syzbot does this now, so your syzkaller bot should also be
able to do it.

Please go and talk to the syzkaller authors to find out how they
extract filesystem images from the reproducer, and any other
information they've also been asked to provide for triage
purposes.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
