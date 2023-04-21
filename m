Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B7BBC77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Apr 2023 06:19:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjDUGTX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Apr 2023 02:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjDUGSx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2023 02:18:53 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F6130DF
        for <linux-xfs@vger.kernel.org>; Thu, 20 Apr 2023 23:18:46 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1a682eee3baso15480005ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 20 Apr 2023 23:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682057925; x=1684649925;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MDZCyL8FpoQEYOpxI4qFdXulgYSq7BeKEORFyOUM/OU=;
        b=EN+5tYK6aJHCKgtm7tP4lGUEdFPp2l3d31/NElhn4CEvVOLh8nqPCSLzTgDcerAcZ+
         QRL9hN54znvkAsk4XwY73709P9c+9ct/lsCJ3ZjjbA1doDwOZ2RYBDWG/snsf7LwdLpM
         /7eUWkltqJtlBFTxM//8g+ccDbc02MJoEw1DCZ1IO21jHbiMBNmEquLuHhX57QAn96sj
         vuTbbTEG9a4g4UuVR+SDKKgpo0ynPKR1fHVnGOdEDTS4UWGFp/d6aPoeoJZBeycEbDMm
         1/JeE14g5MGO7cnPasO8758lWqa/B523L2AwIghuK75AED3Thxaq6uy4b1RANAyspt70
         EPwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682057925; x=1684649925;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MDZCyL8FpoQEYOpxI4qFdXulgYSq7BeKEORFyOUM/OU=;
        b=fgwUFDGJreq/zx6fQXZ1v3HKX4z38KY8lkI1kM30Ud1ZIjaqq0dWZvqptN0+0S8N6B
         D2BuBZLjGO85OWtQNG1ymz+7HABaU3gsCBSNx6Ch9nwNQHrrmsGUXg5kxTDBZ9W6NXHL
         mzVV3I6VfbvYD6CGlOOhCOa6o3K6fl9kNsqgyoicTFYspKB9pTiLXAIZVwV4z+19pjWn
         R77dij6tgecqaQes1BvDT0Z6p72lFoK1SfxDVtqwIPbMqn+/Fm4ZaqGG6SmIq/q9MRFd
         lAWCYqZAWCQI+yEGV02dMMIj2fSXPP/jsfRzbQJRmO+VyLhqniJa63yLNS6sbn1T3lxq
         qrkA==
X-Gm-Message-State: AAQBX9cT2F33CwJTH+uAthl30pLabr5J/k0uqILfXYUFFnrIQRNt+W4g
        iYxhFKK7vUXT9AqWd01TmLpNHw==
X-Google-Smtp-Source: AKy350YEj2jiS/EyKrJuuwfXpbfOaA4eb6NAIGYzVoqyIr3CWY744ZCV8vbAV2rH/Wv5GvS7+1LVjg==
X-Received: by 2002:a17:902:f68e:b0:1a1:f0ad:8657 with SMTP id l14-20020a170902f68e00b001a1f0ad8657mr5514253plg.37.1682057925642;
        Thu, 20 Apr 2023 23:18:45 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id jo13-20020a170903054d00b0019acd3151d0sm1551245plb.114.2023.04.20.23.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 23:18:45 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ppk6U-005x5A-SX; Fri, 21 Apr 2023 16:18:42 +1000
Date:   Fri, 21 Apr 2023 16:18:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Guo Xuenan <guoxuenan@huawei.com>
Cc:     djwong@kernel.org, dchinner@redhat.com, linux-xfs@vger.kernel.org,
        sandeen@redhat.com, guoxuenan@huaweicloud.com, houtao1@huawei.com,
        fangwei1@huawei.com, jack.qiu@huawei.com, yi.zhang@huawei.com
Subject: Re: [PATCH 3/3] xfs: clean up some unnecessary xfs_stack_trace
Message-ID: <20230421061842.GC3223426@dread.disaster.area>
References: <20230421033142.1656296-1-guoxuenan@huawei.com>
 <20230421033142.1656296-4-guoxuenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421033142.1656296-4-guoxuenan@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 21, 2023 at 11:31:42AM +0800, Guo Xuenan wrote:
> With xfs print level parsing correctly, these duplicate dump
> information can be removed.
> 
> Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>

Looks good when considering the previous patch would result in
emitting the stacks in each of these situations.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
