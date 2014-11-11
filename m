Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2D58B7F7B
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 16:36:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1C1A7304062
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 14:36:47 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id V98uv1j5ORPw1we9 for <xfs@oss.sgi.com>;
	Tue, 11 Nov 2014 14:36:45 -0800 (PST)
Message-ID: <54628F7B.7080604@sandeen.net>
Date: Tue, 11 Nov 2014 16:36:43 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Enforcing quota for root user
References: <67EDE14C-CCFB-4B42-8B78-FC6C813CD19A@free.fr>	<5461B333.8050609@hardwarefreak.com>	<F7ACFF71-460D-40E7-999C-BFC8D232EA81@free.fr>	<54622CE8.7050508@hardwarefreak.com>	<631A9090-F9FE-4B8E-88CD-1B30CAFC65B7@colorremedies.com>
	<20141111223203.GS28565@dastard>
In-Reply-To: <20141111223203.GS28565@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Chris Murphy <lists@colorremedies.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com

On 11/11/14 4:32 PM, Dave Chinner wrote:
> On Tue, Nov 11, 2014 at 11:00:25AM -0700, Chris Murphy wrote:
>>
>> On Nov 11, 2014, at 8:36 AM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>>
>>> On 11/11/2014 04:22 AM, Cyril Scetbon wrote:
>>>> That's what I've read first, but someone showed me a sample where it works. He just told me he was using project quota. However, does it make sense ? 
>>>> I've also read somewhere else that quota is never enforced for root user (id,gid=0) that's why I was testing it ....
>>>
>>> No, it doesn't make sense.  Why would you want to enforce quotas for root?
>>
>> A week ago I tried this and project quotas appear to apply to root.
> 
> By intent and design. Project quotas are not a user/group based
> quota and so there is no exemption for any user.

However, at least according to the manpage, "project ID 0" is not
enforced.  Granted, that is not a *user* exception.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
