Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27A65C43381
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF7EA64E60
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239116AbhCDARR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:17:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55516 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235036AbhCCLwQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Mar 2021 06:52:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614772235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WTK59XFEo0EMAERWCrEZolya2R+8PhNSJgmx8VrI2do=;
        b=AlaZutgv7HLJg5KEvq5U4MghxUSYGLKARZ8MpjXPHgJ5Dr5BTEiFBk126edtEpYqDrSB/X
        ejBor1ZJRyTJD7aKeH0JUpa0rLp2W8Otdo1jWVvClHjE1Nk5NSE197lG459NvhK6Yad4L8
        sIEJFdJje+rl52/ZOTzASj+2uUsd+tQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-0xN2JDwWMyeIln_9SyR1QA-1; Wed, 03 Mar 2021 06:50:33 -0500
X-MC-Unique: 0xN2JDwWMyeIln_9SyR1QA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A23BF804038;
        Wed,  3 Mar 2021 11:50:32 +0000 (UTC)
Received: from bfoster (ovpn-119-215.rdu2.redhat.com [10.10.119.215])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A57819D9D;
        Wed,  3 Mar 2021 11:50:31 +0000 (UTC)
Date:   Wed, 3 Mar 2021 06:50:04 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Geert Hendrickx <geert@hendrickx.be>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: xfs_admin -O feature upgrade feedback
Message-ID: <YD937HTr5Lq/YErv@bfoster>
References: <YDy+OmsVCkTfiMPp@vera.ghen.be>
 <20210301191803.GE7269@magnolia>
 <YD4tWbfzmuXv1mKQ@bfoster>
 <YD7C0v5rKopCJvk2@vera.ghen.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YD7C0v5rKopCJvk2@vera.ghen.be>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 02, 2021 at 11:57:22PM +0100, Geert Hendrickx wrote:
> On Tue, Mar 02, 2021 at 07:19:37 -0500, Brian Foster wrote:
> > It's not clear to me if you're reporting that feature upgrades spuriously
> > report this "Conversion failed ..." message (i.e., feature upgrade
> > succeeded, but repair found and fixed things expected to be problems due
> > to the feature upgrade), or that this error is reported if there is
> > something independently wrong with the fs. If the former, that seems like
> > a bug. If the latter, I think that's reasonable/expected behavior.
> 
> 
> 
> There are sillier scenarios, like simply incorrect arguments.  For example
> "xfs_admin -O bigtypo=1 /dev/foo" responds with: "Conversion failed, is the
> filesystem unmounted?"
> 
> (where /dev/foo is the correct blockdevice, properly unmounted etc, but the
> options argument contains a typo)
> 
> The proper xfs_repair error "unknown option -c bigtypo=1" gets thrown away.
> 
> 
> Other examples include "-O bigtime" => "bigtime requires a parameter" (with
> Darrick's patch for the other issue applied), or "bigtime=0" => "bigtime
> only supports upgrades", all dropped on the floor by xfs_admin and replaced
> with the one generic message that gives no indication of the actual problem.
> (the user keeps verifying whether the filesystem is unmounted and clean...)
> 

Ok. I suppose in the scenario where xfs_repair runs on behalf of
xfs_admin and then fails immediately due to a usage error, it might be
more appropriate to dump whatever error xfs_repair exits with. I'm not
sure how best to filter that and/or deal with the issues Darrick points
out, but fair point...

Maybe a simple compromise is a verbose option for xfs_admin itself..?
I.e., the normal use case operates as it does now, but the failure case
would print something like:

  "Feature conversion failed. Retry with -v for detailed error output."

... and then 'xfs_admin -v ...' would just pass through xfs_repair
output. Eh?

Brian

> 
> 
> 	Geert
> 
> 

