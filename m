Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52388 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752385AbdDKTBn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Apr 2017 15:01:43 -0400
Subject: Re: [PATCH 1/2] metadump: warn about corruption if log is dirty
References: <20170411141237.9274-1-jtulak@redhat.com>
 <20170411141237.9274-2-jtulak@redhat.com>
 <20170411183036.GA3865@bfoster.bfoster>
 <272b1e64-96fe-ab9a-12f3-1fc73a0c85ea@sandeen.net>
 <20170411184350.GC3865@bfoster.bfoster>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <bbbb0472-7b6d-b3df-3ca7-8d8a574ff377@sandeen.net>
Date: Tue, 11 Apr 2017 14:01:41 -0500
MIME-Version: 1.0
In-Reply-To: <20170411184350.GC3865@bfoster.bfoster>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On 4/11/17 1:43 PM, Brian Foster wrote:
> On Tue, Apr 11, 2017 at 01:34:25PM -0500, Eric Sandeen wrote:
>> On 4/11/17 1:30 PM, Brian Foster wrote:
>>> On Tue, Apr 11, 2017 at 04:12:36PM +0200, Jan Tulak wrote:
>>>> Add a warning about possible corruption when exporting a dirty log, as
>>>> the log content does not agree with obfuscated metadata.
>>>>
>>>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
>>>> ---
>>>
>>> Thanks for posting this...
>>>
>>>>  db/metadump.c | 3 ++-
>>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/db/metadump.c b/db/metadump.c
>>>> index 66952f6..74e24b2 100644
>>>> --- a/db/metadump.c
>>>> +++ b/db/metadump.c
>>>> @@ -2726,7 +2726,8 @@ copy_log(void)
>>>>  		/* keep the dirty log */
>>>>  		if (obfuscate)
>>>>  			print_warning(
>>>> -_("Filesystem log is dirty; image will contain unobfuscated metadata in log."));
>>>> +_("Filesystem log is dirty; image will contain unobfuscated metadata in log "
>>>> +  "and a log replay can cause a corruption."));
>>>
>>> I think a slightly more verbose message might be a good idea. For
>>> example, something like the following:
>>>
>>> "Filesystem log is dirty; image will contain unobfuscated metadata in
>>> the log. Log recovery of an obfuscated image can cause filesystem
>>> corruption. Please mount the source image to clean the log or disable
>>> metadump obfuscation."
>>>
>>> That could also say "... or verify that log recovery of the resulting
>>> image does not cause corruption," but that might be overkill. Thoughts?
>>> Eric?
>>
>> I think we do need a good explanation, but that will take a lot of workd.
>> We could also refer to the man page for more details - it's getting pretty
>> long for a warning from the tool.
>>
> 
> Hm, yeah. Maybe the existing warning can be condensed a bit more to
> something like:
> 
> "Warning: log recovery of an obfuscated metadata image can leak
> unobfuscated metadata and/or cause filesystem corruption. Please mount
> the source image to clean the log or disable obfuscation."

s/filesystem corruption/image corruption/ - we don't want anyone to think
that it damaged the original fs!

> I suppose we could also just exit under such conditions unless the user
> passes a force flag or something. Maybe that's overkill too, though..

yeah, let's not overengineer - dumping a dirty, obfuscated log is quite
typical I think.

-Eric
