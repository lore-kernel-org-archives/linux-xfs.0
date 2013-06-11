Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D0B8A29DF8
	for <linux-xfs@oss.sgi.com>; Tue, 11 Jun 2013 15:08:14 -0500 (CDT)
Date: Tue, 11 Jun 2013 15:08:11 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: Questions about XFS
Message-ID: <20130611200811.GO32736@sgi.com>
References: <loom.20130611T112155-970@post.gmane.org>
	<20130611193525.GT20932@sgi.com>
	<CAO9HMNEt4XKdV6+jfKwHVPrDaVNytx65MQDK52Uckcy-O6YikQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAO9HMNEt4XKdV6+jfKwHVPrDaVNytx65MQDK52Uckcy-O6YikQ@mail.gmail.com>
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
To: Steve Bergman <sbergman27@gmail.com>
Cc: linux-xfs@oss.sgi.com

Hey Steve,

On Tue, Jun 11, 2013 at 02:55:09PM -0500, Steve Bergman wrote:
> I'm setting up a new server right now, and I'm breaking it up into a
> number of different LV's for flexibility. I've gone through a number
> of possibilities, and I think it's going to look something like this:
> 
> / - Ext4
> /root - Ext4
> /home - Ext4
> /var - Ext4
> /usr/local - Ext4
> /usr/local/worktmp - XFS (Very intensive & time-consuming random
> writes, here. But all files are temporary work files. XFS is
> performing well here in my testing.)

Good.

> /usr/local/data - Ext3 (Cobol doesn't know about fsync. I need
> pony-magic in this LV.)

You might be better served (with whatever filesystem you are using) by
looking into whether you can teach cobol about fsync.  I've never worked
with cobol so I don't know if it can be done.  Based upon a quick web
search I suspect that it may be possible.

> Backup on the /usr/local/worktmp is not critical, due to its nature.
> But can't I just lvm2-snapshot an XFS LV and rsync that to USB drive
> like I do everything else?

Snapshot and rsync should work fine with xfs.  

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
