Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 623AAC5479D
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Jan 2023 19:35:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237024AbjAITfh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Jan 2023 14:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235349AbjAITfg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2023 14:35:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2F617429
        for <linux-xfs@vger.kernel.org>; Mon,  9 Jan 2023 11:34:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673292891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CQMDnAlZYFrg+FDGtR42bVuM/yGIczuxLJaq+U0aLyM=;
        b=EexZ35QrUi+QM1auwV0h+B8NAbPZeyAHWuu3XK9ScotrLysaPKzcebe0TwAbiuo+e5E03T
        PKvt4NdOfOESSVuZxkQLzChxPtMcKnhQasWt/5UxYCCGhaht8rEEvNE9I1LY2asd8YLgFj
        Qjn/Sj+1UWsNsnCwaBKf6T5PamUSw9M=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-380-9M6tB4xPNsyWbICg5zz7fA-1; Mon, 09 Jan 2023 14:34:50 -0500
X-MC-Unique: 9M6tB4xPNsyWbICg5zz7fA-1
Received: by mail-ed1-f71.google.com with SMTP id l17-20020a056402255100b00472d2ff0e59so5924371edb.19
        for <linux-xfs@vger.kernel.org>; Mon, 09 Jan 2023 11:34:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CQMDnAlZYFrg+FDGtR42bVuM/yGIczuxLJaq+U0aLyM=;
        b=j3J3fQb5NxF+0DyOVx8bRszCqA1jiU7D7NcZ8FqMTUrB1yuo81i64sVqqHtg5R4sH3
         EV8KhUbaK6McbyRZmkoL+h/Te3QZT8u6fr4U1/3JcXlE6DBzLKRkfd6Gbnt/0HKS06+j
         +ClC4mk1yZpwxPO7EyvkSEWchYrtmkRuACGYHaSiSwfdAfV9FuwMLg37TTdcqsACJk2n
         AG/rDOhhIZV5u1Yo/WyRLhn6z4fssRLgu8v8c+N5mi8U9bCmaeqx8gBY3otD16XVAdK7
         LmC33mQ7P3Jv412W28Fn5cQW6T7cP7Gq2BepKs0fZcrc2GFzjYh2a2PlTgl4SPl+5R6k
         gShQ==
X-Gm-Message-State: AFqh2krNliOBPBrWgz/35qTWvwG3J+tPiXk61Lp8cZNFWTSR2AuGW/CR
        QZTH5mhXVEOv+Z7QOMsx4TeC9wZ6uvEDcuve8LYjI7Q8aRfOsNNrdW3AKeiEezHuvMKczhKhIHV
        udEb8qihc1rzChP1Jovs=
X-Received: by 2002:a17:907:1759:b0:7ad:d250:b903 with SMTP id lf25-20020a170907175900b007add250b903mr72215588ejc.56.1673292889358;
        Mon, 09 Jan 2023 11:34:49 -0800 (PST)
X-Google-Smtp-Source: AMrXdXu21stgD+/1EjhJf7J1BgUsBezxrJQMbjX6bK3yWH2CTzDuxtPuKAfnC7i/jdXetHE5M2jNRw==
X-Received: by 2002:a17:907:1759:b0:7ad:d250:b903 with SMTP id lf25-20020a170907175900b007add250b903mr72215575ejc.56.1673292889177;
        Mon, 09 Jan 2023 11:34:49 -0800 (PST)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id u2-20020a1709061da200b0083f91a32131sm4076001ejh.0.2023.01.09.11.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 11:34:48 -0800 (PST)
Date:   Mon, 9 Jan 2023 20:34:46 +0100
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 00/11] fsverity: support for non-4K pages
Message-ID: <20230109193446.mpmbodoctaddovpv@aalbersh.remote.csb>
References: <20221223203638.41293-1-ebiggers@kernel.org>
 <Y7xRIZfla92yzK9N@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7xRIZfla92yzK9N@sol.localdomain>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 09, 2023 at 09:38:41AM -0800, Eric Biggers wrote:
> On Fri, Dec 23, 2022 at 12:36:27PM -0800, Eric Biggers wrote:
> > [This patchset applies to mainline + some fsverity cleanups I sent out
> >  recently.  You can get everything from tag "fsverity-non4k-v2" of
> >  https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git ]
> 
> I've applied this patchset for 6.3, but I'd still greatly appreciate reviews and
> acks, especially on the last 4 patches, which touch files outside fs/verity/.
> 
> (I applied it to
> https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git/log/?h=fsverity for now,
> but there might be a new git repo soon, as is being discussed elsewhere.)
> 
> - Eric
> 

The fs/verity patches look good to me, I've checked them but forgot
to send RVB :( Haven't tested them yet though

Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>

-- 
- Andrey

