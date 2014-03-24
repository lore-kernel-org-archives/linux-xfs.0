Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3C7D27F4E
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2014 11:13:00 -0500 (CDT)
Message-ID: <53305989.3000708@sgi.com>
Date: Mon, 24 Mar 2014 11:12:57 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: xfs blocks (blocked for more than 120 seconds)
References: <532FF9DD.5080700@1st-setup.nl> <533032C6.8090800@sgi.com>
	<533035CF.6050807@1st-setup.nl>
In-Reply-To: <533035CF.6050807@1st-setup.nl>
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
To: "Michel Verbraak(1st-Setup)" <info@1st-setup.nl>
Cc: xfs@oss.sgi.com

On 03/24/14 08:40, Michel Verbraak(1st-Setup) wrote:
> op 24-03-14 14:27, Mark Tinguely schreef:
>> On 03/24/14 04:24, Michel Verbraak(1st-Setup) wrote:
>>> Hi,
>>>
>>> We have a problem with one of our systems which is using XFS but we are
>>> unable to find the problem. Recently we had two moments, Tuesday 4th of
>>> March and Friday the 21st of March, where we had to reboot the system to
>>> get it up and running again.
>>>
>>> What happens:
>>> - The programs handling files on the XFS disc stop working when
>>> creating, deleting or writing files. They do not error they are just
>>> waiting on the command to complete.
>>> - One of our programs, a java application, goes into very high cpu usage
>>> (50%) which normally is at 1%. This could be something in our java
>>> application but it happens at the moment handling files gets stuck.
>>> - A nice restart of the programs does not succeed as wel a kill -9 does
>>> not work.
>>> - Trying to reboot the servers in a normal fashion does not work. As it
>>> is a virtual machine we have to do a shutdown (unplug power) and start
>>> it up again to get it up and running.
>>>
>>> Following details I have for you:
>>>
>>> System OS: Ubuntu 12.04 LTS
>>> Kernel: 3.2.0-37-generic #58-Ubuntu SMP Thu Jan 24 15:28:10 UTC 2013
>>> x86_64 x86_64 x86_64 GNU/Linux
>>> Server: Virtual machine in a VMWare setup.
>>> Disc: 300GB direct attached LUN
>>>
>>> We have an exact clone of this system for our acceptance environment. In
>>> this environment we are unable to reproduce this problem/situation.
>>>
>>> Differences between the two days is that our services on 2014-03-21 were
>>> quit busy with a lot of file changes on the xfs disc and on 2014-03-04
>>> the system was very quiet on the moment the kernel traces appear and the
>>> services get stuck.
>>>
>>> Any help is appreciated.
>>>
>>> Regards Michel Verbraak.
>>
>>
>> Could you set up kdump and take a core dump next time it hangs?
>> There is a couple suspicious items in the syslog entries
>>
>> --Mark.
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
> Mark,
>
> We will setup the kdump. Can you elloborate on your suspicions?
>
> Michel.

I am interested in the AGF buffer locks and it would be nice to know who 
hold what locks. The flush workers are interesting too. We have seen 
process block worker's writes from completing, so looking at what is 
running and scheduled would be interesting. So a vmcore would tell a lot.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
