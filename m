Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D6C097F47
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2015 11:34:50 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 73399AC003
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2015 09:34:50 -0800 (PST)
Received: from darcachon.resolversystems.com (darcachon.resolversystems.com
	[80.68.93.186]) by cuda.sgi.com with ESMTP id nDcEqDZD3Qxq1kT7
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 Mar 2015 09:34:47 -0800 (PST)
Message-ID: <54F893AF.2070406@pythonanywhere.com>
Date: Thu, 05 Mar 2015 17:34:39 +0000
From: Harry <harry@pythonanywhere.com>
MIME-Version: 1.0
References: <54EC958E.2000001@pythonanywhere.com>	<20150224215907.GA18360@dastard>	<54EF1A8F.7030505@pythonanywhere.com>	<54F856E7.10006@pythonanywhere.com>
	<54F87BF3.3000405@sandeen.net>
	<54F88CEC.4030009@pythonanywhere.com> <54F89201.60805@sandeen.net>
In-Reply-To: <54F89201.60805@sandeen.net>
Subject: Re: trying to avoid a lengthy quotacheck by deleting all quota data
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
To: xfs@oss.sgi.com
Cc: "developers@pythonanywhere.com" <developers@pythonanywhere.com>

We're on 3.13.0-39 (Ubuntu Trusty).

If you're interested in looking into it further, I'd be happy to provide 
any extra info you'd like?

But just to make sure I'm not wasting any of your time -- I think the 
team have pretty much decided to make the switch no matter what.  The 
quotacheck issue is one thing, but actually the switch to ext4 
simplifies lots of other aspects of our quota system (one of the reasons 
we picked nfs was to be able to use project quotas, but it turns out we 
don't need them any more, so user quotas are simpler...)



On 05/03/15 17:27, Eric Sandeen wrote:
> On 3/5/15 11:05 AM, Harry wrote:
>> Thanks for the reply Eric.
>>
>> One of our problems is that we're limited in terms of what
>> manipulations we can apply to the live system, and so instead we've
>> been running our experiments against the backup system, and you're
>> quite right that DRBD may be introducing some weirdness of its own,
>> so those experiments may not be safe to draw conclusions from.
>>
>> Here's what we know about the live system
>> -> it had an outage, equivalent to having its power cable yanked, or doing an 'echo b > /proc/sysrq-trigger'
>> -> when it came back, it decided to mount the drive without quotas.
>> -> we saw a message in syslog saying " Failed to initialize disk quotas"
>> -> last time we had to run a quotacheck (several months ago) it took about 2 hours.
>>
>> We can repro the quotacheck issue on our test clusters, as follows:
>> -> kick off a job that writes to the disk
>> -> hard reboot with "echo b > /proc/sysrq-trigger"
>> -> on next boot, see "Failed to initialize disk quotas" message, xfs mounts without quotas
>> -> soft reboot with "reboot"
>> -> on next boot, see "Quotacheck needed: Please wait." message.
>> -> Quotacheck completes some time later.
>>
>> So our best-case scenario is that, next time we reboot, we'll have an
>> outage of about 2 hours. And our paranoid worst-case scenario,
>> induced by our experiments with our drbd backup drives, are that the
>> disk will actually turn out not to be mountable at all.
>>
>> is that "quotacheck always required after hard reboot" behaviour that
>> we're observing something you expected? you seemed to be saying that
>> the fact that quota are journaled should mean it's not needed?
> In general, that's correct.  It's not clear why "Failed to initialize disk quotas"
> appeared; that seems closer to the root cause.  But again, we don't have your
> full logs to look at, I don't know if anything else offers a clue.  (For that
> matter, we don't even know what kernel version you're on...)
>
> here, on a recent 4.0-rc1 kernel:
>
> # mount -o quota /dev/sdc6 /mnt/test
> # cp -aR /lib/modules/ /mnt/test
> # echo b > /proc/sysrq-trigger
>
> [152807.209688] sysrq: SysRq : Resetting
> ...
> <reboots>
>
> # mount -o quota /dev/sdc6 /mnt/test
> # dmesg | tail -n 3
> [   90.822601] XFS (sdc6): Mounting V4 Filesystem
> [   90.921346] XFS (sdc6): Starting recovery (logdev: internal)
> [   93.399133] XFS (sdc6): Ending recovery (logdev: internal)
> #
>
> -Eric

Rgds,
Harry + the PythonAnywhere team.

-- 
Harry Percival
Developer
harry@pythonanywhere.com

PythonAnywhere - a fully browser-based Python development and hosting environment
<http://www.pythonanywhere.com/>

PythonAnywhere LLP
17a Clerkenwell Road, London EC1M 5RD, UK
VAT No.: GB 893 5643 79
Registered in England and Wales as company number OC378414.
Registered address: 28 Ely Place, 3rd Floor, London EC1N 6TD, UK

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
