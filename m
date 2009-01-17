Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0HNENKC016468 for <xfs@oss.sgi.com>; Sat, 17 Jan 2009 17:14:27 -0600
Received: from rv-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 51C18181287E
	for <xfs@oss.sgi.com>; Sat, 17 Jan 2009 15:14:21 -0800 (PST)
Received: from rv-out-0708.google.com (rv-out-0708.google.com
	[209.85.198.249]) by cuda.sgi.com with ESMTP id
	trAFvLqEXGQpDlfb for <xfs@oss.sgi.com>;
	Sat, 17 Jan 2009 15:14:21 -0800 (PST)
Received: by rv-out-0708.google.com with SMTP id f25so2106166rvb.32
	for <xfs@oss.sgi.com>; Sat, 17 Jan 2009 15:14:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <49722875.90202@sandeen.net>
References: <adcf4ef70901170913l693376d7s6fd0395e2c88e10@mail.gmail.com>
	<4972166D.5000006@sandeen.net>
	<adcf4ef70901171042p31054ae0rb56819fce7b6f47e@mail.gmail.com>
	<49722875.90202@sandeen.net>
Date: Sat, 17 Jan 2009 18:14:21 -0500
Message-ID: <adcf4ef70901171514v2fa036a6o9deb0df7d9dd569d@mail.gmail.com>
Subject: Re: help with xfs_repair on 10TB fs
From: Alberto Accomazzi <aaccomazzi@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Sat, Jan 17, 2009 at 1:50 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> Alberto Accomazzi wrote:
>> On Sat, Jan 17, 2009 at 12:33 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>>
>>> Alberto Accomazzi wrote:
>>>> I need some help with figuring out how to repair a large XFS
>>>> filesystem (10TB of data, 100+ million files).  xfs_repair seems to
>>>> have crapped out before finishing the job and now I'm not sure how to
>>>> proceed.
>>> How did it "crap out?
>>
>>
>> Well, in the way I described below, namely it ran for several hours and then
>> died without completing.  As you can see from the log (which captured both
>> stdout and stderr) there's nothing that indicates what terminated the
>> program.  And it's definitely not running now.
>>
>>
>>> the src.rpm from
>>>
>>> http://kojipkgs.fedoraproject.org/packages/xfsprogs/2.10.2/3.fc11/src/
>>>
>>
>> Ok, I guess it's worth giving it a shot.  I assume I don't need to worry
>> about kernel modules because the xfsprogs don't depend on that, right?

For the record, after upgrading to xfsprogs-2.10.2 as suggested by
Eric, xfs_repair completed successfully.  Unfortunately now I'm left
with dealing with quite a mess: 388K files in lost+found, with a
filesystem of over 160M inodes.  ugh...

Thanks for all your help, though...
-- Alberto

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
