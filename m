Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37628C4320A
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 19:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D537613A7
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 19:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhHWTC7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Aug 2021 15:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbhHWTC6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Aug 2021 15:02:58 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5864DC06175F
        for <linux-xfs@vger.kernel.org>; Mon, 23 Aug 2021 12:02:15 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id x15so1301464plg.10
        for <linux-xfs@vger.kernel.org>; Mon, 23 Aug 2021 12:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vq24WZbvZaeS/j6ldFMsVI1j+zKK5/FPuVsdEfF/56k=;
        b=TOwz77agxsX/Z6vHOfh3RsJJK/W+1zHnCyvXzIPPHH0ETLgijhzZ2KHfvVbfuBZXUU
         W7RxLzFOomU+omO1e7IJYkHSpOfBocIITKkP0hoCz7hrwaeTv/tHtIBs6v3Qm1cEeE3s
         BYWjlByN+DL2fqSBW2lTF4DMrC4azMiQx3p9eHngsI1+Y3jv87+8I3LNkxBTXJjANr30
         7CEN4njK3Ii27U1oagG8VmxC/Istn9iIJA2ak6hRDgtGP9+kbeGZMFxY8r8X94jb6OyD
         b+D1ylmnZf9dGOEPKHqAEyi5YLYmwJwKoN8RwMIlZbI80xPi4ZwIXBDd+RneAdyVTz/1
         hQlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vq24WZbvZaeS/j6ldFMsVI1j+zKK5/FPuVsdEfF/56k=;
        b=cJSAXrZqlEJy9WzvevJMleLavcqVxQgVEh+RlGiYp2WgmJ9obenMrMjnI8Jb5ftoyy
         k4JyoKqjmTVVYpEzz+oWwiJmXWiVTiO3gX36wJ9Q3EGl+Y4OTmvxeoqm74CiJj9ySNxv
         L2LJdW8fhMQVB0ZehQiVnz+WvJQPY4wnmBl/ipyAQ+u5ThGd40anMWSS+Et1cG1Sf63E
         tYn06Sbd37IKSCWI6H91ggo1G0y7I2lhZsTsYv4T9GkKd0St5V93+TGpqSmaionzET78
         DFEOTHRota0RHvnY/8ey0NhJwo3sIfjOYWand5hlcmuZeO8wtQIqqxrflcHNfrNPT3sW
         kXTg==
X-Gm-Message-State: AOAM532n5jK15nQHfh8n/NWWgztDNpb7e0uWuZOGygjc5GiXhRKxMB9E
        o0WUcq4dxlsGWRN1d3CCUwfsE2C2+80UuPwOE+utyQ==
X-Google-Smtp-Source: ABdhPJw4ffFVirjni1kbtamzxeZlOeZAU2Wfrl9BJ1rGaHZkFmiEzD+T7HoyhzHN8ZFTf8oDeKzbEe1A35lBSTzbMnU=
X-Received: by 2002:a17:902:9b95:b0:130:6a7b:4570 with SMTP id
 y21-20020a1709029b9500b001306a7b4570mr18038564plp.27.1629745334855; Mon, 23
 Aug 2021 12:02:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210823123516.969486-1-hch@lst.de> <20210823123516.969486-4-hch@lst.de>
In-Reply-To: <20210823123516.969486-4-hch@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 23 Aug 2021 12:02:04 -0700
Message-ID: <CAPcyv4ifoEi3E65yb3OOwwiY2aMyrSap=e7PohN-5w_K4RgKrg@mail.gmail.com>
Subject: Re: [PATCH 3/9] dm: use fs_dax_get_by_bdev instead of dax_get_by_host
To:     Christoph Hellwig <hch@lst.de>
Cc:     Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 23, 2021 at 5:39 AM Christoph Hellwig <hch@lst.de> wrote:
>
> There is no point in trying to finding the dax device if the DAX flag is
> not set on the queue as none of the users of the device mapper exported
> block devices could make use of the DAX capability.

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
