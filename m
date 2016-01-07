Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 97AB57F37
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 19:41:05 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7DEDA304059
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 17:41:05 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id mVNKjR5FoJZp2thu (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 06 Jan 2016 17:41:00 -0800 (PST)
Subject: Re: [PATCH 00/35 v2] separate operations from flags in the
	bio/request structs
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
Date: Wed, 06 Jan 2016 20:40:09 -0500
In-Reply-To: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
	(mchristi@redhat.com's message of "Tue, 5 Jan 2016 14:53:03 -0600")
Message-ID: <yq14meqi2va.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
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
To: mchristi@redhat.com
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, linux-kernel@vger.kernel.org, philipp.reisner@linbit.com, linux-f2fs-devel@lists.sourceforge.net, linux-raid@vger.kernel.org, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, osd-dev@open-osd.org, linux-fsdevel@vger.kernel.org, lars.ellenberg@linbit.com, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, drbd-dev@lists.linbit.com

>>>>> "Mike" == mchristi  <mchristi@redhat.com> writes:

Mike> The following patches begin to cleanup the request->cmd_flags and
bio-> bi_rw mess. We currently use cmd_flags to specify the operation,
Mike> attributes and state of the request. For bi_rw we use it for
Mike> similar info and also the priority but then also have another
Mike> bi_flags field for state. At some point, we abused them so much we
Mike> just made cmd_flags 64 bits, so we could add more.

Mike> The following patches seperate the operation (read, write discard,
Mike> flush, etc) from cmd_flags/bi_rw.

Mike> This patchset was made against linux-next from today Jan 5 2016.
Mike> (git tag next-20160105).

Very nice work. Thanks for doing this!

I think it's a much needed cleanup. I focused mainly on the core block,
discard, write same and sd.c pieces and everything looks sensible to me.

I wonder what the best approach is to move a patch set with this many
stakeholders forward? Set a "speak now or forever hold your peace"
review deadline?

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
