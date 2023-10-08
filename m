Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5F63E95A67
	for <linux-xfs@archiver.kernel.org>; Sun,  8 Oct 2023 20:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbjJHU0o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 8 Oct 2023 16:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjJHU0n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Oct 2023 16:26:43 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E65899;
        Sun,  8 Oct 2023 13:26:42 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id 5614622812f47-3afc38cbdbcso1653915b6e.1;
        Sun, 08 Oct 2023 13:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696796801; x=1697401601; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8zBwTiFmOyiSrWi8kowYs1L9nr5J7WpIdPVf6xKDyZ4=;
        b=NHnqGpKWXNiRHupEUUfjKmR7aKh0g76MHR9paddHRiqOyx9aEa9N9U9cOAT/Y531eL
         Yuo/8KsqGwKOf+IG2tbwSN6CzBylUtyRwI1RJxt0hagZip7wMRzTEyFugo/AaYyNruIr
         IF6ArUqKPnIXcWETL4qm4KhwTqV6rY5AcT832w/yaJQ1q3an3wGi2/HMGnyQIoDPPovy
         9Vu/B8uGT8+qVt7RsvuH+s7PtVs1N8jGkrg/Ea9UjvtwI+K7eBLVzp4wT4wuJIL9RWYz
         om6OvXBZjpb7a+R4gv6EuHokKPYv0sCCQAQ4aNr5N+raBY8dxIpUchMSMmbw90z3GXIF
         3wzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696796801; x=1697401601;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8zBwTiFmOyiSrWi8kowYs1L9nr5J7WpIdPVf6xKDyZ4=;
        b=NFNgaoHicAcbnrvhgzP4XBb1ObKz007XTHdcmLERxDre228hjht0fUgr5Op0yQnXqz
         vKeb6cEW93EC5uCBkuEyqDL+R8XXSFlB2hoA9lkHqN9L51pacvAu1pN2AGyI5GdK0sSs
         e4ST2gYR3IAWkpps9lXfzhkK8UtgaKZY/oGgXJgSnVTbaVtxz39pmfGd413MbxAv9E+p
         it46hlDaMLRfyrqicX8HFA0VgXThCVYV4nakWFoPOU2Xu0Z6/02L/gL9sPOSz5+4nPu/
         qMNw7Sbgzm0SvJeEsYIlyblizeq6gK3fRORSzyJSONCkM8F1zWNdqkPzPu8DFwmtgPA5
         c9Gg==
X-Gm-Message-State: AOJu0YzoqwzIsbNu6OzlbooOqRNtkc/2pJzX8m7KBsX+DoOLstA9Cfdd
        xb2svr7lXM4W+5H/YCCioKJOEfevQFS/rd6NhbAFGP+U
X-Google-Smtp-Source: AGHT+IGXFZMVUUj33ZMCd2lgToLfK0JancQcV+OpfZX/S6PlohpbaFOPRHkSWgTIzdgUA7UG4Vn8i/zScfqA4jMEThw=
X-Received: by 2002:a05:6808:aaa:b0:3a7:e779:7fc1 with SMTP id
 r10-20020a0568080aaa00b003a7e7797fc1mr4913920oij.7.1696796801341; Sun, 08 Oct
 2023 13:26:41 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:5786:0:b0:4f0:1250:dd51 with HTTP; Sun, 8 Oct 2023
 13:26:40 -0700 (PDT)
In-Reply-To: <20231007203543.1377452-6-willy@infradead.org>
References: <20231007203543.1377452-1-willy@infradead.org> <20231007203543.1377452-6-willy@infradead.org>
From:   Mateusz Guzik <mjguzik@gmail.com>
Date:   Sun, 8 Oct 2023 22:26:40 +0200
Message-ID: <CAGudoHEg7oWG8CuyivWRsWLZZtw51oY0=PjLPRzFZDDZf=kzGg@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] fs: Add inode_assert_locked() and inode_assert_locked_excl()
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/7/23, Matthew Wilcox (Oracle) <willy@infradead.org> wrote:
> +static inline void inode_assert_locked_excl(const struct inode *inode)
> +{
> +	rwsem_assert_held_write(&inode->i_rwsem);
> +}
> +
>  static inline void inode_lock_nested(struct inode *inode, unsigned
> subclass)
>  {
>  	down_write_nested(&inode->i_rwsem, subclass);

Why "excl" instead of "write"? Apart from looking weird, it is
inconsistent with "prior art" in the file: i_mmap_assert_write_locked.

-- 
Mateusz Guzik <mjguzik gmail.com>
