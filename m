Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E76C77B73
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 17:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbjFERS4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 13:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234541AbjFERSz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 13:18:55 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D3ACFA6
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 10:18:53 -0700 (PDT)
Received: from [10.0.0.71] (liberator.sandeen.net [10.0.0.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPS id 44AAB48C71A;
        Mon,  5 Jun 2023 12:18:53 -0500 (CDT)
Message-ID: <a902dd49-8617-157f-134f-41c3514a0d30@sandeen.net>
Date:   Mon, 5 Jun 2023 12:18:53 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [PATCH 3/5] xfs_db: fix metadump name obfuscation for ascii-ci
 filesystems
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
        hch@infradead.org
References: <168597938725.1226098.18077307069307502725.stgit@frogsfrogsfrogs>
 <168597940416.1226098.14610650380180437820.stgit@frogsfrogsfrogs>
 <99cf8b71-3c8a-7114-c7d1-7078242b9dff@sandeen.net>
 <20230605170948.GL72241@frogsfrogsfrogs>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20230605170948.GL72241@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/5/23 12:09 PM, Darrick J. Wong wrote:
> On Mon, Jun 05, 2023 at 11:59:45AM -0500, Eric Sandeen wrote:
>> On 6/5/23 10:36 AM, Darrick J. Wong wrote:
>>> @@ -1205,9 +1264,9 @@ generate_obfuscated_name(
>>>    	/* Obfuscate the name (if possible) */
>>> -	hash = libxfs_da_hashname(name, namelen);
>>> -	obfuscate_name(hash, namelen, name);
>>> -	ASSERT(hash == libxfs_da_hashname(name, namelen));
>>> +	hash = dirattr_hashname(ino != 0, name, namelen);
>>> +	obfuscate_name(hash, namelen, name, ino != 0);
>>> +	ASSERT(hash == dirattr_hashname(ino != 0, name, namelen));
>>
>> This makes sense to me - comments above here remind us that "inode == 0"
>> means we're obfuscating an xattr value, not a filename or path name, but ...
>>
>>>    	/*
>>>    	 * Make sure the name is not something already seen.  If we
>>> @@ -1320,7 +1379,7 @@ obfuscate_path_components(
>>>    			/* last (or single) component */
>>>    			namelen = strnlen((char *)comp, len);
>>>    			hash = libxfs_da_hashname(comp, namelen);
>>> -			obfuscate_name(hash, namelen, comp);
>>> +			obfuscate_name(hash, namelen, comp, false);
>>>    			ASSERT(hash == libxfs_da_hashname(comp, namelen));
>>>    			break;
>>>    		}
>>> @@ -1332,7 +1391,7 @@ obfuscate_path_components(
>>>    			continue;
>>>    		}
>>>    		hash = libxfs_da_hashname(comp, namelen);
>>> -		obfuscate_name(hash, namelen, comp);
>>> +		obfuscate_name(hash, namelen, comp, false);
>>>    		ASSERT(hash == libxfs_da_hashname(comp, namelen));
>>>    		comp += namelen + 1;
>>>    		len -= namelen + 1;
>>>
>>
>> here, why is "is_dirent" false? Shouldn't a symlink path component match the
>> associated dirents, and be obsucated the same way?
> 
> Name obfuscation replaces every byte except for the last five bytes with
> a random printable character, and then flips bits in those last five
> bytes to make the hash match.  Chances are good that calling
> obfuscate_name() twice on the same name will return different results,
> which means that symlink targets won't point anywhere useful after the
> obfuscation.
> 
> One could make metadump remember the (input -> output) pairs instead of
> regenerating the names every time, but this comes at a cost of higher
> memory consumption.  I actually did this for parent pointers so that
> obfuscated dumped pptrs are still verifiable by xfs_repair.
> 
> However, symlink targets aren't required to point to a valid path, so
> there doesn't seem to be much reason to add that overhead.

Fair enough, thanks. If you wanted to throw in a comment it might be 
nice, but I'll leave that up to you, esp. if we're killing off ascii-ci 
in the long run anyway.

Thanks,
-Eric

