Return-Path: <SRS0=zxI9=ZT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC5AC432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Nov 2019 15:19:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 520822053B
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Nov 2019 15:19:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PSyxNkOk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfK0PTq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Nov 2019 10:19:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46194 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726603AbfK0PTp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Nov 2019 10:19:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574867984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=STuFSyhJ2w7w2bGNFK+MJnxHROHB6ZDp1MJmzhVOfGc=;
        b=PSyxNkOkWxw0DdozLImmPzkCUpMMzMLxV1Lcv5b7vsGqdSzRSGY9aICKEtkAv06qscwSTd
        9fTjltfsQulyx+YfYIK4G5RWDfbnE1mLq/tSM9UGBaUMoMieFyHQUe+L1zxlqgBnKbSFyg
        8y+xmC1Or0uBD7kcG7Njf2rxjMVvaus=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-Ksx8_jtuOo60VlDmyY5TLQ-1; Wed, 27 Nov 2019 10:19:41 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 009B280183C;
        Wed, 27 Nov 2019 15:19:40 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 50FA61001DE1;
        Wed, 27 Nov 2019 15:19:39 +0000 (UTC)
Date:   Wed, 27 Nov 2019 10:19:39 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Eric Sandeen <sandeen@sandeen.net>, Alex Lyakas <alex@zadara.com>,
        linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC-PATCH] xfs: do not update sunit/swidth in the superblock to
 match those provided during mount
Message-ID: <20191127151939.GC56266@bfoster>
References: <1574359699-10191-1-git-send-email-alex@zadara.com>
 <20191122154314.GA31076@bfoster>
 <CAOcd+r3_gKYBv4vtM7nfPEPvkVp-FgHKvgQQx-_zMDt+QZ9z+g@mail.gmail.com>
 <20191125130744.GA44777@bfoster>
 <CAOcd+r2wMaX02acHffbNKXX4tZ1fXo-y1-OAW-dVGTq63qJcaw@mail.gmail.com>
 <20191126115415.GA50477@bfoster>
 <CAOcd+r3h=0umb-wdY058rQ=kPHpksMOwSh=Jc-did_tLkaioFw@mail.gmail.com>
 <0a1f2372-5c5b-85c7-07b8-c4a958eaec47@sandeen.net>
 <20191127141929.GA20585@infradead.org>
MIME-Version: 1.0
In-Reply-To: <20191127141929.GA20585@infradead.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: Ksx8_jtuOo60VlDmyY5TLQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 27, 2019 at 06:19:29AM -0800, Christoph Hellwig wrote:
> Can we all take a little step back and think about the implications
> of the original patch from Alex?  Because I think there is very little.
> And updated sunit/swidth is just a little performance optimization,
> and anyone who really cares about changing that after the fact can
> trivially add those to fstab.
>=20
> So I think something like his original patch plus a message during
> mount that the new values are not persisted should be perfectly fine.
>=20

I agree, FWIW. I've no issues with the original patch provided we fix up
the xfs_info behavior. I think the "historical behavior" argument is
reasonable, but at the same time how many people rely on the historical
behavior of updating the superblock? It's not like this changes the
mount api or anything. A user would just have to continue using the same
mount options to persist behavior.

Eric pointed out offline that we do refer to using the mount options to
"reset" su/sw in at least one place (repair?), but I don't see why we
couldn't rephrase that and/or provide a repair/admin script that updates
on-disk values. Still just my .02. :)

Brian

> We can still make xfs_repair smarter about guessing the root inode
> of course.
>=20

