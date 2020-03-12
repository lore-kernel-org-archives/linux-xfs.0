Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F16E3C4CECE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 10:08:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C665A20724
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 10:08:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DXnL+Ncr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgCLKIG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 06:08:06 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52412 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725978AbgCLKIG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 06:08:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584007685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UREMN3SChoR23ul+gfDOcGQfVoGjOsof5Gn863j6Nd4=;
        b=DXnL+NcrLxBPyutdoJBMA01TzEHc70k5dWTZ8HVKZYBTmYV2nP0ynhFxVZnvUHusyi5rFu
        RzkBUFQNFjMLysMNA85MGj83EVt2YxTSo8lWxq92Scki5W+x06QcTlCIeR/dl+PZX3XN+F
        3gCLGdLhYbbd2CnIqlMpIcxP98z5+Lo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-HwXjt_E_PU-qSYhRePSKpw-1; Thu, 12 Mar 2020 06:08:01 -0400
X-MC-Unique: HwXjt_E_PU-qSYhRePSKpw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DBA34189D6D3;
        Thu, 12 Mar 2020 10:07:59 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-182.rdu2.redhat.com [10.10.120.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E57D3277AD;
        Thu, 12 Mar 2020 10:07:57 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <969260.1584004779@warthog.procyon.org.uk>
References: <969260.1584004779@warthog.procyon.org.uk>
To:     mbobrowski@mbobrowski.org, darrick.wong@oracle.com
Cc:     dhowells@redhat.com, jack@suse.cz, hch@lst.de,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: Is ext4_dio_read_iter() broken? - and xfs_file_dio_aio_read()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1015226.1584007677.1@warthog.procyon.org.uk>
Date:   Thu, 12 Mar 2020 10:07:57 +0000
Message-ID: <1015227.1584007677@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> Is ext4_dio_read_iter() broken?  It calls:
> 
> 	file_accessed(iocb->ki_filp);
> 
> at the end of the function - but surely iocb should be expected to have been
> freed when iocb->ki_complete() was called?

I think it's actually worse than that.  You also can't call
inode_unlock_shared(inode) because you no longer own a ref on the inode since
->ki_complete() is expected to call fput() on iocb->ki_filp.

Yes, you own a shared lock on it, but unless somewhere along the
fput-dput-iput chain the inode lock is taken exclusively, the inode can be
freed whilst you're still holding the lock.

Oh - and ext4_dax_read_iter() is also similarly broken.

And xfs_file_dio_aio_read() appears to be broken as it touches the inode after
calling iomap_dio_rw() to unlock it.

David

