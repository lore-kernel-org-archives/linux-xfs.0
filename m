Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67MUm5L197959 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 17:30:48 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF29A558A5
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 15:30:47 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id O8I6JMf92OA4nPEh for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2011 15:30:47 -0700 (PDT)
Message-ID: <4E163396.2010707@sandeen.net>
Date: Thu, 07 Jul 2011 17:30:46 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_growfs doesn't resize
References: <20110707182532.GA31319@sonic.net> <4E160A34.20902@sandeen.net>
	<20110707222350.GA776@sonic.net>
In-Reply-To: <20110707222350.GA776@sonic.net>
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
To: Keith Keller <kkeller@sonic.net>
Cc: xfs@oss.sgi.com

On 7/7/11 5:23 PM, Keith Keller wrote:
> On Thu, Jul 07, 2011 at 02:34:12PM -0500, Eric Sandeen wrote:

...

>> If it were me, if possible, I'd make backups of the fs as it's mounted
>> now, then umount it and make an xfs_metadump of it, restore that metadump
>> to a new sparse file, and point xfs_repair at that metadata image file,
>> to see what repair might do with it.
>>
>> If repair eats it alive, then we can look into more xfs_db type surgery
>> to fix things up more nicely...
> 
> This sounds like a reasonable plan.  It looks like xfs_metadump needs a
> umounted or readonly filesystem in order to work properly; is there any
> way to estimate how long such a dump would take, and how large it would
> be from an almost-full 11TB fs with however many inodes it has (~19 million
> IIRC)?  I want to plan downtime and usable disk space accordingly.

well, I'm looking at an image of a 4T fs right now, with 208k inodes,
and the image itself took up 800M (a 4T sparse file when restored,
of course, but only using 800M)

> Would xfs_metadump create the same dump from a filesystem remounted ro
> as from a filesystem not mounted?  I think you suggested this idea in

yes, looks like it works, with recent tools anyway.

> an earlier post.  In a very optimistic scenario, I could imagine
> remounting the original filesystem ro, taking the metadump, then being
> able to remount rw so that I could put it back into service while I
> work with the metadump.  Then, once I knew more about the metadump, I

I think that should work.

> could do an actual umount and fix the filesystem using the information
> gathered from the metadump testing.  If they will produce the same
> metadump, then it could be a win-win if it's able to successfully
> remount rw afterwards; and if it can't, it wasn't any additional effort
> or risk to try.

agreed.

> Will xfsprogs 3.1.5 work with the older kernel, and will it make a
> better dump than 2.9.4?  I have built xfsprogs from source, but if it

2.9.4 won't have xfs_metadump ... and no problems with newer tools on
older kernels.  It's just reading the block device, in any case.
No unique kernel interaction.

> might have problems working with the kmod-xfs kernel module I can use
> the 2.9.4 tools instead.  (Again, in keeping with the hope-for-the-best
> scenario above, if avoiding a reboot won't be too harmful it'd be
> convenient.)

I think you can.

> I think you also mentioned that xfs_metadump can not dump frozen
> filesystems, but the man page for 3.1.5 says it can.  FWIW xfs_metadump
> refused to work on a frozen filesystem on my test machine, which is
> version 2.9.4 (though from an older CentOS base).  (xfs_freeze does look
> like a nice tool though!)

it should(?) but:

# xfs_metadump /dev/loop0 blah
xfs_metadump: /dev/loop0 contains a mounted and writable filesystem

fatal error -- couldn't initialize XFS library

# xfs_freeze -f mnt/
# xfs_metadump /dev/loop0 blah
xfs_metadump: /dev/loop0 contains a mounted and writable filesystem

fatal error -- couldn't initialize XFS library

# xfs_freeze -u mnt
# mount -o remount,ro mnt
# xfs_metadump /dev/loop0 blah

<proceeds w/o problems>

I think we should make the tools work with freeze, but remount,ro works fine too.

-Eric

> --keith
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
