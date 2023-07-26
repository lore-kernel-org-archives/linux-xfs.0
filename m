Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6527DEB64DD
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Jul 2023 00:23:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbjGZAXb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Jul 2023 20:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjGZAXa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jul 2023 20:23:30 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A74F11F
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jul 2023 17:23:29 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1bb8a89b975so18509375ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jul 2023 17:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1690331009; x=1690935809;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Aszh+XgVxwL/lzEyX7X1UsJhP7dqoF3ZW93khaildOI=;
        b=3iq6rNKTfBbVDbhkxo82tap08DnzS/ApRBso2ErZvUW0DKNBe4ErRzePZ/J8/21TYf
         aJL5+lMa5ozmbTj9Tw36SH6hlaZFOa4NGcJ7PHL2pgXg5mSon9AsCnHmwMdQgI86PK4o
         oAp9iN75WGjNqB+iic37lO9KMuAP5L95e2x6BEBPhHjUA/Tx4W6KuL21R3qFj8puggv0
         ZPIR1bnT7rqfGCPa7ILlC+YMKAVUyDgAFeU5oQfisUtO11PwAurIee8w2HtQCPPgNk4l
         bmdxa7kbCAZp4Jh8YbrwjnV1P2OLxcBw/V3fIw8LRsBR2WM7UMTyEAlvADHex/CYGCRn
         oQJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690331009; x=1690935809;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Aszh+XgVxwL/lzEyX7X1UsJhP7dqoF3ZW93khaildOI=;
        b=FRdSTnaAXMR2MKk9JU9YvyLDrEIs0ea0Q8ymt0KO8WHbNLk9R4V06sm+P8kOtHnrV/
         Wg/4hNFrJDYoTpFwdfXDGeEBwBMcnPu3QxF6W4R2EOKXeCbU3pZyrFLEiim+fYmFe6PS
         mqqcMTY9nMDZ6XRbse2zVgzrTmpU66sYPaOVOQNhg9Qvwx/bsFNokZ1gEfVMxXIauVgz
         JJMParB1Rv0Sw+6Zf3JuMJmFD1L4RnhrWsgFZhs3IPu4oO9h+X1J78zT4Pu2Ur3i+Tae
         5oJUc+/R0eAVtCfvtL9DakdUjPic5d1hz6c5/RhPDX5b/V8f0eaADUj87XgbwKyfWJ6I
         nB1A==
X-Gm-Message-State: ABy/qLYtQtYG6w9FglO5phmOTQP4JR9TEiPnS2SzVp4ddmisAQGH2kDr
        lgtaNBr7gq5cOT8mIvEUdI1aKw==
X-Google-Smtp-Source: APBJJlHq6Yyz3XYHy2jaar94WNm+tPC6IaHtDy11ZCwU1iPRoxpZZ32yia+lNbYkv4ik100U71mzAQ==
X-Received: by 2002:a17:903:2308:b0:1b8:aef2:773e with SMTP id d8-20020a170903230800b001b8aef2773emr736158plh.46.1690331008981;
        Tue, 25 Jul 2023 17:23:28 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-119-116.pa.vic.optusnet.com.au. [49.186.119.116])
        by smtp.gmail.com with ESMTPSA id l2-20020a170902f68200b001b89536974bsm11659651plg.202.2023.07.25.17.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 17:23:28 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qOSJJ-00AXtp-1g;
        Wed, 26 Jul 2023 10:23:25 +1000
Date:   Wed, 26 Jul 2023 10:23:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove the XFS_IOC_ATTRLIST_BY_HANDLE definitions
 out of xfs_fs.h
Message-ID: <ZMBnfRBoUqkLmsQG@dread.disaster.area>
References: <20230724154404.34524-1-hch@lst.de>
 <20230724154404.34524-2-hch@lst.de>
 <20230725034913.GX11352@frogsfrogsfrogs>
 <20230725040044.GY11352@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230725040044.GY11352@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 24, 2023 at 09:00:44PM -0700, Darrick J. Wong wrote:
> Does anyone actually /use/ these extended extended attribute functions?

xfsdump, for one.

And, IIRC, there were other SGI HSM-aware applications that used
libhandle for these functions too, but I think we can largely ignore
those on Linux nowdays.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
