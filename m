Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 492487F37
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 09:54:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 269EC304032
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 07:54:49 -0700 (PDT)
Received: from mail-ob0-f177.google.com (mail-ob0-f177.google.com
	[209.85.214.177]) by cuda.sgi.com with ESMTP id
	REtLt1pt0PXF2MYm (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 09 Jul 2013 07:54:48 -0700 (PDT)
Received: by mail-ob0-f177.google.com with SMTP id ta17so7042016obb.8
	for <xfs@oss.sgi.com>; Tue, 09 Jul 2013 07:54:47 -0700 (PDT)
Subject: Re: inode64 and Firefox
Mime-Version: 1.0 (Apple Message framework v1085)
From: aurfalien <aurfalien@gmail.com>
In-Reply-To: <51DC1FB4.7010108@hardwarefreak.com>
Date: Tue, 9 Jul 2013 07:54:43 -0700
Message-Id: <F95C7C94-A8AD-415A-BF74-E8600397406F@gmail.com>
References: <EA658AFF-6AEC-41D1-BA40-4103BEF7FD5E@gmail.com>
	<51DC1600.7080906@sandeen.net>
	<C7F53623-AA6A-4FD2-90A6-52BBA6562D10@gmail.com>
	<51DC198C.70106@sandeen.net> <51DC1FB4.7010108@hardwarefreak.com>
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
To: stan@hardwarefreak.com
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com


On Jul 9, 2013, at 7:35 AM, Stan Hoeppner wrote:

> On 7/9/2013 9:09 AM, Eric Sandeen wrote:
>> On 7/9/13 9:08 AM, aurfalien wrote:
>>> 
>>> On Jul 9, 2013, at 6:54 AM, Eric Sandeen wrote:
>>> 
>>>> On 7/9/13 8:37 AM, aurfalien wrote:
>>>>> Before I dig deeper, wondering if any one has issues running Firefox v22 from an XFS file system mounted using inode64 option?
>>>> 
>>>> I've not tried it, but first question - 32-bit or 64-bit firefox?
>>> 
>>> Its 32 bit FF.  Thunderbird also has issues.  Too bad :(
>> 
>> Ok, below was for 64-bit, even!
>> 
>> I'd file a bug w/ them, it can't be that hard to fix.  Modern filesystems have 64 bit inodes, they should handle it!
>> 
>> -Eric
>> 
>>> Stuck in the stone age.  Got a 24TB fs functioning as a home dir for ~100 pplz that I would like to modernize.
> 
> Is XFS being mounted via NFS or Samba?

NFS

>  Do your server and client
> versions of these support 64 bit inodes?

Yes, everything works except for Mozilla warez.  I'm seeing if there are any KDE issues as well.

>  If these are 32 bit Windows
> clients I think it's pretty certain they don't/can't handle 64 bit
> inodes.  Thus this may not be strictly a FF/TB problem.  We need more
> information.
> 

My OS's both actual and virtual are 64 bit.  Lin64 and Win64.

- aurf

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
