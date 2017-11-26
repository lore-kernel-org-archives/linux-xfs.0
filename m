Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:42792 "EHLO
        mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752064AbdKZI4l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Nov 2017 03:56:41 -0500
MIME-Version: 1.0
In-Reply-To: <20171124103814.gfvxw3ethkcvm6xa@ws.net.home>
References: <20171123111031.6550-4-eguan@redhat.com> <20171124050144.23549-1-eguan@redhat.com>
 <CAOQ4uxgxRxByGHhePr3b4H+W1zEGxUX6Emj9PBzZpEKEs2iHog@mail.gmail.com> <20171124103814.gfvxw3ethkcvm6xa@ws.net.home>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 26 Nov 2017 10:56:40 +0200
Message-ID: <CAOQ4uxjbnrgJG3PLVV6TvAS-Fjgskms_jWc5-b4DVmLhbVUdFg@mail.gmail.com>
Subject: Re: [PATCH v4] fstests: filter readonly mount error messages
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Karel Zak <kzak@redhat.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Nov 24, 2017 at 12:38 PM, Karel Zak <kzak@redhat.com> wrote:
> On Fri, Nov 24, 2017 at 10:04:33AM +0200, Amir Goldstein wrote:
>> [cc: Karel Zak]
>>
>> On Fri, Nov 24, 2017 at 7:01 AM, Eryu Guan <eguan@redhat.com> wrote:
>> > util-linux commit 6dede2f2f7c5 ("libmount: support MS_RDONLY on
>> > write-protected devices") changed the error message on read-only
>> > block device, and in the failure case printed one line message
>> > instead of two (for details please see comments in common/filter),
>> > and this change broke generic/050 and overlay/035.
>> >
>> > Fix it by adding more filter rules to _filter_ro_mount and updating
>> > associated .out files to unify the output from both old and new
>> > util-linux versions.
>> >
>> > Signed-off-by: Eryu Guan <eguan@redhat.com>
>> > ---
>> > v4 (also passed with both old & new util-linux):
>> > - add more comments to explain the output differences between util-linux
>> >   versions
>> > - print out message directly instead of using perl variables
>> > - add word "device" to failed ro mount message
>>
>>
>> Eryu,
>>
>> This looks good and you can take it as an ACK on the series.
>>
>> I've CC'ed Karel, so maybe he thinks about us fstests guys before making
>> these sort of changes again...
>
> Frankly, we have never promised that things like warning messages (or
> another messages) are stable interface. It's fragile to depend on this
> stuff...
>

I know. No complains. Just wanted to inform you of the downstream
ripples.

>> Thinking out loud, does xfstest even need to use mount program from
>> util-linux? Do we ever need anything other than the bare libc mount(2)?
>> We need it for -o loop, but that is the exception to the rule.
>
> Well, I don't think that create a parallel universe is the best
> solution.
>

I agree. However, xfstest uses 'mount' is a very particular way:
- User has to provide both block device and mount point
- xfstests already checks that those block device and mount point
  are not in use in /proc/mounts *before* calling 'mount'

So I prefer the 'machine output format' solution going forward, but
since xfstests will need to continue supporting old util-linux installations
it might be less clumsy to use a simple C wrapper to mount(2), then
to carry these error format filters.
xfstests can also check for availability of the new machine format in
'mount' and if it doesn't exist fall back to using its private mount helper.

>> For fs that have mount helpers (cifs,nfs), we could use mount.$FSTYP
>> directly (what error formats are reported from the helpers??). For all other
>> fs we can write a simple t_mount program to wrap libc mount(2) and not be
>> dependent on util-linux error message formats.
>> Maybe we can consider it next time util-linux changes..
>>
>> Another idea to through in the air in the direction of Karel -
>> Maybe it makes sense for util-linux to check some env variable
>> and then print all error messages in a unified machine format, e.g.:
>> fprintf("%s: errno=%d\n", progname, errno);
>
> This is good idea, I can try to implement it into libmount.
>

That would be great.

Thanks,
Amir.
