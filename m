Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 59CC47F3F
	for <xfs@oss.sgi.com>; Wed, 11 Jun 2014 10:43:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DBA42AC006
	for <xfs@oss.sgi.com>; Wed, 11 Jun 2014 08:43:11 -0700 (PDT)
Received: from mail-yk0-f180.google.com (mail-yk0-f180.google.com
	[209.85.160.180]) by cuda.sgi.com with ESMTP id
	bXMINKVCvI67XUBg (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Jun 2014 08:43:09 -0700 (PDT)
Received: by mail-yk0-f180.google.com with SMTP id 131so3406767ykp.11
	for <xfs@oss.sgi.com>; Wed, 11 Jun 2014 08:43:09 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 11 Jun 2014 11:43:09 -0400
Message-ID: <CA+Bg6wd9CFKdHaAM-XyJx3royVb2-QdKqhmaamA-KMQk1TdieQ@mail.gmail.com>
Subject: (Un)known issue with XFS group quotas on LVM?
From: John Desantis <desantis@mail.usf.edu>
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
To: xfs@oss.sgi.com

Hello list!

A big "thanks!" to all XFS developers for a great product.

Now, to the point!

We're using an XFS file system created on an LVM with a standard
kernel (2.6.32-431.3.1).  We're using quotas without an issue, with
the exception of the group quota.  It seems that group quotas are
ignored at times, at least from our configuration (we use remote user
and group look-ups and authentication).  I've only been able to get
root running sudo -g dd.. to create a group file which reflects
changes in the group quota limit.

We've mounted the file system in question with both user and group
quotas enabled;  I didn't see anywhere in the man page that said this
isn't possible, although I did see where group and project quotas
cannot be used simultaneously on the same file system.

Has anyone experienced this behavior before?  I feel that I did some
pretty good searching in the archives, Google, and the BugZilla page,
but there were no "real" results which seemed to describe the same
issue we're facing.  Strace didn't provide any clues either.  I don't
think it's a sync issue because I've allowed a few days to pass in
between "test" runs.

I've tested the quota by:

1.)  Using sudo -u user -g group dd.... on both the exported file
system and its mount path on the server itself.
2.)  Using sudo -u user -g group dd.. on the client and the file
system's mount path.
3.)  Using sudo -g group dd... on both the exported file system and
its mount path on the server itself;  this method produces expected
results.
4.)  Using sudo -g group dd.. on the client and the file system's
mount path;  this method also produces expected results.

Items #1 and #2 produce the error.

I just wanted to ping the list before creating a local testing group
to see if it's an issue with remote group look-ups.

Thank you,
John DeSantis

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
