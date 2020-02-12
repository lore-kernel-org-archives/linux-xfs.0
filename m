Return-Path: <SRS0=V0Y3=4A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D213C3B187
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Feb 2020 19:50:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11C2824671
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Feb 2020 19:50:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fIM9sQtU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbgBLTt6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Feb 2020 14:49:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36384 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728887AbgBLTt4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Feb 2020 14:49:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581536994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U+GXIvAMcn/l9xGhAfn01B4ypUvtlhAuMLYkyfgVwcY=;
        b=fIM9sQtUEZKNa9LeRJ7RIadgaOxd5lTIBt8v/Ag//QH56CpgKzcccMn+bv4hPlm05PAiPP
        Sdk34PCTT4Zh+Bd7STF+51NzAAL6RWZSSwfLCsEWOhxuB6mURTuYCLqXrokw+tUxYXqr60
        dtjeJbbxLBYRXzmSOJ/CL+hbGawRmJc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-tJPaTru3NKio2wfOesUvGg-1; Wed, 12 Feb 2020 14:49:52 -0500
X-MC-Unique: tJPaTru3NKio2wfOesUvGg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81E12800EB2;
        Wed, 12 Feb 2020 19:49:50 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 01CED60BF4;
        Wed, 12 Feb 2020 19:49:48 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Ira Weiny <ira.weiny@intel.com>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 00/12] Enable per-file/directory DAX operations V3
References: <20200208193445.27421-1-ira.weiny@intel.com>
        <x49imke1nj0.fsf@segfault.boston.devel.redhat.com>
        <20200211201718.GF12866@iweiny-DESK2.sc.intel.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Wed, 12 Feb 2020 14:49:48 -0500
In-Reply-To: <20200211201718.GF12866@iweiny-DESK2.sc.intel.com> (Ira Weiny's
        message of "Tue, 11 Feb 2020 12:17:18 -0800")
Message-ID: <x49sgjf1t7n.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Ira Weiny <ira.weiny@intel.com> writes:

> On Mon, Feb 10, 2020 at 10:15:47AM -0500, Jeff Moyer wrote:
>> Hi, Ira,
>> 
>> Could you please include documentation patches as part of this series?
>
> I do have an update to the vfs.rst doc in
>
> 	fs: Add locking for a dynamic DAX state
>
> I'm happy to do more but was there something specific you would like to see?
> Or documentation in xfs perhaps?

Sorry, I was referring to your statx man page addition.  It would be
nice if we could find a home for the information in your cover letter,
too.  Right now, I'm not sure how application developers are supposed to
figure out how to use the per-inode settings.

If I read your cover letter correctly, the mount option overrides any
on-disk setting.  Is that right?  Given that we document the dax mount
option as "the way to get dax," it may be a good idea to allow for a
user to selectively disable dax, even when -o dax is specified.  Is that
possible?

-Jeff

