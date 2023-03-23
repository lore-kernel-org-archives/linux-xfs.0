Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E52C6FD1C
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Mar 2023 23:19:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjCWXTG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Mar 2023 19:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbjCWXSk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Mar 2023 19:18:40 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D9E1ABD6
        for <linux-xfs@vger.kernel.org>; Thu, 23 Mar 2023 16:18:39 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id le6so291032plb.12
        for <linux-xfs@vger.kernel.org>; Thu, 23 Mar 2023 16:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1679613519;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DQ5FcpLXO9sClwUQ9bvRO7LaWmHWWl8aHXRl+z4i944=;
        b=8UEP3bAzADrZUPbj4lWjpHJuQeBoI/3SUw0WCwJZKffTwjRxxCp9LdSV2DbGsTy3sY
         Q5YShuaByTia4d0C9fIYqIrQ8+jW6tnjY4YUZ9hfIi6yOMkQ3Xy64j3dVhBpIGSLB47g
         3l5VWAxKzJ13DLQtF810Db0dTw1vBVdR4OBlfvH0y52Aod6JbWhtf5tzSlqIm5DwZeqp
         Gir2y4pIe/29Fj+xuoQUUA1+3y6/jqenItTaNBmSRlCs+RZIh/8FoC+QUgmhIn3SJaH/
         tTVe9k/CxaNObsXAt6HFho3J6oX91Ekmx3Kau/cf1IFye6WZvVhoK9s7q8l/2+x8V923
         3TIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679613519;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DQ5FcpLXO9sClwUQ9bvRO7LaWmHWWl8aHXRl+z4i944=;
        b=VEeC+pni9VsQxZT/T5XscJ5c2qKiR1v0Hl0IBFzRH+sPXhxSf6scyFhozeoSzByAbJ
         gVbMFjI0kp39BXA8xI5BtlqSYjN004et8D6kIuZyjCVQP8pPuHPNi1qRpEegf4kZ+zqc
         ZmMGmFo6RrRS1QCR6KoYgYQUATKS5C37B3TUNMs/jSuMaNaCIQcmPftOsOS6BKaKBt8z
         9k7K+RU1/YrAOXfDRqb3NxonmIwHlM9QQSuP9FAxelSUbsCqwWfawTzGakNpr32USVbq
         bK/hQA6s3wEt9476CTuxqXkC41Tpem5o9feJY7lJZVWwL4S62aHNaBShj+rmlGZxY/t+
         6lZA==
X-Gm-Message-State: AAQBX9fiSKOgvp8VtviD2T+eDIkekxMcLmab4ULv2AQtZggxMkDwDKom
        oKstC66a1Rh59p+pkbAuRVbqcA==
X-Google-Smtp-Source: AKy350Z5JYxVmhaDGVUNKDp6j6udHTKBBEwuFCxKqLEnwp9YWnKgItlIkkuWjUQGykEm9ouC3cZy5w==
X-Received: by 2002:a17:902:cec6:b0:19a:ad2f:2df9 with SMTP id d6-20020a170902cec600b0019aad2f2df9mr551602plg.55.1679613519220;
        Thu, 23 Mar 2023 16:18:39 -0700 (PDT)
Received: from destitution (pa49-181-91-157.pa.nsw.optusnet.com.au. [49.181.91.157])
        by smtp.gmail.com with ESMTPSA id u6-20020a170902b28600b00194d14d8e54sm12816181plr.96.2023.03.23.16.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 16:18:38 -0700 (PDT)
Received: from dave by destitution with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1pfUCY-001gJC-2h;
        Fri, 24 Mar 2023 10:18:34 +1100
Date:   Fri, 24 Mar 2023 10:18:29 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Johnatan Hallman <johnatan-ftm@protonmail.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: FS (dm-0): device supports 4096 byte sectors (not 512)
Message-ID: <ZBzeRR+OjZYku7vu@destitution>
References: <EgkSUvPep_zPazvY0jpnimG82K4wOeYfiPz0Ly_34-TMN9DZKWNNQDxGFJPyq622ZaKee6RU3aFT34Yy-i00rjdT7hWFzS6HSGRe74z1F5o=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <EgkSUvPep_zPazvY0jpnimG82K4wOeYfiPz0Ly_34-TMN9DZKWNNQDxGFJPyq622ZaKee6RU3aFT34Yy-i00rjdT7hWFzS6HSGRe74z1F5o=@protonmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 23, 2023 at 10:45:18AM +0000, Johnatan Hallman wrote:
> Hello List,
> 
> I get this error when I try to mount an XFS partition.
> Fortunately there is no critical data on it as it is just a backup but I would still like to mount it if it's possible.
> 
> I have tried with various Linux distros with kernels ranging from 5.6 to 6.1 it's the same result.
> 
> xfs_info /dev/mapper/test
> meta-data=/dev/mapper/test       isize=256    agcount=32, agsize=30523559 blks

Where did this filesystem come from? It's a v4 filesystem, so
unless you specifically made it that way it must be a pretty old
filesystem.

What is the drive hardware and how is it connected to the machine?
e.g. perhaps it is an an external drive connected through a USB-SATA
bridge and the bridge hardware might be advertising the drive as a
4kB sector drive incorrectly?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
