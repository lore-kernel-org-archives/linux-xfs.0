Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9710C7FA1
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 10:09:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 34CA3AC001
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 08:09:48 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id AgzxB7YmPK1uNj1C (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 03 Jul 2015 08:09:43 -0700 (PDT)
Date: Fri, 3 Jul 2015 17:09:40 +0200 (CEST)
From: Ales Novak <alnovak@suse.cz>
Subject: Re: [PATCH] xfs: fix in the setting of logbsize
In-Reply-To: <20150606223200.GZ24666@dastard>
Message-ID: <alpine.LSU.2.03.1507031703450.24061@suse.cz>
References: <1433510925-11438-1-git-send-email-alnovak@suse.cz>
	<20150605222257.GY24666@dastard> <55722AD9.2080105@sandeen.net>
	<20150606223200.GZ24666@dastard>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 2015-6-7 00:32, Dave Chinner wrote:

> On Fri, Jun 05, 2015 at 06:03:53PM -0500, Eric Sandeen wrote:
>> On 6/5/15 5:22 PM, Dave Chinner wrote:
>>
>>> On Fri, Jun 05, 2015 at 03:28:45PM +0200, Ales Novak wrote:
>>>> However, this rule is only mentioned in the documentation, while it
>>>> could be checked during the mount.
>>>
>>> Where in the documentation is that mentioned?
>>
>> Documentation/filesystems/xfs.txt:
>>
>>   logbsize=value
>>         Set the size of each in-memory log buffer.  The size may be
>>         specified in bytes, or in kilobytes with a "k" suffix.
>>         Valid sizes for version 1 and version 2 logs are 16384 (16k)
>>         and 32768 (32k).  Valid sizes for version 2 logs also
>>         include 65536 (64k), 131072 (128k) and 262144 (256k). The
>>         logbsize must be an integer multiple of the log
>>         stripe unit configured at mkfs time.
>
> Ah, ok. I'll need to look at the history of that, because I think I
> can see what it is intended to mean, but the "power-of-two" sizes
> that are enforced will also enforce the "integer multiple" part,
> too. I think it was more intended for people using wierd stripe
> units (e.g. 96k) to say the equivalent on 2x96k is a valid log
> buffer size. I suspect we need to revisit both the code and the
> documentation here....

So, how will we proceed here? I understand that my patch only somehow 
blindly implements the restriction mentioned in the documentation and that 
proper solution would mean completely reworking these restrictions; 
however I don't like the state where setting seemingly harmless 
option leads to kernel crash (and possibly fs corruption).

While I understand that only playful root would do that.

-- 
Ales Novak

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
