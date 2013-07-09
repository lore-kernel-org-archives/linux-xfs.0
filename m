Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5087E7F37
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 09:08:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 406E830405F
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 07:08:09 -0700 (PDT)
Received: from mail-ob0-f171.google.com (mail-ob0-f171.google.com
	[209.85.214.171]) by cuda.sgi.com with ESMTP id
	GXnCG2CogUVv7aHN (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 09 Jul 2013 07:08:08 -0700 (PDT)
Received: by mail-ob0-f171.google.com with SMTP id dn14so7040140obc.16
	for <xfs@oss.sgi.com>; Tue, 09 Jul 2013 07:08:07 -0700 (PDT)
Subject: Re: inode64 and Firefox
Mime-Version: 1.0 (Apple Message framework v1085)
From: aurfalien <aurfalien@gmail.com>
In-Reply-To: <51DC1600.7080906@sandeen.net>
Date: Tue, 9 Jul 2013 07:08:03 -0700
Message-Id: <C7F53623-AA6A-4FD2-90A6-52BBA6562D10@gmail.com>
References: <EA658AFF-6AEC-41D1-BA40-4103BEF7FD5E@gmail.com>
	<51DC1600.7080906@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com


On Jul 9, 2013, at 6:54 AM, Eric Sandeen wrote:

> On 7/9/13 8:37 AM, aurfalien wrote:
>> Before I dig deeper, wondering if any one has issues running Firefox v22 from an XFS file system mounted using inode64 option?
> 
> I've not tried it, but first question - 32-bit or 64-bit firefox?

Its 32 bit FF.  Thunderbird also has issues.  Too bad :(

Stuck in the stone age.  Got a 24TB fs functioning as a home dir for ~100 pplz that I would like to modernize.

> However, this isn't encouraging:
> 
> $ file /usr/lib64/firefox/firefox
> /usr/lib64/firefox/firefox: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.18, stripped
> 
> $ ./summarise_stat.pl /usr/lib64/firefox/firefox
>      1 100.0% use 32-bit stat() family interfaces only
> 
> sooo if my perl script is to be believed, it may be problematic, depending on how serious a stat() failure is.
> 
> -Eric

Thanks for the feedback.

- aurf

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
