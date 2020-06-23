Return-Path: <SRS0=nlsN=AE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46A14C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 23:08:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F64A20888
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 23:08:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bdcTBo4g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387959AbgFWXIC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Jun 2020 19:08:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37656 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387755AbgFWXIB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jun 2020 19:08:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592953680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ahEmQGBzcm4G7jZoGF5Jz1fcknfZw8IDKEFPzO/GRt8=;
        b=bdcTBo4gJAt+G8rR2uCCnAm6oc4wu2bjw5XKg7twgu004emfq4fT1+c25qBoHt7TImtQLC
        2UDTl6/nn+j0WKOJNMnMLCE8hXM+lb1mCGiI4HQcNLSdIA7M7CuY6F8IuD6jQmvACadB3f
        szJ+J9z+K9JFBWJsTIDq7FYBEcjES2A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-B0OhYdBAPcCsa-oHsC_tyA-1; Tue, 23 Jun 2020 19:07:58 -0400
X-MC-Unique: B0OhYdBAPcCsa-oHsC_tyA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5883800138;
        Tue, 23 Jun 2020 23:07:57 +0000 (UTC)
Received: from redhat.com (ovpn-114-235.rdu2.redhat.com [10.10.114.235])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 895287CADE;
        Tue, 23 Jun 2020 23:07:57 +0000 (UTC)
Date:   Tue, 23 Jun 2020 18:07:55 -0500
From:   Bill O'Donnell <billodo@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfsprogs: xfs_quota command error message improvement
Message-ID: <20200623230755.GA131402@redhat.com>
References: <20200622131319.7717-1-billodo@redhat.com>
 <a2c5d616-c48a-435e-e3b4-4d6c784d4a2d@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2c5d616-c48a-435e-e3b4-4d6c784d4a2d@sandeen.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 23, 2020 at 05:30:38PM -0500, Eric Sandeen wrote:
> On 6/22/20 8:13 AM, Bill O'Donnell wrote:
> > @@ -350,8 +365,15 @@ quotaoff(
> >  		return;
> >  	}
> >  	dir = mount->fs_name;
> > -	if (xfsquotactl(XFS_QUOTAOFF, dir, type, 0, (void *)&qflags) < 0)
> > -		perror("XFS_QUOTAOFF");
> > +	if (xfsquotactl(XFS_QUOTAOFF, dir, type, 0, (void *)&qflags) < 0) {
> > +		if (errno == EEXIST)
> > +			fprintf(stderr, _("Quota already off.\n"));
> > +		else if (errno == EINVAL)
> > +			fprintf(stderr,
> > +				_("Can't disable when quotas are off.\n"));
> 
> Is this the right message here?  We get here from off_f(), which disables
> enforcement and accounting, so I'm not sure "can't disable" makes sense
> if "disable" means "disable enforcement" as it did in disable_enforcement()...?
> 
> (IOWs, have can you provoke EINVAL?  How?  Sorry, this just kind of jumps out
> at me because "can't disable" seems a little out of place in quotaoff() so
> I want to double check.)

You're right. It was a copy/paste from the disable case. You also have a good point
in that I don't think EINVAL is ever provoked for the OFF case. I'll recheck it.

Thanks-
Bill

> 
> Thanks,
> -Eric
> 

