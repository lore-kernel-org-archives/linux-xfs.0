Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E34C1C3DA6F
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Aug 2023 01:09:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236772AbjHYBJL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Aug 2023 21:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236173AbjHYBIq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2023 21:08:46 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A25A19BB
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 18:08:44 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1bbc87ded50so3875895ad.1
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 18:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1692925724; x=1693530524;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ziXWjx7YC4C3d8ZyUNW0Hr4Fur9pHQrQwRs9vQGRGzU=;
        b=das3RpszntX1xQRLyqv29UVlo2GsacmLuvxpRxFi1P0ECJuztS+lryeb+coRs9uL+r
         V8V2E3o38sLcJgZhZNGzpj2yhipBseCxkbC9Ek2mnTmNoem23EnGylosn+4LOwwC4OAZ
         AmYKsAf46gMw0ZoVD1a5ICCavo09corrPdheK3aV9GXIZbX0Hs/vz+Hv/p07OM430Vmj
         bPNrRbYPbLnMaB52NiCBHrIg8ivGWPDQPbV5wgSvHEDe7GF34DG415ofHd4Ceea6fY7U
         mDwOcWEBejYdH1DrXjE7zHybbQTfFkg9LWepKYygOzhMnjjMzW27Tz163bfcIZTB0XWd
         mTtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692925724; x=1693530524;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ziXWjx7YC4C3d8ZyUNW0Hr4Fur9pHQrQwRs9vQGRGzU=;
        b=MVioD1o6gGRVALksGNpaV4Whbc4ewPZe1Y0gAGhgkUDqLlbqcL4Kezzr0lqjUd2r7a
         Ijx7s/yUKa4fV31MiNlgknRcUpnsc0oHPqgv7j91kPozaJLazC7un09uPcAxVbRZbaO8
         3S1qXKj3cZ/puiPXy9TYVd037D20h9iwOkJPCWlZREshENLs39j9gMj6fcY1xZP2pTio
         tRHlQ42HDPBBHl379SKvTTVqO+Fv60JTpkW+ug5NTJ+Qb9BGVJ1n3vDvslEU0UPS5vDx
         XrYGgIkH/Y515oxvIiPj6Rv/PyzhjaSLBDj1hwtJal8Ypm52Afvj7LLHGIw2MTpGnrlo
         gkxw==
X-Gm-Message-State: AOJu0YwyrkP7BrBHtVMVfZ9JDr+o+SARrsUeURUx3JPr8j1qrNNSbWG9
        rGnFJ59bSYO/LUYcQ2ooknSxPQ==
X-Google-Smtp-Source: AGHT+IGBRCOu5on+NMAvFDnzVsU3cfktWqbm/naJ6icmWY8/HvcrAR9W1Rz05g8YuMe6dMrUgjZEJg==
X-Received: by 2002:a17:902:b782:b0:1bf:22b7:86d with SMTP id e2-20020a170902b78200b001bf22b7086dmr14130284pls.3.1692925723984;
        Thu, 24 Aug 2023 18:08:43 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id jh13-20020a170903328d00b001bbab888ba0sm315424plb.138.2023.08.24.18.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 18:08:43 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qZLJZ-0067gm-0v;
        Fri, 25 Aug 2023 11:08:41 +1000
Date:   Fri, 25 Aug 2023 11:08:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandan.babu@gmail.com, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 3/3] xfs: log is not writable if we have unknown rocompat
 features
Message-ID: <ZOf/GRvDI4oy2sF+@dread.disaster.area>
References: <169291929524.220104.3844042018007786965.stgit@frogsfrogsfrogs>
 <169291931221.220104.3437825303883889120.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169291931221.220104.3437825303883889120.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 24, 2023 at 04:21:52PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Ever since commit 9e037cb7972f, the superblock write verifier will trip
> if someone tries to write a superblock with unknown rocompat features.
> However, we allow ro mounts of a filesystem with unknown rocompat
> features if the log is clean, except that has been broken for years
> because the end of an ro mount cleans the log, which logs and writes the
> superblock.
> 
> Therefore, don't allow log writes to happen if there are unknown
> rocompat features set.
> 
> Fixes: 9e037cb7972f ("xfs: check for unknown v5 feature bits in superblock write verifier")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Yup, this makes sense.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
