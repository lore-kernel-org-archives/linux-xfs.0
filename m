Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B32B7C55ABD
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Nov 2020 08:37:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47F5D21D93
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Nov 2020 08:37:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gGqzQbwb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgKPIXR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Nov 2020 03:23:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50134 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726628AbgKPIXQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Nov 2020 03:23:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605514995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jeiiYaKwvyJyH5y+wcliNEtxg1lZaBGQ9AQLeWJN/BI=;
        b=gGqzQbwb7IKKQGoM4mfO+1id6FupOqOWq07Hs7T6tZwyPJ3RY3X5dWioe02qF6UqjZpS78
        HoGd9fgTbyUljtIXBjFy9aksvw6JFMJUdOJfGpARRX2pIB5LIvNTsS/N2+lbeL5b78wBWv
        ojzX7t86t54Fb0iwg2j5oa1jfvZS4yM=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-U4uI2y_6MySLXvc-rrJoJw-1; Mon, 16 Nov 2020 03:23:13 -0500
X-MC-Unique: U4uI2y_6MySLXvc-rrJoJw-1
Received: by mail-pl1-f198.google.com with SMTP id x19so8667288plm.19
        for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2020 00:23:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jeiiYaKwvyJyH5y+wcliNEtxg1lZaBGQ9AQLeWJN/BI=;
        b=n1tYtyY75lUlXZpVaTO4f+8KlPAdR8XE1gOquIXmcsaXwUKE09KiIbifZaW/N7sfjx
         gyRzNFbJ/jenUo+IQ2oP6Z4hy090nFHaM6UtP33hGx2cL37Ck5hlVPw+/zfEOU2hjlAY
         04fLAkvlpb1A9oVkC2Bx8Om1cWxmj9Xj8hkpz4HIdX32krNXWkwOxmTCz0x/Z7Tf/tPn
         CvBASbI7DWIWWhCC4/x4BARfS7ykNDdjT9yR2NMj51kkv67J0l/UJ6ykRBV5HgnWnW3q
         Gxw8hi4txisfLNOYwr3vAv0dyPXiYqhGXSxYvPItUptVAOIN5DrWwjxghVA2BPFcCVJo
         +vuw==
X-Gm-Message-State: AOAM531rOd5SJP0v+maQcVDqZmu/H/aEd3waq7T4mzhM+Sc87YFoUPJY
        6lPXvRMu6Bakpwr06SlVxOLrEs6gxOpWfYshmi8g4JVkYs7ykDN+rwCro5RAXKk+Cj6jP3RCpDP
        gFmIm3WNlww4aw1kSGLAg
X-Received: by 2002:a63:e449:: with SMTP id i9mr11752878pgk.438.1605514991978;
        Mon, 16 Nov 2020 00:23:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzWvWC06RRFkS8J1mzWHfVtjiyFOmtqKRyIrvdw6zdttDYEjyuEfXyWFrCDpv9AzTqrX3xz2Q==
X-Received: by 2002:a63:e449:: with SMTP id i9mr11752866pgk.438.1605514991672;
        Mon, 16 Nov 2020 00:23:11 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 26sm15258474pgm.92.2020.11.16.00.23.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 00:23:11 -0800 (PST)
Date:   Mon, 16 Nov 2020 16:23:01 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org, Donald Douwsma <ddouwsma@redhat.com>
Subject: Re: [RFC PATCH] xfsrestore: fix rootdir due to xfsdump bulkstat
 misuse
Message-ID: <20201116082301.GB1486562@xiangao.remote.csb>
References: <20201113125127.966243-1-hsiangkao@redhat.com>
 <e1e4f0a9-01bf-1ae4-5673-77738b3abd1b@sandeen.net>
 <20201113141553.GA981063@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113141553.GA981063@xiangao.remote.csb>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Eric,

On Fri, Nov 13, 2020 at 10:15:53PM +0800, Gao Xiang wrote:
> On Fri, Nov 13, 2020 at 08:10:39AM -0600, Eric Sandeen wrote:
> > On 11/13/20 6:51 AM, Gao Xiang wrote:
> 
> ...
> 
> > 
> > Thank you for looking into this - I think you now understand xfsdump &
> > xfsrestore better than anyone else on the planet.  ;)
> > 
> > One question - what happens if the wrong "root inode" is not a directory?
> > I think that it is possible from the old "get the first active inode" heuristic
> > to find any type of file and save it as the root inode.
> > 
> > I think that your approach still works in this case, but wanted to double check
> > and see what you think.
> 
> Yeah, good question. I also think it works too, but just in case let me
> do fault injection on a regular inode later (Donald's image is /var
> subdir...)
> 

Sorry for the previous wrong conclusion...

From the code itself, tree_begindir() only triggers for node_t == dir but all
dirents can be trigged by tree_addent(), so I update the patch and verified
with manual fault injection code as well...

RFC v2: https://lore.kernel.org/linux-xfs/20201116080723.1486270-1-hsiangkao@redhat.com/
fault injection: https://lore.kernel.org/linux-xfs/20201116081359.GA1486562@xiangao.remote.csb/

Thanks,
Gao Xiang

> Thanks,
> Gao Xiang
> 
> > 
> > Thanks,
> > -Eric
> > 

