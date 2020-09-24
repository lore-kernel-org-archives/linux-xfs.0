Return-Path: <SRS0=cWrc=DB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EBFDC4727D
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 18:48:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 130052311E
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 18:48:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZnzwnhYe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728736AbgIXSr7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 14:47:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56179 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728707AbgIXSr7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Sep 2020 14:47:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600973278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qevhx+mKfF351kyzXMJzLK28uMAwbH6ptXHpGeBndNM=;
        b=ZnzwnhYe8hmxI6v8emLTOyrGXOH9EtXfhBzOX9p5BShF/ex6u6oSAO0eJyk2tCXeRl1BBm
        y0Cj9fWck6TRHDYV42Yqy7XXWtOJepwIBK0+e9G4dyNHZHfNOT4XJBmd5gSnMXibivCRwr
        ZKj/+O2dUZTrUF3o4Wsj14Vds6CNQrE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-J0C0jdFUOn6GGTo368u4aA-1; Thu, 24 Sep 2020 14:47:52 -0400
X-MC-Unique: J0C0jdFUOn6GGTo368u4aA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4BE1E80B727;
        Thu, 24 Sep 2020 18:47:51 +0000 (UTC)
Received: from ovpn-66-196.rdu2.redhat.com (unknown [10.10.67.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 719AA73684;
        Thu, 24 Sep 2020 18:47:50 +0000 (UTC)
Message-ID: <f623da731d7c2e96e3a37b091d0ec99095a6386b.camel@redhat.com>
Subject: Re: [PATCH] iomap: Set all uptodate bits for an Uptodate page
From:   Qian Cai <cai@redhat.com>
To:     sedat.dilek@gmail.com, Matthew Wilcox <willy@infradead.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>
Date:   Thu, 24 Sep 2020 14:47:49 -0400
In-Reply-To: <CA+icZUUgwcLP8O9oDdUMT0SzEQHjn+LkFFkPL3NsLCBhDRSyGw@mail.gmail.com>
References: <20200924125608.31231-1-willy@infradead.org>
         <CA+icZUUQGmd3juNPv1sHTWdhzXwZzRv=p1i+Q=20z_WGcZOzbg@mail.gmail.com>
         <20200924151538.GW32101@casper.infradead.org>
         <CA+icZUX4bQf+pYsnOR0gHZLsX3NriL=617=RU0usDfx=idgZmA@mail.gmail.com>
         <20200924152755.GY32101@casper.infradead.org>
         <CA+icZUURRcCh1TYtLs=U_353bhv5_JhVFaGxVPL5Rydee0P1=Q@mail.gmail.com>
         <20200924163635.GZ32101@casper.infradead.org>
         <CA+icZUUgwcLP8O9oDdUMT0SzEQHjn+LkFFkPL3NsLCBhDRSyGw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2020-09-24 at 20:27 +0200, Sedat Dilek wrote:
> I run both linux-kernel on my Debian/unstable AMD64 host (means not in
> a VM) with and without your patch.
> 
> Instructions:
> cd /opt/ltp
> ./runltp -f syscalls -s preadv203
> 
> Unfortunately, the logs in the "results" directory have only the short
> summary.
> 
> Testcase                                           Result     Exit Value
> --------                                           ------     ----------
> preadv203                                          PASS       0
> preadv203_64                                       PASS       0
> 
> So, I guess I am not hitting the issue?
> Or do I miss some important kernel-config?

https://gitlab.com/cailca/linux-mm/-/blob/master/arm64.config

That is .config I used to reproduce. Then, I ran the linux-mm testsuite (lots of
hard-coded places because I only need to run this on RHEL8) first:

# git clone https://gitlab.com/cailca/linux-mm
# cd linux-mm; make
# ./random -k

Then, run the whole LTP syscalls:
# ./runltp -f syscalls

If that is still not triggered, it needs some syscall fuzzing:
# ./random -x 0-100 -f




