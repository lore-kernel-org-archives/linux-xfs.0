Return-Path: <SRS0=8CmW=W6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD1EC3A5A2
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Sep 2019 21:33:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 523A6204EC
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Sep 2019 21:33:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=mbobrowski-org.20150623.gappssmtp.com header.i=@mbobrowski-org.20150623.gappssmtp.com header.b="W7+Hedgg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbfICVdC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Sep 2019 17:33:02 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:38925 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbfICVdB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Sep 2019 17:33:01 -0400
Received: by mail-pg1-f174.google.com with SMTP id u17so9927743pgi.6
        for <linux-xfs@vger.kernel.org>; Tue, 03 Sep 2019 14:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mbobrowski-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jDbxMpS5LYlU984Ph/2POHc4fiXRIXts9atICT35mak=;
        b=W7+HedggPYfelbnF2mNp2MgXt6yq39eQ5U0S/eunv5h7VyOJsUjY3WxYV1VOGCFg01
         FBPGMSXd78dl+fmodCCV6GycFuRQIj4wy+Qm9ZR/FyI9IWuaxCt3taUjwQDxiOw7Qvj7
         Pz5upHS/tpw3d0XlH5Er6ELX2n9ldPoXy1h7UozC1TB4eUJ9DYouBWA+PH6Ur6Mxzpwg
         5oeLTK0W0IUzcRjHG9UyuP8qai3ltqd7cR5CUjOuROCBAdbhPVV5h1PsLMn5Yecm4VD/
         juQ90TR6xfpH/l7OzZKEdUqqh61t5tJlBv7gmT/fhBz1a3by4GgkTOHD6/tEMREsx6/G
         iHIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jDbxMpS5LYlU984Ph/2POHc4fiXRIXts9atICT35mak=;
        b=eQxmzVanq6g5r6068invG6zik7WP3APh6+RpVKX+XssbYpqLc3vYmDF0lJHp7lfnpy
         Z7IqLQ7bkroVRgAsWqLZn8vbPlhUnnn2+X13BXm7KzFdPNy6A0gpbfV3NPyWu9FHQIgn
         Ux30c3He9AGp75uxStlihhS8hDCnVZYO8Y6vrcdLL4RIwP/VFIbil5vfKOFQnlx5iYOh
         1lNt3F1j8SXnUJfDcNuGejAsl0wptYfBGa38Q52sZYPONM44qFq7fnMiR385UoxFxssH
         skqeaP6W64yY2smEBAezSJLfdHeg3onJDIgaAAW2CwtRP20wQrM8kJ8vlj+fbiswMmYe
         WocQ==
X-Gm-Message-State: APjAAAWzffQbTex3Vu3BtpdAfmYRaeqZy5dg1mcFcLboep8gk6DqmaNv
        Q2aoecH7usho7oHCzHVx44mScMre1g==
X-Google-Smtp-Source: APXvYqyuVwjmgWE0sbpgq0U+4HHtdaZ9+1HZBl9RuZm0YIgALjcuYBmXyHUJorZFLVyXvTYKe8hmtA==
X-Received: by 2002:a63:29c4:: with SMTP id p187mr32639330pgp.330.1567546380976;
        Tue, 03 Sep 2019 14:33:00 -0700 (PDT)
Received: from athena.bobrowski.net ([120.17.56.123])
        by smtp.gmail.com with ESMTPSA id 15sm20485962pfh.188.2019.09.03.14.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 14:33:00 -0700 (PDT)
Date:   Wed, 4 Sep 2019 07:32:54 +1000
From:   Matthew Bobrowski <mbobrowski@mbobrowski.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: iomap_dio_rw ->end_io improvements
Message-ID: <20190903213254.GA11431@athena.bobrowski.net>
References: <20190903130327.6023-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903130327.6023-1-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hey Christoph!

On Tue, Sep 03, 2019 at 03:03:25PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this series contains two updates to the end_io handling for the iomap
> direct I/O code.  The first patch is from Matthew and passes the size and
> error separately, and has been taken from his series to convert ext4 to
> use iomap for direct I/O.

Great, looks good and thank you for expediting this change for
me. I'll make sure to drop these changes in the series that I'll be
posting through very shortly.

--M

