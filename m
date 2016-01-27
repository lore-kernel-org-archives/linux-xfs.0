Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1D9FE7CA2
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2016 11:17:52 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0B928304039
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2016 09:17:48 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 8XFJ6Q23OF37Tasj for <xfs@oss.sgi.com>;
	Wed, 27 Jan 2016 09:17:30 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id A270860961B3
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2016 11:17:29 -0600 (CST)
Subject: Re: [PATCH] Split default quota limits by quota type
References: <1453303127-27295-1-git-send-email-cmaiolino@redhat.com>
	<569FC41E.2040300@sandeen.net> <20160127153705.GA17571@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56A8FBA9.3060205@sandeen.net>
Date: Wed, 27 Jan 2016 11:17:29 -0600
MIME-Version: 1.0
In-Reply-To: <20160127153705.GA17571@redhat.com>
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

On 1/27/16 9:37 AM, Carlos Maiolino wrote:
>>>
>>> This patch aims to split the default quota value by quota type. Allowing each
>>> quota type having different default values.
>>>
>>> Default time limits are still set globally, but I don't mind to split them by
>>> quota type too.
>>
>> Hm, I guess it seems like it should be done; otherwise it's a weird
>> caveat, isn't it?  "Default limits are set by type, but timers are
>> inherited from whatever first default quota is found across all types"
>>
>> So yeah, seems like it should be done for timers as well, IMHO;
>> grace periods can be set for each default quota type, so they should
>> be honored.
>>
> 
> Ok, I was just working on implement it, but honestly, I don't see the point now
> in split time limits by user/group/project.
> 
> grace periods are set globally by default. We don't have specific quota grace
> limits for each user or each group. Just a single value for them.

yeah, sorry about that.  I forgot that they were fs-wide, but that makes sense.
Sorry for leading you astray.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
