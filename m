Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DDD9D29DF8
	for <linux-xfs@oss.sgi.com>; Tue, 11 Jun 2013 14:55:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B47C48F804B
	for <linux-xfs@oss.sgi.com>; Tue, 11 Jun 2013 12:55:10 -0700 (PDT)
Received: from mail-qc0-f170.google.com (mail-qc0-f170.google.com
	[209.85.216.170]) by cuda.sgi.com with ESMTP id
	PeYLIYf7gUpG8zNC (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <linux-xfs@oss.sgi.com>;
	Tue, 11 Jun 2013 12:55:09 -0700 (PDT)
Received: by mail-qc0-f170.google.com with SMTP id s1so1905360qcw.29
	for <linux-xfs@oss.sgi.com>; Tue, 11 Jun 2013 12:55:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130611193525.GT20932@sgi.com>
References: <loom.20130611T112155-970@post.gmane.org>
	<20130611193525.GT20932@sgi.com>
Date: Tue, 11 Jun 2013 14:55:09 -0500
Message-ID: <CAO9HMNEt4XKdV6+jfKwHVPrDaVNytx65MQDK52Uckcy-O6YikQ@mail.gmail.com>
Subject: Re: Questions about XFS
From: Steve Bergman <sbergman27@gmail.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: linux-xfs@oss.sgi.com

Hi Ben,

I'm setting up a new server right now, and I'm breaking it up into a
number of different LV's for flexibility. I've gone through a number
of possibilities, and I think it's going to look something like this:

/ - Ext4
/root - Ext4
/home - Ext4
/var - Ext4
/usr/local - Ext4
/usr/local/worktmp - XFS (Very intensive & time-consuming random
writes, here. But all files are temporary work files. XFS is
performing well here in my testing.)
/usr/local/data - Ext3 (Cobol doesn't know about fsync. I need
pony-magic in this LV.)

Backup on the /usr/local/worktmp is not critical, due to its nature.
But can't I just lvm2-snapshot an XFS LV and rsync that to USB drive
like I do everything else?

-Steve

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
