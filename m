Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 534427F9B
	for <xfs@oss.sgi.com>; Wed, 22 Jul 2015 20:45:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3D9848F8035
	for <xfs@oss.sgi.com>; Wed, 22 Jul 2015 18:45:17 -0700 (PDT)
Received: from mail01.lsn.net (mail01.lsn.net [66.90.130.120]) by cuda.sgi.com
	with ESMTP id xrYXSTHvSnCOoYGp for <xfs@oss.sgi.com>;
	Wed, 22 Jul 2015 18:45:13 -0700 (PDT)
Message-ID: <55B04723.6010202@mygrande.net>
Date: Wed, 22 Jul 2015 20:45:07 -0500
From: Leslie Rhorer <lrhorer@mygrande.net>
MIME-Version: 1.0
Subject: Re: XFS File system in trouble
References: <03864DDC681E664EBF5D47682BE7D7CF0D3574DF@USADCWVEMBX07.corp.global.level3.com>
	<55AA5FCE.4080702@sandeen.net>
	<03864DDC681E664EBF5D47682BE7D7CF0D358740@USADCWVEMBX07.corp.global.level3.com>
	<CAN3tLtJuk3LKHtxvbXATBR7bjr2e=GTX-fgs-jQniuxqRXjeoA@mail.gmail.com>
	<55AAF73A.4040903@mygrande.net>
	<20150720111747.GA53450@bfoster.bfoster>
In-Reply-To: <20150720111747.GA53450@bfoster.bfoster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Kris Rusocki <kszysiu@braxis.org>, "Rhorer, Leslie" <Leslie.Rhorer@level3.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 7/20/2015 6:17 AM, Brian Foster wrote:
> On Sat, Jul 18, 2015 at 08:02:50PM -0500, Leslie Rhorer wrote:
>>
>> 	I found the problem with md5sum (and probably nfs, as well).  One of the
>> memory modules in the server was bad.  The problem with XFS persists.  Every
>> time tar tried to create the directory:
>>
>> /RAID/Server-Main/Equipment/Drive Controllers/HighPoint Adapters/Rocket 2722/Driver/RR276x/Driver/Linux/openSUSE/rr276x-suse-11.2-i386/linux/suse/i386-11.1
>>
>> 	It would begin spitting out errors, starting with "Cannot mkdir: Structure
>> needs cleaning".  At that point, XFS had shut down.  I went into
>> /RAID/Server-Main/Equipment/Drive Controllers/HighPoint Adapters/Rocket
>> 2722/Driver/RR276x/Driver/Linux/openSUSE/rr276x-suse-11.2-i386/linux/suse/
>> and created the i386-11.1 directory by hand, and tar no longer starts
>> spitting out errors at that point, but it does start up again at
>> RR2782/Windows/Vista-Win2008-Win7-legacy_single/x64.
>>
>
> So is this untar problem a reliable reproducer? If so, here's what I

	Absolutely reliable producer.  The only change is if I create the 
offending directory by hand (after recovering the filesystem, of course) 
and then start the tar again.  Then it copies all the files into the 
previously offending directory, failing the next time it tries to create 
a directory.

> would try to hopefully isolate a filesystem problem from something
> underneath:

	OK.  Frankly, I fail to find it at all likely to be anything above.  I 
can read and write 100s of megabytes of data without an error.  The only 
thing that I can find failing is creating directories, and that is only 
when tar attempts it.  The directory structure is going to be written to 
different inodes as time goes by, so a failure of mdadm or some 
structure above it should cause other widesperead issues.  I need to try 
some other tarballs when I get the chance, and also try dumping that tar 
on a different directory.


> xfs_metadump -go /dev/md0 /somewhere/on/rootfs/md0.metadump
> xfs_mdrestore -g /somewhere/on/rootfs/md0.metadump /.../fileonrootfs.img

	How big are those files going to be, do you think?  The root partition 
is not all that huge.  There is only a little over 80G free.

> mount /.../fileonrootfs.img /mnt/
>
> ... and repeat the test on that mount using the original tarball (if
> it's on the associated fs, the version from the dump will have no data).

	It is.  I've tried copying it to another fs, and it works fine, there.

> This will create a metadata only dump of the original fs onto another
> storage device (e.g., whatever holds the root fs), restore the metadump
> to a file and mount it loopback. The resulting fs will not contain any
> file data, but will contain all of the metadata such as directory
> structure, etc. and is otherwise mountable and usable for experimental
> purposes.
>
> If the problem is in the filesystem or "above" (as in kernel, memory
> issue, etc.), the test should fail on this mount. If the problem is
> beneath the fs such as somewhere in the storage stack (assuming the
> rootfs storage stack is reliable), it probably shouldn't fail.

	I'll look into this when I can.  Right now I have some critical 
operations going on both servers (primary and backup), and I can't take 
down a file system or even risk doing so.  Hopefully I will get around 
to it this weekend.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
