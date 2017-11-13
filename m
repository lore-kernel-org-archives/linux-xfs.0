Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f181.google.com ([74.125.82.181]:47896 "EHLO
        mail-ot0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755361AbdKMUhB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Nov 2017 15:37:01 -0500
Received: by mail-ot0-f181.google.com with SMTP id s4so5569597ote.4
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2017 12:37:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171113201414.GD16026@wotan.suse.de>
References: <20171113103139.GA18936@yu-chen.sh.intel.com> <20171113201414.GD16026@wotan.suse.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 13 Nov 2017 12:37:00 -0800
Message-ID: <CAPcyv4hbHpoMe20Sjpq4Qov6TKx9A+t6Y9GJ68PT2tsY3Jh7kA@mail.gmail.com>
Subject: Re: [Regression/XFS/PM] Freeze tasks failed in xfsaild
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Yu Chen <yu.c.chen@intel.com>, Michal Hocko <mhocko@suse.com>, Hendrik Woltersdorf <hendrikw@arcor.de>, Dave Chinner <dchinner@redhat.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jiri Kosina <jkosina@suse.cz>, Len Brown <len.brown@intel.com>, Rui Zhang <rui.zhang@intel.com>, Yu Chen <yu.chen.surf@gmail.com>, linux-xfs@vger.kernel.org, Linux-pm mailing list <linux-pm@vger.kernel.org>, inux-kernel@vger.kernel.org, Thorsten Leemhuis <linux@leemhuis.info>

On Mon, Nov 13, 2017 at 12:14 PM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> On Mon, Nov 13, 2017 at 06:31:39PM +0800, Yu Chen wrote:
>> The xfs-buf/dm-1 should be freezed according to
>> commit 8018ec083c72 ("xfs: mark all internal workqueues
>> as freezable"), thus a easier way might be have to revert
>> commit 18f1df4e00ce ("xfs: Make xfsaild freezeable
>> again") for now, after this reverting the xfsaild/dm-1
>> becomes non-freezable again, thus pm does not see this
>> thread - unless we find a graceful way to treat xfsaild/dm-1
>> as 'frozen' if it is waiting for an already 'frozen' task,
>> or if the filesystem freeze is added in.
>>
>> Any comments would be much appreciated.
>
> Reverting 18f1df4e00ce ("xfs: Make xfsaild freezeable again")
> would break the proper form of the kthread for it to be freezable.
> This "form" is not defined formally, and sadly its just a form
> learned throughout years over different kthreads in the kernel.

If the behavior breaks then the "form" is broken.

> I'm also not convinced all our hibernation / suspend woes would be fixed by
> reverting this commit, its why I worked instead on formalizing a proper freeze
> / thaw, which a lot of filesystems already implement prior to system
> hibernation / suspend / resume [0].
>
> I'll be respinning this series without the last patch, provided I'm able to
> ensure I don't need the ext[234] hack I did in that thread. Can you test the
> first 3 patches *only* on that series and seeing if that helps on your XFS
> front as well?

Those do not seem suitable for a  -stable backport. We can always
follow on with these patches once -stable and mainline are back to
their baseline behavior.
