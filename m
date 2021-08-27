Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B5FFC432BE
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Aug 2021 16:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40C7660F92
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Aug 2021 16:23:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbhH0QYN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Aug 2021 12:24:13 -0400
Received: from sandeen.net ([63.231.237.45]:43204 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234869AbhH0QYN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Aug 2021 12:24:13 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id A06E879FC;
        Fri, 27 Aug 2021 11:23:00 -0500 (CDT)
Subject: Re: [PATCH] mkfs.xfs.8: clarify DAX-vs-reflink restrictions in the
 mkfs.xfs man page
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Eric Sandeen <esandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Bill O'Donnell <bodonnel@redhat.com>
References: <59ebcf23-9e32-e219-ef8b-9aa7ab2444c2@redhat.com>
 <20210827154905.GP12640@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8c478cd9-31cf-d659-0088-949519cf11bc@sandeen.net>
Date:   Fri, 27 Aug 2021 11:23:22 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210827154905.GP12640@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/27/21 10:49 AM, Darrick J. Wong wrote:
> On Fri, Aug 27, 2021 at 10:39:18AM -0500, Eric Sandeen wrote:
>> Now that we have the tristate dax mount options, it is possible
>> to enable DAX mode for non-reflinked files on a reflink-capable
>> filesystem.  Clarify this in the mkfs.xfs manpage.
>>
>> Reported-by: Bill O'Donnell <bodonnel@redhat.com>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
>> index a7f70285..84ac50e8 100644
>> --- a/man/man8/mkfs.xfs.8
>> +++ b/man/man8/mkfs.xfs.8
>> @@ -316,12 +316,20 @@ option set. When the option
>>   is used, the reference count btree feature is not supported and reflink is
>>   disabled.
>>   .IP
>> -Note: the filesystem DAX mount option (
>> +Note: the filesystem-wide DAX mount options (
>>   .B \-o dax
>> -) is incompatible with
>> -reflink-enabled XFS filesystems.  To use filesystem DAX with XFS, specify the
>> +and
>> +.B \-o dax=always
>> +) are incompatible with
>> +reflink-enabled XFS filesystems.  To use filesystem-wide DAX with XFS, specify the
>>   .B \-m reflink=0
>>   option to mkfs.xfs to disable the reflink feature.
>> +Alternatey, use the
> 
> "Alternately..."

"Alternatively,"

> 
>> +.B \-o dax=inode
>> +mount option to selectively enable DAX mode on non-reflinked files.
> 
> /me wonders if this is dangerously close to wading into the muck that is
> "Use dax=inode or even no dax option at all, then make sure nobody
> shares your file's data blocks to set the DAX fsxattr flag on the file,
> and /then/ you can have DAX."

Perhaps I should drop most of it, and just wave hands vaguely at xfs.5?

-Eric
