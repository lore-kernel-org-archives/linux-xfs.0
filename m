Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:34910 "EHLO
        mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759365AbdCVMeY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Mar 2017 08:34:24 -0400
Received: by mail-vk0-f44.google.com with SMTP id r69so13125744vke.2
        for <linux-xfs@vger.kernel.org>; Wed, 22 Mar 2017 05:34:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170321155512.GZ14226@eguan.usersys.redhat.com>
References: <20170315163347.29743-1-jtulak@redhat.com> <20170316074941.GS14226@eguan.usersys.redhat.com>
 <20170321152253.GB59313@bfoster.bfoster> <20170321155512.GZ14226@eguan.usersys.redhat.com>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 22 Mar 2017 13:33:55 +0100
Message-ID: <CACj3i73zH0f_saV21nD5=g6jYWStf0QfaV79tt5_UOheRY9zMA@mail.gmail.com>
Subject: Re: [PATCH] xfstests: xfs/191 update
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Tue, Mar 21, 2017 at 4:55 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Tue, Mar 21, 2017 at 11:22:54AM -0400, Brian Foster wrote:
>> On Thu, Mar 16, 2017 at 03:49:41PM +0800, Eryu Guan wrote:
>> > On Wed, Mar 15, 2017 at 05:33:47PM +0100, Jan Tulak wrote:
>> > > The removed 'do_mkfs_pass -l size=4096b' was against man page
>> > > (-b section). Other entries are things that weren't covered before.
>> > >
>> > > Specifically, a standalone "-l size=4096b" should fail, because:
>> > > To  specify any options on the command line in units of filesys‐
>> > > tem blocks, this option must be  specified  first  so  that  the
>> > > filesystem block size is applied consistently to all options.
>> > >
>> > > Signed-off-by: Jan Tulak <jtulak@redhat.com>
>> >
>> > This looks fine to me. But I'd like some reviews from xfs developers
>> > too. (cc'd linux-xfs@vger.kernel.org).
>> >
>>
>> So has mkfs been fixed to cause '-l size=4096b' to fail? I'm not sure we
>> should cause the test to fail until/unless the mkfs behavior is fixed
>> up.
>
> I agreed, we don't want to update existing test and introduce false
> regressions. This is one of the reasons I want more reviews on this
> patch :)
>

I forgot to mention that this patch is a complement to my patchset for
mkfs.xfs. So yes, do not merge it now, it looks like the set won't get
merged yet. Sorry for not stating it in the description.

Jan


-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
