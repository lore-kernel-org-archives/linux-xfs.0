Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ECB5C77B61
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Apr 2023 13:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbjDXNVi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Apr 2023 09:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231964AbjDXNVf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Apr 2023 09:21:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DD54EED;
        Mon, 24 Apr 2023 06:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tO4JNHQLVQVuoKsDjBtbTMPAx+2bd2jzQfdk7G2t26M=; b=rpLSG38kag+bEQnWP1v8wMz1+A
        LVbvLapSdQCAHXV7K0Yh5Bz+4/27DgRw8/XygDxiwxj119Df4qS1AFGgbNJ2+4x16NpihFJuUMCBa
        vYSSxWAaStQi34MAUGeOnLZ525S6moQui93HP0NmV/UAQ41G42rjM0+lVdUnSExrT5b6VMcqzODYg
        qLa3mo/haylcWppPSSvWCslZOW1egkN9ggDnVhL2BTCYqGL8KP/Ry/xi1LZqfhn1/cak1LQ1rQ7ST
        eDIKX/6jnlnPQ9diREUKx++smyRq/tkvEnJ1moozUN3Q+P19rqiFgmi+qXlGZwErAboJdB9qlROiR
        GXqrw5MA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pqw81-000TyJ-EG; Mon, 24 Apr 2023 13:21:13 +0000
Date:   Mon, 24 Apr 2023 14:21:13 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+606f94dfeaaa45124c90@syzkaller.appspotmail.com>,
        djwong@kernel.org, hch@infradead.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [fs?] [mm?] KCSAN: data-race in __filemap_remove_folio
 / folio_mapping (2)
Message-ID: <ZEaCSXG4UTGlHDam@casper.infradead.org>
References: <000000000000d0737c05fa0fd499@google.com>
 <CACT4Y+YKt-YvQ5fKimXAP8nsV=X81OymPd3pxVXvmPG-51YjOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+YKt-YvQ5fKimXAP8nsV=X81OymPd3pxVXvmPG-51YjOw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 24, 2023 at 09:38:43AM +0200, Dmitry Vyukov wrote:
> On Mon, 24 Apr 2023 at 09:19, syzbot
> <syzbot+606f94dfeaaa45124c90@syzkaller.appspotmail.com> wrote:
> If I am reading this correctly, it can lead to NULL derefs in
> folio_mapping() if folio->mapping is read twice. I think
> folio->mapping reads/writes need to use READ/WRITE_ONCE if racy.

You aren't reading it correctly.

        mapping = folio->mapping;
        if ((unsigned long)mapping & PAGE_MAPPING_FLAGS)
                return NULL;

        return mapping;

The racing write is storing NULL.  So it might return NULL or it might
return the old mapping, or it might return NULL.  Either way, the caller
has to be prepared for NULL to be returned.

It's a false posiive, but probably worth silencing with a READ_ONCE().

