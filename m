Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C398C83013
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Dec 2020 14:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD0962222E
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Dec 2020 14:46:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgLBOpx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Dec 2020 09:45:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47644 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726121AbgLBOpx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Dec 2020 09:45:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606920267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CySxSh2Ld010Ti5dLGysi8diYPX64t0f3BfCXzkYBHI=;
        b=W5+o9kWoM4IfvG4kEY8n5to1tSkQoVWyAjEOa8ynxTVcSJnRw7UVRIQQTrtYZ1Lg3ygcmi
        XlpIrTVGO1JE1UdGf+B9O33qr22jWLPRA2xl7zPia7cTC0E4Q1gYEm0ah06Xcj7bNHKMEQ
        M5CcRqnXJA8bMLaUzW36h/nZduNa9dU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-hnA_kny3M3GsQhCmZYbQ8Q-1; Wed, 02 Dec 2020 09:44:25 -0500
X-MC-Unique: hnA_kny3M3GsQhCmZYbQ8Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE958425DE;
        Wed,  2 Dec 2020 14:44:24 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CB615D6BA;
        Wed,  2 Dec 2020 14:44:24 +0000 (UTC)
Subject: Re: [RFC PATCH 2/2] xfs: do not allow reflinking inodes with the dax
 flag set
To:     Christoph Hellwig <hch@infradead.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <1d87a83e-ba03-b735-f19a-955a09bcdcf7@redhat.com>
 <07c41ba8-ecb7-5042-fa6c-dd8c9754b824@redhat.com>
 <20201202102221.GB19762@infradead.org>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <49e44513-2f52-b221-6c33-e5e7119eb8b9@redhat.com>
Date:   Wed, 2 Dec 2020 08:44:24 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201202102221.GB19762@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/2/20 4:22 AM, Christoph Hellwig wrote:
> On Tue, Dec 01, 2020 at 01:20:55PM -0600, Eric Sandeen wrote:
>> Today, xfs_reflink_remap_prep() will reject inodes which are in the CPU
>> direct access state, i.e. IS_DAX() is true.  However, it is possible to
>> have inodes with the XFS_DIFLAG2_DAX set, but which are not activated as
>> dax, due to the dax=never mount option, or due to the flag being set after
>> the inode was loaded.
>>
>> To avoid confusion and make the lack of dax+reflink crystal clear for the
>> user, reject reflink requests for both IS_DAX and XFS_DIFLAG2_DAX inodes.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> This is RFC because as Darrick says, it introduces a new failure mode for
>> reflink. On the flip side, today the user can reflink a chattr +x'd file,
>> but cannot chattr +x a reflinked file, which seems a best a bit asymmetrical
>> and confusing... see xfs_ioctl_setattr_xflags()
> 
> This seems confusing.  IMHO for now we should just for non-dax access
> to any reflink file even if XFS_DIFLAG2_DAX is set.  The only place
> where we cannot do that is if a file has XFS_DIFLAG2_DAX set and is in
> use and we want to reflink it.  Note that "in use" is kinda murky and
> potentially racy.  So IMHO not allowing reflink when XFS_DIFLAG2_DAX
> is set and dax=never is not set makes sense, but we should not go
> further.

Hm, trying to parse that...

Would it be correct to restate your last sentence as "Disallowing reflink
when XFS_DIFLAG2_DAX is set and dax=inode is set makes sense?"

If so, then the only change you're suggesting to this patch is to /allow/
reflinking if dax=never is set?

I just figured a very clear statementa bout incompatible flags was simplest,
but I get it that it's overly restrictive, functionally.

Thanks,
-Eric

