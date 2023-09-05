Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20344C83F2C
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Sep 2023 16:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351026AbjIEQZ1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354043AbjIEJ1J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Sep 2023 05:27:09 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F50C1A7
        for <linux-xfs@vger.kernel.org>; Tue,  5 Sep 2023 02:27:02 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-402bec56ca6so170415e9.0
        for <linux-xfs@vger.kernel.org>; Tue, 05 Sep 2023 02:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693906021; x=1694510821; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QivlHq495u/KUMjd8H66huPqjXNAmSye3h8RVHL8dfQ=;
        b=kHWjUPh5E9P0PuMc1KvzZrpbBJIlK+fqtQ51r5spaT/X71HFQ1cFrIYmojupmeatNc
         iK9Jf6KueruDB3aavndU6yXWEyu4UokzrV0ad20yU9W+Vjl7OPwUSGH6oaCtW601eiBq
         8pgqVZ4bYHmcU9fGUepyeF+I1+Ia3NddyVr09DtoXzsalyaR3ygWs4rLiLAO/xeOSqRJ
         HQGg+4zYX2hwLIzgjwzq2kE9X/ZBWHMIuGjrtGa3bHwmYTCxnYFV5YwFHFK5OQsxvgTk
         IHTAmTWdYteCZS+OW/u8OBXW/XkP1OnALba/BEfDbpXYFFm1t2CdP5Oc9xUvw/nuSKAj
         +WiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693906021; x=1694510821;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QivlHq495u/KUMjd8H66huPqjXNAmSye3h8RVHL8dfQ=;
        b=hgpk1y24E/y8izuxmY5To/0QKqh4+FoZ/Ys+SM35cPGjYL/rblPL2unB4hFVskZ5Hb
         1SeH0XlN4FTkj6/1un+WzVqIA4FL5wGEbmp9b51v0WifFE1UprwoWz6rJE75GSU8f3n+
         zPQqA//voZdCIOVsBoWNCqu1JLZOIQQ54UeNuji68akZT2UBqdQDS5kvdRPfT3JGriBc
         CRzhq+z/rRKzdneETOFQrPD+k/CcFgS/txBFRAl2NRBbv5MPXj0wEv9T5Cx001I0AE1D
         TCjytMxK1DAfyanSt1tjFeOyLmd5CdEmxM8MWqaNuNceSEIWbmduPOqNX0s6LIBkrdj2
         iqLw==
X-Gm-Message-State: AOJu0YxGQxQCBjSHiXZaEXP0dOjQC5kFVLIsY5Pq8d88bnW70vdqCHv1
        +CN+5dmqG1mZ/XPZj7XWx75Qxcrk3YSA5cbPuWxQRA==
X-Google-Smtp-Source: AGHT+IGENfu5/HhYPIWUo6x3+albtxhQtbOQlDFueHeuAVWyG78SAwIxkvUDeE8EOtxevF3nTDBpl1nNYQYGKf57LhM=
X-Received: by 2002:a05:600c:512a:b0:3fe:e9ea:9653 with SMTP id
 o42-20020a05600c512a00b003fee9ea9653mr263627wms.4.1693906020688; Tue, 05 Sep
 2023 02:27:00 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000e76944060483798d@google.com> <ZPbcdagjHgbBE6A8@infradead.org>
In-Reply-To: <ZPbcdagjHgbBE6A8@infradead.org>
From:   Aleksandr Nogikh <nogikh@google.com>
Date:   Tue, 5 Sep 2023 11:26:48 +0200
Message-ID: <CANp29Y65sCETzq3CttPHww40W_tQ2S=0HockV-aSUi9dE8HGow@mail.gmail.com>
Subject: Re: [syzbot] [xfs?] [ext4?] kernel BUG in __block_write_begin_int
To:     Christoph Hellwig <hch@infradead.org>
Cc:     syzbot <syzbot+4a08ffdf3667b36650a1@syzkaller.appspotmail.com>,
        adilger.kernel@dilger.ca, djwong@kernel.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        song@kernel.org, syzkaller-bugs@googlegroups.com, tytso@mit.edu,
        yukuai3@huawei.com, zhang_shurong@foxmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 5, 2023 at 9:45=E2=80=AFAM Christoph Hellwig <hch@infradead.org=
> wrote:
>
> syz test: git://git.infradead.org/users/hch/misc.git bdev-iomap-fix

A minor correction:

#syz test: git://git.infradead.org/users/hch/misc.git bdev-iomap-fix
