Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3D7A27CA0
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 08:48:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 00E858F8040
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 06:48:18 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 616QNEoHNMIe1fCD for <xfs@oss.sgi.com>;
	Wed, 16 Mar 2016 06:48:14 -0700 (PDT)
Subject: Re: an mount option question and dunno if right here...
References: <08297acdf77244b468e15458f3d78327@zbfmail.de>
	<56E1A8B1.2080800@sandeen.net>
	<ebcb0a57f224c5a9be0d2d2777bca581@zbfmail.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56E9641D.7010203@sandeen.net>
Date: Wed, 16 Mar 2016 08:48:13 -0500
MIME-Version: 1.0
In-Reply-To: <ebcb0a57f224c5a9be0d2d2777bca581@zbfmail.de>
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
To: weber@zbfmail.de
Cc: xfs@oss.sgi.com

On 3/16/16 8:03 AM, Marko Weber | 8000 wrote:
> 

> Hi Eric,
> 
> 
> my /etc/fstab entry:
> 
> /dev/VolGroup01/wiso    /raid5/wiso     xfs     norelatime,lazytime
> 
> 
> 
> # mount:
> 
> 
> /dev/mapper/VolGroup01-wiso on /raid5/wiso type xfs (rw,relatime,lazytime,attr2,inode64,logbufs=8,logbsize=256k,sunit=1024,swidth=3072,noquota)
> 
> 
> cat /proc/mounts:
> 
> /dev/mapper/VolGroup01-wiso /raid5/wiso xfs rw,lazytime,relatime,attr2,inode64,logbufs=8,logbsize=256k,sunit=1024,swidth=3072,noquota 0 0
> 

Ok, I stand corrected, sorry; I forgot about this:

commit 0ae45f63d4ef8d8eeec49c7d8b44a1775fff13e8
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Feb 2 00:37:00 2015 -0500

    vfs: add support for a lazytime mount option

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
