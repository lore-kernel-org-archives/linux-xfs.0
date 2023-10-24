Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93126C07545
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Oct 2023 19:40:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234954AbjJXTk4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Oct 2023 15:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234925AbjJXTkx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Oct 2023 15:40:53 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3494B10E5
        for <linux-xfs@vger.kernel.org>; Tue, 24 Oct 2023 12:40:49 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-50816562320so26059e87.3
        for <linux-xfs@vger.kernel.org>; Tue, 24 Oct 2023 12:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1698176447; x=1698781247; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dQAl0rC44IDpm4wzCCiFnwdE9x2WCYlyNzW0Sdf0Q28=;
        b=JMfidq6EgMaFyyDQKdWBkNW5O5IXK/RwKfZjZaLbgAGaF8LoDV1WIQbcplr4wCBJun
         NH7wHqSHxmoDmo9/XoQgUrOQ6skmklRePpSPdzmgJysshchS4FoE+noAZGLhd0VaOEIc
         peLSrEJoImRqd+55FZ4V0T3Gcho7mdAlbOkHM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698176447; x=1698781247;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dQAl0rC44IDpm4wzCCiFnwdE9x2WCYlyNzW0Sdf0Q28=;
        b=mQ1PMiiZAo5L79yIFFC+g8iip4Q5Y8hBODRm7vzQS9gMraZFgf10HIKxR+FIU0pntH
         8lWMiCD6Ecd1+V6rYUtIkyrvNiGPnPURAv6nPFrogcnzijXfNClAVW2AfINIpFpWlOXI
         dOdTmcAydHfdRHQKuH1Fo+k3dMR4xoUvS62OI57e1HDMX22ezQ6cMixM+4Px+BM9Vyrj
         Qa8m+oUXbFwhbXdmlXCwacEKlWtPW3/zMCHYZF+BxrKsDCCnFwQN/JTx82gfJq3CsaYq
         lVgu8Z1QPQ20f0CL5Oy04qGm/LBqU+vWFTPNifq3GapOS7ZZhpJFK5P7yRnG7QOl+Hpn
         zRGQ==
X-Gm-Message-State: AOJu0Ywi5+Bc1QaAoSqD5vT3fI754NnroXlpJhra/X5tQM6k1pJtifS8
        yOp/rsOEBGp7pa6deFoEpKtGwq+wpDFI136H7UkM8LHo
X-Google-Smtp-Source: AGHT+IEI1LjJOcQWOi4+ca9mGKfQPkPjVAeenfgsD37nphRdVupv6vX6D0M3vb7tNw3E7dgn/csj2g==
X-Received: by 2002:ac2:5299:0:b0:503:3816:c42c with SMTP id q25-20020ac25299000000b005033816c42cmr9079962lfm.41.1698176446933;
        Tue, 24 Oct 2023 12:40:46 -0700 (PDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id q20-20020a056402033400b0053dd8898f75sm8232272edw.81.2023.10.24.12.40.46
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 12:40:46 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-53dd752685fso7599166a12.3
        for <linux-xfs@vger.kernel.org>; Tue, 24 Oct 2023 12:40:46 -0700 (PDT)
X-Received: by 2002:a17:906:eecd:b0:9bd:9bfe:e410 with SMTP id
 wu13-20020a170906eecd00b009bd9bfee410mr9262779ejb.72.1698176425825; Tue, 24
 Oct 2023 12:40:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wixObEhBXM22JDopRdt7Z=tGGuizq66g4RnUmG9toA2DA@mail.gmail.com>
 <d6162230b83359d3ed1ee706cc1cb6eacfb12a4f.camel@kernel.org>
 <CAHk-=wiKJgOg_3z21Sy9bu+3i_34S86r8fd6ngvJpZDwa-ww8Q@mail.gmail.com>
 <5f96e69d438ab96099bb67d16b77583c99911caa.camel@kernel.org>
 <20231019-fluor-skifahren-ec74ceb6c63e@brauner> <0a1a847af4372e62000b259e992850527f587205.camel@kernel.org>
 <ZTGncMVw19QVJzI6@dread.disaster.area> <eb3b9e71ee9c6d8e228b0927dec3ac9177b06ec6.camel@kernel.org>
 <ZTWfX3CqPy9yCddQ@dread.disaster.area> <61b32a4093948ae1ae8603688793f07de764430f.camel@kernel.org>
 <ZTcBI2xaZz1GdMjX@dread.disaster.area> <CAHk-=whphyjjLwDcEthOOFXXfgwGrtrMnW2iyjdQioV6YSMEPw@mail.gmail.com>
 <2c74660bc44557dba8391758535e4012cbea3724.camel@kernel.org>
In-Reply-To: <2c74660bc44557dba8391758535e4012cbea3724.camel@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 24 Oct 2023 09:40:08 -1000
X-Gmail-Original-Message-ID: <CAHk-=wibJqQGBXAr2S69FifUXdJJ=unAQT5ag0qRSQNxGk31Lw@mail.gmail.com>
Message-ID: <CAHk-=wibJqQGBXAr2S69FifUXdJJ=unAQT5ag0qRSQNxGk31Lw@mail.gmail.com>
Subject: Re: [PATCH RFC 2/9] timekeeping: new interfaces for multigrain
 timestamp handing
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        John Stultz <jstultz@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.de>,
        David Howells <dhowells@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-mm@kvack.org,
        linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 24 Oct 2023 at 09:07, Jeff Layton <jlayton@kernel.org> wrote:
>
> The new flag idea is a good one. The catch though is that there are no
> readers of i_version in-kernel other than NFSD and IMA, so there would
> be no in-kernel users of I_VERSION_QUERIED_STRICT.

I actually see that as an absolute positive.

I think we should *conceptually* do those two flags, but then realize
that there are no users of the STRICT version, and just skip it.

So practically speaking, we'd end up with just a weaker version of
I_VERSION_QUERIED that is that "I don't care about atime" case.

I really can't find any use that would *want* to see i_version updates
for any atime updates. Ever.

We may have had historical user interfaces for i_version, but I can't
find any currently.

But to be very very clear: I've only done some random grepping, and I
may have missed something. I'm not dismissing Dave's worries, and he
may well be entirely correct.

Somebody would need to do a much more careful check than my "I can't
find anything".

             Linus
