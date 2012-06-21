Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5L6UHtT259977 for <xfs@oss.sgi.com>; Thu, 21 Jun 2012 01:30:17 -0500
Received: from nospam3.slac.stanford.edu (nospam3.slac.stanford.edu
	[134.79.18.80]) by cuda.sgi.com with ESMTP id KaDlbmIbuadwd6Eg
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jun 2012 23:30:15 -0700 (PDT)
Message-ID: <4FE2BF74.9010406@slac.stanford.edu>
Date: Wed, 20 Jun 2012 23:30:12 -0700
From: Ling Ho <ling@slac.stanford.edu>
MIME-Version: 1.0
Subject: Re: Debugging file truncation problem
References: <4FE27E2B.2060705@slac.stanford.edu>
	<20120621060249.GR30705@dastard>
In-Reply-To: <20120621060249.GR30705@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 6/20/12 11:02 PM, Dave Chinner wrote:
> On Wed, Jun 20, 2012 at 06:51:39PM -0700, Ling Ho wrote:
>> Hello,
>>
>> I am trying to debug a problem that has bugged us for the last few months.
>>
>> We have set up a large storage system using GlusterFS, and XFS
>> underneath it. We have 5 RHEL6.2 servers (running
>> 2.6.32-220.7.1.el6.x86_64 when problem last occurred), with LSI
>> 9285-8e Raid Controller with Battery Backup Unit. System memory is
>> 48GB.
> Perhaps you should report the problem to your RedHat support
> engineer and tell them to raise a bug - it's entire possible that
> the RH kernel needs this fix:
>
> be4f1ac xfs: log all dirty inodes in xfs_fs_sync_fs
>
> Cheers,
>
> Dave.
>
Ok. Is there a bug reference number or thread I can point to?

I will try to open a ticket with Red Hat.

Thanks,
...
ling

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
