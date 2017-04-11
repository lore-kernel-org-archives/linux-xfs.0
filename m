Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52188 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753176AbdDKS7e (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Apr 2017 14:59:34 -0400
Subject: Re: [PATCH 2/2] mdrestore: warn about corruption if log is dirty
References: <20170411141237.9274-1-jtulak@redhat.com>
 <20170411141237.9274-3-jtulak@redhat.com>
 <20170411183356.GB3865@bfoster.bfoster>
 <601745b4-296f-3ce8-d676-2387890a86a1@sandeen.net>
 <20170411184903.GD3865@bfoster.bfoster>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d40ffca0-31ea-ff31-4a3f-0e9ca4f404ff@sandeen.net>
Date: Tue, 11 Apr 2017 13:59:33 -0500
MIME-Version: 1.0
In-Reply-To: <20170411184903.GD3865@bfoster.bfoster>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On 4/11/17 1:49 PM, Brian Foster wrote:
> On Tue, Apr 11, 2017 at 01:39:55PM -0500, Eric Sandeen wrote:
>> On 4/11/17 1:33 PM, Brian Foster wrote:

...

>>> BTW, this is going to warn on every xfs_mdrestore of an image with a
>>> dirty log, right? That is slightly unfortunate, if so. Do we have any
>>> method to track or determine whether an image is obfuscated (I'm
>>> guessing not easily...)?
>>
>> Nope!  There is an unused slot in the header, maybe we could add flags?
>>
>> Hm, or we could do a trick like setting the fs label to "OBFUSCATED"
>> instead of "label" like we currently do.  That might be reasonable...
>>
>>                 /* Replace any filesystem label with "L's" */
>>                 if (obfuscate) {
>>                         struct xfs_sb *sb = iocur_top->data;
>>                         memset(sb->sb_fname, 'L',
>>                                min(strlen(sb->sb_fname), sizeof(sb->sb_fname)));
>>                         iocur_top->need_crc = 1;
>>                 }
>>
>> (today we keep the same label length, but that's probably not
>> necessary?)
> 
> That's an interesting idea. It looks like we currently set the fname to
> L's when obfuscated. Could we just key off that in mdrestore?

Right, like the code above.  :)

I guess the problem is that if a filesystem had no label, then we replaced
it with "no" L's, i.e. it stays empty.

So we may want to:

1) Start replacing it with 12 L's going forward, no matter what, and
2) Look for L's in mdrestore as a clue, which may sometimes fail ...
3) Any non-NULL label != "LLL..." probably isn't obfuscated, and can skip warning

-Eric

> Brian
> 
>> -Eric
>>  
>>> Brian
>>>
>>>> +		case 0:
>>>> +			 /* Everything is ok. */
>>>> +			break;
>>>> +	}
>>>> +
>>>> +}
>>>> +
>>>> +
>>>>  static void
>>>>  usage(void)
>>>>  {
>>>> @@ -271,5 +353,7 @@ main(
>>>>  	if (src_f != stdin)
>>>>  		fclose(src_f);
>>>>  
>>>> +	test_dirty_log(is_target_file, argv[optind]);
>>>> +
>>>>  	return 0;
>>>>  }
>>>> -- 
>>>> 2.1.4
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
