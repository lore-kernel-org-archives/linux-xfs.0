Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n67E5YPh147997 for <xfs@oss.sgi.com>; Tue, 7 Jul 2009 09:05:34 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7B660349147
	for <xfs@oss.sgi.com>; Tue,  7 Jul 2009 07:06:09 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id VKCHSocrRgRbDxdL for
	<xfs@oss.sgi.com>; Tue, 07 Jul 2009 07:06:09 -0700 (PDT)
Message-ID: <4A535650.7020309@sandeen.net>
Date: Tue, 07 Jul 2009 09:06:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] default to inode64 on 64-bit systems
References: <4A52419E.5020301@sandeen.net> <20090707093802.GA32125@citd.de>
In-Reply-To: <20090707093802.GA32125@citd.de>
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
To: Matthias Schniedermeyer <ms@citd.de>
Cc: xfs mailing list <xfs@oss.sgi.com>

Matthias Schniedermeyer wrote:
> On 06.07.2009 13:25, Eric Sandeen wrote:
>> I'm tiring of telling people to use the inode64 mount option
>> when they are experiencing bad performance on large xfs 
>> filesystems...
>>
>> 32-bit userspace is still largely broken when it comes to still
>> using 32-bit stat calls, but on 64-bit systems this should be
>> safe.
>>
>> The only problem here is moving the disk onto a 32-bit system, or using
>> 32-bit apps.  But I think it's a small risk.
>>
>> What do we think about the following?
> 
> What is with people running 64bit kernel but 32bit Userspace?
> 

Good point.  I wonder how many do that...   hrm.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
