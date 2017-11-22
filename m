Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:33648 "EHLO
        mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751375AbdKVUkI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Nov 2017 15:40:08 -0500
Received: by mail-yw0-f169.google.com with SMTP id z125so6248863ywb.0
        for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2017 12:40:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171122183119.GI2135@magnolia>
References: <20170830145400.3681-1-hch@lst.de> <20171115011022.GC5119@magnolia>
 <CAOQ4uxg2iF5ucZTeN6orJVA2VYFnHAkvyb1-FS0BEZ=rGN+-Lw@mail.gmail.com> <20171122183119.GI2135@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 22 Nov 2017 22:40:07 +0200
Message-ID: <CAOQ4uxjzpBrzMnt-OFP4P_6DB5onw9U+BM+4Dd_BpaeaPQ86iQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: remove experimental tag for reflinks
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Nov 22, 2017 at 8:31 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Wed, Nov 15, 2017 at 08:14:33AM +0200, Amir Goldstein wrote:
[...]
>>
>> Last time you wrote about this bug you had a "hard question" about transaction
>> reservation for the solution and said your're going to go have a think about it:
>> https://marc.info/?l=linux-xfs&m=150766311924170&w=2
>> Did you come to any conclusions?
>> That sounds like one of those nasty CoW corner cases, so I'd be happy to know
>> there is at least a well thought design for a solution - if not a fix.
>
> Sorry I let myself get distracted/stressed with the merge window;
> hopefully the patch I sent out will address that problem?
>

Problem reproduces better on a spinning rust I have at the office, so will
give it a spin tomorrow.

>> Practically, I would love if that bug could be solved soon so that we can all
>> start running generic/503 for more than a few iterations to stress
>> test reflink/cow
>> with power failure. Success on this front could be a big upside before
>> turning off
>> EXPERIMENTAL.
>
> Indeed!  What is the status of those tests, anyway?  Are they in xfstests?
>

Yes.
2 fsx stress tests, with and without clones
generic/455
generic/457
(replay group)

One regression test for ext4 crash bug that was already fixed
generic/456

And one regression test for xfs reflink crash bug that you already fixed
generic/458

So generic/457 is the one we should be hammering (fsx and reflink)
it creates 10 clones and runs fsx workers on them.
I imagine it is not long before there are no more shared extents.
It's not much, but its a good start.
I recon it would be good if you guys added some more variants of this test
to try and cover more interesting reflink cases.

FYI, Josef also has an fsstress based test, but it is plain shell script
and I never got around to adapting it to an xfstest:
https://github.com/josefbacik/log-writes

Cheers,
Amir.
