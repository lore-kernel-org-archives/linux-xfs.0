Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9FF8C5479D
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Jan 2023 17:24:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237125AbjAIRYb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Jan 2023 12:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237007AbjAIRYb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2023 12:24:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3F240C3E
        for <linux-xfs@vger.kernel.org>; Mon,  9 Jan 2023 09:23:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673285024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OPrgrbO4EaJMcZw3XP+ZMoUmcH9Y+9fDGPyN/K2Dvmw=;
        b=MPcxSbZ8LNTLMV/n5fdJyTWzokmoslBdO71BQJLOiEEEjYeDzNVnKQXXs0QBFowupwLNq5
        ElxT6c2DTberTzQVSZs/HK0G9sniEanvbbif7xkUPNO+Wf30QgqAEh9iPUpfgdY2FjOvCY
        P+xBF9HSt0K1vRIOfagFuhBVj3jlONY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-141-47u-s8OkMDyTR42zfOoN9Q-1; Mon, 09 Jan 2023 12:23:42 -0500
X-MC-Unique: 47u-s8OkMDyTR42zfOoN9Q-1
Received: by mail-ed1-f71.google.com with SMTP id z8-20020a056402274800b0048a31c1746aso5668044edd.0
        for <linux-xfs@vger.kernel.org>; Mon, 09 Jan 2023 09:23:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OPrgrbO4EaJMcZw3XP+ZMoUmcH9Y+9fDGPyN/K2Dvmw=;
        b=fExzg6GE320hvyxanEhZBMg31dRkmvtRKrsr9/lyTGN7hsbJkOnMeI5b9C86voRElg
         /Zsf5dCoN7zeZ4zUihGjuH8AMdwJU9X0EuSjicVQM+TV7B3z+iJZcxCJUJDxwv5Odxci
         iRtBAlA1M6iXHjjf4g3eUG3J6y/vGM4HHO1J036yhk7aeGdkQ/5NjEwlHv9y2XXWwOyh
         DqK6RkQu748gCKP4Zwk7mIcuxdZBY4eroGEXEt8QHS2jmPqSsZ3gVhIFljdkir+VCQWj
         82Tckf7lABPp2v39SOQ1DQJTXLmfgkzGxUUkPes+QMnn9GsGr1iWifb21CEZKjOFymwb
         U8VQ==
X-Gm-Message-State: AFqh2koidYHGurYG4QkgHLy3fNwv58vUIFLycB0HWbwonTAInJMcMpd2
        2gXhfHsWuEjwgYG8kbyoFQ9pNLb/beuk0cKvD2sPzQURU/lLYaG13WSMAYvu7N73NNrGOWbo816
        F35PKm+9tr9+S2uO6IZk=
X-Received: by 2002:a17:906:36c5:b0:829:594c:8ec8 with SMTP id b5-20020a17090636c500b00829594c8ec8mr51388833ejc.29.1673285021071;
        Mon, 09 Jan 2023 09:23:41 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvZ0i9p+8e+EGUjC39Fc3fXEiIKaYn11oX7gxdKN3v2KVBKFky9eSggH3976smcCIqqTw4kJg==
X-Received: by 2002:a17:906:36c5:b0:829:594c:8ec8 with SMTP id b5-20020a17090636c500b00829594c8ec8mr51388825ejc.29.1673285020924;
        Mon, 09 Jan 2023 09:23:40 -0800 (PST)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id k23-20020a17090632d700b00837ac146a53sm3965895ejk.23.2023.01.09.09.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 09:23:40 -0800 (PST)
Date:   Mon, 9 Jan 2023 18:23:38 +0100
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 07/11] xfs: disable direct read path for fs-verity
 sealed files
Message-ID: <20230109172338.5pebvg33fc4xds2f@aalbersh.remote.csb>
References: <20221213172935.680971-1-aalbersh@redhat.com>
 <20221213172935.680971-8-aalbersh@redhat.com>
 <Y6XUv68yaKY9vBoO@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6XUv68yaKY9vBoO@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 23, 2022 at 08:18:07AM -0800, Christoph Hellwig wrote:
> On Tue, Dec 13, 2022 at 06:29:31PM +0100, Andrey Albershteyn wrote:
> > The direct path is not supported on verity files. Attempts to use direct
> > I/O path on such files should fall back to buffered I/O path.
> 
> Just curious: why?  What prevents us from running the hash function
> over the user pages in direct I/O?
> 

hmm, not sure if there are any technical obstacles (probably no),
but as fs-verity subsystem doesn't deal with direct i/o, I went the
same path.

-- 
- Andrey

