Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5NGZM9b037111 for <xfs@oss.sgi.com>; Tue, 23 Jun 2009 11:35:23 -0500
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1D56A97EDFA
	for <xfs@oss.sgi.com>; Tue, 23 Jun 2009 09:44:10 -0700 (PDT)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id MeBF0DERdz7qW75J for
	<xfs@oss.sgi.com>; Tue, 23 Jun 2009 09:44:10 -0700 (PDT)
Date: Tue, 23 Jun 2009 18:35:35 +0200
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: XFS and atime update strangeness
Message-ID: <20090623163535.GA12551@citd.de>
References: <4A3B5C14.9070101@dermichi.com>
	<AE31FB8A-6C11-4177-85AB-794839A88080@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AE31FB8A-6C11-4177-85AB-794839A88080@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Felix Blyakher <felixb@sgi.com>
Cc: Michael Weissenbacher <mw@dermichi.com>, xfs@oss.sgi.com

On 23.06.2009 10:01, Felix Blyakher wrote:
> On Jun 19, 2009, at 4:36 AM, Michael Weissenbacher wrote:
>
>> Is there any way to enable permanent atime updates in case someone 
>> wants them?
>
> That's another good request I'd like to address as well. The
> above mentioned patch just makes it behave as relatime.

Just to have it explictly mentioned a.k.a. just for the record.

strictatime is AWOL.

With current 2.6.30 you just can't have 'atime' because default was 
changed to 'relatime' and the former default got the new option 
'strictatime'(*). But if i want to mount a XFS-filesystem strictatime: 
XFS: unknown mount option [strictatime]


*:                
According to fs/namespace.c, line 795 and following these 4 
atime-related options appear to be allowed:

{ MNT_NOATIME, ",noatime" },
{ MNT_NODIRATIME, ",nodiratime" },
{ MNT_RELATIME, ",relatime" },
{ MNT_STRICTATIME, ",strictatime" },




Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
