Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Jun 2007 01:10:18 -0700 (PDT)
Received: from mail.ukfsn.org (s2.ukfsn.org [217.158.120.143])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5J8ADdo017677
	for <xfs@oss.sgi.com>; Tue, 19 Jun 2007 01:10:14 -0700
Message-ID: <46778F60.5090107@dgreaves.com>
Date: Tue, 19 Jun 2007 09:10:08 +0100
From: David Greaves <david@dgreaves.com>
MIME-Version: 1.0
Subject: xfs freeze/umount problem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, David Chinner <dgc@sgi.com>

David Chinner wrote:
 > FWIW, I'm on record stating that "sync" is not sufficient to quiesce an XFS
 > filesystem for a suspend/resume to work safely and have argued that the only
 > safe thing to do is freeze the filesystem before suspend and thaw it after
 > resume.

Whilst testing a potential bug in another thread I accidentally found that 
unmounting a filesystem that I'd just frozen would hang.

As the saying goes: "Well, duh!!"

I could eventually run an unfreeze but the mount was still hung. This lead to an 
unclean shutdown.

OK, it may not be bright but it seems like this shouldn't happen; umount should 
either unfreeze and work or fail ("Attempt to umount a frozen filesystem.") if 
the fs is frozen.

Is this a kernel bug/misfeature or a (u)mount one?
Suggestions as to the best place to report it if not in the cc's?

David
