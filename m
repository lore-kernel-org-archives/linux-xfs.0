Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:32989 "EHLO
        mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753148AbdDLLZA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2017 07:25:00 -0400
Received: by mail-vk0-f52.google.com with SMTP id j127so5491459vkh.0
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2017 04:25:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170412110318.GA6834@bfoster.bfoster>
References: <20170411141237.9274-1-jtulak@redhat.com> <20170411141237.9274-2-jtulak@redhat.com>
 <20170411183036.GA3865@bfoster.bfoster> <272b1e64-96fe-ab9a-12f3-1fc73a0c85ea@sandeen.net>
 <20170411184350.GC3865@bfoster.bfoster> <bbbb0472-7b6d-b3df-3ca7-8d8a574ff377@sandeen.net>
 <20170411234444.GH8502@birch.djwong.org> <20170412110318.GA6834@bfoster.bfoster>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 12 Apr 2017 13:24:38 +0200
Message-ID: <CACj3i73NnVW70=6h_kZ+cp-NEsT_1Z-pANkx42yqgF5wyd3mGA@mail.gmail.com>
Subject: Re: [PATCH 1/2] metadump: warn about corruption if log is dirty
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On Wed, Apr 12, 2017 at 1:03 PM, Brian Foster <bfoster@redhat.com> wrote:
> On Tue, Apr 11, 2017 at 04:44:44PM -0700, Darrick J. Wong wrote:
>> On Tue, Apr 11, 2017 at 02:01:41PM -0500, Eric Sandeen wrote:
>> > On 4/11/17 1:43 PM, Brian Foster wrote:
>> > > On Tue, Apr 11, 2017 at 01:34:25PM -0500, Eric Sandeen wrote:
>> > >> On 4/11/17 1:30 PM, Brian Foster wrote:
>> > >>> On Tue, Apr 11, 2017 at 04:12:36PM +0200, Jan Tulak wrote:
>> > >>>> Add a warning about possible corruption when exporting a dirty log, as
>> > >>>> the log content does not agree with obfuscated metadata.
>> > >>>>
>> > >>>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
>> > >>>> ---
>> > >>>
>> > >>> Thanks for posting this...
>> > >>>
>> > >>>>  db/metadump.c | 3 ++-
>> > >>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>> > >>>>
>> > >>>> diff --git a/db/metadump.c b/db/metadump.c
>> > >>>> index 66952f6..74e24b2 100644
>> > >>>> --- a/db/metadump.c
>> > >>>> +++ b/db/metadump.c
>> > >>>> @@ -2726,7 +2726,8 @@ copy_log(void)
>> > >>>>                /* keep the dirty log */
>> > >>>>                if (obfuscate)
>> > >>>>                        print_warning(
>> > >>>> -_("Filesystem log is dirty; image will contain unobfuscated metadata in log."));
>> > >>>> +_("Filesystem log is dirty; image will contain unobfuscated metadata in log "
>> > >>>> +  "and a log replay can cause a corruption."));
>> > >>>
>> > >>> I think a slightly more verbose message might be a good idea. For
>> > >>> example, something like the following:
>> > >>>
>> > >>> "Filesystem log is dirty; image will contain unobfuscated metadata in
>> > >>> the log. Log recovery of an obfuscated image can cause filesystem
>> > >>> corruption. Please mount the source image to clean the log or disable
>> > >>> metadump obfuscation."
>> > >>>
>> > >>> That could also say "... or verify that log recovery of the resulting
>> > >>> image does not cause corruption," but that might be overkill. Thoughts?
>> > >>> Eric?
>> > >>
>> > >> I think we do need a good explanation, but that will take a lot of workd.
>> > >> We could also refer to the man page for more details - it's getting pretty
>> > >> long for a warning from the tool.
>> > >>
>> > >
>> > > Hm, yeah. Maybe the existing warning can be condensed a bit more to
>> > > something like:
>> > >
>> > > "Warning: log recovery of an obfuscated metadata image can leak
>> > > unobfuscated metadata and/or cause filesystem corruption. Please mount
>> > > the source image to clean the log or disable obfuscation."
>> >
>> > s/filesystem corruption/image corruption/ - we don't want anyone to think
>> > that it damaged the original fs!
>>
>> OTOH the fs might be damaged just badly enough that log recovery is
>> impossible (which is why we're creating the metadump to send to support)
>> so aborting metadump is the wrong thing to do.
>>
>
> Indeed..
>
>> It seems sort of silly even to lecture the user about log recovery when
>> they might not be able to recover said log and might not ever even start
>> the log recovery process.
>>
>
> There's a bit of a balance here between handling dirty log + obfuscation
> cases where a log recovery issue is the purpose of the metadump, it is
> not the purpose and the original fs can run log recovery without
> disrupting problem diagnosis, or something in between and the resulting
> image is explicitly verified to not lead to such metadump-specific
> corruption.
>
> I think adjusting the preexisting warning wrt to the fact that log data
> is not obfuscated to point out this issue is a relatively minor change
> given the potential result.. (put another way, it seems kind of silly
> that we'd warn about leaking unobfuscated data but not this..).
>
> Brian
>

I think that this is something we really should notify about. It
serves as a notification for a rare issue, "hey, are you aware of
this," rather than a list of instructions or a manual. So, I would
keep the message short. This (slightly modified) variant sounds good
to me:

"Warning: log recovery of an obfuscated metadata image can leak
unobfuscated metadata and/or cause image corruption. Please mount
the source image to clean the log or disable obfuscation, if possible."

Jan

-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
