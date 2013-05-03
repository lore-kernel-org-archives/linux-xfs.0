Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 846CD7F5F
	for <xfs@oss.sgi.com>; Fri,  3 May 2013 09:41:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 70E868F8035
	for <xfs@oss.sgi.com>; Fri,  3 May 2013 07:41:49 -0700 (PDT)
Received: from mail.in8.de (brockman.in8.de [85.214.220.56]) by cuda.sgi.com
	with ESMTP id VznfIw83yUnu2Lml for <xfs@oss.sgi.com>;
	Fri, 03 May 2013 07:41:48 -0700 (PDT)
Received: from [172.24.1.213] (unknown [192.166.201.94])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.in8.de (Postfix) with ESMTPSA id 8A18F6AC203
	for <xfs@oss.sgi.com>; Fri,  3 May 2013 16:41:47 +0200 (CEST)
Message-ID: <5183CCAA.30302@jan-o-sch.net>
Date: Fri, 03 May 2013 16:41:46 +0200
From: Jan Schmidt <list.xfs@jan-o-sch.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: btrfs/276 - stop all fsstress before exiting
References: <517A10B1.7040107@redhat.com> <517A3C49.9090703@jan-o-sch.net>
	<7DC41D7F-396D-4769-B573-816E80372456@redhat.com>
	<5183B652.8020300@sgi.com>
In-Reply-To: <5183B652.8020300@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Fri, May 03, 2013 at 15:06 (+0200), Rich Johnston wrote:
> On 04/26/2013 08:10 AM, Eric Sandeen wrote:
>> On Apr 26, 2013, at 3:35 AM, Jan Schmidt <list.btrfs@jan-o-sch.net> wrote:
>>
>>> On Fri, April 26, 2013 at 07:29 (+0200), Eric Sandeen wrote:
>>>> Tests after 276 were failing because the background fsstress
>>>> hadn't quit prior to exit, devices couldn't be unmounted, etc.
>>>
>>> I don't see how that would happen. Any further insight?
>>>
>> Yes, sorry for not including it.  The parent process was killed, but the
>> fsstress processes just got reparented to init.
>>
>> I tried for a while to use pkill to knock them of first but this seems
>> simpler, actually.
>>
>> Eric
>>
> 
> Jan, with Eric's explanation, may I put your Reviewed-by: on this patch?

Yes, you may :-)

-Jan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
