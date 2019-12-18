Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C4B0C43603
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 16:45:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69BC220717
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 16:45:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfLRQpA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Dec 2019 11:45:00 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:44713 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727160AbfLRQo7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Dec 2019 11:44:59 -0500
Received: from mail-qt1-f182.google.com ([209.85.160.182]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1My6xz-1hl6H70dkV-00zTNH; Wed, 18 Dec 2019 17:44:58 +0100
Received: by mail-qt1-f182.google.com with SMTP id n15so2454485qtp.5;
        Wed, 18 Dec 2019 08:44:57 -0800 (PST)
X-Gm-Message-State: APjAAAWe3Vs1VVwusIdEy6EtesIfTgwMQJvs1Te9YS3hWfT4/TadfwF7
        ASCnD5Wm5XUx10kvVQj21CQrQH9naHcKbmgtq5w=
X-Google-Smtp-Source: APXvYqz+l4BOlK2W2ys3sLUa8ROCWJ8lqlRzESKGpDoxTAUgyCUDZt0Q19zyLDMrdWwIzD8L81ulsb8WG6J0gy/M2Bo=
X-Received: by 2002:ac8:6153:: with SMTP id d19mr2990509qtm.18.1576687497010;
 Wed, 18 Dec 2019 08:44:57 -0800 (PST)
MIME-Version: 1.0
References: <20191213204936.3643476-1-arnd@arndb.de> <20191213205417.3871055-12-arnd@arndb.de>
 <20191213211728.GL99875@magnolia> <CAK8P3a3k9dq+9DnPFBKdzOe=ALPXXjCvBBj8r_xsqz1vTswGsg@mail.gmail.com>
 <CAK8P3a2nJKR+_Gc6G_S6Bd0fKecBCM+a2cekOU+6m6kw_c4q9A@mail.gmail.com> <20191217221555.GE12765@magnolia>
In-Reply-To: <20191217221555.GE12765@magnolia>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 18 Dec 2019 17:44:40 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1QWxbGao7MLbAg-Wmv58oQ8ZsURYHgf3mihJ6-RKACrQ@mail.gmail.com>
Message-ID: <CAK8P3a1QWxbGao7MLbAg-Wmv58oQ8ZsURYHgf3mihJ6-RKACrQ@mail.gmail.com>
Subject: Re: [PATCH v2 21/24] xfs: quota: move to time64_t interfaces
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     y2038 Mailman List <y2038@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Pavel Reichl <preichl@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:j5/HNtZsXsGRbPZkpl4k+drfIvbR0CyOiXMiafhTVZpdhwkPTMH
 WdWO1B+LVkkCAe7uzp9t7MKWFMt1p42mqh9daEwoiA3Mmtcbl8y9dLXJEI/hpqIweNCjTf3
 zqSCX0VLAKrsWiV/KfQfU0EtNOMf03QEv4frx1sjDtesNn3tYBfgfbCZovx04EDKffVSCSt
 LPyU37UjKB33gIrsgb8LA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:k4N9wcJcEio=:S1vAD/RU39IDfIxJZEYlRp
 1Oc7mv12ZmRoKyDbRo+UCmQYBX0+yBS7BqREqavcBvoYgRbnq5ZsBZdIL464pUWs1VsqJAHWW
 UT4IDn3nH/1zAxLhC8de1OUk6Ggnk8TkO5/Yx2a8hqP6vmSlQcKUYGZCliP6dO/bLlaKN4/JW
 CztHn7shrnKxkSvvEZuuUcA3xdEq7w42+T2u0oaTM/v7bvQqro7Hz1IM3F1Cr0v5LtPa7obLT
 c85miHvZVgD9QgzHhp9i0emPnWvHHJffOcRwKUtfqkVXxVYgaYKIpWjMtAubOxaMv7LOsE1Ld
 2qhjDVoMV5K/L/yP4hNETfHx/WHsF7yMMlDi7SIFj5rv24A6W1PW5ISnVtEuoXyK49ig3MIVw
 eg3Jj+tPpj8G6gvyt/7w33e6O5ViBLJy9pu2EzT9DOFM6q0KKUy/XXkdXhxPbYxLRyEKd2Atd
 CS5LqGCM+jWo72C9ZLkrxLRIT7BUk17tX1XckBr5szJBhd2nbkMI9uF/LLfGQMWG/vlNdSH+3
 9Y7ItA2/FePuiWUmBgOoQbqcrZ1YFD4qcck0FWMe0ZoOw3TdQxXyNRQ7+pTTMfso+GTeiGqKC
 v+Ybl4JU6kdIn8knU5zrMB/B/tZswbdm53G/gAXg9Lh2+cdoacL31pplzynS0YowNcQWJV0nf
 itCIVn8s9hfO67eXrIMjZJVZtGH/91SM9/Ix77zCZ7BXb6wgy0NR/1unS+gf1NdN2RkvnDcYB
 hzdc+bay0VDpyDxbOo1ZZNrwXga+zOG0w84hzFly69l6M8msF9DcVyx5WjGVQlTnZqPUkfPkM
 jXKcBdcPWXY/hjk96UQ8kTPRCNbs9/S1Qc6JNtMcrDZ8fkkAN+LcpbbKOu8pPFxE0iakYFzS6
 3d8jfd7LIN3ok3+0HoeA==
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 17, 2019 at 11:18 PM Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Tue, Dec 17, 2019 at 04:02:47PM +0100, Arnd Bergmann wrote:
> > On Mon, Dec 16, 2019 at 5:52 PM Arnd Bergmann <arnd@arndb.de> wrote:
> > > On Fri, Dec 13, 2019 at 10:17 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > >>
> > >> Hmm, so one thing that I clean up on the way to bigtime is the total
> > >> lack of clamping here.  If (for example) it's September 2105 and
> > >> rtbtimelimit is set to 1 year, this will cause an integer overflow.  The
> > >> quota timer will be set to 1970 and expire immediately, rather than what
> > >> I'd consider the best effort of February 2106.
> >
> > One more hing to note (I will add this to the changelog text) is that on
>
> Ok, I'll look for it in the next revision you send out.
>
> By the way, would you mind cc'ing the xfs list on all 24 patches?  They
> probably aren't directly relevant to xfs, but it does make it a lot
> easier for us to look at the other 21 patches and think "Oh, ok, so
> there isn't some core infrastructure change that we're not seeing".

I wasn't planning on sending the full series once more, as there were very
few comments now. I've sent the three XFS patches again by themselves
now. If you can pick these up, I'll put the rest into linux-next to give them
some more testing, and hopefully have others pick up a couple more
before I send a pull request.

      Arnd
