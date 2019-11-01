Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94AE0CA9ED1
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 14:43:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D349217D9
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 14:43:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="F1mV5T+e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbfKAOns (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 10:43:48 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:39022 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727390AbfKAOns (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 10:43:48 -0400
Received: by mail-il1-f195.google.com with SMTP id f201so3225053ilh.6
        for <linux-xfs@vger.kernel.org>; Fri, 01 Nov 2019 07:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qo1YkX5K53htT1v846eBmxvfTkH+lDKypx0tZHv9K/k=;
        b=F1mV5T+e7alskaz/TMQCqlbDe7C9X5eyBcADwQfnOGKvJoerMwk5hl8yMg5U7mHNv8
         2TZI4RMSQrIcKNqaT7Z+njAo4+vetJGRGDD12jstSf0mdfumCEuTvWLEvsp/v9KkajD/
         NUAh0seO4qPSwzyctxmdNtOM6ft+8DlPYOMcWCfWRNIqkEBdFTv258Qh5TuqlRl6IH0q
         ItGzf3QO2l+aCWiaIN8WKMuBONptYxpNU2/eOikY9yjddSxyP6IQiz4MB1+eGHKD5S/y
         RPiHxjW2UfYU3e2E46XNiRWDfou45mNveSVLcs0UTk0MAUiSssB5u5+vyJ7CBsYE1vJ5
         2Npg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qo1YkX5K53htT1v846eBmxvfTkH+lDKypx0tZHv9K/k=;
        b=NEuHHAtNt07+VgPyIyVENgrsKV5uqa5ovUzDpvTT0nzycvb47MmDpbTLNIWS3KrXEG
         y6evbjNO77pLs7ioZQVyr9r1UXAaCf30oSbpEeZXBRbpHlhWC0K35a67/08mAK2wryCD
         NbOZ6OBOlRa40Uc3QGqLkP4ft8joEH4oV2o3eDBYMZCZBy9sIUUYZEvqc2eMpUFEgR/z
         qRGbnYyWWl/GSg67VtA8+v3Oz0+iJcn1FjrF1SKXqd4HWFNgtTIImZxslpS61sB5YbSk
         x5YEA/LaU51sBL+Trqiii8d02GxT6j4ppkvbLnqSJIM+YKweezY9Nams+RMwiVzSIeTa
         jkrQ==
X-Gm-Message-State: APjAAAUtQLLzdW0xSAeasaUQrOZvrvngKW7fZFYhrSKmEHf7vVkEv5DY
        x8mGrQBGhoo9sYafnUjn9F1Z4Ne4ASpAWg==
X-Google-Smtp-Source: APXvYqypoGx2owUeN4bTKCioAqMyCDKZuIoXDSee7i++vVR9rVQPdFB2uPEXTfVYmg8yTLuqksRWIA==
X-Received: by 2002:a92:af99:: with SMTP id v25mr13239884ill.167.1572619427173;
        Fri, 01 Nov 2019 07:43:47 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o10sm695606iob.29.2019.11.01.07.43.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Nov 2019 07:43:46 -0700 (PDT)
Subject: Re: [PATCH v4] loop: fix no-unmap write-zeroes request behavior
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
References: <20191031032948.GA15212@magnolia>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2e7b4eed-58fb-a788-f17d-83b582b28184@kernel.dk>
Date:   Fri, 1 Nov 2019 08:43:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191031032948.GA15212@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/30/19 9:29 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Currently, if the loop device receives a WRITE_ZEROES request, it asks
> the underlying filesystem to punch out the range.  This behavior is
> correct if unmapping is allowed.  However, a NOUNMAP request means that
> the caller doesn't want us to free the storage backing the range, so
> punching out the range is incorrect behavior.
> 
> To satisfy a NOUNMAP | WRITE_ZEROES request, loop should ask the
> underlying filesystem to FALLOC_FL_ZERO_RANGE, which is (according to
> the fallocate documentation) required to ensure that the entire range is
> backed by real storage, which suffices for our purposes.

Applied, thanks Darrick.

-- 
Jens Axboe

