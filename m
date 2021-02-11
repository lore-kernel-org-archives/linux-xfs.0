Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 266ABC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 18:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDF6864E05
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 18:15:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbhBKSF1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 13:05:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29654 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232745AbhBKSDT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Feb 2021 13:03:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613066513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cs4l+PNBWOxlFwdZyGDYY3vVgvNXaCKMAxOCs0USmFA=;
        b=asTTCIH/ZScRfqtVXOJvcaP4TsNsn0q/VkSoWrPsJWk9uni/hwqmy9bBFJaqoxvhBPebw7
        8KVrNbIcfzQoYYsUXGT4ej1no6c5oZ8uaGMfNkH8ahLh6fP2iij/6uOxwwcnxphcB8SoZ9
        OfCxdG4UQUx6aaMfDQ4CmkFPnDVK4PQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-U0WN-dVyMsSjYyFX1sRvVQ-1; Thu, 11 Feb 2021 13:01:51 -0500
X-MC-Unique: U0WN-dVyMsSjYyFX1sRvVQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F9E1183CD01;
        Thu, 11 Feb 2021 18:01:50 +0000 (UTC)
Received: from bfoster (ovpn-113-234.rdu2.redhat.com [10.10.113.234])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 727431F4;
        Thu, 11 Feb 2021 18:01:49 +0000 (UTC)
Date:   Thu, 11 Feb 2021 13:01:47 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 4/6] check: don't abort on non-existent excluded groups
Message-ID: <20210211180147.GG222065@bfoster>
References: <161292577956.3504537.3260962158197387248.stgit@magnolia>
 <161292580215.3504537.12419725496679954055.stgit@magnolia>
 <20210211140019.GD222065@bfoster>
 <20210211172705.GI7190@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211172705.GI7190@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 11, 2021 at 09:27:05AM -0800, Darrick J. Wong wrote:
> On Thu, Feb 11, 2021 at 09:00:19AM -0500, Brian Foster wrote:
> > On Tue, Feb 09, 2021 at 06:56:42PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Don't abort the whole test run if we asked to exclude groups that aren't
> > > included in the candidate group list, since we actually /are/ satisfying
> > > the user's request.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  check |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > 
> > > diff --git a/check b/check
> > > index e51cbede..6f8db858 100755
> > > --- a/check
> > > +++ b/check
> > > @@ -243,7 +243,7 @@ _prepare_test_list()
> > >  		list=$(get_group_list $xgroup)
> > >  		if [ -z "$list" ]; then
> > >  			echo "Group \"$xgroup\" is empty or not defined?"
> > > -			exit 1
> > > +			continue
> > >  		fi
> > 
> > Is this only for a nonexistent group? I.e., 'check -x nosuchgroup ...' ?
> > If so, what's the advantage?
> 
> I wrote this for groups that exist somewhere but would never have been
> selected for this filesystem type in the first place.  For example,
> 'dangerous_scrub' (aka fuzz testing for xfs_scrub) is only found in
> tests/xfs/group, so running:
> 
> # FSTYP=ext4 ./check -x dangerous_scrub
> 
> fails because ./check cannot select any of the dangerous_scrub tests for
> an ext4 run so it doesn't recognize the group name.  IOWs, it's too
> stupid to realize that excluding a group that can't be selected should
> be a no-op.
> 

Ah, I see. Seems reasonable enough:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> --D
> 
> > Brian
> > 
> > >  
> > >  		trim_test_list $list
> > > 
> > 
> 

