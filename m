Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1E84F8045
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 09:20:08 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F03C08F8035
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 07:20:07 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 3imJw6wjHcac4lWW for <xfs@oss.sgi.com>;
	Mon, 04 Mar 2013 07:20:03 -0800 (PST)
Message-ID: <5134BBA4.3060305@sandeen.net>
Date: Mon, 04 Mar 2013 09:20:04 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair segfaults
References: <CANU9nTnvJS50vdQv2K0gKHZPvzzH5EY1qpizJNsqUobrr2juDA@mail.gmail.com>
	<512FA67D.2090708@sandeen.net>
	<CANU9nTm3vR3Z5JwRwou4vnNejstAkAsnBb2ivwx-KhnHHbWpoQ@mail.gmail.com>
	<5130DB54.9030503@sandeen.net>
	<CANU9nTkekrw2mdptFdK2RVUFXD=evt0sTZhB9VL+PKY8DTj11A@mail.gmail.com>
In-Reply-To: <CANU9nTkekrw2mdptFdK2RVUFXD=evt0sTZhB9VL+PKY8DTj11A@mail.gmail.com>
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
To: Ole Tange <tange@binf.ku.dk>
Cc: xfs@oss.sgi.com

On 3/4/13 3:00 AM, Ole Tange wrote:
> On Fri, Mar 1, 2013 at 5:46 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> On 3/1/13 3:37 AM, Ole Tange wrote:
> 
>>> Please consider providing an example in the man page for xfs_metadump e.g:
>>>
>>>   xfs_metadump.sh -g /dev/sda2 meta.dump
>>
>> From the manpage,
>>
>> SYNOPSIS
>>        xfs_metadump [ -efgow ] [ -l logdev ] source target
>>
>> The source argument must be the pathname of
>> the device or file containing the XFS filesystem
>>
>> and
>>
>> the target argument specifies the destination file name.
>>
>> is not enough?
> 
> I have never run xfs_metadump before and I am in a state of worry that
> my filesystem is toast. I would therefore like to be re-assured that
> what I am doing is correct. I did that by reading and re-reading the
> manual to make sure I had understood it correctly. By providing me
> with an example of the right way to do it in the man page, I will feel
> more confident that what I am about to do it correct and I could
> probably save time by not having to re-read the manual.
> 
> So I am not saying the information is not there, what I am saying is
> that you in a simple way could make it easier to grasp the
> information.

Fair enough, maybe a concrete example is warranted.

I suggested the meatadump for 2 reasons:

1) to get an image we could look at, to analyze the reason for the segfault, and
2) so you could run a "real" non-"n" xfs_repair on a metadata image as a more realistic dry run

xfs_metadump only *reads* your filesystem, so there is nothing dangerous.

But I understand your paranoia and worry.  :)

-Eric

> 
> /Ole
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
