Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:43418 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757984AbdKOSFf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2017 13:05:35 -0500
MIME-Version: 1.0
In-Reply-To: <20171115180138.GF16026@wotan.suse.de>
References: <20171113103139.GA18936@yu-chen.sh.intel.com> <6271997.pCNICGrn9T@aspire.rjw.lan>
 <20171114230730.GD4094@dastard> <1642052.KjDFtI7czP@aspire.rjw.lan> <20171115180138.GF16026@wotan.suse.de>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Wed, 15 Nov 2017 19:05:33 +0100
Message-ID: <CAJZ5v0jKa0n+7Bg+znRuhSuaot0WG3ByAttkFdRoBgMveUff7Q@mail.gmail.com>
Subject: Re: [Regression/XFS/PM] Freeze tasks failed in xfsaild
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Dave Chinner <david@fromorbit.com>, Jiri Kosina <jkosina@suse.cz>, Dan Williams <dan.j.williams@intel.com>, Yu Chen <yu.c.chen@intel.com>, Michal Hocko <mhocko@suse.com>, Hendrik Woltersdorf <hendrikw@arcor.de>, Dave Chinner <dchinner@redhat.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Len Brown <len.brown@intel.com>, Rui Zhang <rui.zhang@intel.com>, Yu Chen <yu.chen.surf@gmail.com>, linux-xfs@vger.kernel.org, Linux-pm mailing list <linux-pm@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Thorsten Leemhuis <linux@leemhuis.info>, Oleg Antonyan <oleg.b.antonyan@gmail.com>, Oliver Neukum <oneukum@suse.com>

On Wed, Nov 15, 2017 at 7:01 PM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> On Wed, Nov 15, 2017 at 12:40:43AM +0100, Rafael J. Wysocki wrote:
>> On Wednesday, November 15, 2017 12:07:30 AM CET Dave Chinner wrote:
>> Can we stop here and be constructive going forward, please?
>
> Then let's stop this nonsense and get to work.
>
>> > > So what do you think should be done, specifically?
>> >
>> > Luis posted an initial version of those "use fs freeze" changes
>> > recently, so Work with Luis to get those changes into the kernel.
>>
>> This isn't the first version as per the above and sorry, but without
>> help from fs people this is going to end the same way as before and
>> I sort of doubt that "working with Luis" alone is going to be sufficient.
>>
>> We need the fs people to actually help us, pretty much like back in 2011.
>
> Rafael, AFAICT the only outstanding issue with the patches I posted were
> the last two patches. I haven't had time to re-test my patches without the
> last patch, but if Chinner was right, and I suspect he was, then the last patch
> is what implicated the need for the ext patch, which we don't want. So dropping
> the last two patches I think would be a good starting point.
>
> I hope to have time to re-test this week, if you feel compelled to help,
> you can also help test the patches except for the last two. Then if you
> want to help further, helping iron out the kinks on the last patch would
> be much appreciated.

OK, please resend the series when you're ready.

Thanks,
Rafael
