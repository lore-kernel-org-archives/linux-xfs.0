Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 07 Oct 2007 16:00:42 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l97N0aNv031566
	for <linux-xfs@oss.sgi.com>; Sun, 7 Oct 2007 16:00:38 -0700
Message-ID: <4709650F.7060101@sandeen.net>
Date: Sun, 07 Oct 2007 18:00:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: mounting raid5 with different unit values
References: <5d96567b0710070015j723810aag20dc3e2866868684@mail.gmail.com> <20071007221902.GO23367404@sgi.com>
In-Reply-To: <20071007221902.GO23367404@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Raz <raziebe@gmail.com>, linux-xfs@oss.sgi.com

David Chinner wrote:
> On Sun, Oct 07, 2007 at 09:15:23AM +0200, Raz wrote:
>> Hello
>> I am trying to mount xfs over raid5. I am trying to mount it with
>> different values than
>> the true ones. the mount fails with a general error of :
>> mount -osunit=6144,swidth=18432 /dev/md1 /d1/
>> mount: wrong fs type, bad option, bad superblock on /dev/md1,
>>        or too many mounted file systems
> 
> Try looking in your syslog or dmesg for the error that occurred
> during mount. 

Just a general plea to everyone.  If you get that above generic mount
error ("... or planets out of alignment") you *really* need to look at
dmesg to get any idea what's actually gone wrong.

-Eric
