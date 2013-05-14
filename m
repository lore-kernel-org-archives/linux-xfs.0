Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D59B47F3F
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 03:52:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 98DD48F8039
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 01:52:47 -0700 (PDT)
Received: from mail-ie0-f175.google.com (mail-ie0-f175.google.com
	[209.85.223.175]) by cuda.sgi.com with ESMTP id
	pzmKKq1Wnyda1uw8 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 14 May 2013 01:52:46 -0700 (PDT)
Received: by mail-ie0-f175.google.com with SMTP id s9so487515iec.20
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 01:52:46 -0700 (PDT)
Received: from [192.168.1.2] ([184.52.11.124])
	by mx.google.com with ESMTPSA id 9sm22507737igy.7.2013.05.14.01.52.40
	for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
	Tue, 14 May 2013 01:52:45 -0700 (PDT)
Message-ID: <5191FB46.2080300@gmail.com>
Date: Tue, 14 May 2013 04:52:22 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Rambling noise #2: Learning to use the v8 pquota/uquota patchset
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
To: xfs@oss.sgi.com

Hi!  I seem to have no luck in getting v8 of the pquota/uquota patchset 
working and have it pass xfstests with flying colors.  Is v8 of the 
pquota/gquota patchset sufficient to make the new separate pquota/gquota 
bits work?  Or is it an incremental patchset?

The basic functionality works, in my opinion, and I hope nobody wastes 
time with a nice, educated reply.  It would be mostly wasted on me and 
is better saved for somebody else.  A reply of "do this...and 
this...btw, how did this test come out?" would be welcomed, though ;-)

Anyway, some vague observations as I grasp for straws...

1) The xfstests quota group tests seem to fail in different ways than 
the way they did before applying the patches.

2) Nothing has oopsed.

3) In testing using the `xfs_quota -x` command, the patches seem to 
work.  On `mount -t xfs -o gquota` mounts, using the quota command from 
within the xfs_quota shell, the group quotas show but not the projid 
quotas.  On `mount -t xfs -o pquota` mounts, the projid quotas show but 
not the gquota mounts.  This is different than the old behavior, where 
the gquota numbers might be recycled into projid numbers.

4) The results of `xfsquota -c print` are confusing.  Maybe they're 
showing the XFS view when they show things like 
'uqnoenforce,gquota,pquota' for a mount that is gquota only.  They're 
doubly confusing once /etc/projid and /etc/projects have been set up. 
The 'gqnoenforce' and 'pqnoenforce' flags show up at times for reasons 
that are unknown to me.

5) `mount -t xfs -o gquota,pquota` is not possible at this time.

6) The patches applied cleanly to a git Linux 3.10-rc1 kernel + xfs-oss, 
with only whitespace errors reported.

7) I question whether 'bsoft=' has a visible effect on projid quotas, 
whether using your patches or not.  Did it ever work?

8) I had no feel on whether the filesystem had to be mounted once as 
gquota, then once as pquota, for the full dual functionality to work.

9) It looks like xfs_repair doesn't ruin anything, but the `xfsquota -c 
print` output looks a little different on the next mount.

That's about all that could be put together in a coherent manner.  Sleep 
awaits.

The PC is a 32-bit Pentium 4.  In addition to the kernel mentioned in 
(6), there are a few J. Liu and Dave Chinner patches applied as well.

Best of luck!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
