Return-Path: <SRS0=2CQE=7X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3988C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Jun 2020 01:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89AB0206C3
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Jun 2020 01:04:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GPdCxYX5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbgFJBEV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Jun 2020 21:04:21 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38396 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725988AbgFJBEU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jun 2020 21:04:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591751059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d4z6zMYUo1TFeTibaF62jZiaK95sC5eirufP0keiaew=;
        b=GPdCxYX5IPMii4+Pj587wSQcv3Oo84545oCAn5eMj2i74sbqo19oMcuEFq949ynsIdC4kz
        G74BRCJU6m5CNkMjLqb70mNZcKOBsNtahkzW8VyuOdnVv19yZDF0S8043Bmy43m0OiCWPD
        z47+MNUma2wC1YSA2ErGqYD7bcgyUz8=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-0zoGZg7qPTKiriXkiVc4qg-1; Tue, 09 Jun 2020 21:04:14 -0400
X-MC-Unique: 0zoGZg7qPTKiriXkiVc4qg-1
Received: by mail-pg1-f200.google.com with SMTP id y12so252990pgi.20
        for <linux-xfs@vger.kernel.org>; Tue, 09 Jun 2020 18:04:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=d4z6zMYUo1TFeTibaF62jZiaK95sC5eirufP0keiaew=;
        b=ATdjIgzv0nkv4FHdxFwjgnEEW5T6Snlk24I0XDl0h9uGVTJP3Az7JWtBipNtEfc2qf
         VLxQExYnB35cLeT3iMa0sZYD839uG6v+Lc3vkDxHe8t4pxiQYdK5IDKXR/bJJSAxUE3E
         KxjCe1r1W5WitF9F9IJQkGGSCu6X50VXXroj8zOaeS3OoPc8emD8DltM+toXqsOt4iTs
         1A6mtRozsVfdXLURySm1AEN19orhoGhDDfNeerJPN8ICN0dEppN5tWQ4GZd1M2W29aaf
         DcFAwBjpXWDIFY4Vsi5UAqXpZCcietZhEb9gJDfAu8Uvk7KIaJGQD82P9LHCRg6Ow7Uq
         +img==
X-Gm-Message-State: AOAM530qUvZfFENnvnQmhsEc9FKAB+ZL+V5n1DOcNkmVn/p3oLGQ/fiS
        PmSQ31RDOSnnlSDiPiANI5C77ftEavHoFvG9m52Fc33c0ahoESmeNCAkoWwLq6i+niZCNHoRMr0
        L/I6gCtCgdLB/8Zlzd6E1
X-Received: by 2002:a17:90a:d3d6:: with SMTP id d22mr511516pjw.184.1591751053702;
        Tue, 09 Jun 2020 18:04:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyc8oKLQzEEBcgsyphgeKCZAW55X6g7mJiEj2Vw62fSmgd9OoLdRKUN421NsCtCnYTByV/IZA==
X-Received: by 2002:a17:90a:d3d6:: with SMTP id d22mr511489pjw.184.1591751053458;
        Tue, 09 Jun 2020 18:04:13 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j186sm10930708pfb.220.2020.06.09.18.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 18:04:12 -0700 (PDT)
Date:   Wed, 10 Jun 2020 09:04:03 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [RFC PATCH] xfs_repair: fix rebuilding btree node block less
 than minrecs
Message-ID: <20200610010403.GA29545@xiangao.remote.csb>
References: <20200609114053.31924-1-hsiangkao@redhat.com>
 <20200609201423.GD11245@magnolia>
 <20200609221239.GE11245@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609221239.GE11245@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

On Tue, Jun 09, 2020 at 03:12:39PM -0700, Darrick J. Wong wrote:

...

> 
> Oops, I hit send too quickly; the computation looks ok to me.
> 
> Granted that's probably due to having written another btree geometry
> calculation function. :D
> 
> Also, I think init_rmapbt_cursor does a similar trick and therefore
> suffers from a similar bug.  See the comment "Leave enough slack in the
> rmapbt that we can insert..." around line 1412 or so?

These comments are fine :) I will try to fix them all in the next version.

Thanks,
Gao Xiang

