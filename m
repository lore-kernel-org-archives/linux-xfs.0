Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDC71C5479D
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Jan 2023 16:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbjAIQfR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Jan 2023 11:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233106AbjAIQfR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2023 11:35:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE72B81
        for <linux-xfs@vger.kernel.org>; Mon,  9 Jan 2023 08:34:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673282068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QF1a5tKcYgole0jC8DNiwCqj35Xt7SSZg6oSwq6Hd2U=;
        b=LL1vXzY7bfvEAiG5JdfHkPLXUcdZn5EXq3VbBNF3dHjxYcmz494MNq3VoDDT2gHckNcavR
        VREjPyIdrca9ylIv8rqFCSJEbEDURjAMjqaq+H9LIO2Yo01UkfcxZGJyfSzbBv+2Z5ZFDO
        jncxPVjRO8jusHazSi0miOO157We59g=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-139-af62eW1QM4-V_uQet4iZsQ-1; Mon, 09 Jan 2023 11:34:26 -0500
X-MC-Unique: af62eW1QM4-V_uQet4iZsQ-1
Received: by mail-ed1-f70.google.com with SMTP id h8-20020a056402280800b0046af59e0986so5735687ede.22
        for <linux-xfs@vger.kernel.org>; Mon, 09 Jan 2023 08:34:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QF1a5tKcYgole0jC8DNiwCqj35Xt7SSZg6oSwq6Hd2U=;
        b=AAKShZhFFA4R8pb0tzQGRsCmnVN4f73E9DoGGhYCPY+Bz53nt07Cfbp289m63BGVsW
         WS7pDV5TsTZH6M2AuSyjUUzyh5q9Dx+kXGaChFw3n3vIxhxYy9Wlb0ULBPJfmE7UliAK
         40sVJbVHQa9bQnCeB5cuUzddbeKZAVaVS3dg53lH8IQweay3YiswsB562YLNjJX3Zh/d
         ZbYeruxzBA4tNkRwGpJAoofyUrP6y4lZ50AL8Xjq6fAHgUh6LlHLfEJa5NBIoHyVF2M3
         c0dYgc1ohlgwcN6scBx7SZnKl/FUEVzpxKtvuN8Y5MaOMjU13+firMEFwovZxUAsTZhP
         pkGA==
X-Gm-Message-State: AFqh2ko6n7PxhbGeK8lBHM6L4nOYxa8PtRzaXoNhH4BT8De7CnXMYiAu
        r3h3M/SO637QLP7UrfcVmjO5WcPa+XzR5Yd7+4o5t1Fhr1EwVVNsFfCYVJ7qyZPSkNQ22AV0yhm
        A42S/RRVOvY6Xx9/rw2c=
X-Received: by 2002:a05:6402:6c9:b0:46c:2c94:d30b with SMTP id n9-20020a05640206c900b0046c2c94d30bmr71921201edy.33.1673282065576;
        Mon, 09 Jan 2023 08:34:25 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtWq3XRc3T8ZfdZYEscSzO7mgFjxgNBvHYXWSEdpXL8eGnTOec2uHkncxWnZmWXlhYf4PjAmw==
X-Received: by 2002:a05:6402:6c9:b0:46c:2c94:d30b with SMTP id n9-20020a05640206c900b0046c2c94d30bmr71921191edy.33.1673282065382;
        Mon, 09 Jan 2023 08:34:25 -0800 (PST)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id k26-20020a508ada000000b00487fc51c532sm4014812edk.33.2023.01.09.08.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 08:34:24 -0800 (PST)
Date:   Mon, 9 Jan 2023 17:34:23 +0100
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 02/11] pagemap: add mapping_clear_large_folios()
 wrapper
Message-ID: <20230109163423.45o5moxlh7h6yvbb@aalbersh.remote.csb>
References: <20221213172935.680971-1-aalbersh@redhat.com>
 <20221213172935.680971-3-aalbersh@redhat.com>
 <Y5i8igBLu+6OQt8H@casper.infradead.org>
 <20221213210813.GW3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213210813.GW3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 14, 2022 at 08:08:13AM +1100, Dave Chinner wrote:
> On Tue, Dec 13, 2022 at 05:55:22PM +0000, Matthew Wilcox wrote:
> > On Tue, Dec 13, 2022 at 06:29:26PM +0100, Andrey Albershteyn wrote:
> > > Add wrapper to clear mapping's large folio flag. This is handy for
> > > disabling large folios on already existing inodes (e.g. future XFS
> > > integration of fs-verity).
> > 
> > I have two problems with this.  One is your use of __clear_bit().
> > We can use __set_bit() because it's done as part of initialisation.
> > As far as I can tell from your patches, mapping_clear_large_folios() is
> > called on a live inode, so you'd have to use clear_bit() to avoid races.
> 
> I think we can do without mapping_clear_large_folios() - we
> already have precedence for this sort of mapping state change with
> the DAX inode feature flag.  That is, we change the on-disk state in
> the ioctl context, but we don't change the in-memory inode state.
> Instead, we mark it I_DONTCACHEi to get it turfed from memory with
> expediency. Then when it is re-instantiated, we see the on-disk
> state and then don't enable large mappings on that inode.
> 
> That will work just fine here, I think.

Thanks for the suggestion, I will try to look into this. If it won't
work out I will stick to large folio switch, if no other objections.
In anyway I will remove the mapping_clear_large_folios() wrapper not
to encourage further use of such approach.

> 
> > The second is that verity should obviously be enhanced to support
> > large folios (and for that matter, block sizes smaller than PAGE_SIZE).
> > Without that, this is just a toy or a prototype.  Disabling large folios
> > is not an option.
> 
> Disabling large folios is very much an option. Filesystems must opt
> in to large mapping support, so they can also choose to opt out.
> i.e. large mappings is a filesystem policy decision, not a core
> infrastructure decision. Hence how we disable large mappings
> for fsverity enabled inodes is open to discussion, but saying we
> can't opt out of an optional feature is entirely non-sensical.
> 
> > I'm happy to work with you to add support for large folios to verity.
> > It hasn't been high priority for me, but I'm now working on folio support
> > for bufferhead filesystems and this would probably fit in.
> 
> Yes, we need fsverity to support multipage folios, but modifying
> fsverity is outside the scope of initially enabling fsverity support
> on XFS.  This patch set is about sorting out the on-disk format
> changes and interfacing with the fsverity infrastructure to enable
> the feature to be tested and verified.
> 
> Stuff like large mapping support in fsverity is a future concern,
> not a show-stopper for initial feature support. We don't need every
> bell and whistle in the initial merge....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

Thanks
Andrey

