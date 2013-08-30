Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B2C4A7F59
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 22:20:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 93BA08F8049
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 20:19:57 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id yYrwt2mXuSxbsZ0g for <xfs@oss.sgi.com>;
	Thu, 29 Aug 2013 20:19:56 -0700 (PDT)
Message-ID: <52200F5A.9050702@sandeen.net>
Date: Thu, 29 Aug 2013 22:19:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: higher agcount on LVM2 thinp volumes
References: <321D1F95-5603-4571-A445-A267DA5F670F@colorremedies.com>
	<52200BAE.1060501@sandeen.net>
	<4393C3B8-8C46-41ED-B9F3-BC7B37C2681F@colorremedies.com>
In-Reply-To: <4393C3B8-8C46-41ED-B9F3-BC7B37C2681F@colorremedies.com>
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
To: Chris Murphy <lists@colorremedies.com>
Cc: xfs@oss.sgi.com

On 8/29/13 10:18 PM, Chris Murphy wrote:
> 
> On Aug 29, 2013, at 9:04 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> 
>> What does
>>
>> # blockdev --getiomin --getioopt mkfs.xfs /dev/mapper/vg1-data
>>
>> say?
> 
> 
> [root@f19s ~]# blockdev --getiomin --getioopt mkfs.xfs /dev/mapper/vg1-data
> blockdev: cannot open mkfs.xfs: No such file or directory

Argh sorry, how did I type THAT?

# blockdev --getiomin --getioopt /dev/mapper/vg1-data

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
