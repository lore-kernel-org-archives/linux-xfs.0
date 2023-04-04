Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F9B8C6FD1D
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 20:51:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236337AbjDDUvn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 16:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236279AbjDDUvm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 16:51:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C1E468E
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 13:51:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE60261FA9
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 20:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE8DC433D2;
        Tue,  4 Apr 2023 20:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680641497;
        bh=notXKIFM1VY27kgjVmlAiChZnhriUyXV1JSIeuP/uzw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cs4lZWFFLPa/+V9bXGAQU7ACsNlDESeH8NvJHT4nZygVQOQK8e1g97zb/vkcCC79/
         NxPXd2LHTvZNR8S0kORldIsghYZ18NlaC6SEuP3ii4yZD3lji2Jww1nS8gdjvc6Emc
         H5zxISsqaCkgbPOgAoduVwtVV1jAo30eiBjim3219+FTE+omMumYARXxCvnEJKr+M8
         17qp0e4+ojyQ2xyeH0KWfsBCCzlPWUA8Hk41Kk7u6r+sQxhj+HIMRmkJIGOIey1i8P
         7uFj4wkK6fSUcCsBANw1nsw71E811oOcSVLX+nsvtuFS1poSpi5lNCmgD3OWbybJzP
         TgcFzsuULg2qg==
Date:   Tue, 4 Apr 2023 13:51:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfs: test the ascii case-insensitive hash
Message-ID: <20230404205136.GA110000@frogsfrogsfrogs>
References: <168062802052.174368.10967543545284986225.stgit@frogsfrogsfrogs>
 <168062803200.174368.4290650174353254767.stgit@frogsfrogsfrogs>
 <CAHk-=wi-W-zJkW-URTQoLcLnRuwzmWj4MRqV6SHXmjKDV2zXFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=wi-W-zJkW-URTQoLcLnRuwzmWj4MRqV6SHXmjKDV2zXFg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[now adding hch because his name is on the original patches from 2008]

On Tue, Apr 04, 2023 at 11:06:27AM -0700, Linus Torvalds wrote:
> On Tue, Apr 4, 2023 at 10:07 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> \> Now that we've made kernel and userspace use the same tolower code for
> > computing directory index hashes, add that to the selftest code.
> 
> Please just delete this test. It's really really fundamentally wrong.
> 
> The fact that you even *think* that you use the same tolower() as user
> space does shows just that you don't even understand how user space
> works.

Wrong.  I'm well aware that userspace tolower and kernel tolower are
*NOT* the same thing.  I'm trying to **STOP USING** tolower in XFS.

I'm **replacing** tolower with a new function that substitutes specific
bytes with other bytes, and I'm redefining the ondisk format to say that
names remain arbitrary sequences of bytes that do not include nulls or
slashes but that hash indexing and lookups will apply the above byte
transformation.  The rules for that transformation may or may not
coincide with what anyone thinks is "upper case in ASCII", but that's
irrelevant.  The rules will be the same in all places, and they will not
break any existing filesystems.

Maybe I should've named it xfs_ItB8n_ci_o43jM28() to make it clearer
that I don't care what ascii is, nor does it matter here.  Perhaps I
should have written "Now that we've made kernel and userspace perform
the same mathematical transformation on dirent name byte arrays before
hashing, add that to the selftest code as well."

Christoph and Barry Naujok should have defined specifically the exact
transformation and the permitted ranges of name inputs when they wrote
the feature.  I wasn't around when this feature was invented...

> Really. The only thing this series shows is that you do not understand
> the complexities.

...and I don't think they understood the complexities when the code was
written.

> Lookie here: compile and run this program:
> 
>     #include <stdio.h>
>     #include <ctype.h>
>     #include <locale.h>
> 
>     int main(int argc, char **argv)
>     {
>         printf("tolower(0xc4)=%#x\n", tolower(0xc4));
>         setlocale(LC_ALL, "C");
>         printf("tolower(0xc4)=%#x\n", tolower(0xc4));
>         setlocale(LC_ALL, "sv_SE.iso88591");
>         printf("tolower(0xc4)=%#x\n", tolower(0xc4));
>     }
> 
> and on my machine, I get this:
> 
>     tolower(0xc4)=0xc4
>     tolower(0xc4)=0xc4
>     tolower(0xc4)=0xe4
> 
> and the important thing to note is that "on my machine". The first
> line could be *different* on some other machine (and the last line
> could be too: there's no guarantee that the sv_SE locale even exists).
> 
> So this whole "kernel and userspace use the same tolower code"
> sentence is simply completely and utterly wrong. It's not even "wrong"
> in the sense fo "that's not true". It's "wrong" in the sense "that
> shows that you didn't understand the problem at all".
> 
> Put another way: saying "5+8=10" is wrong. But saying "5+8=tiger" is
> nonsensical.
> 
> Your patches are nonsensical.

I disagree.  I'm saying that 5 💩 8 = tiger because that's what the 💩
operator does.  💩 is not +, even if 4 💩 8 = 12.

You claim to understand the complexities; how would /you/ fix this?
I'll send along the test cases that reproduce the problems.

--D

>                Linus
