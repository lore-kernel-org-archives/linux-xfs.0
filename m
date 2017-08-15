Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:33876 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751570AbdHOSCg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Aug 2017 14:02:36 -0400
MIME-Version: 1.0
In-Reply-To: <20170815173349.GA17774@li70-116.members.linode.com>
References: <CAPaz=E+-+C-LXtADm99epmVEszpfT70Ep39tKedfPi1AN-P7tA@mail.gmail.com>
 <20170815173349.GA17774@li70-116.members.linode.com>
From: Vijay Chidambaram <vvijay03@gmail.com>
Date: Tue, 15 Aug 2017 13:01:54 -0500
Message-ID: <CAPaz=E+sPDK3uWYCepmYPMT2+nvTgA2C_OSyPY0a51iM=bBCsQ@mail.gmail.com>
Subject: Re: CrashMonkey: A Framework to Systematically Test File-System Crash Consistency
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.og, Ashlie Martinez <ashmrtn@utexas.edu>

Hi Josef and Amir,

Thank you for the replies! We were aware that Josef had proposed
something like this a few years ago [1], but didn't know it was being
currently used inside Facebook. Glad to hear it!

@Josef: Thanks for the link! I think CrashMonkey does what you have in
log-writes, but our goal is to go a bit further:

- We want to test replaying subsets of writes between flush/fua.
Indeed, this is one of the major focus points of the work. Given W1 W2
W3 Flush, CrashMonkey will generate states, (W1), (W1 W3), (W1 W2),
etc. We believe many interesting bugs lie in this space. The problem
is that there are a large number of possible crash states, so we are
working on techniques to find "interesting" crash states. For now, our
plan is to focus on write requests tagged with the META flag.

- We want to aid the users in testing data consistency after a crash.
The plan is that after each crash state, after running fsck, if the
file system mounts, we allow the user to run a number of custom tests.
To help the user figure out what data should be present in the crash
state, we plan to provide functionality that informs the user at which
point the crash occurred (similar to the "mark" functionality in
log-writes, but instead of indicating a single point in the stream, it
would provide a snapshot of fs state)

@Amir: Given that Josef's code is already in the kernel, do you think
changing CrashMonkey code would be useful? We are always happy to
provide something for upstream, but we want to be sure how much work
would be involved.

[1] https://lwn.net/Articles/637079/

Thanks,
Vijay

On Tue, Aug 15, 2017 at 12:33 PM, Josef Bacik <josef@toxicpanda.com> wrote:
> On Mon, Aug 14, 2017 at 11:32:02AM -0500, Vijay Chidambaram wrote:
>> Hi,
>>
>> I'm Vijay Chidambaram, an Assistant Professor at the University of
>> Texas at Austin. My research group is developing CrashMonkey, a
>> file-system agnostic framework to test file-system crash consistency
>> on power failures. We are developing CrashMonkey publicly at Github
>> [1]. This is very much a work-in-progress, so we welcome feedback.
>>
>> CrashMonkey works by recording all the IO from running a given
>> workload, then *constructing* possible crash states (while honoring
>> FUA and FLUSH flags). A crash state is the state of storage after an
>> abrupt power failure or crash. For each crash state, CrashMonkey runs
>> the filesystem-provided fsck on top of the state, and checks if the
>> file-system recovers correctly. Once the file system mounts correctly,
>> we can run further tests to check data consistency.  The work was
>> presented at HotStorage 17. The workshop paper is available at [2] and
>> the slides at [3].
>>
>> Our plan was to post on the mailing lists after reproducing an
>> existing bug. We are not there yet, but I saw some posts where others
>> were considering building something similar, so I thought I would post
>> about our work.
>>
>> [1] https://github.com/utsaslab/crashmonkey
>> [2] http://www.cs.utexas.edu/~vijay/papers/hotstorage17-crashmonkey.pdf
>> [3] http://www.cs.utexas.edu/~vijay/papers/hotstorage17-crashmonkey-slides.pdf
>>
>
> I did this same work 3 years ago
>
> https://github.com/torvalds/linux/blob/master/Documentation/device-mapper/log-writes.txt
> https://github.com/josefbacik/log-writes
>
> I have xfstests patches I need to get upstreamed at some point that does
> fsstress and then replays the logs and verifies, and also one that makes fsx
> store state so we can verify fsync() is doing the right thing.  We run this on
> our major releases on xfs, ext4, and btrfs to make sure everything is working
> right internally at Facebook.  You'll notice a bunch of commits recently because
> we thought we found an xfs replay problem (we didn't).  This stuff is actively
> used, I'd welcome contributions to it if you have anything to add.  One thing I
> haven't done yet and have on my list is to randomly replay writes between
> flush/fua, but it hasn't been a pressing priority yet.  Thanks,
>
> Josef
