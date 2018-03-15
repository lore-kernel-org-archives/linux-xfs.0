Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:45104 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751413AbeCOLRG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Mar 2018 07:17:06 -0400
Received: by mail-wr0-f195.google.com with SMTP id h2so7810827wre.12
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 04:17:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c1da5bba-3abb-7b14-d5e9-2d326af542bc@sandeen.net>
References: <20180305150546.32191-1-jtulak@redhat.com> <20180305215659.GE18129@dastard>
 <2d50aa97-a03b-128f-f4f6-4a6416fac69b@sandeen.net> <20180305223148.GG18129@dastard>
 <421d1afd-5af1-aef9-e6bb-3addcdeeff3f@sandeen.net> <CACj3i73y_ZWvgdv3aKTKaKGuo+6uhcfy1465T3CD2uQDLE3=xQ@mail.gmail.com>
 <20180306213915.GJ18129@dastard> <CACj3i71SHP90DOAhpS3kWyY_6gnx9OzTqgHy7=uxAZH0cfUKMw@mail.gmail.com>
 <e7a132d5-33de-736f-840a-8de45910846c@sandeen.net> <CACj3i73Zb04iHUSS7LNnvegGMe1xaTXwxBjCPnNQg9JmEwQQtQ@mail.gmail.com>
 <c1da5bba-3abb-7b14-d5e9-2d326af542bc@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 15 Mar 2018 12:16:44 +0100
Message-ID: <CACj3i711KdeV8ak5f67FLFzKGZFvRHQSO2VjA0Cxv2V0+hWrsA@mail.gmail.com>
Subject: Re: [PATCH] fsck.xfs: allow forced repairs using xfs_repair
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Mar 14, 2018 at 4:19 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 3/14/18 9:30 AM, Jan Tulak wrote:
>> On Fri, Mar 9, 2018 at 12:28 AM, Eric Sandeen <sandeen@sandeen.net>
>> wrote:
>>>
>>> If it's critical to report whether errors were fixed, it would be
>>> trivial to add a new option to xfs_repair which causes it to test
>>> fs_is_dirty for runs without "-n", and exit with a different
>>> value.
>>
>> I have toyed with it a bit and this seems to be the best option. A
>> flag that changes the exit code on a successful run. Is exit code 3
>> ok? According to man page, only 1 and 2 are currently used and the
>> "everything is ok now, but an issue was there" should not be mixed
>> with the existing ones. I also thought about a flag that would
>> change all exit codes to fsck ones, but that seems too complicated
>> and completely unnecessary.
>
> Hm, I guess we'll have to.

We can either map xfs_repair to fsck in the fsck.xfs script, or change
xfs_repair to use the fsck exit codes. I'm for the first variant (just
add a one new exit code for xfs_repair and remap it for fsck codes in
the script) rather than complicate xfs_repair with two sets of exit
codes.

Jan
