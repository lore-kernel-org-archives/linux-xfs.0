Return-Path: <SRS0=lRpT=32=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98433C352A3
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 15:32:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EFBF222C2
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 15:32:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AqdlXmru"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727588AbgBFPcO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Feb 2020 10:32:14 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33869 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725535AbgBFPcO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Feb 2020 10:32:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581003132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JkkJGmIOTY9azTSJOAyBmE/D2+0ai1ViZFBb2hElwXY=;
        b=AqdlXmrukIN1dSjBGLgl0WWXYapV9ibPs0KMy28+CHasnKPW+uJQj0YBECl5fnxZ/8uZVA
        5WiBYCIjpxIq04f1TF4Laa9aubDLrF0l1Ac75gCxYIo8S2L4bVQ0UD8Fz3m/qZ+8Tk0sX6
        Eo11lJ8+tzGckpkTGCGqiBk2ibbFqQw=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-zdKzGFmjPmKDKVvow6M-Sw-1; Thu, 06 Feb 2020 10:32:11 -0500
X-MC-Unique: zdKzGFmjPmKDKVvow6M-Sw-1
Received: by mail-oi1-f199.google.com with SMTP id n4so2985581oih.12
        for <linux-xfs@vger.kernel.org>; Thu, 06 Feb 2020 07:32:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JkkJGmIOTY9azTSJOAyBmE/D2+0ai1ViZFBb2hElwXY=;
        b=kVkqvzxe9PDeI1hyvif+6cYUS+TpJnp0f+t2bfevU5Bc9YF7K7UfrhfFmnvU8fLsc4
         8JjS693guSGTAmPUtFsNaOh4T6MwU6GjK+tnCA2eKJsKl7VOXBUBDV4JZfHX2fzaJpoG
         cakRsgT1xCQYwFsURhBTFo1fLISNwcrdp0uutEwQ1g4r09kapn3Ka8F+bdpwYfvykJ+X
         JeNYWSZAUoqfX5YD4+OBVfewHkeG2Uw0J5EG+k/F62dFeUwk/D0IVpxnVS1OIZakf4lk
         VhxA40pGr7VQFQGx0Xo1rYVFf/KLoyyNMZxK8IaWLkagexW27ZN+qsfHGstGwYJaZ/0v
         JbZg==
X-Gm-Message-State: APjAAAXTNR1T1q7P6Z4u7O3xgerFp+sUlYlxz+jwwsIRj1JwQaaCpdrW
        sWHVbL93Bq1ZPN6sA31TA/w7Evbkrr8T+CyGcNDRTF93QWjlkW0p1Z8v4w170BzWyX4FeKj7Zqr
        0ovbwCatNlZ4MnBPljEYiI7kbOUalwz/rOEWS
X-Received: by 2002:aca:48d0:: with SMTP id v199mr7121508oia.10.1581003130604;
        Thu, 06 Feb 2020 07:32:10 -0800 (PST)
X-Google-Smtp-Source: APXvYqz63b3BCvjFz9bZiKofXwlA69pEYM2GvuAIssv4co0has6j21zg9p8DSROFpl+t1g3/AiFAiFF1ObcmOqpV8Jw=
X-Received: by 2002:aca:48d0:: with SMTP id v199mr7121485oia.10.1581003130363;
 Thu, 06 Feb 2020 07:32:10 -0800 (PST)
MIME-Version: 1.0
References: <20200114161225.309792-1-hch@lst.de> <20200114161225.309792-6-hch@lst.de>
In-Reply-To: <20200114161225.309792-6-hch@lst.de>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Thu, 6 Feb 2020 16:31:58 +0100
Message-ID: <CAHc6FU45m59PjBWWO=F740_jyOtKSwc__XfYhP84WkpK0uqcWQ@mail.gmail.com>
Subject: Re: [Cluster-devel] [PATCH 05/12] gfs2: fix O_SYNC write handling
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Waiman Long <longman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Christoph,

thanks for this patch, and sorry for taking so long to react.

On Tue, Jan 14, 2020 at 5:54 PM Christoph Hellwig <hch@lst.de> wrote:
> Don't ignore the return value from generic_write_sync for the direct to
> buffered I/O callback case when written is non-zero.  Also don't bother
> to call generic_write_sync for the pure direct I/O case, as iomap_dio_rw
> already takes care of that.

I like the idea, but the patch as is doesn't quite work: iomap_dio_rw
already bumps iocb->ki_pos, so we end up with the wrong value by
adding the (direct + buffered) write size again.
We'd probably also be better served by replacing
filemap_write_and_wait_range with generic_write_sync + IOCB_DSYNC in
the buffered fallback case. I'll send an update that you'll hopefully
like.

Andreas

