Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4NHZ9Hj013189 for <xfs@oss.sgi.com>; Sat, 23 May 2009 12:35:09 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B26C2A6898
	for <xfs@oss.sgi.com>; Sat, 23 May 2009 10:35:20 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id NN52UNTUOXxWwT2n for
	<xfs@oss.sgi.com>; Sat, 23 May 2009 10:35:20 -0700 (PDT)
Message-ID: <4A1833D7.30608@sandeen.net>
Date: Sat, 23 May 2009 12:35:19 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Invalid argument
References: <4A180FCD.9080905@cape-horn-eng.com> <4A181B40.9080608@sandeen.net>
	<20090523180721.94212hyfjppuupmo@webmail.df.eu>
In-Reply-To: <20090523180721.94212hyfjppuupmo@webmail.df.eu>
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
To: richard.ems@cape-horn-eng.com
Cc: xfs@oss.sgi.com

richard.ems@cape-horn-eng.com wrote:
> Quoting Eric Sandeen <sandeen@sandeen.net>:
> 
>> Richard Ems wrote:

...

>>> I tried different 2.6.27 versions, one 2.6.29 and one 2.6.30-rc6
>>> version, all gave the same error, check
>>> https://bugzilla.novell.com/show_bug.cgi?id=506361 for the different
>>> kernel versions and errors.
>> I don't see in that bug where you tested .29 or .30, or what the results
>> were...
> 
> Sorry, I wrote a 2nd comment into bugzilla but forgot to submit it 8( .
> Now it's there, please check again (  
> https://bugzilla.novell.com/show_bug.cgi?id=506361#c1 ) .
> 
>>
>>> Is this fix still not included in Linus / openSUSE trees?
>> As for Linus' tree, AFAIK everything works; I can't speak to what SuSE has.
> 
> So the Vanilla kernel I tried should have this fix included, is it  
> then a new bug?

Not sure ... how big is the current fs and how big is the device?  Can
you provide:

# xfs_info /mnt
# grep sda1 /proc/partitions

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
