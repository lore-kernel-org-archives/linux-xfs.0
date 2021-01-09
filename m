Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6F1CC43381
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 00:49:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CB5523A75
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 00:49:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbhAIAtX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Jan 2021 19:49:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44458 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726819AbhAIAtW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jan 2021 19:49:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610153276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=19ORASWZtYUOOlk6kkfU5Qq9+wt4P8et1KjMnAKCcgw=;
        b=hHtIQ9rZAN+Ue8UUw3PTzD5GWZuxugdOLnJTUPfoNEa+0rAT/98qJw+hsIBd23jeWyVhzv
        +Jra51bFndVDZPDyGyMR6lN+Mtt7KTI7ObCnHRne3DhbXpX60w/GM02Zy4X+JV2s81W3mt
        2UFlbTiDnol0589h+/zewbb/1uDUNAY=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-UdkUwhLsPXSGyvcSI6Fgdw-1; Fri, 08 Jan 2021 19:47:53 -0500
X-MC-Unique: UdkUwhLsPXSGyvcSI6Fgdw-1
Received: by mail-pj1-f70.google.com with SMTP id mz17so7978450pjb.5
        for <linux-xfs@vger.kernel.org>; Fri, 08 Jan 2021 16:47:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=19ORASWZtYUOOlk6kkfU5Qq9+wt4P8et1KjMnAKCcgw=;
        b=pfbR4ugHzKXDLBQ+vBw7NpmI6V3wIybURU7D5Jt/LX7IVXsdS7ZznVvoZPHUsUqsrQ
         c6rMJdkg8hpsew6rdE5blMFtIdlUFizX80xWpwWQCyC1RIuESzKRie8FPIJfBU2QOKx6
         /ZJGi8MO1kwgyYLaNhZJvqvVCiet6pgbNuSdUUhD32zSrlTdGsLaCY220/6vWTBfsWNZ
         xKhekYrYjPS8elSnqoAFCa10+ZHsHpYIgzRQoO8Arde4qEfmsw3H48hN80kvltJij9m4
         4hYRiWKxtNMRqtdoRoMJAXHaKeHHkrbW9OV96MRNwT4LVnErywd8WHsNntypJIzAOnE3
         u35g==
X-Gm-Message-State: AOAM533u2c1vIQ1L/5SOdf5XohZOFHQrT6rnsP0IaUkw7eomaNaiao6P
        QDaNXWlXjwNU989l6BhtKAZZetYrX0nkqK11OinTLTzC4VBsVe7NhdFn7DgfrdhRTWQlcsvWLgP
        ueDbcPZ2I1whI9xR9lCO1
X-Received: by 2002:a17:902:e901:b029:dd:fa49:37f7 with SMTP id k1-20020a170902e901b02900ddfa4937f7mr4488244pld.51.1610153272197;
        Fri, 08 Jan 2021 16:47:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy9Wj1iOfF78KWma62s+R/SLnIl7+KlY5DZONnnLg7UM6DWEDCG+scHYA+2m4gZHH8JYQBHCQ==
X-Received: by 2002:a17:902:e901:b029:dd:fa49:37f7 with SMTP id k1-20020a170902e901b02900ddfa4937f7mr4488227pld.51.1610153271947;
        Fri, 08 Jan 2021 16:47:51 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a22sm10081438pfg.49.2021.01.08.16.47.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 16:47:51 -0800 (PST)
Date:   Sat, 9 Jan 2021 08:47:41 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v3 4/4] xfs: support shrinking unused space in the last AG
Message-ID: <20210109004741.GA660098@xiangao.remote.csb>
References: <20210108190919.623672-1-hsiangkao@redhat.com>
 <20210108190919.623672-5-hsiangkao@redhat.com>
 <20210108211942.GQ38809@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210108211942.GQ38809@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

On Fri, Jan 08, 2021 at 01:19:42PM -0800, Darrick J. Wong wrote:
> On Sat, Jan 09, 2021 at 03:09:19AM +0800, Gao Xiang wrote:

...

> >  	delta = nb;	/* use delta as a temporary here */
> 
> Yikes, can this become a separate variable please?

Ok.

> 
> >  	nb_mod = do_div(delta, mp->m_sb.sb_agblocks);
> > @@ -99,10 +102,18 @@ xfs_growfs_data_private(
> >  	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
> >  		nagcount--;
> >  		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
> > -		if (nb < mp->m_sb.sb_dblocks)
> > +		if (nagcount < 2)
> >  			return -EINVAL;
> >  	}
> > -	delta = nb - mp->m_sb.sb_dblocks;
> > +
> > +	if (nb > mp->m_sb.sb_dblocks) {
> > +		delta = nb - mp->m_sb.sb_dblocks;
> > +		extend = true;
> > +	} else {
> > +		delta = mp->m_sb.sb_dblocks - nb;
> > +		extend = false;
> 
> /me wonders why delta isn't simply int64_t, and then you can do things
> like:
> 
> if (delta > 0)
> 	growfs
> else if (delta < 0)
> 	shrinkfs
> 
> ?

Yeah, delta changed into a signed variable in mycurrent experimental
shrinking entire AG hack as well. Will update this here in advance.

Thanks,
Gao Xiang

