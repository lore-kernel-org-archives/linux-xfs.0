Return-Path: <SRS0=XUqT=23=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2F4BC33C8C
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jan 2020 14:46:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C28420731
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jan 2020 14:46:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XuBHXaO3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgAFOq6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jan 2020 09:46:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37873 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726303AbgAFOq6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jan 2020 09:46:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578322016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qwEAV/zaQSP8dEHgxI0K6zdwjA8b6DLb8sSotCswdOQ=;
        b=XuBHXaO3lFfWy4skqhasIi1PRzDYqMX+cuOC7TRSWDRbUg7KnHpkHuUW2mKj5nTdey8HyL
        dmenv7LqVk7pNQccV3HxEeP925dtfW87zkGeJQpFPtkKp71EfrwJYZScLk3I7CwIvEo4j8
        kZSS8up0tUs4BWfoeSzvBw3FHGWc3rI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-1Zb-09cGML6tNz85nSWwsQ-1; Mon, 06 Jan 2020 09:46:53 -0500
X-MC-Unique: 1Zb-09cGML6tNz85nSWwsQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7BE25805845;
        Mon,  6 Jan 2020 14:46:52 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 131937BFFA;
        Mon,  6 Jan 2020 14:46:51 +0000 (UTC)
Date:   Mon, 6 Jan 2020 09:46:50 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 05/14] xfs: Factor out new helper functions
 xfs_attr_rmtval_set
Message-ID: <20200106144650.GB6799@bfoster>
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-6-allison.henderson@oracle.com>
 <20191224121410.GB18379@infradead.org>
 <07284127-d9d7-e3eb-8e25-396e36ffaa93@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07284127-d9d7-e3eb-8e25-396e36ffaa93@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 25, 2019 at 10:43:15AM -0700, Allison Collins wrote:
> 
> 
> On 12/24/19 5:14 AM, Christoph Hellwig wrote:
> > On Wed, Dec 11, 2019 at 09:15:04PM -0700, Allison Collins wrote:
> > > Break xfs_attr_rmtval_set into two helper functions
> > > xfs_attr_rmt_find_hole and xfs_attr_rmtval_set_value.
> > > xfs_attr_rmtval_set rolls the transaction between the
> > > helpers, but delayed operations cannot.  We will use
> > > the helpers later when constructing new delayed
> > > attribute routines.
> > 
> > Please use up the foll 72-ish characters for the changelog (also for
> > various other patches).
> Hmm, in one of my older reviews, we thought the standard line wrap length
> was 68.  Maybe when more folks get back from holiday break, we can have more
> chime in here.
> 

I thought it was 68 as well (I think that qualifies as 72-ish" at
least), but the current commit logs still look short of that at a
glance. ;P

Brian

> > 
> > For the actual patch: can you keep the code in the order of the calling
> > conventions, that is the lower level functions up and
> > xfs_attr_rmtval_set at the bottom?  Also please keep the functions
> > static until callers show up (which nicely leads to the above order).
> > 
> 
> Sure, will do.
> 
> Allison
> 

