Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f176.google.com ([209.85.216.176]:35902 "EHLO
        mail-qt0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752147AbdHPBo5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Aug 2017 21:44:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhkT05yHfQz0csruH-mz_hTamMABh3eZaNmzjXX02J1=A@mail.gmail.com>
References: <CAPaz=E+-+C-LXtADm99epmVEszpfT70Ep39tKedfPi1AN-P7tA@mail.gmail.com>
 <20170815173349.GA17774@li70-116.members.linode.com> <CAPaz=E+sPDK3uWYCepmYPMT2+nvTgA2C_OSyPY0a51iM=bBCsQ@mail.gmail.com>
 <CAOQ4uxhkT05yHfQz0csruH-mz_hTamMABh3eZaNmzjXX02J1=A@mail.gmail.com>
From: Vijay Chidambaram <vvijay03@gmail.com>
Date: Tue, 15 Aug 2017 20:44:16 -0500
Message-ID: <CAPaz=E+D7wpkXRx7=M9+7d=TUFpbG7MetK-nkECtWQXwO-Z8gA@mail.gmail.com>
Subject: Re: CrashMonkey: A Framework to Systematically Test File-System Crash Consistency
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Josef Bacik <josef@toxicpanda.com>, Ext4 <linux-ext4@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-btrfs@vger.kernel.og, Ashlie Martinez <ashmrtn@utexas.edu>

Hi Amir,

I neglected to mention this earlier: CrashMonkey does not require
recompiling the kernel (it is a stand-alone kernel module), and has
been tested with the kernel 4.4. It should work with future kernel
versions as long as there are no changes to the bio structure.

As it is, I believe CrashMonkey is compatible with the current kernel.
It certainly provides functionality beyond log-writes (the ability to
replay a subset of writes between FLUSH/FUA), and we intend to add
more functionality in the future.

Right now, CrashMonkey does not do random sampling among possible
crash states -- it will simply test a given number of unique states.
Thus, right now I don't think it is very effective in finding
crash-consistency bugs. But the entire infrastructure to profile a
workload, construct crash states, and test them with fsck is present.

I'd be grateful if you could try it and give us feedback on what make
testing easier/more useful for you. As I mentioned before, this is a
work-in-progress, so we are happy to incorporate feedback.

Thanks,
Vijay Chidambaram,
http://www.cs.utexas.edu/~vijay/


On Tue, Aug 15, 2017 at 3:32 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Tue, Aug 15, 2017 at 8:01 PM, Vijay Chidambaram <vvijay03@gmail.com> wrote:
>> Hi Josef and Amir,
>>
> ...
>>
>> @Amir: Given that Josef's code is already in the kernel, do you think
>> changing CrashMonkey code would be useful? We are always happy to
>> provide something for upstream, but we want to be sure how much work
>> would be involved.
>>
>
> Simply put, people (myself included) are more likely to use CrashMonkey
> if it uses upstream kernel and/or if it brings valuable functionality
> to filesystem
> testing, beyond what log-writes already does -
> I am have not studies either tools yet to be able to determine if that
> is the case.
>
> Cheers,
> Amir.
