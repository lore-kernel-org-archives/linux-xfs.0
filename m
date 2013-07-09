Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CAA5D7F50
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 09:09:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 64E8EAC005
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 07:09:17 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id uADYNNQ8DT6MnmSB for <xfs@oss.sgi.com>;
	Tue, 09 Jul 2013 07:09:16 -0700 (PDT)
Message-ID: <51DC198C.70106@sandeen.net>
Date: Tue, 09 Jul 2013 09:09:16 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: inode64 and Firefox
References: <EA658AFF-6AEC-41D1-BA40-4103BEF7FD5E@gmail.com>
	<51DC1600.7080906@sandeen.net>
	<C7F53623-AA6A-4FD2-90A6-52BBA6562D10@gmail.com>
In-Reply-To: <C7F53623-AA6A-4FD2-90A6-52BBA6562D10@gmail.com>
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
To: aurfalien <aurfalien@gmail.com>
Cc: xfs@oss.sgi.com

On 7/9/13 9:08 AM, aurfalien wrote:
> 
> On Jul 9, 2013, at 6:54 AM, Eric Sandeen wrote:
> 
>> On 7/9/13 8:37 AM, aurfalien wrote:
>>> Before I dig deeper, wondering if any one has issues running Firefox v22 from an XFS file system mounted using inode64 option?
>>
>> I've not tried it, but first question - 32-bit or 64-bit firefox?
> 
> Its 32 bit FF.  Thunderbird also has issues.  Too bad :(

Ok, below was for 64-bit, even!

I'd file a bug w/ them, it can't be that hard to fix.  Modern filesystems have 64 bit inodes, they should handle it!

-Eric

> Stuck in the stone age.  Got a 24TB fs functioning as a home dir for ~100 pplz that I would like to modernize.
> 
>> However, this isn't encouraging:
>>
>> $ file /usr/lib64/firefox/firefox
>> /usr/lib64/firefox/firefox: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.18, stripped
>>
>> $ ./summarise_stat.pl /usr/lib64/firefox/firefox
>>      1 100.0% use 32-bit stat() family interfaces only
>>
>> sooo if my perl script is to be believed, it may be problematic, depending on how serious a stat() failure is.
>>
>> -Eric
> 
> Thanks for the feedback.
> 
> - aurf
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
