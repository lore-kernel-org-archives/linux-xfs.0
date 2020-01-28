Return-Path: <SRS0=UJS8=3R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF4EC2D0DB
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 14:48:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABF5B207FD
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 14:48:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbgA1Oso (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jan 2020 09:48:44 -0500
Received: from sandeen.net ([63.231.237.45]:35314 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726715AbgA1Osn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Jan 2020 09:48:43 -0500
Received: from Lucys-MacBook-Air.local (erlite [10.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 3460F2542;
        Tue, 28 Jan 2020 08:48:42 -0600 (CST)
Subject: Re: [PATCH] xfsprogs: do not redeclare globals provided by libraries
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <0892b951-ac99-9f84-9c65-421798daa547@sandeen.net>
 <20200128032907.GM3447196@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <332e4c3a-ddac-4e48-b236-e4c2248163a5@sandeen.net>
Date:   Tue, 28 Jan 2020 08:48:40 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200128032907.GM3447196@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/27/20 9:29 PM, Darrick J. Wong wrote:
> On Mon, Jan 27, 2020 at 04:56:02PM -0600, Eric Sandeen wrote:
>> From: Eric Sandeen <sandeen@redhat.com>
>>
>> In each of these cases, db, logprint, and mdrestore are redeclaring
>> as a global variable something which was already provided by a
>> library they link with.
> 
> Er... which library?

libxfs and libxlog ...


   File                Line
0 libxlog/util.c      10 int print_exit;
1 logprint/logprint.c 27 int print_exit = 1;

   File           Line
0 db/init.c      30 libxfs_init_t x;
1 libxlog/util.c 13 libxfs_init_t x;

   File                      Line
0 fsr/xfs_fsr.c              31 char *progname;
1 io/init.c                  14 char *progname;
2 libxfs/init.c              28 char *progname = "libxfs";
3 mdrestore/xfs_mdrestore.c  10 char *progname;

(fsr & io don't link w/ libxfs; mdrestore does)


> 
> Also, uh...maybe we shouldn't be exporting globals across libraries?
> 
> (He says having not looked for how many there are lurki... ye gods)

Well, it's ugly for sure.

We could either try to re-architect this to

1) pass stuff like progname all over the place, or
2) consistently make the library provide it as a global, or
3) consistently make utils provide it to the library as a global (?)

choose your poison?

> 
> --D
> 
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/db/init.c b/db/init.c
>> index 455220a..0ac3736 100644
>> --- a/db/init.c
>> +++ b/db/init.c
>> @@ -27,7 +27,6 @@ static int		force;
>>   static struct xfs_mount	xmount;
>>   struct xfs_mount	*mp;
>>   static struct xlog	xlog;
>> -libxfs_init_t		x;
>>   xfs_agnumber_t		cur_agno = NULLAGNUMBER;
>>
>>   static void
>> diff --git a/logprint/logprint.c b/logprint/logprint.c
>> index 7754a2a..511a32a 100644
>> --- a/logprint/logprint.c
>> +++ b/logprint/logprint.c
>> @@ -24,7 +24,6 @@ int	print_buffer;
>>   int	print_overwrite;
>>   int     print_no_data;
>>   int     print_no_print;
>> -int     print_exit = 1; /* -e is now default. specify -c to override */
>>   static int	print_operation = OP_PRINT;
>>
>>   static void
>> @@ -132,6 +131,7 @@ main(int argc, char **argv)
>>   	bindtextdomain(PACKAGE, LOCALEDIR);
>>   	textdomain(PACKAGE);
>>   	memset(&mount, 0, sizeof(mount));
>> +	print_exit = 1; /* -e is now default. specify -c to override */
>>
>>   	progname = basename(argv[0]);
>>   	while ((c = getopt(argc, argv, "bC:cdefl:iqnors:tDVv")) != EOF) {
>> @@ -152,7 +152,7 @@ main(int argc, char **argv)
>>   			case 'e':
>>   			    /* -e is now default
>>   			     */
>> -				print_exit++;
>> +				print_exit = 1;
>>   				break;
>>   			case 'C':
>>   				print_operation = OP_COPY;
>> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
>> index 3375e08..1cd399d 100644
>> --- a/mdrestore/xfs_mdrestore.c
>> +++ b/mdrestore/xfs_mdrestore.c
>> @@ -7,7 +7,6 @@
>>   #include "libxfs.h"
>>   #include "xfs_metadump.h"
>>
>> -char 		*progname;
>>   static int	show_progress = 0;
>>   static int	show_info = 0;
>>   static int	progress_since_warning = 0;
>>
> 

