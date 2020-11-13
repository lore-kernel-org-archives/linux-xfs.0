Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19409C388F7
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 14:16:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9C7B2223F
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 14:16:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eVEuaahZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbgKMOQI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 09:16:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25390 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726520AbgKMOQI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 09:16:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605276967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yMqHiJ+07en5rhk6NQZ7TJuN1b8yQOAkg+qP5wgqkBc=;
        b=eVEuaahZRdSlTV1Pk+k+AlopUyN3velFTeZa/yPqvLdzJS3S189VYvlblh8U5xplivw92F
        4GApk4D8YRuhVB4LOXMnvasveE4K6vZnlFjwn5E3VXFAa4BWV3VEI46zgPvkh1vzOolMh1
        maeS/3NlGwFRq1sik3aIU/PJiEUW2mM=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-sy_00woWPZa7qbCtdg5DTw-1; Fri, 13 Nov 2020 09:16:05 -0500
X-MC-Unique: sy_00woWPZa7qbCtdg5DTw-1
Received: by mail-pl1-f200.google.com with SMTP id v20so6112792plo.3
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 06:16:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yMqHiJ+07en5rhk6NQZ7TJuN1b8yQOAkg+qP5wgqkBc=;
        b=oKD3HNPvQbFI930bf4qA6od4MG1Ubf6Y/wn++071BjRul6ZMi9XDqvTlc5XQ/idGG+
         zwfWdQLk0o3wlpf4eEfKux8Ns+C/yihvSW+5GcseaCofFOQNwD2fpedQLPsujZZTHFGo
         RalSueF0dbjIozBcop1iqtD8UCXXaC+zh2imX9l74jMpj5PbECymx8GrrmR0tKeOlB4M
         hT0JHdOLRtWFck3FBq65vKm/UZ1a4CvD1NLdnUNcCsYvA+ND7DBZsEqM/b0I4RkARAy2
         b2mV26kImc5oafquncCpawM1phZxkXXJf2kFn2UDUnrUPxj+ZFwTNJoLGXHGoiTpZpFI
         68Yw==
X-Gm-Message-State: AOAM533iB3GRBT7fjyQYo/70gphBwlX8ESoIt3DUzolB+GvGLIC/31bw
        xRAv81sMSt1oKGi30/VGVciPUWXYlWJechAb1A9mhW4xKqP2phgU7vfpi9Dhyg4ee4LEGsQCAM6
        KtbGZRI4E7E2ErjxP/bu/
X-Received: by 2002:a17:90a:9205:: with SMTP id m5mr3108778pjo.200.1605276963783;
        Fri, 13 Nov 2020 06:16:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyvPgzcRjUS5uI5o6uRI/BPlvOBhcFoI1ys9c788CJVf4jrw6U7ApRpB3PL2pAt3yAQPEZbtg==
X-Received: by 2002:a17:90a:9205:: with SMTP id m5mr3108754pjo.200.1605276963535;
        Fri, 13 Nov 2020 06:16:03 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g8sm20118pgn.47.2020.11.13.06.16.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 06:16:02 -0800 (PST)
Date:   Fri, 13 Nov 2020 22:15:53 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH] xfsrestore: fix rootdir due to xfsdump bulkstat
 misuse
Message-ID: <20201113141553.GA981063@xiangao.remote.csb>
References: <20201113125127.966243-1-hsiangkao@redhat.com>
 <e1e4f0a9-01bf-1ae4-5673-77738b3abd1b@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1e4f0a9-01bf-1ae4-5673-77738b3abd1b@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 13, 2020 at 08:10:39AM -0600, Eric Sandeen wrote:
> On 11/13/20 6:51 AM, Gao Xiang wrote:

...

> 
> Thank you for looking into this - I think you now understand xfsdump &
> xfsrestore better than anyone else on the planet.  ;)
> 
> One question - what happens if the wrong "root inode" is not a directory?
> I think that it is possible from the old "get the first active inode" heuristic
> to find any type of file and save it as the root inode.
> 
> I think that your approach still works in this case, but wanted to double check
> and see what you think.

Yeah, good question. I also think it works too, but just in case let me
do fault injection on a regular inode later (Donald's image is /var
subdir...)

Thanks,
Gao Xiang

> 
> Thanks,
> -Eric
> 

