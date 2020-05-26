Return-Path: <SRS0=dAFJ=7I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48A74C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 12:28:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27D5220776
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 12:28:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mPT3FjLj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388496AbgEZM2v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 May 2020 08:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388099AbgEZM2v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 May 2020 08:28:51 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27314C03E96D
        for <linux-xfs@vger.kernel.org>; Tue, 26 May 2020 05:28:50 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id z1so3795293qtn.2
        for <linux-xfs@vger.kernel.org>; Tue, 26 May 2020 05:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1kX/0h7k/dLe5VJKTh3GU8d/OkmFa8r3dT9cu3FJjGc=;
        b=mPT3FjLjm62VBWNljqWLDCHoPckeQ4ksZJtI9uhDW+MWFlBsItM87HrXLaTOHmD1Os
         8lvWLgU/YJZ+LcSDxnqxF7yhVVgFkkWkJYhX1sa3hF5wDCqLOhDYgVitjnc+f8wlfu3F
         BGhZftnjDNBvxui1hh5itHQ77YJZsuGj0dds5hQTzNchwn3owOTXzruvFwsbgMljCUkY
         8iZhKn24+iB3r9vYjctfK4o9f7exfOtn/Wgc6HGulpLRk4j/URFVXEb0CBcwTriz0cre
         HEvZVdG18YDDxsdbGJ6RHYaXYBywNuflMMwez8hZ6K1OnUmbEeYBdKjCByqfSq/FFbAX
         IQiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1kX/0h7k/dLe5VJKTh3GU8d/OkmFa8r3dT9cu3FJjGc=;
        b=uTIOmJoLGLrtOxc5sil7IxOVjQm5B4+/OA7wIwfhc6bOP2jnxv65iShSUE9DXGZmfP
         zdrs/6vRKijpSdGXMF50vrynkks7hird8VkJlN1S6AgZi795hVUqku6SuCjyZTaFNzzv
         eWYIj2yI+npPX+vUmgBqmDgT+s7aixNLFC45knww1ZL6ATSuY+/aFjMlGgCYIZdvLwkh
         9z+L7S3I135YEaHQfGk4VrRL5ABfznecK8vyEnFNyEVtfeprpAFKLDLLxsUlhPeUorhc
         BVmS6/bZQW507ZKtqF9MpVFuSkuWv2Rv23qot08OK7oQs5Qa8HVtERsWMAeUcsPDmAA2
         yDpw==
X-Gm-Message-State: AOAM531h3MgQ7ux6Xnc2D1iITJaq89HJ0WKB+4snjndcRwJVrY71W1J+
        Sthpl+Kxg4dFX9h7pACisiveBgAW1SXAlr8DrrxVBg==
X-Google-Smtp-Source: ABdhPJzYmQaKATAOlbMfaUIFDS+5i7N6bvQY8eKswoVGpLACVzSZ7jP4lSy35/qZaQ6wPHwH3aDYuw8sUXBzyMev+8I=
X-Received: by 2002:aed:3668:: with SMTP id e95mr1006428qtb.50.1590496129116;
 Tue, 26 May 2020 05:28:49 -0700 (PDT)
MIME-Version: 1.0
References: <CACT4Y+ap21MXTjR3wF+3NhxEtgnKSm09tMsUnbKy2_EKEgh0kg@mail.gmail.com>
 <3979FAE7-0119-4F82-A933-FC175781865C@lca.pw>
In-Reply-To: <3979FAE7-0119-4F82-A933-FC175781865C@lca.pw>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 26 May 2020 14:28:37 +0200
Message-ID: <CACT4Y+azkizw6QA0VCr0wv93oSkgaYCPc4txy9M=ivgBot1+zg@mail.gmail.com>
Subject: Re: linux-next build error (8)
To:     Qian Cai <cai@lca.pw>
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        syzbot <syzbot+792dec47d693ccdc05a0@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 26, 2020 at 2:19 PM Qian Cai <cai@lca.pw> wrote:

> > On May 26, 2020, at 8:09 AM, Dmitry Vyukov <dvyukov@google.com> wrote:
> >
> > +linux-next and XFS maintainers
> >
> > Interesting. This seems to repeat reliably and this machine is not
> > known for any misbehavior and it always happens on all XFS files.
> > Did XFS get something that crashes gcc's?
>
> Are you still seeing this in today=E2=80=99s linux-next? There was an iss=
ue had already been sorted out.

syzbot seen this on these commits/dates:

https://syzkaller.appspot.com/bug?extid=3D792dec47d693ccdc05a0
Crashes (4):
Manager Time Kernel Commit Syzkaller Config Log Report Syz repro C repro
ci-upstream-linux-next-kasan-gce-root 2020/05/22 01:23 linux-next
e8f32747 5afa2ddd .config log report
ci-upstream-linux-next-kasan-gce-root 2020/05/21 15:01 linux-next
e8f32747 1f30020f .config log report
ci-upstream-linux-next-kasan-gce-root 2020/05/19 18:24 linux-next
fb57b1fa 6d882fd2 .config log report
ci-upstream-linux-next-kasan-gce-root 2020/03/18 16:19 linux-next
47780d78 0a96a13c .config log report
