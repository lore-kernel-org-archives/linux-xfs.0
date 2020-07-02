Return-Path: <SRS0=cy20=AN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98B1BC433DF
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 12:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6630220772
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 12:50:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="apeRvCQI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbgGBMuf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jul 2020 08:50:35 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57590 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728851AbgGBMue (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jul 2020 08:50:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593694233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tmRwIfalrQflYVzKzlovPXRsJgMgdkNqbwjd3fD5RI8=;
        b=apeRvCQIZQGPAXYoiuLJvDAn3JPGVyzo4S3YKJMGYtamu+k4hTo5RFUQb2jUSVr6lIglvA
        Sdd0RTfpV2vnEGp1MN2KZy1aidhhuEZulVLOfovBFRSrIQXSJtl2ufNDf7TJL7n4tTab2b
        LvghA+DfINL7rWd14gfWurGsXJ8nVMg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-CUVVq9YVMGmN5P8mXCq-lA-1; Thu, 02 Jul 2020 08:50:31 -0400
X-MC-Unique: CUVVq9YVMGmN5P8mXCq-lA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86B801009600;
        Thu,  2 Jul 2020 12:50:30 +0000 (UTC)
Received: from bfoster (ovpn-120-48.rdu2.redhat.com [10.10.120.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3510A741AF;
        Thu,  2 Jul 2020 12:50:30 +0000 (UTC)
Date:   Thu, 2 Jul 2020 08:50:28 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Diego Zuccato <diego.zuccato@unibo.it>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Separate user- and project- quota ?
Message-ID: <20200702125028.GD55314@bfoster>
References: <93882c1f-f26e-96c7-0a60-68fc9381e36c@unibo.it>
 <2c0bfee3-01cc-65cf-2be1-1af9432a18be@sandeen.net>
 <df054c4d-a1e1-2425-3319-dafa88fc9f08@unibo.it>
 <9c64b36f-8222-a031-b458-9b15d8e6831f@sandeen.net>
 <cb98acba-ebbd-5b45-36bd-0ee292449615@unibo.it>
 <20200702113437.GA55314@bfoster>
 <1b7ed4c0-90f9-420c-e1ca-2af69769f4b6@unibo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1b7ed4c0-90f9-420c-e1ca-2af69769f4b6@unibo.it>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 02, 2020 at 02:15:04PM +0200, Diego Zuccato wrote:
> Il 02/07/20 13:34, Brian Foster ha scritto:
> 
> > I missed how this went from a question around interaction between user
> > and project quotas to reporting of a problem associated with enablement
> > of group+project quotas and an old fs.
> Detected the problem and reported it as an "aside", suggesting a
> possible improvement.
> 
> > The above shows a v4 superblock
> > (crc=0), which means project and group quotas share an inode and thus
> > are mutually exclusive. It sounds to me that the problem is simply that
> > you're specifying a set of incompatible mount options on a v4 fs, but
> > you haven't really stated the problem clearly. I.e.:
> > # mount /dev/test/scratch /mnt/ -o gquota,pquota
> > mount: /mnt: wrong fs type, bad option, bad superblock on /dev/mapper/test-scratch, missing codepage or helper program, or other error.
> > # dmesg | tail
> > [  247.554345] XFS (dm-3): Super block does not support project and group quota together
> Seems you pinned it anyway.
> 
> > We have to fail in this scenario (as opposed to randomly picking one)
> > because either one can work for any mount (presumably wiping out the old
> > quotas when changing from one mode to the other across a mount).
> So that's not possible because introducing such a change would create
> problems in existingsystems. I understand, more or less: if they still
> boot, they're using just one option and from down my ignorance it seemed
> a good idea to just discard deterministically one of the options
> allowing the system to boot anyway. The usual "it's easy if you don't
> have to do it" :)
> 

Pretty much. ;) I think it's reasonable in theory to say something like
"pick one or the other for older fs," but then we have to get into
issues like being subtly affected by code changes that might reorder
mount options without any notion of that affecting behavior (i.e. very
brittle) and/or choosing one option of the other based on the current
status of the [pg]quota inode, which is more implementation and doesn't
rule out having to fail the mount in all cases anyways. Suffice it to
say I don't think it's worth going further down that path simply to
support passing a combination of mount options that has no runtime
effect and was never a supported combination for the associated version
of the fs in the first place.

Brian

> Tks a lot for the clear explanation. Today I learnt something new.
> 
> -- 
> Diego Zuccato
> DIFA - Dip. di Fisica e Astronomia
> Servizi Informatici
> Alma Mater Studiorum - Università di Bologna
> V.le Berti-Pichat 6/2 - 40127 Bologna - Italy
> tel.: +39 051 20 95786
> 

