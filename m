Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48434 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753330AbdC1Ugl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Mar 2017 16:36:41 -0400
Subject: Re: [PATCH] xfs_io: changes to statx interface [ver #2]
References: <29458.1490711932@warthog.procyon.org.uk>
 <3791d155-b448-5257-d8b9-8a6f20e12180@sandeen.net>
 <7a090a8e-7204-1b9b-8b31-e7a061b39f87@sandeen.net>
 <29491.1490712064@warthog.procyon.org.uk>
 <4DB15765-D097-43B5-9F1B-43DE76D3BC90@sandeen.net>
 <CAOQ4uxj_S2UtW0A5vSsmD_1vjgPsdopckj4Jtc5w5KuM2aTppA@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <21974862-4737-831f-8885-13b6ded23260@sandeen.net>
Date: Tue, 28 Mar 2017 15:36:33 -0500
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxj_S2UtW0A5vSsmD_1vjgPsdopckj4Jtc5w5KuM2aTppA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>, David Howells <dhowells@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>

On 3/28/17 12:35 PM, Amir Goldstein wrote:
> On Tue, Mar 28, 2017 at 12:42 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> I am (literally) in the woods this week so can't really comment at length, but generally:
>>
>> xfs_io is useful to facilitate testing at times, but usually doesn't have tests built into the tool itself.
>>
> 
> David,
> 
> Eric being the maintainer, so he gets to decide, but he is being
> somewhat subtle.

Sorry about that.  More like: terse, with only a phone to communicate,
and a wife who thinks we're on vacation.  ;)

> There is no precedence AFAIK to tests within xfs_io.
> Instead of comparing to stat with -c flag, you can make sure that
> output of xfs_io -c 'statx -c'
> is fully compatible to output of xfs_io -c 'stat -v' and do the test in scripts.

*nod*

>> And I think you are right that it is a poor fit for some of the testing you'd like to do.
>> There is a src/ dir in xfstests for specialized C tests which get called by the test harness; that might also be a reasonable option.
>>
> 
> That's actually the shortest path for you and there are quite a few
> tests in xfstests that took
> this path. It should be easy for you to copy & paste one of them.
> 
> That's not instead of adding xfs_io statx - just for tests that are
> not natural to do with xfs_io.

Agreed.

I think there's value in having a statx command in xfs_io, but it won't
be able to facilitate testing /everything/ that needs to be tested.

Thanks,
-Eric

>> Thanks,
>> Eric
>>
>>> On Mar 28, 2017, at 9:41 AM, David Howells <dhowells@redhat.com> wrote:
>>>
>>> Note that the intention is to put the testing of the syscall parameter
>>> handling into LTP, along with testing of the symlink following and dirfd usage
>>> since xfstests seems unsuitable for this.
>>>
>>> David
>>
> 
