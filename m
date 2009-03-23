Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2NGjfqU170969
	for <linux-xfs@oss.sgi.com>; Mon, 23 Mar 2009 11:46:02 -0500
Received: from qw-out-1920.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C78D1C63466
	for <linux-xfs@oss.sgi.com>; Mon, 23 Mar 2009 09:45:23 -0700 (PDT)
Received: from qw-out-1920.google.com (qw-out-1920.google.com [74.125.92.146])
	by cuda.sgi.com with ESMTP id yl1lVcxBCkgRYSH1 for
	<linux-xfs@oss.sgi.com>; Mon, 23 Mar 2009 09:45:23 -0700 (PDT)
Received: by qw-out-1920.google.com with SMTP id 9so1119514qwj.32
	for <linux-xfs@oss.sgi.com>; Mon, 23 Mar 2009 09:45:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <174852.24274.qm@web51309.mail.re2.yahoo.com>
References: <49C7AC2C.9090307@tmr.com>
	<174852.24274.qm@web51309.mail.re2.yahoo.com>
Date: Mon, 23 Mar 2009 12:45:23 -0400
Message-ID: <87f94c370903230945k66a804a0iefbb76dd9c93fc16@mail.gmail.com>
Subject: Re: How to configure 36 disks ?
From: Greg Freemyer <greg.freemyer@gmail.com>
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
To: Jon@ehardcastle.com
Cc: linux-aio@kvack.org, Linux RAID Mailing List <linux-raid@vger.kernel.org>, linux-xfs@oss.sgi.com, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Raz <raziebe@gmail.com>, linux-fsdevel@vger.kernel.org, Bill Davidsen <davidsen@tmr.com>

On Mon, Mar 23, 2009 at 12:02 PM, Jon Hardcastle
<jd_hardcastle@yahoo.com> wrote:
>
> I'd like to understand how you even go attaching that many devices to a system.. I am 'comparatively' new to this.. and have a 6 raid5 system.. not enterprise.. and i have slammed into case/power/sat slot issues already. What sort of hardware must one use to grow to a 36 array system!

For the drives you could get a few big enclosures:

http://www.pc-pitstop.com/sata_enclosures/sat122urd.asp
http://www.pc-pitstop.com/sata_enclosures/scsas16rm.asp

I don't think these offer PMP (port multiplexer) support.  I would
look for ones that did if you're serious about doing something like
this.

If you used PMP with 4x drives per sata port, you would only need 9
sata ports in the PC to control the 36 drives.  Not sure what the
limits of PMP is, but 4x seems reasonable to me.

Greg
-- 
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
