Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A0FCCD6E5D
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 11:14:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234737AbjJKLOR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 07:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345865AbjJKLNx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 07:13:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B8A98
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 04:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697022787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QCk7wawpxWR/0pRF2lN6xcLeaTX+QEqqMdqYqyMN2VM=;
        b=aN/dGeyJN9syJGWENat2GFTQ7YX3OA+IbvunM9j582KfNJFHzg4q02kCKAetJ5P50mkfag
        eEYHir6ycJZabBNvCElc9LFNbBs7vK7pI6p3iESitk973/jh/dLlQ0IMIqoQO3T0s1n3qd
        0+uCKSUX5gxlYh1//KwCPCRwuSOgrEs=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-rGzaVPtZPKiYjHeB9TNEVA-1; Wed, 11 Oct 2023 07:13:06 -0400
X-MC-Unique: rGzaVPtZPKiYjHeB9TNEVA-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5368aae40d2so5460825a12.2
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 04:13:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697022784; x=1697627584;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QCk7wawpxWR/0pRF2lN6xcLeaTX+QEqqMdqYqyMN2VM=;
        b=QjrQzJBV0WrvGOr6DgGsqxc4tTKr1TRPLSeknLG8NZlsxQwyg4Gt2UYDX5ELUcdDAI
         Jnkg9vjd1tuZXksdvZZ0ld2g3Gjhj2kg4SbfOkm8noofOP4DKtf4E3WrgvFTW8FP20um
         +ZafTec4gxx3S+tJUGLYr8fzaGpUxZtOvX0wXGdYZtMeGIU/HQ6LX1Z8BYGtjqvk3Bi9
         MRDRJlvriIElm0epoas42UbnFF/e1Doy2cexfHdV0qlcSM4KVvx3bAr/8qPRW+u3Qwyc
         2XvMm8TOy6KVIkg8mJq6DlJinDaMJDcg7QT3ceXM6QK2BKiTGavXO624+epINzwguXPm
         0TWA==
X-Gm-Message-State: AOJu0Yz/rpnNWLiycEF1/NmFUyZI/EeB+A9bmtCv9sORLleB4/gEFxM8
        hjQHeOaj/z1UjO+DM9plZAjL+jgA+pUY95dzu/buvM7/fOzqkqUOXbTn9lgI/W9aEk3azQwCfww
        6Un+36yr6qSCUPOZ72qJ+t5huahs=
X-Received: by 2002:a05:6402:3458:b0:527:fa8d:d3ff with SMTP id l24-20020a056402345800b00527fa8dd3ffmr16817581edc.6.1697022784805;
        Wed, 11 Oct 2023 04:13:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFM6DlOkWJnlkS9DXFMOt8lJBctYfYXrLJfXwevIGXqlKhPGtt1iOqZUje5Umfc+WHxwjEQkA==
X-Received: by 2002:a05:6402:3458:b0:527:fa8d:d3ff with SMTP id l24-20020a056402345800b00527fa8dd3ffmr16817572edc.6.1697022784532;
        Wed, 11 Oct 2023 04:13:04 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id s14-20020a056402014e00b005309eb7544fsm8696880edu.45.2023.10.11.04.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 04:13:04 -0700 (PDT)
Date:   Wed, 11 Oct 2023 13:13:03 +0200
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev, djwong@kernel.org, david@fromorbit.com,
        dchinner@redhat.com
Subject: Re: [PATCH v3 08/28] fsverity: pass Merkle tree block size to
 ->read_merkle_tree_page()
Message-ID: <y3cj7zsuhdybwk4f6sfxlx52srhtwgetu4updcxe7fqex7w7sr@6qyxm5blq3qs>
References: <20231006184922.252188-1-aalbersh@redhat.com>
 <20231006184922.252188-9-aalbersh@redhat.com>
 <20231011031712.GC1185@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231011031712.GC1185@sol.localdomain>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2023-10-10 20:17:12, Eric Biggers wrote:
> XFS doesn't actually use this, though.  In patch 10 you add
> read_merkle_tree_block, and that is used instead.
> 
> So this patch seems unnecessary.

True, will drop this one.

-- 
- Andrey

