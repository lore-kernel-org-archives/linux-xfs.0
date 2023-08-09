Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EAE4EB64DD
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Aug 2023 09:44:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjHIJoI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Aug 2023 05:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjHIJoH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Aug 2023 05:44:07 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D87BED
        for <linux-xfs@vger.kernel.org>; Wed,  9 Aug 2023 02:44:07 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-686f8614ce5so6453524b3a.3
        for <linux-xfs@vger.kernel.org>; Wed, 09 Aug 2023 02:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1691574246; x=1692179046;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ngdqj+DsTPcgR2O2EfsmzDi34kkv0FI5n2/Y8sp767U=;
        b=axL3SrVJtDCADUAHBOu8BUzwlHgdUBV+G3N2yHuEyCbqdX5GA/DQ3KM2S+HFBFVjYX
         pxl4ylIzBdCG/H+DkFBweo3sKXn7PEHUqglF6Iuo18EwXqFotTgM53tc0GjxBXsXzOfo
         ssUVaRRwpiWVKCRri6DWJS8KL4AYetXx2icNpRsAsEREBnvO19M2OA6LzuaXh1Y6nOk0
         ZLiHpVGFZYmsi9EnXhq2QB4EqqGpeWGA0D/yqAmTqt6v1FDg5wcKvEuk1pkFWG48VZqK
         epbr6Io0BhK59PabReGGFZsze3s1XJHjSuhmRG9/w+s0HNVHFb2faTdYqTLBe8ffQuIn
         R8ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691574246; x=1692179046;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ngdqj+DsTPcgR2O2EfsmzDi34kkv0FI5n2/Y8sp767U=;
        b=GIjjvrr7f2bq7tMI6GA+HEqqN34cGI/3XtjeBE4MbqVaWC99vkCmeFQEaOc4/OMv9G
         jYXqfem3G8xqL1ULLdNeG4A6/yI9IAyLYcbZ0Q1xOQZ1ZAGqrTrXl1Jc96EAqkoRhjsQ
         3EswGXhxlK78nax+gwH973ec2jx0LO8oXiB4IJGEd0qqGfGwFcFd83AuSgY0nQ0zsKue
         DBUiblbuRJsOsEGsUCeSDYERHy6IkeRQt23vJdE4BeFvDZco5yKT3ShzGlpUVmpAQGFU
         YW8fX5EQevp7X7ROb4A8uDeuL6yM7rmtr1XJBRTv7qpK+DviITwXq3o70DxNKjcn6rz8
         gGEw==
X-Gm-Message-State: AOJu0YzE//Qa2K9jTouW9FXQ21qY3ctmcL/lJxfjDDcABmFTGYVlyek7
        FYoO1UljzILr+DursR7cBEd5FpHQQ/9lHkwA2ic=
X-Google-Smtp-Source: AGHT+IFvcP1+kZI2qNibETY264CT/OGrhtHYm8u9LHcweZLVBbc9JHZeX+7ZjGxZ8jyjgykw7iAE0g==
X-Received: by 2002:a05:6a21:7787:b0:126:92de:b893 with SMTP id bd7-20020a056a21778700b0012692deb893mr1902088pzc.31.1691574246574;
        Wed, 09 Aug 2023 02:44:06 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-166-213.pa.nsw.optusnet.com.au. [49.180.166.213])
        by smtp.gmail.com with ESMTPSA id k14-20020aa7820e000000b0063f00898245sm9729042pfi.146.2023.08.09.02.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 02:44:06 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qTfjW-0035z0-2D;
        Wed, 09 Aug 2023 19:44:02 +1000
Date:   Wed, 9 Aug 2023 19:44:02 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET v26.0 0/6] xfs: online repair of inodes and forks
Message-ID: <ZNNf4gIZg7j3SMpg@dread.disaster.area>
References: <20230727221158.GE11352@frogsfrogsfrogs>
 <169049626432.922543.2560381879385116722.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169049626432.922543.2560381879385116722.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 27, 2023 at 03:21:08PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> In this series, online repair gains the ability to repair inode records.
> To do this, we must repair the ondisk inode and fork information enough
> to pass the iget verifiers and hence make the inode igettable again.
> Once that's done, we can perform higher level repairs on the incore
> inode.  The fstests counterpart of this patchset implements stress
> testing of repair.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.

Most of this makes sense. I think the main thing I'd suggest is
documenting the repair decisions being made and how things that get
zapped are then rebuilt - it seems like there is a lot of dependency
on running other parts of repair after zapping for things to be
rebuilt, but it's not immediately clear how the bits are supposed to
go together so a little bit of documentation for that would go a
long way....

-Dave.

-- 
Dave Chinner
david@fromorbit.com
