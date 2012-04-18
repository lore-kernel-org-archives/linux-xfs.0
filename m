Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3I0lMYo124176 for <xfs@oss.sgi.com>; Tue, 17 Apr 2012 19:47:22 -0500
Received: from csamuel.org (csamuel.org [74.50.50.137]) by cuda.sgi.com with
	ESMTP id Za7aMDUE19Ag1Q38 for <xfs@oss.sgi.com>;
	Tue, 17 Apr 2012 17:47:21 -0700 (PDT)
Message-ID: <4F8E0EFF.4090007@csamuel.org>
Date: Wed, 18 Apr 2012 10:46:55 +1000
From: Chris Samuel <chris@csamuel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 00/19 v5] Fix filesystem freezing deadlocks
References: <1334592845-22862-1-git-send-email-jack@suse.cz>
	<C9A0E2F0-ED57-40D6-9F75-5D72D45D21F0@dilger.ca>
	<20120417004329.GE6734@dastard>
	<141752A3-EDF1-4ABC-919D-4170B0455948@whamcloud.com>
In-Reply-To: <141752A3-EDF1-4ABC-919D-4170B0455948@whamcloud.com>
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
To: Andreas Dilger <adilger@whamcloud.com>
Cc: Jan Kara <jack@suse.cz>, "J. Bruce Fields" <bfields@fieldses.org>, ocfs2-devel@oss.oracle.com, KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-nilfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, cluster-devel@redhat.com, Anton Altaparmakov <anton@tuxera.com>, linux-ext4@vger.kernel.org, fuse-devel@lists.sourceforge.net, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Joel Becker <jlbec@evilplan.org>, dchinner@redhat.com, Steven Whitehouse <swhiteho@redhat.com>, Chris Mason <chris.mason@oracle.com>, linux-nfs@vger.kernel.org, Alex Elder <elder@kernel.org>, Theodore Ts'o <tytso@mit.edu>, linux-ntfs-dev@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, linux-btrfs@vger.kernel.org

On 17/04/12 15:10, Andreas Dilger wrote:

> (which IMHO would prevent nearly every Gnome system from freezing unless these
> apps have changed their behaviour in more recent releases).

It would also affect current KDE desktops as they tend to use MySQL for
Akonadi & Nepomuk, plus anyone using Chromium (and presumably Chrome):

samuel@eris:/tmp$ sudo lsof | grep deleted | awk '{print $1}' | sort |
uniq -c
[sudo] password for samuel:
     32 chromium-
      1 dovecot
      5 imap-logi
      5 mysqld

I would be surprised if you could find many systems that didn't have
files in this situation.

-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
