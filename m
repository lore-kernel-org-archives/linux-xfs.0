Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EF30C4332F
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Nov 2023 22:40:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjKEWkR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Nov 2023 17:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjKEWkO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Nov 2023 17:40:14 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFE6CF
        for <linux-xfs@vger.kernel.org>; Sun,  5 Nov 2023 14:40:11 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 41be03b00d2f7-53fbf2c42bfso2962019a12.3
        for <linux-xfs@vger.kernel.org>; Sun, 05 Nov 2023 14:40:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1699224011; x=1699828811; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3wSNMHcx8gzsw/ES2D5Ik4yU9IYn1KGYdrtcYyxz9RE=;
        b=TY0o1kDHlGFv9sT6LGqmIWiZEft63VKxPReoNUSvjsu8igdXN1cn+ZkArhj/MBIuTy
         1EzCIqukq1F/AcC5Wf7p5IuT21jv6pAPeZzgeUpfrxgtj8wha/o2OT/SKZzXQD1fp0Vz
         y8CALcgoJIHBwkm9bpeQvJNcuSltc2qwJikI5yIZuSnerMaMp+PgRB3kgYZY6+iJgGNF
         V7UKTGPPyJG+aFMnF+gJ2JAy0wnVTG6B4Gu4IG7jd2kYf2WGVYbQLXLNJz02qQKjgn8l
         z0WetSUt7F1dgpwjQH+AtYY7iBoyrB2D6u4HRwS36x3KF5F21phg9tirp4mhf77Cafqs
         hN1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699224011; x=1699828811;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3wSNMHcx8gzsw/ES2D5Ik4yU9IYn1KGYdrtcYyxz9RE=;
        b=d1qeW8y5Wv2tH+2jyuARqx6P1qNkftds08u3uwkOqqgNQLBLuHet9asUu+0kURFilq
         vFxkMHkcq/rjUZ1FG7nOxdfc8rLtpGcLf9A/ToCuj4gj1ek+6vuXuGnIGvG3fx7RxvMy
         t7kCC71e/tLRrfOzXMSPmAE+sFyGAs1Nz+y74+RTyaud5W1MTvn2OnXfAy+Yue3Igpx2
         mQ4bThCcLL+VoOq8reNp5Yty6CMM1b6pnrhgQRLOBjzZKSUTBFlgBxtgi/7CKtaMcTRs
         m6kqBmEyrDhzLNiFX8S0nwSqw3kTJkCdFW/sjjy4YJdO9bOC+alBTJLo8ZCxxLmCy9Uj
         gQsg==
X-Gm-Message-State: AOJu0YzTpQlnoZbCx/TeALDgQip2ueQO6Nl4+++Zn0C/I25JUOa0dGD0
        xHPyuj+lkG+CfRRMPWBkVOs+Ow==
X-Google-Smtp-Source: AGHT+IEBTdWvSxOSkmkb1GTzw9Qq6/NNrCs2aet/cWuyyUNSKSCH3O0pFc4aQ/LfpL9io4ihUTS0pQ==
X-Received: by 2002:a05:6a21:66cb:b0:180:eef7:b3dc with SMTP id ze11-20020a056a2166cb00b00180eef7b3dcmr18705725pzb.13.1699224010657;
        Sun, 05 Nov 2023 14:40:10 -0800 (PST)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id iw17-20020a170903045100b001c61073b076sm4586795plb.144.2023.11.05.14.40.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Nov 2023 14:40:09 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qzlmp-008jBF-0X;
        Mon, 06 Nov 2023 09:40:07 +1100
Date:   Mon, 6 Nov 2023 09:40:07 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: XFS_DEBUG got enabled by default in 6.6
Message-ID: <ZUgZxy9d+ICGLWUK@dread.disaster.area>
References: <308d32cc-4451-ad70-53bc-b41275023e45@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <308d32cc-4451-ad70-53bc-b41275023e45@applied-asynchrony.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 05, 2023 at 07:03:55PM +0100, Holger Hoffstätte wrote:
> Hello,
> 
> I recently updated to 6.6 and was surprised to see that XFS_DEBUG suddenly
> got enabled by default.

It should not be enabled by default - XFS_ONLINE_SCRUB defaults to
"n" and so XFS_ONLINE_SCRUB_STATS should not be enabled nor should
it be selecting XFS_DEBUG. So to see this, you have to turn on
XFS_ONLINE_SCRUB first....

> This was apparently caused by commit d7a74cad8f45
> ("xfs: track usage statistics of online fsck") and a followup fix.
> Was that intentional? From the description of XFS_DEBUG I gather it should
> be disabled for regular use, so this was a bit surprising to see.
> Maybe that "default y" setting should be removed.

No, it's just wrong....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
