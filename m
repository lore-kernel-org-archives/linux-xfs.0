Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4PBKWg2137628 for <xfs@oss.sgi.com>; Wed, 25 May 2011 06:20:33 -0500
Received: from mail-ew0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E61311657DBC
	for <xfs@oss.sgi.com>; Wed, 25 May 2011 04:20:31 -0700 (PDT)
Received: from mail-ew0-f53.google.com (mail-ew0-f53.google.com
	[209.85.215.53]) by cuda.sgi.com with ESMTP id ON4aScTxzobW1y50
	for <xfs@oss.sgi.com>; Wed, 25 May 2011 04:20:31 -0700 (PDT)
Received: by ewy8 with SMTP id 8so2477548ewy.26
	for <xfs@oss.sgi.com>; Wed, 25 May 2011 04:20:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1105251155120.4667@dhcp-27-109.brq.redhat.com>
References: <4DDBE293.8030203@philkarn.net>
	<alpine.LFD.2.00.1105251155120.4667@dhcp-27-109.brq.redhat.com>
From: Phil Karn <karn@philkarn.net>
Date: Wed, 25 May 2011 04:20:10 -0700
Message-ID: <BANLkTi=8CX_rjWHFEjt5JO5oScdKoZopww@mail.gmail.com>
Subject: Re: automatically running fstrim
Reply-To: karn@ka9q.net
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5181740149405553941=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>
Cc: xfs@oss.sgi.com

--===============5181740149405553941==
Content-Type: multipart/alternative; boundary=90e6ba6154126b548604a417e4ec

--90e6ba6154126b548604a417e4ec
Content-Type: text/plain; charset=UTF-8

Thanks. My problem is that I've been running some workloads that can gobble
up the SSD erased page pool rather quickly. It's a Perl script feeding a
large number of email messages to procmail, one at a time. I think this
creates and deletes a lot of temporary files. While XFS delayed allocation
normally keeps such files from going to disk, I think procmail defeats this
with fsync() to keep mail from ever being lost.

So I've simply been running fstrim by hand a lot so I don't have a repeat of
the system lockup I had a few days ago that I am pretty sure was due to my
OCZ Revo drive not handling garbage collection very gracefully.

Phil

--90e6ba6154126b548604a417e4ec
Content-Type: text/html; charset=UTF-8

Thanks. My problem is that I&#39;ve been running some workloads that can 
gobble up the SSD erased page pool rather quickly. It&#39;s a Perl script 
feeding a large number of email messages to procmail, one at a time. I 
think this creates and deletes a lot of temporary files. While XFS 
delayed allocation normally keeps such files from going to disk, I think
 procmail defeats this with fsync() to keep mail from ever being lost.<br>
<br>
So I&#39;ve simply been running fstrim by hand a lot so I don&#39;t have a 
repeat of the system lockup I had a few days ago that I am pretty sure 
was due to my OCZ Revo drive not handling garbage collection very 
gracefully.<br>
<br>
Phil

--90e6ba6154126b548604a417e4ec--


--===============5181740149405553941==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5181740149405553941==--
