Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A5E5C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jun 2022 14:53:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233378AbiFXOxX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jun 2022 10:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233380AbiFXOw5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jun 2022 10:52:57 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE9280534
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jun 2022 07:49:19 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id s17so2920311iob.7
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jun 2022 07:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=sn0WBCUd+SNKZr7yNtqbgNYTO7fokpMiyDUJDfaGrhM=;
        b=PXTsa5jpWy4du5CcAECwnpwGZu/1A+vPGawPGHkt+4UknNJfYSWs1WIvn/AKvlYB93
         DwlgqS7zeaw7r1fmFNAtQLdOCtkftRsY6tYsbYprcGr9rq4u6f8rVLIgDLCj1Y+PQhv/
         XYSKTBho8omfXdbRCsaktnpilOG1OEGKidIgfvf/x7WHy/b5B/15scpqPrRb+NuU9uX3
         DrlI37XOee/s2tDpJXb/ebdKl58Y25yu3+Xwdtw5+O/SaZce+myqwgNdjXDcc4ooLprr
         7y15yE8Q9Y35dlxRqA6DZZuSp/CXEzCNO1zi33OFj6nAnt+pfxpaWMgStdRb73ueFfEn
         eFFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sn0WBCUd+SNKZr7yNtqbgNYTO7fokpMiyDUJDfaGrhM=;
        b=Gsvtu2YG8iYVv/f9JMPa74RFP32YPPHN+M0YmziwBJgZ4KlVKzaZJ6y4aSlZwizDAH
         q5gowXjOO9ViYI+G4lJaL50g+bVqVgIO4penFd+Ku00Hu0EHr6qXeui/C8RIRql6Yb9S
         n9TQMvmaE5g9CxzBkzhX4SEvY8rGl5MXdbc1Glpf/yITYImaKXraXEzmKqNFKjEHQCMO
         Bi1C99MgFlmM95cRiNR1t/GiNdRt3L2Psn9rxP6y88LjtcRv795A7kBcLFWDtXgGoMh/
         8TiIQZHl5YI6DDAIPWo+3qMRDPqWYQ3rh1W8aWGPiX3dbZejTZSXOIb488wsWVYFJHhM
         8+0w==
X-Gm-Message-State: AJIora++8qIM+Lg/kyAkKJSxdhSQLLXN3AJNzaz5oAnKFQSu9fXO+i79
        OGRWTapPXMGAmVTrw5elLj5cUA==
X-Google-Smtp-Source: AGRyM1sBp9hf+MBf3qeVE3KmJQS5OBECT+OiSpKpBG0bUmd/EC5icONGUY+WVJyRJQKZK/GhVpwppw==
X-Received: by 2002:a05:6638:2645:b0:332:55e1:10 with SMTP id n5-20020a056638264500b0033255e10010mr8954400jat.121.1656082158686;
        Fri, 24 Jun 2022 07:49:18 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id k12-20020a6b7a4c000000b0067411d7f769sm1342090iop.5.2022.06.24.07.49.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jun 2022 07:49:18 -0700 (PDT)
Message-ID: <2189b2ff-e894-a85c-2d1b-5834c22363d5@kernel.dk>
Date:   Fri, 24 Jun 2022 08:49:17 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [RESEND PATCH v9 00/14] io-uring/xfs: support async buffered
 writes
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        kernel-team@fb.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, david@fromorbit.com, jack@suse.cz,
        willy@infradead.org
References: <20220623175157.1715274-1-shr@fb.com> <YrTNku0AC80eheSP@magnolia>
 <YrVINrRNy9cI+dg7@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YrVINrRNy9cI+dg7@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/23/22 11:14 PM, Christoph Hellwig wrote:
> On Thu, Jun 23, 2022 at 01:31:14PM -0700, Darrick J. Wong wrote:
>> Hmm, well, vger and lore are still having stomach problems, so even the
>> resend didn't result in #5 ending up in my mailbox. :(
> 
> I can see a all here.  Sometimes it helps to just wait a bit.

on lore? I'm still seeing some missing. Which is a bit odd, since eg b4
can pull the series down just fine.

-- 
Jens Axboe

