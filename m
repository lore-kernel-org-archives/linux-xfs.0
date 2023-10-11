Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B621CD6E5A
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 11:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234851AbjJKLSg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 07:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234864AbjJKLSb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 07:18:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99670E9
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 04:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697023060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Zlo0/ziFMNgNYF1FEOPe0SVTb/Xnel6cZPY+1Ns248c=;
        b=YMqpUlEaN8q69LP2ABFX/e5f19hcocs1bKjddXJdKprwmc2oyui9kDdn9cOrWyLifDcm6v
        8TeiB2Hr2SNgZ4d0gWqpDuoe/exmMZLgoY+ywIdHXd5uY9J8lK0fNQj85IIuJikGANISQ1
        33TwR9hyKyPFHzPQJoAysA+SN6xHmh0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-zrNvpdpCPP2SsWleryD1TA-1; Wed, 11 Oct 2023 07:17:39 -0400
X-MC-Unique: zrNvpdpCPP2SsWleryD1TA-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-537efd62f36so5396529a12.2
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 04:17:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697023058; x=1697627858;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zlo0/ziFMNgNYF1FEOPe0SVTb/Xnel6cZPY+1Ns248c=;
        b=TppXlstM7CpIH7tlv2ScMP8a0kcxb1Lj/h38HLTT2HQ9j3DkW37HoRaBOduhocrWON
         cE+WAz8TArN1sUYHaCj++nUCKtAuiiVhjnZMcD9bQy5tDp8mHjYFSfDcrMyEtgvywnO6
         viDTRApgI4XUVCzeQSXA2S5k4cHcISZkbnxYDBZrXDh9UU7TjVh5+I6OFYOsJzZQhgJ9
         Db7hALl1B9MqCkd/mDeRiOiuBQkUUlMF9G596ZnafGKq5IOwXLOTOgOr7XGHJBZKFVM3
         40f32gCVjqvJWLm5P9N/hLD8QrzoCWdpG4ExbTGI3lECx0XrJGccw1+W8/V1m22XVS/J
         40hw==
X-Gm-Message-State: AOJu0YzjhObSX4HpsgI7O6duWwKMc8x0DWLcwu8k7nhNKmc1Lirgk4l/
        /EX7BtgxC3/4o5eDNHiDUgnzIWtigMs1gZPspd4TyE8/AiGtXBBlQLBVP7fsOUxkE/pbpmmsEF7
        NXBkevrn2ZBr+ZkPdTrhaVasOI3U=
X-Received: by 2002:aa7:c549:0:b0:531:1241:3e98 with SMTP id s9-20020aa7c549000000b0053112413e98mr18033176edr.9.1697023057997;
        Wed, 11 Oct 2023 04:17:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHZZ+YnNUe9yjYU4VsUgPkzYbFo3mygztYN0VRUFnAXJzd2X2vpYfGz2QCoVKm8w94kwwpTtA==
X-Received: by 2002:aa7:c549:0:b0:531:1241:3e98 with SMTP id s9-20020aa7c549000000b0053112413e98mr18033170edr.9.1697023057687;
        Wed, 11 Oct 2023 04:17:37 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id cy7-20020a0564021c8700b0053de19620b9sm462255edb.2.2023.10.11.04.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 04:17:37 -0700 (PDT)
Date:   Wed, 11 Oct 2023 13:17:36 +0200
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev, djwong@kernel.org, david@fromorbit.com,
        dchinner@redhat.com
Subject: Re: [PATCH v3 09/28] fsverity: pass log_blocksize to
 end_enable_verity()
Message-ID: <bwwev42i7ahrbdl4kvl7sc27zwrg7btmwf2j5h2grxp25mxxpl@4loq5hqs43gv>
References: <20231006184922.252188-1-aalbersh@redhat.com>
 <20231006184922.252188-10-aalbersh@redhat.com>
 <20231011031906.GD1185@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231011031906.GD1185@sol.localdomain>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2023-10-10 20:19:06, Eric Biggers wrote:
> On Fri, Oct 06, 2023 at 08:49:03PM +0200, Andrey Albershteyn wrote:
> > diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
> > index 252b2668894c..cac012d4c86a 100644
> > --- a/include/linux/fsverity.h
> > +++ b/include/linux/fsverity.h
> > @@ -51,6 +51,7 @@ struct fsverity_operations {
> >  	 * @desc: the verity descriptor to write, or NULL on failure
> >  	 * @desc_size: size of verity descriptor, or 0 on failure
> >  	 * @merkle_tree_size: total bytes the Merkle tree took up
> > +	 * @log_blocksize: log size of the Merkle tree block
> >  	 *
> >  	 * If desc == NULL, then enabling verity failed and the filesystem only
> >  	 * must do any necessary cleanups.  Else, it must also store the given
> > @@ -65,7 +66,8 @@ struct fsverity_operations {
> >  	 * Return: 0 on success, -errno on failure
> >  	 */
> >  	int (*end_enable_verity)(struct file *filp, const void *desc,
> > -				 size_t desc_size, u64 merkle_tree_size);
> > +				 size_t desc_size, u64 merkle_tree_size,
> > +				 u8 log_blocksize);
> 
> Maybe just pass the block_size itself instead of log2(block_size)?

XFS will still do `index << log2(block_size)` to get block's offset.
So, not sure if there's any difference.

-- 
- Andrey

