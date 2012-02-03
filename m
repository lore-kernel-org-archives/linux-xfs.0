Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q13LVRCo161603
	for <linux-xfs@oss.sgi.com>; Fri, 3 Feb 2012 15:31:28 -0600
Received: from crunch.scalableinformatics.com
	(173-10-54-97-Michigan.hfc.comcastbusiness.net [173.10.54.97])
	by cuda.sgi.com with ESMTP id U4GrtAuzY9xTosGc (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for
	<linux-xfs@oss.sgi.com>; Fri, 03 Feb 2012 13:31:22 -0800 (PST)
Message-ID: <4F2C5224.4080902@scalableinformatics.com>
Date: Fri, 03 Feb 2012 16:31:16 -0500
From: Joe Landman <landman@scalableinformatics.com>
MIME-Version: 1.0
Subject: Re: A corruption that seems to span a few kernels
References: <4F2C3D46.1010509@scalableinformatics.com>
	<20120203212724.GA22100@infradead.org>
In-Reply-To: <20120203212724.GA22100@infradead.org>
Reply-To: landman@scalableinformatics.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@oss.sgi.com

On 02/03/2012 04:27 PM, Christoph Hellwig wrote:
> On Fri, Feb 03, 2012 at 03:02:14PM -0500, Joe Landman wrote:
>> XFS file system, built using a 2.6.32.41 kernel.  External journals.
>>
>> repair the file system, mount, turn on gluster (3.2.5), do a find,
>> and get a corruption.  Actually it looks like xfs_repair doesn't fix
>> the problem.
>>
>> Rinse repeat, reproduce.  Works (procedure to generate the
>> corruption) in 2.6.32.41.scalable, 2.6.39.1, 3.2.2
>
> [PATCH v2] repair: update extent count after zapping duplicate blocks
>
> which was sent to the list yesterday should make xfs_repair handle this
> case.
>
> How do you reproduce the corruption?  Just start gluster on a fresh fs
> an do a find?  Any chance you could share command lines used?

It looks like the corruption was just never repaired by xfs_repair. I 
just followed the notes here: 
http://xfs.org/index.php/XFS_FAQ#Q:_How_to_get_around_a_bad_inode_repair_is_unable_to_clean_up 
and got it operational again.  I first blockget -n -i ###  to figure out 
the mapping and let the user know.

I'll grab the patch and apply it.  If this comes up again, I'll report.

To summarize, this was a corruption that xfs_repair didn't fix, so 
fixing it by hand (and rerunning xfs_repair) did.

Thanks!

Joe

-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
