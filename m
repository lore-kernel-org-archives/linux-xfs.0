Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73776C25B48
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Oct 2023 18:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbjJZSKY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Oct 2023 14:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjJZSKX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2023 14:10:23 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA189C
        for <linux-xfs@vger.kernel.org>; Thu, 26 Oct 2023 11:10:21 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-9adb9fa7200so250406366b.0
        for <linux-xfs@vger.kernel.org>; Thu, 26 Oct 2023 11:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1698343819; x=1698948619; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vTbt9gqKKxXYaVH3DBnhOUVSf9jjJse6rxhifrnnjZk=;
        b=XOscnmogPVD18uaSCG5AznLkn6dvylNHpXDFbAqepN7PtAgiFB0BR/pJPlnOP1RKLM
         xlFzOMVO5V60UxiBa6jxzclbRepjqungsZKvUD6rNPIdXWPXBQz4kqXUnfrPVG7fgXFY
         8kiidtkfC0oW8+dpg6YrzToH75P43tkWZl6KI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698343819; x=1698948619;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vTbt9gqKKxXYaVH3DBnhOUVSf9jjJse6rxhifrnnjZk=;
        b=NO8rXg4VCIKfYJrPaxsM8gG8prMd/FiGkHCJtELt7FJ2CfygkSFyqyuBIAjdNO9Vkk
         qCNfk5hH85x3n9FAl3k+GEIfXazxpJrVBq7m7fekujT16ZWHNgI/Jfg8xMQ13vB28ok0
         wizyWOGyNVDPkXK7zxDzgO7NNM68eK7dEnJ5jHZB98rvrfvx4LtWFhtTTkH28/PssfGS
         3KoESpHjaFvkO+l9bPGSZFF4lqx1C/QqMwB+LbChDvu31ha7luU5dyacZKbn5Ln9vgMA
         w1a/6uxpI85RsMZNP5Uv7rjp0pLPMvNwkt3Ys31qZykf8mNEebymWd4z0R2UV6j9+j5E
         SE7Q==
X-Gm-Message-State: AOJu0YzVMUSqlQD2CFFhqMK8jqtd3MU513d1Jyrsm0uimIQvBEqhPnB6
        xr3PqxXSqsqciNcqtcR2+WeombKVlvgfU9DlBrVlqA==
X-Google-Smtp-Source: AGHT+IHItlDMRvBRRCYDqNYGDb01GlTtWYfcQsJwOUZy4smsy2PWzHypX4hAUrGgDLbJAdV0LIkDOA==
X-Received: by 2002:a17:907:2da3:b0:9c3:97d7:2c67 with SMTP id gt35-20020a1709072da300b009c397d72c67mr512563ejc.25.1698343819539;
        Thu, 26 Oct 2023 11:10:19 -0700 (PDT)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com. [209.85.208.48])
        by smtp.gmail.com with ESMTPSA id m11-20020a170906234b00b00988e953a586sm11987329eja.61.2023.10.26.11.10.18
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Oct 2023 11:10:18 -0700 (PDT)
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-53fc7c67a41so4934040a12.0
        for <linux-xfs@vger.kernel.org>; Thu, 26 Oct 2023 11:10:18 -0700 (PDT)
X-Received: by 2002:aa7:c758:0:b0:541:342b:2469 with SMTP id
 c24-20020aa7c758000000b00541342b2469mr1010574eds.1.1698343818276; Thu, 26 Oct
 2023 11:10:18 -0700 (PDT)
MIME-Version: 1.0
References: <169786962623.1265253.5321166241579915281.stg-ugh@frogsfrogsfrogs>
 <CAHk-=whNsCXwidLvx8u_JBH91=Z5EFw9FVj57HQ51P7uWs4yGQ@mail.gmail.com>
 <20231023223810.GW3195650@frogsfrogsfrogs> <20231024-flora-gerodet-8ec178f87fe9@brauner>
 <20231026031325.GH3195650@frogsfrogsfrogs>
In-Reply-To: <20231026031325.GH3195650@frogsfrogsfrogs>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 26 Oct 2023 08:10:01 -1000
X-Gmail-Original-Message-ID: <CAHk-=whQHBdJTr9noNuRwMtFrWepMHhnq6EtcAypegi5aUkQnQ@mail.gmail.com>
Message-ID: <CAHk-=whQHBdJTr9noNuRwMtFrWepMHhnq6EtcAypegi5aUkQnQ@mail.gmail.com>
Subject: Re: [GIT PULL] iomap: bug fixes for 6.6-rc7
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christian Brauner <brauner@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Shirley Ma <shirley.ma@oracle.com>, hch@lst.de,
        jstancek@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 25 Oct 2023 at 17:13, Darrick J. Wong <djwong@kernel.org> wrote:
>
> Similar to what we just did with XFS, I propose breaking up the iomap
> Maintainer role into pieces that are more manageable by a single person.
> As RM, all you'd have to do is integrate reviewed patches and pull
> requests into one of your work branches.  That gives you final say over
> what goes in and how it goes in, instead of letting branches collide in
> for-next without warning.

I _think_ what you are saying is that you'd like to avoid being both a
maintainer and a developer.

Now, I'm probably hugely biased and going by personal experience, but
I do think that doing double duty is the worst of both worlds, and
pointlessly stressful.

As a maintainer, you have to worry about the big picture (things like
release timing, even if it's just a "is this a fix for this release,
or should it get queued for the next one") but also code-related
things like "we have two different things going on, let's sort them
out separately". Christian had that kind of issue just a couple of
days ago with the btrfs tree.

But then, as a developer, those are distractions and just add stress
and worry, and distract from whatever you're working on. As a
developer, the last thing you want to worry about is something else
than the actual technical issue you're trying to solve.

And obviously, there's a lot of overlap. A maintainer needs to be
_able_ to be a developer just to make good choices. And the whole
"maintainer vs developer" doesn't have to be two different people,
somebody might shift from one to the other simply because maybe they
enjoy both roles. Just not at the same time, all the time, having both
things putting different stress on you.

You can *kind* of see the difference in our git tree if you do

    git rev-list --count --author=XYZ --no-merges --since=1.year HEAD

to see "code authorship" (aka developer), vs

    git rev-list --count --committer=XYZ --since=1.year HEAD

which shows some kind of approximation of "maintainership". Obviously
there is overlap (potentially a lot of it) and the above isn't some
absolute thing, but you can see some patterns.

I personally wish we had more people who are maintainers _without_
having to worry too much about developing new code.  One of the issues
that keeps coming up is that companies don't always seem to appreciate
maintainership (which is a bit strange - the same companies may then
_love_ appreciateing managers, which is something very different but
has some of the same flavour to it).

And btw, I don't want to make that "I wish we had more maintainers" be
a value judgement. It's not that maintainers are somehow more
important than developers. I just think they are two fairly different
roles, and I think one person doing both puts unnecessary stress on
that person.

             Linus
