Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 767A3C7619A
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Apr 2023 14:17:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238076AbjDEORx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 10:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238290AbjDEORu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 10:17:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74CD2C1
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 07:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680704178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=net1/YQpLyeedtAUAtKmhMoSFz+7An5MzKe0V2cpLas=;
        b=OUcbgABGX6uIRr9ssY8905TAc7UTKGEKA5iRwcwlb8g6JMC53vywQTpOZTZNTJdq67E9eD
        UkvV2mPFyoV2r9FBiDLJNp0dgiLTkex5G/I6GOjLCNtDzuuNZejdq8gHcJQbi6aFetVziK
        wD+MsButmJnP66zhsZEHn0Mvr8kVPd4=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-FvKvfUCwNxydD94crBxn1g-1; Wed, 05 Apr 2023 10:02:19 -0400
X-MC-Unique: FvKvfUCwNxydD94crBxn1g-1
Received: by mail-pj1-f72.google.com with SMTP id j3-20020a17090a94c300b0024018f0656cso11464000pjw.2
        for <linux-xfs@vger.kernel.org>; Wed, 05 Apr 2023 07:02:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680703331;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=net1/YQpLyeedtAUAtKmhMoSFz+7An5MzKe0V2cpLas=;
        b=gIBqvAhb+7UoGNEnTqaGVQsAmQexxFe78ve4Zd4GQfKIAuJt4wu9vtrKJXR2TZ1aV6
         P1FgPf0VT222ZEJRctb/j0GTzONDHTs87TndLENqR3mMBt/Sjf9ckAbeOwu2pWYWDj2j
         sdRIS5BYBznbyfDHsCc4GxYWCv0DeR6+JZTQv6k4tj/ADUV6Cn65brH+p4S0BvYT9KXN
         UQRtxkWOUHCjOgqstNAov8kmCo4mN2WDvNmAc6ZWcegYtIl4m8ovEOLUrOhCpXYShVgb
         QX8Y9YgsODFsIaXcC4qBv7fAouw9smV6wuR9oWhAjLSFsxNi6aZkMO1kKoFH2vR89l3P
         ezdw==
X-Gm-Message-State: AAQBX9dOScj37ZlxwDaD+4Tk9hjyLbSytZYERUEg9EKGDz8zaBiC71VY
        fNlOcvbu/be7UlzElMafTNYWcrObcIVJO6eFkUJut+UIlTJJ+PeaRVvkY2LL+s+n+sBOljzak8I
        yXgwcSISo5jLh1mpZikHo
X-Received: by 2002:a17:903:283:b0:1a1:cd69:d301 with SMTP id j3-20020a170903028300b001a1cd69d301mr6292224plr.68.1680703330928;
        Wed, 05 Apr 2023 07:02:10 -0700 (PDT)
X-Google-Smtp-Source: AKy350Z3hrO2tDczikPPadND/siCWP3StMDF6ZwRfuQDU1LtW+SuQXatmasFWBRAsAV4qHbVdUEpFA==
X-Received: by 2002:a17:903:283:b0:1a1:cd69:d301 with SMTP id j3-20020a170903028300b001a1cd69d301mr6292202plr.68.1680703330583;
        Wed, 05 Apr 2023 07:02:10 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id b24-20020a630c18000000b005023496e339sm9037285pgl.63.2023.04.05.07.02.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 07:02:10 -0700 (PDT)
Date:   Wed, 5 Apr 2023 22:02:02 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
        brauner@kernel.org, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, djwong@kernel.org, amir73il@gmail.com,
        linux-unionfs@vger.kernel.org, anand.jain@oracle.com,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        fdmanana@suse.com, jack@suse.com, linux-fsdevel@vger.kernel.org,
        ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/5] fstests/MAINTAINERS: add supported mailing list
Message-ID: <20230405140202.bdp3lzgross2cjbt@zlang-mailbox>
References: <20230404171411.699655-1-zlang@kernel.org>
 <20230404171411.699655-4-zlang@kernel.org>
 <20230404221653.GC1893@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404221653.GC1893@sol.localdomain>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 04, 2023 at 03:16:53PM -0700, Eric Biggers wrote:
> Hi Zorro,
> 
> On Wed, Apr 05, 2023 at 01:14:09AM +0800, Zorro Lang wrote:
> > +FSVERITY
> > +L:	fsverity@lists.linux.dev
> > +S:	Supported
> > +F:	common/verity
> > +
> > +FSCRYPT
> > +L:      linux-fscrypt@vger.kernel.org
> > +S:	Supported
> > +F:	common/encrypt
> 
> Most of the encrypt and verity tests are in tests/generic/ and are in the
> 'encrypt' or 'verity' test groups.
> 
> These file patterns only pick up the common files, not the actual tests.
> 
> Have you considered adding a way to specify maintainers for a test group?
> Something like:
> 
>     G:      encrypt
> 
> and
> 
>     G:      verity

Good idea! Let's check if this patchset is acceptable by most of you,
then I'll think about how to add this feature later.

Thanks,
Zorro

> 
> - Eric
> 

