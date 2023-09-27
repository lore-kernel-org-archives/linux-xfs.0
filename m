Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 154DCE7F150
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Sep 2023 02:53:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235705AbjI0CxI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 22:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235865AbjI0CvH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 22:51:07 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178B01F1B
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 18:18:47 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id af79cd13be357-7742da399a2so380819485a.0
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 18:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1695777526; x=1696382326; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LtwNx0bbAtYKFwMATRYOsNB6/aB6xeUP5MHzuRhubV8=;
        b=xL5aWIQD2nz4KCM1fWpoB3/tQ7uCxyYhE96aMxv1AjuKquKDfMp5Wu+yHk0bEwi/rK
         qxazk8rsC4moPpS2AVkHK41A3yOiiskyBISrBdEB/g10qD0ZifpsN+/XSnfW24TM7IJm
         NgKzDIK8/eYXkyw6rwXiu/tfPY4GQSsGZgASY9k5W86JOtmlDU9r9nfZqT6RhRhqrm1R
         zZta60YxHA7GIyt1ENxmyN9OOJl9wNAREDzjpui/PUV4JOiFIMdWPNg3r1LanDHrI/4Z
         QjNMnH8GF/NGIwG/d24QdlK/J/REuxVMCUP5QZhvKbbIOB0bE6amKi2+yULTT9kA8ia8
         zK9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695777526; x=1696382326;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LtwNx0bbAtYKFwMATRYOsNB6/aB6xeUP5MHzuRhubV8=;
        b=wpFyfH1OUtzdIchufvQSZDoZxaFaP2diXgx/sAEWzeT/2h39Vb4TacugLfcGluINYM
         axydeKnpW9vJWuTFQpsU+tUxE/0We+yaTSjACNdTzDdAfcfqAuN+Dqgu0C6OEdwGpgny
         Y7peudxCDfUAcebxGy4xXhCpxEx2R49jTPMrPYDxiXPOA2wWefW4/1t/o6shAQ8TyhvB
         ec5cm74MQ/7duJE1IyUShOH1mCLMd0B4T/J8h9aLkF1ZNtdI8vjQuFioYF3OinchNuZU
         pFxkKfTqLp9OF52KbAnQzxb0YOZaFsXECgq4h5WRgcdonLunQIKDKsqvKss8wFgGvMD2
         2LMQ==
X-Gm-Message-State: AOJu0YxrXqpn865YlBle6hkdxkC7qrjL+n+41nklZjG/oYMt1KAn/Znr
        /zBxEszck7p9DpU1a3ZKimVjxGMlVc5ZDt6AIgQ=
X-Google-Smtp-Source: AGHT+IGMERguD8Nbh7njgpyWv8MTtUkMcRbsGHRvIE69chNK2m7X1prW1+mTzN4JrcPj+g12qemmFw==
X-Received: by 2002:a05:620a:1218:b0:774:1e8a:3182 with SMTP id u24-20020a05620a121800b007741e8a3182mr427232qkj.26.1695777526164;
        Tue, 26 Sep 2023 18:18:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id c14-20020aa7880e000000b0069100e70943sm10595329pfo.24.2023.09.26.18.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 18:18:45 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qlJCM-0064Mq-0S;
        Wed, 27 Sep 2023 11:18:42 +1000
Date:   Wed, 27 Sep 2023 11:18:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
        nvdimm@lists.linux.dev, chandan.babu@oracle.com,
        dan.j.williams@intel.com
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
Message-ID: <ZROC8hEabAGS7orb@dread.disaster.area>
References: <20230915063854.1784918-1-ruansy.fnst@fujitsu.com>
 <86167409-aa7f-4db4-8335-3f290d507f14@fujitsu.com>
 <20230926145519.GE11439@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230926145519.GE11439@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 26, 2023 at 07:55:19AM -0700, Darrick J. Wong wrote:
> On Thu, Sep 21, 2023 at 04:33:04PM +0800, Shiyang Ruan wrote:
> > Hi,
> > 
> > Any comments?
> 
> I notice that xfs/55[0-2] still fail on my fakepmem machine:
> 
> --- /tmp/fstests/tests/xfs/550.out	2023-09-23 09:40:47.839521305 -0700
> +++ /var/tmp/fstests/xfs/550.out.bad	2023-09-24 20:00:23.400000000 -0700
> @@ -3,7 +3,6 @@ Format and mount
>  Create the original files
>  Inject memory failure (1 page)
>  Inject poison...
> -Process is killed by signal: 7
>  Inject memory failure (2 pages)
>  Inject poison...
> -Process is killed by signal: 7
> +Memory failure didn't kill the process
> 
> (yes, rmap is enabled)

Yes, I see the same failures, too. I've just been ignoring them
because I thought that all the memory failure code was still not
complete....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
