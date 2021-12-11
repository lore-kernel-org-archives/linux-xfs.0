Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A37B9C433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Dec 2021 05:52:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhLKFw4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Dec 2021 00:52:56 -0500
Received: from sandeen.net ([63.231.237.45]:52416 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229502AbhLKFw4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 11 Dec 2021 00:52:56 -0500
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 72F4815B3D;
        Fri, 10 Dec 2021 23:52:42 -0600 (CST)
Message-ID: <7f51c3db-6f3e-be89-09cf-4e704b840440@sandeen.net>
Date:   Fri, 10 Dec 2021 23:52:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <1639167697-15392-1-git-send-email-sandeen@sandeen.net>
 <1639167697-15392-4-git-send-email-sandeen@sandeen.net>
 <20211211002156.GC1218082@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 3/4] xfs_quota: don't exit on fs_table_insert_project_path
 failure
In-Reply-To: <20211211002156.GC1218082@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/10/21 6:21 PM, Darrick J. Wong wrote:
> On Fri, Dec 10, 2021 at 02:21:36PM -0600, Eric Sandeen wrote:
>> From: Eric Sandeen <sandeen@redhat.com>
>>
>> If "project -p" fails in fs_table_insert_project_path, it
>> calls exit() today which is quite unfriendly. Return an error
>> and return to the command prompt as expected.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>> ---
>>   libfrog/paths.c | 7 +++----
>>   libfrog/paths.h | 2 +-
>>   quota/project.c | 4 +++-
>>   3 files changed, 7 insertions(+), 6 deletions(-)
>>
>> diff --git a/libfrog/paths.c b/libfrog/paths.c
>> index d679376..6c0fee2 100644
>> --- a/libfrog/paths.c
>> +++ b/libfrog/paths.c
>> @@ -546,7 +546,7 @@ out_error:
>>   		progname, strerror(error));
>>   }
>>   
>> -void
>> +int
>>   fs_table_insert_project_path(
>>   	char		*dir,
>>   	prid_t		prid)
>> @@ -561,9 +561,8 @@ fs_table_insert_project_path(
>>   	else
>>   		error = ENOENT;
>>   
>> -	if (error) {
>> +	if (error)
>>   		fprintf(stderr, _("%s: cannot setup path for project dir %s: %s\n"),
>>   				progname, dir, strerror(error));
> 
> Why not move this to the (sole) caller?  Libraries (even pseudolibraries
> like libfrog) usually aren't supposed to go around fprintfing things.

I mean, that's a legit goal, but

$ grep -rw "printf\|fprintf"  libfrog/ | wc -l
55

but ok, I can reduce it to 54 ;)

-Eric
  
