Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E51FC05027
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Feb 2023 00:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjBJACZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjBJACY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 19:02:24 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7602F7B2
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 16:02:24 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id b1so2461612pft.1
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 16:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AmkaeM12coKnv3vFRlDu0Y4YeKHrnrrhN6QFnrsSejo=;
        b=n5VWHlhECW4/85aEFTYkfJJMTqU6y7I7hfBRkpnve25Nbb8X59T1lgMmI1marA8C40
         ePbBwDVvXcIU4BZrqASaiiqRXPxbN0AeOa150iSTsHMX6z2N65+49jwwHKt//SXyi09K
         66FWHjzDw9nlLTdQhhQu8/9TKOEIYc0XNdXtARxHwe1WGUIs/1TawNILT7q1T10z2Tei
         fawUcaGAehHk/jrBFhdpROsMhO6Quc7M97zteF1JFNTZI+xp/r7lrhtTvifajW29mMP5
         nqtL8XU0dlY880iC+Ki3mQAFvABLC7MtR72p4RSQI9gNj1M3+56IpI/j3eYVqQaCtJaf
         UtXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AmkaeM12coKnv3vFRlDu0Y4YeKHrnrrhN6QFnrsSejo=;
        b=KK7UcC5uYE76hRQZgcVmKnAAivXEhMv4DbtWg+yFQFRpvbvOWX5OigpDdv8TwSBQpW
         fct7VkCIH68Q3nJ67QL+FI8RUWBhpE+02ssJPTysEdhtPPwea1h59j2+dAh+u713Y77c
         prUtIPEmf11J39KTPt30DXNTr9WyXgFZ0jNHMaycn0XHq4vWNma6o4tNrzmOCgcxwaU+
         sR8VM4ZaKvLBKo+Hy0o4J7Oc4/2Riy9kYADORPqt3TG2qcHjr13sgvQDx2R1DGTo8zke
         bY8LjqV/Ac4qwdu8s/pbu9jqHQIwJv7wRVlrW608A25wZUdtEj5tFV1+bpUR79RsoaP7
         JjMg==
X-Gm-Message-State: AO0yUKU7Jldzj6aNrgG1XAYStGHoVkF4h6LJa6A1bTOm/iCtmfZKaZit
        jeQ5wHrY/fUnTsBFXOfttB0JSKxGcLc65+OV
X-Google-Smtp-Source: AK7set/p/i8KbhcStMbUNr++5fPI1K549rt2fwVA7+84E8tE57vlGLzgWtk1mY0C2IdezYu7wLa7XA==
X-Received: by 2002:aa7:943d:0:b0:5a8:47e5:bbb2 with SMTP id y29-20020aa7943d000000b005a847e5bbb2mr5618236pfo.0.1675987343596;
        Thu, 09 Feb 2023 16:02:23 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id i19-20020aa787d3000000b005815017d348sm2059137pfo.179.2023.02.09.16.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 16:02:23 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pQGrs-00DQSf-Mp; Fri, 10 Feb 2023 11:02:20 +1100
Date:   Fri, 10 Feb 2023 11:02:20 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Donald Douwsma <ddouwsma@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] xfs: allow setting full range of panic tags
Message-ID: <20230210000220.GI360264@dread.disaster.area>
References: <20230207062209.1806104-1-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207062209.1806104-1-ddouwsma@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 07, 2023 at 05:22:09PM +1100, Donald Douwsma wrote:
> xfs will not allow combining other panic masks with
> XFS_PTAG_VERIFIER_ERROR.
> 
>  # sysctl fs.xfs.panic_mask=511
>  sysctl: setting key "fs.xfs.panic_mask": Invalid argument
>  fs.xfs.panic_mask = 511
> 
> Update to the maximum value that can be set to allow the full range of
> masks. Do this using a mask of possible values to prevent this happening
> again as suggested by Darrick.
> 
> Fixes: d519da41e2b7 ("xfs: Introduce XFS_PTAG_VERIFIER_ERROR panic mask")
> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>

LGTM.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
