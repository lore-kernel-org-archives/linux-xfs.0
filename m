Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36435C83F14
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Aug 2023 22:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344228AbjH3W5j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Aug 2023 18:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344319AbjH3W5f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2023 18:57:35 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41515CF
        for <linux-xfs@vger.kernel.org>; Wed, 30 Aug 2023 15:57:15 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-68a402c1fcdso161771b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 30 Aug 2023 15:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1693436234; x=1694041034; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SzJ2NrV9bYDG0e+PoClzZvz6u+K3UQj9i4olKiDu0y0=;
        b=HFlAzM9O3rLcR0aG0jDsJOoLAS9LxfJ1wftCHUuPk7zsfKBTayfcybo6vsukmI3xDz
         5PEuIC/uwMzmM/rsJHeD/nI3eP5qhq72Pzs17HPE509vX4uTGAl0iOMK58c72h9R9+DI
         JvHO6qd2G4T6EFjlDzoHbRDrp4RGUdt6hnlO9yfIqaRY7A6v3ZelpJ1AsTluc6En4YHE
         dzKFpRq5GK4wWzsNJC8ngulbMOAF4fCiyYtum7GoS9hnYHPspcM2buscF/j6Lw6FWkrg
         EEPF+b5fFDfl2rp+HEt1Ue37/NAVIaH0s746hCpY+TFRBCRQBVpBXE+FsLWZ85ScjI1K
         5mOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693436234; x=1694041034;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SzJ2NrV9bYDG0e+PoClzZvz6u+K3UQj9i4olKiDu0y0=;
        b=EMw6CO5tfMQCnZQlGjXkbY588F3xe3B+/TUICjTERpbWVDtYnxRzL3sQFWKNXJjdyv
         MS8VK3zqD3oSasWA8B+zg7KWbWkzKSZGLUOctFpW2Ki08lnT26Ej1MrFSCvDeagTnyoO
         MZLv7q5RfoF9HuFdX23b+SUNYRDtJ5d/9CuxQOlJnGkLVXH28ZIkzk+E+rICPn6mhOZu
         MV/osWd+bk5gXp/hZrwgWNnXDH/voMJ/nme4I02+xBiUkSJ6RXfJ2FychmON3fVtEMdQ
         qYb/j6XcPxK7DEGVhpP4zEZrkpRukGdEro9Crvp/mQ1pVG81cLOLSByJIHhzMP2fV0MG
         7DUQ==
X-Gm-Message-State: AOJu0YxAkWT8pZIfmYuIx05MdHgY7QtBWY8TY7BHipCobZGGm/c5Badc
        sZDWekszu03RKyojVOlvn4hN/Q==
X-Google-Smtp-Source: AGHT+IF0k5h+LG4Rbh7cL+sq1GOY/cp/Hm01zkU1a3F8Eln1KdpIssT1kupozszsQRn5WLUnei5HSQ==
X-Received: by 2002:a05:6a00:39a2:b0:68b:c1a2:abc9 with SMTP id fi34-20020a056a0039a200b0068bc1a2abc9mr3679377pfb.17.1693436233695;
        Wed, 30 Aug 2023 15:57:13 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id x19-20020a056a00271300b0068beb77468esm102983pfv.0.2023.08.30.15.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Aug 2023 15:57:13 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qbU7Z-008iDp-3D;
        Thu, 31 Aug 2023 08:57:10 +1000
Date:   Thu, 31 Aug 2023 08:57:09 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, ritesh.list@gmail.com,
        sandeen@sandeen.net
Subject: Re: [PATCHSET v2 0/2] fstests: fix cpu hotplug mess
Message-ID: <ZO/JRddbU8llvrs4@dread.disaster.area>
References: <169335047228.3523635.3342369338633870707.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169335047228.3523635.3342369338633870707.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 29, 2023 at 04:07:52PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Ritesh and Eric separately reported crashes in XFS's hook function for
> CPU hot remove if the remove event races with a filesystem being
> mounted.  I also noticed via generic/650 that once in a while the log
> will shut down over an apparent overrun of a transaction reservation;
> this turned out to be due to CIL percpu list aggregation failing to pick
> up the percpu list items from a dying CPU.
> 
> Either way, the solution here is to eliminate the need for a CPU dying
> hook by using a private cpumask to track which CPUs have added to their
> percpu lists directly, and iterating with that mask.  This fixes the log
> problems and (I think) solves a theoretical UAF bug in the inodegc code
> too.
> 
> v2: fix a few put_cpu uses, add necessary memory barriers, and use
>     atomic cpumask operations
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> This has been running on the djcloud for months with no problems.  Enjoy!
> Comments and questions are, as always, welcome.

These changes look good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
