Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o59Hlaae026182 for <xfs@oss.sgi.com>; Wed, 9 Jun 2010 12:47:36 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 911773AD6E7
	for <xfs@oss.sgi.com>; Wed,  9 Jun 2010 10:49:51 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id tMcIj0U0Fm5rHuEt for
	<xfs@oss.sgi.com>; Wed, 09 Jun 2010 10:49:51 -0700 (PDT)
Message-ID: <4C0FD43D.3040803@sandeen.net>
Date: Wed, 09 Jun 2010 12:49:49 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 4/8] Add test of quota accounting using fsx
References: <1274710459-11446-1-git-send-email-jack@suse.cz>
	<1274710459-11446-5-git-send-email-jack@suse.cz>
In-Reply-To: <1274710459-11446-5-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: hch@infradead.org, xfs@oss.sgi.com

Jan Kara wrote:
> Run fsx (and also several fsx threads in parallel) and verify that
> quota accounting is correct after they finish.

Jan, I'm having trouble with this one on XFS for some reason, with our 
RHEL6 kernel and quota-3.17...

+Disabling group quota enforcement and accounting on /dev/mapper/VolGroup00-testvol2
+Disabling user quota enforcement and accounting on /dev/mapper/VolGroup00-testvol2
+repquota: Mountpoint (or device) /mnt/testarea/scratch not found or has no quota enabled.
+repquota: Not all specified mountpoints are using quota.
+repquota: Mountpoint (or device) /mnt/testarea/scratch not found or has no quota enabled.
+repquota: Not all specified mountpoints are using quota.

...

however if I remove the quotaon calls (off / on settings) in check_usage()
then it works:

check_usage()
{
        # quotaon -f -u -g $SCRATCH_MNT 2>/dev/null
        repquota -u -g $SCRATCH_MNT  | grep -v "^root" | filter_scratch \
                >$tmp.orig
        quotacheck -u -g $SCRATCH_MNT 2>/dev/null
        repquota -u -g $SCRATCH_MNT  | grep -v "^root" | filter_scratch \
                >$tmp.checked
        # quotaon -u -g $SCRATCH_MNT 2>/dev/null
        diff $tmp.orig $tmp.checked
}


Seems like 2 issues: noisy disable messages, and repquota failing when disabled.

Any ideas?

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
