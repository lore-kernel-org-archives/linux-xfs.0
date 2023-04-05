Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51BD6C7619A
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Apr 2023 10:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237657AbjDEKhn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 06:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237640AbjDEKhk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 06:37:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BC65258
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 03:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680691009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8hFqrvNZsn86teCYjqs2wVJUMFZmHeavzTexdU+dVHw=;
        b=NAiLEzl10qFt6snaAQP2hfdhzRimdNsv7/DkZBn8NFMYda9ZexlvVrZGs+9B0if20NZrKh
        E0yElc4xN57N/sbHyTaGfEFctOyq8UsNrQwKzUmcQ7eUBRF+s+aIEBDaCADydrCsQnBwJv
        o3lOFa56cwTQ1qunAmDJTtWIYr7HpzE=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-581-AjXiN7SOOvCEEun8DXDzvw-1; Wed, 05 Apr 2023 06:36:48 -0400
X-MC-Unique: AjXiN7SOOvCEEun8DXDzvw-1
Received: by mail-qk1-f200.google.com with SMTP id b142-20020ae9eb94000000b007486a8b9ae9so13355610qkg.11
        for <linux-xfs@vger.kernel.org>; Wed, 05 Apr 2023 03:36:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680691008;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8hFqrvNZsn86teCYjqs2wVJUMFZmHeavzTexdU+dVHw=;
        b=PT05i6aUFSZdT7AlJTGk47qkXdZ8v6JH8MxhM1pO+Nsb52uF5W3k93dl3Q9s4LN8m9
         ANGOBaczxWzt2g1SEvbPisnG+xmQon6c+W/Z1gsOmmGNANwvPiZNqRJObSXJK+UexanC
         8luPLQ5IaVc9GKqONryIng6+Jsj8ojHM76T2IqOOsBb4ODAAYZXnVfw4Izn5x07FuP11
         uvLo8L2wAoOSQthJ/R8v0Rew7SKX2u4Ae4M6oNYc5d0dDikbYGUldSCC73yBCBEhKY0W
         pI9xNpwjAbsX3y4EH5dUto/LBYvznW5w81DAJJOl2QFR2UpO/7lYWcZN7QfDBFcIKfK3
         wOiw==
X-Gm-Message-State: AAQBX9eIdTmEIpYoBH1aRADBt1y6Fzqxx56zJwg399drL0fkvteBdkOw
        KpK0PM//z3EIm6bnNumyOk1gJ926swrVzt7+ad6mYkbxFaZjuU9D88qIi2hDuGqv15CBVeTAhZG
        jHk3cUAbMl99er4os42Q=
X-Received: by 2002:a05:622a:181c:b0:3da:aa9b:105a with SMTP id t28-20020a05622a181c00b003daaa9b105amr4016620qtc.17.1680691008079;
        Wed, 05 Apr 2023 03:36:48 -0700 (PDT)
X-Google-Smtp-Source: AKy350Yray4mqL/DA63FufP2W8G+Q2vCv/dEYqnAM/OkHjKwnv430c/AiUDk3FXiS3P6h8ilen17Eg==
X-Received: by 2002:a05:622a:181c:b0:3da:aa9b:105a with SMTP id t28-20020a05622a181c00b003daaa9b105amr4016592qtc.17.1680691007736;
        Wed, 05 Apr 2023 03:36:47 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id i2-20020ac84882000000b003d5aae2182dsm3911845qtq.29.2023.04.05.03.36.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 03:36:47 -0700 (PDT)
Date:   Wed, 5 Apr 2023 12:36:42 +0200
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     djwong@kernel.org, dchinner@redhat.com, ebiggers@kernel.org,
        linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
        rpeterso@redhat.com, agruenba@redhat.com, xiang@kernel.org,
        chao@kernel.org, damien.lemoal@opensource.wdc.com, jth@kernel.org,
        linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com
Subject: Re: [PATCH v2 05/23] fsverity: make fsverity_verify_folio() accept
 folio's offset and size
Message-ID: <20230405103642.ykmgjgb7yi7htphf@aalbersh.remote.csb>
References: <20230404145319.2057051-1-aalbersh@redhat.com>
 <20230404145319.2057051-6-aalbersh@redhat.com>
 <ZCxCnC2lM9N9qtCc@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCxCnC2lM9N9qtCc@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Christoph,

On Tue, Apr 04, 2023 at 08:30:36AM -0700, Christoph Hellwig wrote:
> On Tue, Apr 04, 2023 at 04:53:01PM +0200, Andrey Albershteyn wrote:
> > Not the whole folio always need to be verified by fs-verity (e.g.
> > with 1k blocks). Use passed folio's offset and size.
> 
> Why can't those callers just call fsverity_verify_blocks directly?
> 

They can. Calling _verify_folio with explicit offset; size appeared
more clear to me. But I'm ok with dropping this patch to have full
folio verify function.

-- 
- Andrey

