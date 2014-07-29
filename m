Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 239C97F37
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2014 15:54:05 -0500 (CDT)
Message-ID: <53D809EB.80207@sgi.com>
Date: Tue, 29 Jul 2014 15:54:03 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: Is jdm_delete_filehandle part of a public API?
References: <53D7DA7F.2040706@redhat.com> <53D7E56C.8020103@sgi.com>
	<53D7FE32.3080807@sgi.com> <53D801B1.5000300@sandeen.net>
In-Reply-To: <53D801B1.5000300@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 07/29/14 15:18, Eric Sandeen wrote:
> On 7/29/14, 3:04 PM, Mark Tinguely wrote:
>> On 07/29/14 13:18, Mark Tinguely wrote:
>>> On 07/29/14 12:31, Eric Sandeen wrote:
>>>> I was cleaning up xfsprogs to plug some leaks, and wanted to use
>>>> jdm_delete_filehandle(). I noticed that it has an "hlen" argument which
>>>> is unused.
>>>>
>>>> Can we remove that, or is this part of a public API? It's not in any
>>>> manpage (or even called anywhere in xfsprogs/xfstests/xfsdump/dmapi)
>>>> but it is in a public header...
>>>>
>>>> anyone know?
>>>>
>>>> If needed I guess I can just call it with hlen==0, but that seems odd.
>>>>
>>>> Thanks,
>>>> -Eric
>>>
>>> The first thing that comes to mind is maybe they trying to distinguish
>>> between a fshandle or handle. Or they we trying to be consistent with
>>> the allocation calls.
>>>
>>> The libhandle free_handle has the same calling parameters. It also does
>>> nothing with the length. That we cannot change without breaking existing
>>> code.
>>>
>>> I will look/ask around.
>>>
>>> --Mark.
>>
>> Looks like the code is pretty sloppy with freeing the handles.
>
> yeah, that's what I was going to fix :)
>
>> Best guess is jdm_delete_filehandle() and free_handle are trying to
>> keep the API similar to DMAPI. The DMAPI handle free routine,
>> dm_handle_free(), also has a second length parameter that is not used
>> in the library.
>>
>> The code example that I saw are similar to the use in xfsdump, where
>> the length used in the free comes from the handle creation/conversion
>> routine.
>
> yup but I don't think jdm_getfshandle has anything similar does it?

nope. Do you know why there is a jdm and a libhandle libs?

>
>> Since the xfsprogs do not open handles with calls that provide a
>> length. How about FSHANDLE_SZ and FILEHANDLE_SZ depending on if it is
>> a xfs_fshandle or xfs_handle?
>
> *shrug* it's not used anyway - I'm not sure why we'd need to invent a
> macro to pass in only to have it ignored.  Is there any advantage to that?

never mind... handles are opaque and we should not be defining a size.

I did the grep and saw that the sizes were defined and thought they were 
better than nothing. I did not not realize that the defines are are in 
jdm.c and not a header file. In that case, nothing is better than adding 
a define for an opaque item.

> -Eric

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
