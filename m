Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFF82C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Oct 2022 21:01:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbiJZVBW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Oct 2022 17:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233497AbiJZVBU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2022 17:01:20 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D57E09D9
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 14:01:18 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id 4so9501598pli.0
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 14:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fzk1lW5j6OpDfF7/bqtQ8ish77B3urkRolKZscwwEWQ=;
        b=uYUF5kcQBr7edkk6UGE6VJoXWZbRL0VcpihwcMkUbcXGQ5ylpq6Ta3wI4f/G3RwRF1
         Vv+VmtbFF3hC/dj4lymFg4bV+enA+WQqqJ6+VCs+Bu9uAtzCoZzvllTZGymB40cmNFt2
         69ErZhbgXGlrWGbbxJ0k/U2EDSp+zCi9G9YK/4HglQiD6Xk8B4VRr2/DQehNVWS2GFB4
         q6EXDJSjdfOU4KzlXand+UC+junILWu7I4/RvAzrAa0aXEtgHuvUhTk3w0wU93kxTzqB
         aae9BIWIyUECAsqYr+0bLFL7xq9pLOAqj6Ptc90+z4NJVMPLjmUxTCXXXC9yZ49FSRCR
         6yYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fzk1lW5j6OpDfF7/bqtQ8ish77B3urkRolKZscwwEWQ=;
        b=CVJxCR94qxZ2I+BjlN52gu25z9DpgYj0x0XzrJnlbZE5NY1Nebz95AxQz5ZlVOhjwv
         3WWBdbnPk6tG42Oah7l05pO+oESfvd/QkrYN370XTP3j/MKz17HOOZ3DReh/rk6Wddd4
         /o3gK2jXw0YD2Jue/iBeWAjKKtSET84cvOZkk4L6cZZ4xkMzrgBXG0QDEdgh03AFdYOV
         nhzGy1xEhkoBDWC8DouIruRAJks4f9pOLB6uLZj5saZAaV+Xa2McrHhyIe+aCQOq+kzs
         6Z1AeGLP9aJ77yk7OtDdlG3z+FiySzd7jToIf9kFKP/W38NNCBna3TAEEeeGU3+axqao
         MVUw==
X-Gm-Message-State: ACrzQf03FlXeV4VimsM31tlgWDgF5HMVbA7wZPB8cRiRyN5iFi/3ez9p
        O+CzeYxMy9w4B5qeDRyCEdnZ1DChhsXr3g==
X-Google-Smtp-Source: AMsMyM7Tj0QIxfqB3o2Orp9l0Uu8A5/M55ZizBfuOR2C00doTr0Sepc21TEkb5+NYp3S2sxMzQK5PA==
X-Received: by 2002:a17:902:a70b:b0:181:d20e:6565 with SMTP id w11-20020a170902a70b00b00181d20e6565mr46921978plq.66.1666818078307;
        Wed, 26 Oct 2022 14:01:18 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id h15-20020a62830f000000b0056b9a740ec2sm3384665pfe.156.2022.10.26.14.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 14:01:17 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1onnWU-006l6r-UQ; Thu, 27 Oct 2022 08:01:14 +1100
Date:   Thu, 27 Oct 2022 08:01:14 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 7/8] xfs: actually abort log recovery on corrupt
 intent-done log items
Message-ID: <20221026210114.GO3600936@dread.disaster.area>
References: <166681485271.3447519.6520343630713202644.stgit@magnolia>
 <166681489220.3447519.15381302502050780897.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166681489220.3447519.15381302502050780897.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 26, 2022 at 01:08:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If log recovery picks up intent-done log items that are not of the
> correct size it needs to abort recovery and fail the mount.  Debug
> assertions are not good enough.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
