Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40946 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753166AbdJUBGV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2017 21:06:21 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9L16KVe031318
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 21 Oct 2017 01:06:21 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9L16Kbk024628
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 21 Oct 2017 01:06:20 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v9L16KBW006341
        for <linux-xfs@vger.kernel.org>; Sat, 21 Oct 2017 01:06:20 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 00/17] Parent Pointers V3
References: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
 <CAOQ4uxhzZT=5O6PM4Gp=uSwYPFdrO5X9D8UF54f3jEmM2LxK1Q@mail.gmail.com>
 <CAOQ4uxjCTs0vFcQ3OLrMmReAGBCcqQDN8byPom__oPEuW3c6Lg@mail.gmail.com>
Message-ID: <d364c211-04da-960a-9a61-41aef0c7ed09@oracle.com>
Date: Fri, 20 Oct 2017 18:06:12 -0700
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxjCTs0vFcQ3OLrMmReAGBCcqQDN8byPom__oPEuW3c6Lg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 10/19/2017 08:22 PM, Amir Goldstein wrote:

> On Thu, Oct 19, 2017 at 7:11 AM, Amir Goldstein<amir73il@gmail.com>  wrote:
>> On Thu, Oct 19, 2017 at 1:55 AM, Allison Henderson
>> <allison.henderson@oracle.com>  wrote:
>>> Hi all,
>>>
>>> This is the third version of parent pointer attributes for xfs.
>>> I've integrated the suggestions made since v2, mostly moving the
>>> attr buffers in the xfs_attr_log_item to pointers that point to
>>> xfs_attr_item. I've also implementing the recovery routines for
>>> the xfs_attr_log_format.  If I missed anything please point it
>>> out.  As always, comments and feedback are appreciated.  Thank
>>> you!
>>>
>> A minor comment about the cover letter.
>> All designated reviewers must know exactly what "parent pointers" are for,
>> but it could be useful to add some context in the cover letter about the purpose
>> of this work for the sake of other readers on the list. Useful to refer to the
>> upcoming scrub support patches.
>>
>> BTW, not sure if this was mentioned in the previous lifetime of those
>> patches, but parent pointers can be used to implement exportfs operation
>> xfs_fs_fh_to_parent() for "non-connectable" file handles (FILEID_INO32_GEN)
>> and to implement xfs_fs_get_name(), which would make reconnect_path()
>> *much* more efficient.
>>
>> Also, you may want to use git format-patch -v3 for V3
>> makes it easier to browse old versions of patches on the list.
>>
>> Cheers,
>> Amir.
>>
>>> Allison Henderson (7):
>>>    Add helper functions xfs_attr_set_args and xfs_attr_remove_args
>>>    Set up infastructure for deferred attribute operations
>>>    Add xfs_attr_set_defered and xfs_attr_remove_defered
>>>    Remove all strlen calls in all xfs_attr_* functions for attr names.
>>>    Add the extra space requirements for parent pointer attributes when
>>>      calculating the minimum log size during mkfs
>>>    Add parent pointers to rename
>>>    Add the parent pointer support to the superblock version 5.
>>>
>>> Brian Foster (1):
>>>    xfs_bmap_add_attrfork(): re-add error handling from set_attrforkoff()
>>>      call
>>>
>>> Dave Chinner (5):
>>>    xfs: define parent pointer xattr format
>>>    :xfs: extent transaction reservations for parent attributes
> You must've already noticed - just pointing out the :xfs: typo in that commit
> subject (easier to comment on that here then on patch itself)
>
> Amir.
Yep, I noticed it after I sent it.  I will fix that and expand on the 
cover letter a bit.  I think there's a few things that can leverage 
parent pointers once they are in place.  I will add the -v3 flag too.  Thx!

