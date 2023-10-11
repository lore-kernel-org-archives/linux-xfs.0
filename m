Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC7F7CD6E7B
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 14:37:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbjJKOhv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 10:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232389AbjJKOhu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 10:37:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C0290
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 07:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697035026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=34baUARs91EkkCBFmzlWLNU8Iitqc+tKVHHJesgsXbs=;
        b=VTdgOqVKy2Xx7lxMktrxWkJ+GXYqmSqBX3ROIPzPmZ3tSlbwxWrTR0+VvCjdroZ/a9FpY7
        qOloTNnvfdRjM8A6CwyYGK8mXR6gGF5fnWjKfQNwVcVa6ztXBmrT2BMudPttVeoB6k5g79
        XdHoql9hePFsV9LNuYuBoB51cbjRFRg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-320-ZdHE0TeVN7e-At50G-WP4g-1; Wed, 11 Oct 2023 10:37:04 -0400
X-MC-Unique: ZdHE0TeVN7e-At50G-WP4g-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9bd7c682b33so69704166b.3
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 07:37:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697035023; x=1697639823;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=34baUARs91EkkCBFmzlWLNU8Iitqc+tKVHHJesgsXbs=;
        b=fg8x5WN5ZiDf/HzF5kROt5e+dUy0VI/Emxl6HbeIDsub8MS4tC77oI5t5jQpCRK0j/
         +K/facGL2ADuY7+JGVN6dF4xLuPj2w77Kn8bWjHxQyf7ixOCNhLhet+HZmfdGKxMcrSm
         +/HrnzDBTcziT7LIbNYv6ZLkPYCUhcQBUuqzxQ4XBiKQp5rvscjH7OqpvfbWvgiHtLKB
         Dnm+UINiHj/2TxMq7mwfKWx/VUr7oF1jMkEJLjUX3J7WX2JHK6Hekhkgnszm77YZSlMc
         MnjdpC950AeZUrDvYA7HsCZPTQPeanDiHmufeywF9uqHjEXryrfCvdoUghiX49rZ3zfj
         Vyew==
X-Gm-Message-State: AOJu0Yxf6fiPsg/tKYyqSpVu/HAMk+btGBI8Qlehe2s1gBwaiuU3l87w
        UzjVx4c1qRFAErvbDGrACWszahLUFdt4/5wU7bss3PzYnBbo9abTlzL3Vms1ivPepAUdQ+6Qw7v
        FdrqsmJKIyNpz6w3aOMs=
X-Received: by 2002:a17:906:4c9:b0:9a6:572f:597f with SMTP id g9-20020a17090604c900b009a6572f597fmr17398648eja.38.1697035023441;
        Wed, 11 Oct 2023 07:37:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPo2YB484LHLqni0xArxuSgEFDfsRNtQl070YQebW8HyUaykksPcIpxZzOOF+gbR7567Puiw==
X-Received: by 2002:a17:906:4c9:b0:9a6:572f:597f with SMTP id g9-20020a17090604c900b009a6572f597fmr17398636eja.38.1697035023119;
        Wed, 11 Oct 2023 07:37:03 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id dx8-20020a170906a84800b0099cbfee34e3sm9819150ejb.196.2023.10.11.07.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 07:37:02 -0700 (PDT)
Date:   Wed, 11 Oct 2023 16:37:02 +0200
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev, ebiggers@kernel.org, david@fromorbit.com,
        dchinner@redhat.com
Subject: Re: [PATCH v3 26/28] xfs: make scrub aware of verity dinode flag
Message-ID: <6o4zaqtxsyetq2cfaxuxfpkxf55tazafoen7plhjywetei6h6q@xnzapk24io6e>
References: <20231006184922.252188-1-aalbersh@redhat.com>
 <20231006184922.252188-27-aalbersh@redhat.com>
 <20231011010641.GI21298@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231011010641.GI21298@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2023-10-10 18:06:41, Darrick J. Wong wrote:
> On Fri, Oct 06, 2023 at 08:49:20PM +0200, Andrey Albershteyn wrote:
> > fs-verity adds new inode flag which causes scrub to fail as it is
> > not yet known.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!

-- 
- Andrey

