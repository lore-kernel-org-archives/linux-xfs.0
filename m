Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98FC6C04A6A
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Aug 2023 19:15:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234162AbjHHTPc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Aug 2023 15:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235215AbjHHTPF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Aug 2023 15:15:05 -0400
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E09E3C206
        for <linux-xfs@vger.kernel.org>; Tue,  8 Aug 2023 09:38:02 -0700 (PDT)
Received: by mail-oo1-xc29.google.com with SMTP id 006d021491bc7-56c4c4e822eso3959590eaf.3
        for <linux-xfs@vger.kernel.org>; Tue, 08 Aug 2023 09:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1691512665; x=1692117465;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=858PTVnbArXoQvcXi1UnX0dCap4cIAwhHqyVb6HI5O0=;
        b=NWTjCchFU4AvhLA9LSOwArKZjNUGZn6YDPjN9rzt1bqOQdwlsrmEH3hCBidGY5a+Ti
         pDBbkhRn8dJIij21nde3FwXOWcqB3IJhMoQn47ktQAXCqaBRo+tazMdFTrXytv0B0Owx
         a/AR/SkU86H2Iuw5aNPgWHWHJCGlyG/GN24lKvvauKBR/t+AJoncMBKYAbSPyoU2Gu7b
         z9aYA1Ull3sN1W7h4wApgEGOpYYxSRDwUAVTYt0GmNJnJ1XnbDCdw6StVKli7HiWrOnH
         VCCQfR2kYqKGhK09vqaeZxD04olyDnYpVb0rXPBg/QjfmCyzCLmddW4AzuRoVAd/GObp
         5TbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691512665; x=1692117465;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=858PTVnbArXoQvcXi1UnX0dCap4cIAwhHqyVb6HI5O0=;
        b=PMEIAlCqKi9gds4MjHAFnf/FbcfannB5y/44eTs9eV4+bMe1zVqYDsVQAmng88DJ37
         1Dddwkkbs7sHH47jZ8QK6hYA0ajz0RJrXjXOWmJNoaVxDXS9gErPLVt1L0bNcvVhkvuG
         /G0gi9uYdWfmDTb3LH6l6LNmmJAE6MSXDx4GS4xPhz2HRX4Dw5ccwnNDkBgBm3VXI/ar
         dt9XmOnARrq4JtkO+mPDsVrAqd8i6y2FMEOH2VFqsSIWSugulqDawPuurbCK0m2QFMn2
         yLTATWdMcESyvxHiJ5cuzRSRzkkrnwfeHg8sPboY8+3uXwfefiPWq/vvW9aNvnf5wzQx
         LQxQ==
X-Gm-Message-State: AOJu0Yz5118mIg+f90sHG0U6uEikIkRIjKbGBVwpuiD/XEGob7/fPX1w
        Gw/9lNABw91iOHcq/v8Qfml8YdC1LKAmacLUvQ0=
X-Google-Smtp-Source: AGHT+IGeyZWUacopLpfZ+SmQyi0KQMywspgbfiSHYDJXvBux1xRpXRP2LeuEDO3ufF3uTSAJb7KvOw==
X-Received: by 2002:a17:902:b70e:b0:1b2:48c:4db with SMTP id d14-20020a170902b70e00b001b2048c04dbmr9636287pls.38.1691479004794;
        Tue, 08 Aug 2023 00:16:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-166-213.pa.nsw.optusnet.com.au. [49.180.166.213])
        by smtp.gmail.com with ESMTPSA id y23-20020a17090264d700b001bb24cb9a40sm8333547pli.39.2023.08.08.00.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 00:16:44 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qTGxO-002cDO-1J;
        Tue, 08 Aug 2023 17:16:42 +1000
Date:   Tue, 8 Aug 2023 17:16:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET v26.0 0/2] xfs: fixes for the block mapping checker
Message-ID: <ZNHr2u0b2W2RTKdz@dread.disaster.area>
References: <20230727221158.GE11352@frogsfrogsfrogs>
 <169049626076.922440.10606459711846791721.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169049626076.922440.10606459711846791721.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 27, 2023 at 03:20:53PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> This series amends the file extent map checking code so that nonexistent
> cow/attr forks get the ENOENT return they're supposed to; and fixes some
> incorrect logic about the presence of a cow fork vs. reflink iflag.

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
