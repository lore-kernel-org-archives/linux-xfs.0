Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC8AC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 14:09:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237249AbiD0OMS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Apr 2022 10:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237151AbiD0OMS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Apr 2022 10:12:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8FAA14EDCA
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 07:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651068545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LD70G1DdFlUCxtY0+RhQwVS23b0tg/L6YR0eORY2xmg=;
        b=C/S1wOiXKiMdn0LzVmwIxD6w3/imp2tjSGdt14MePkN4PuTziIa2qeE1i29mIfVFbnaHV4
        V8AHqEZ41+saFaY/nATVTVxbC7ojAC7dG5v/NqiSJedx7QEZp4nEILKuGEfqsmysd3QqV2
        b3eI6yS44u5S+SQUNI7kBq9FXiGnovk=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-r7IBE6v0M7CgCxb9hqCRRg-1; Wed, 27 Apr 2022 10:09:04 -0400
X-MC-Unique: r7IBE6v0M7CgCxb9hqCRRg-1
Received: by mail-qv1-f71.google.com with SMTP id kk23-20020a056214509700b004542af238feso1280752qvb.19
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 07:09:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LD70G1DdFlUCxtY0+RhQwVS23b0tg/L6YR0eORY2xmg=;
        b=CtUdqweoNydVddiqxYv1qqa2jazr1zqfa5OW/lAKzCd2CdcXKug5vLFIvrMk+sWC6v
         qmNkyhLkfyZlw1Yhr27o9xLMPTNQIWAMsn2RR5fEwtt+Nd2P+FcC5bOf/10nqCEa//37
         wSRSoodWkPJ5utuT21Nr2hpdvm+4G91foQoy8k0n7JHqGqjSXgfAitfpNEasgmgSoFu1
         p176uSb+z1+NfNhou58Czv3MaNJTs37yBAIJh83DgZqkUMFsGPPCjhg2cQUCWutf0poh
         p9MNA3x5HjYdNzga4vE9aCVRA40Utgksh7k5ksbv9JD5HFTkN5RH5+y5J18/AD//oZN+
         COwA==
X-Gm-Message-State: AOAM533uPUiUyMcm8RwTB6zoETedx9Mig6xkGN36HsMNPpISBFKHbWhf
        AyqQtTInAOEZlZhdI7aMurOY2yvc2btAXvncwTv+NEnwXUU/AcpRgQE+NxBCXrna4O3lC+wZpWi
        OVnOZpww4KqC2CdZ2KpdD
X-Received: by 2002:a05:622a:509:b0:2f3:8407:48e1 with SMTP id l9-20020a05622a050900b002f3840748e1mr1939288qtx.66.1651068543566;
        Wed, 27 Apr 2022 07:09:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzoiTgTPwuMKvoYL7Jf0wtVKg14MA3pT8cVq9QG305vkW6rgo4yY0CVqn1buftNbgyoCbsYNA==
X-Received: by 2002:a05:622a:509:b0:2f3:8407:48e1 with SMTP id l9-20020a05622a050900b002f3840748e1mr1939267qtx.66.1651068543333;
        Wed, 27 Apr 2022 07:09:03 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id t186-20020a372dc3000000b0069ec8a9254esm8215053qkh.73.2022.04.27.07.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 07:09:02 -0700 (PDT)
Date:   Wed, 27 Apr 2022 10:09:00 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 0/2] xfs: remove quota warning limits
Message-ID: <YmlOfJljvI49sZyW@bfoster>
References: <20220421165815.87837-1-catherine.hoang@oracle.com>
 <43e8df67-5916-5f4a-ce85-8521729acbb2@sandeen.net>
 <20220425222140.GI1544202@dread.disaster.area>
 <20220426024331.GR17025@magnolia>
 <Ymf+k9EA2bY/af4Y@bfoster>
 <20220426145347.GV17025@magnolia>
 <Ymg6yvbrE//70InS@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ymg6yvbrE//70InS@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 26, 2022 at 02:32:42PM -0400, Brian Foster wrote:
> On Tue, Apr 26, 2022 at 07:53:47AM -0700, Darrick J. Wong wrote:
> > On Tue, Apr 26, 2022 at 10:15:47AM -0400, Brian Foster wrote:
> > > On Mon, Apr 25, 2022 at 07:43:31PM -0700, Darrick J. Wong wrote:
> > > ...
> > > > 
> > > > The biggest problem right now is that the pagecache is broken in 5.18
> > > > and apparently I'm the only person who can trigger this.  It's the same
> > > > problem willy and I have been working on since -rc1 (where the
> > > > filemap/iomap debug asserts trip on generic/068 and generic/475) that's
> > > > documented on the fsdevel list.  Unfortunately, I don't have much time
> > > > to work on this, because as team lead:
> > > > 
> > > 
> > > I seem to be able to reproduce this fairly reliably with generic/068.
> > > I've started a bisect if it's of any use...
> > 
> > Thank you!  Matthew has hinted that he suspects this is a case of the
> > page cache returning the wrong folio in certain cases, but neither of us
> > have been able to narrow it down to a specific commit, or even a range.
> > 
> 
> So my first stab at a bisect...
> 
> git bisect start 'fs' 'mm' 'include/'
> ...
> # good: [65722ff6181aa52c3d5b0929004af22a3a63e148] drm/amdkfd: CRIU export dmabuf handles for GTT BOs
> git bisect good 65722ff6181aa52c3d5b0929004af22a3a63e148
> # good: [89695196f0ba78a17453f9616355f2ca6b293402] Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
> git bisect good 89695196f0ba78a17453f9616355f2ca6b293402
> # bad: [52deda9551a01879b3562e7b41748e85c591f14c] Merge branch 'akpm' (patches from Andrew)
> git bisect bad 52deda9551a01879b3562e7b41748e85c591f14c
> # bad: [169e77764adc041b1dacba84ea90516a895d43b2] Merge tag 'net-next-5.18' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next
> git bisect bad 169e77764adc041b1dacba84ea90516a895d43b2
> # first bad commit: [169e77764adc041b1dacba84ea90516a895d43b2] Merge tag 'net-next-5.18' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next
> 
> ... landed on a netdev merge commit. :/ That doesn't seem terribly
> informative. I suspect either I was too aggressive with the testing or
> source dir tree filtering. I've manually confirmed that the last couple
> of marked merge commits are good and bad respectively, so I'll probably
> try a new bisect of that range without any filtering and a bit more
> deliberate testing (which will take a bit longer) and see if that yields
> anything more useful.
> 

Bisect round two lands on commit 56a4d67c264e ("mm/readahead: Switch to
page_cache_ra_order"). I'm not sure how much of a smoking gun that is
given it looks like it switches mmapped readahead over to a different
code path, but I reproduced nearly instantly as of that commit and I'm
now spinning the test against a HEAD of the immediately previous commit
(1854bc6e2420 ("mm/readahead: Align file mappings for non-DAX")) with
probably 130+ successful iterations so far. I'll let it spin a while
longer just to be sure.

Brian

> Brian
> 
> > --D
> > 
> > > Brian
> > > 
> > 

