Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0IKY80b025202 for <xfs@oss.sgi.com>; Sun, 18 Jan 2009 14:34:10 -0600
Received: from rv-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2D54B9ACE4
	for <xfs@oss.sgi.com>; Sun, 18 Jan 2009 12:34:06 -0800 (PST)
Received: from rv-out-0708.google.com (rv-out-0708.google.com
	[209.85.198.248]) by cuda.sgi.com with ESMTP id
	DsBPVnm8icke9F7j for <xfs@oss.sgi.com>;
	Sun, 18 Jan 2009 12:34:06 -0800 (PST)
Received: by rv-out-0708.google.com with SMTP id f25so2323848rvb.32
	for <xfs@oss.sgi.com>; Sun, 18 Jan 2009 12:34:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <49726E94.4060806@sandeen.net>
References: <adcf4ef70901170913l693376d7s6fd0395e2c88e10@mail.gmail.com>
	<4972166D.5000006@sandeen.net>
	<adcf4ef70901171042p31054ae0rb56819fce7b6f47e@mail.gmail.com>
	<49722875.90202@sandeen.net>
	<adcf4ef70901171514v2fa036a6o9deb0df7d9dd569d@mail.gmail.com>
	<49726E94.4060806@sandeen.net>
Date: Sun, 18 Jan 2009 15:34:05 -0500
Message-ID: <adcf4ef70901181234g3183b66bm1831751c2c7c965c@mail.gmail.com>
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

On Sat, Jan 17, 2009 at 6:49 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> Alberto Accomazzi wrote:
>
>
>> For the record, after upgrading to xfsprogs-2.10.2 as suggested by
>> Eric, xfs_repair completed successfully.  Unfortunately now I'm left
>> with dealing with quite a mess: 388K files in lost+found, with a
>> filesystem of over 160M inodes.  ugh...
>>
>> Thanks for all your help, though...
>> -- Alberto
>
> Bummer.  What was the first thing that went wrong, by the way?

A hardware issue with the underlying RAID managed by a 3ware
controller.  Although this is running RAID 6 + hot spare apparently
there was enough accumulation of bad blocks on the drives that we
experienced data corruption.  I'm definitely not happy about it and
I'm trying to figure out if there is something faulty going on here.
In fact I just noticed that the drives in question (Seagate ES.2) have
been found to have problems with data loss under certain
circumstances: http://seagate.custkb.com/seagate/crm/selfservice/search.jsp?DocId=207931

-- Alberto

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
