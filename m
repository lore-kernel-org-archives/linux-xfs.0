Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p073KHtp221128 for <xfs@oss.sgi.com>; Thu, 6 Jan 2011 21:20:18 -0600
Received: from mail-gx0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D8CBD23EDB8
	for <xfs@oss.sgi.com>; Thu,  6 Jan 2011 19:22:26 -0800 (PST)
Received: from mail-gx0-f181.google.com (mail-gx0-f181.google.com
	[209.85.161.181]) by cuda.sgi.com with ESMTP id
	Wh7DB5GkUo4WEkPA for <xfs@oss.sgi.com>;
	Thu, 06 Jan 2011 19:22:26 -0800 (PST)
Received: by gxk10 with SMTP id 10so8713837gxk.26
	for <xfs@oss.sgi.com>; Thu, 06 Jan 2011 19:22:26 -0800 (PST)
Message-ID: <4D2686ED.7000304@philkarn.net>
Date: Thu, 06 Jan 2011 19:22:21 -0800
From: Phil Karn <karn@philkarn.net>
MIME-Version: 1.0
Subject: TRIM details
Reply-To: karn@ka9q.net
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
To: xfs@oss.sgi.com

Now that I've rebuilt my main Linux server, added a 120GB Intel SSD and
converted all the file systems to XFS, I've gotten interested in the
internals of both XFS and TRIM and how they work together (or will work
together).

I'd like to know exactly how the drives implement TRIM but I've only
found bits and pieces. Can anyone suggest a current and complete
reference for the complete SATA command set that includes all the TRIM
related stuff?

As I understand it, there's a SATA (and SCSI?) command that will
repeatedly write a fixed block of data to some number of consecutive
LBAs (WRITE SAME), and an "unmap" bit in the write command can be set to
indicate that instead of actually writing the blocks, they can be marked
for erasure and placed in the free pool.

Is this the only way it can be done? It occurs to me that while an
"unmap" bit should be quite fast, you don't absolutely *have* to have it.

Just have the drive interpret an ordinary write of all 0's to any LBA as
an implicit "unmap" indication for that LBA. As long as the drive
returns all 0's when an unmapped LBA is read (and I believe this is
already a requirement) then were an application to write a block of real
data that just happens to contain all 0's, it would still get back what
it wrote.

Then you could manually trim a drive with something like

dd if=/dev/zero of=foobar bs=1024k count=10240k
rm foobar

or if you're really adventurous and don't mind a little hiccup:

dd if=/dev/zero of=foobar bs=1024k count=20m
rm foobar

(i.e, let dd run the file system out of space before you delete the
temporary).

Then you wouldn't need a potentially dangerous program like wiper.sh
talking directly to the drive behind the file system's back. And while
wiper.sh only works with file systems whose structures it knows, this
approach would work with ANY file system.

This will all become moot when every SSD supports TRIM and every file
system uses it. But there are a lot of file systems out there, not all
of them support TRIM, and many may not for some time.

Somebody must have already thought of this, right?

Phil

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
